//
//  BLEListViewController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/20.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import CoreBluetooth
import PromiseKit

@objc protocol BLEListViewControllerDelegate: NSObjectProtocol {
    func bleList(didConnectedToPeripheral peripheral:CBPeripheral)
}

class BLEListViewController: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    let tableView = UITableView()
    var centralService:BluetoothCentralService?
    var peripheralService:BluetoothPeripheralService?
    var peripherals = [AvailablePeripheralData]()
    let PeripheralCellReuseId = "PeripheralCellReuseId"
    let CarServiceUUID = CBUUID(string: "FFE0")
    let CarCharUUID = CBUUID(string: "FFE1")
    weak var delegate:BLEListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if appDelegate.centralService == nil || appDelegate.centralService!.centralStatus != .poweredOn {
            appDelegate.centralService = BluetoothCentralService(onStateUpdate: {[unowned self] (state) in
                switch state {
                case .poweredOn:
                    self.startScan()
                    break
                default:
                    break
                }
            })
            centralService = appDelegate.centralService
        }else{
            centralService = appDelegate.centralService
            self.startScan()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        centralService?.stopScan()
    }
    
    func startScan() {
        centralService?.startScan(discoverHandler: {[unowned self] (peripheralDict) in
            self.peripherals = Array(peripheralDict.values)
            self.tableView.reloadData()
        })
    }
    

    func setupUI() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [AppColor.ListGradientStart!.cgColor, AppColor.ListGradientEnd!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1)
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.register(CheckedTableViewCell.self, forCellReuseIdentifier: PeripheralCellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        tableView.frame = view.bounds
    }
}

enum DeviceListError:Error {
    case NoAvailableService
}

extension BLEListViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeripheralCellReuseId, for: indexPath) as! CheckedTableViewCell,
        peripheral = peripherals[indexPath.row]
        cell.titleLabel.text = peripheral.peripheral.name ?? "-"
        switch peripheral.peripheral.state {
        case .connecting:
            cell.status = .checked
            break
        case .connected:
            cell.status = .loading
            break
        default:
            cell.status = .uncheck
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        centralService?.stopScan()
        let cell = tableView.cellForRow(at: indexPath) as! CheckedTableViewCell,
        peripheral = peripherals[indexPath.row].peripheral
        guard let service = centralService else {
            return
        }
        cell.status = .loading
        tableView.isUserInteractionEnabled = false
        service.connect(peripheral: peripheral)
            .then(execute: { (p) -> Promise<CBPeripheral> in
                self.peripheralService = BluetoothPeripheralService(p: p)
                return self.peripheralService!.discoverService(serviceUUIDs: [self.CarServiceUUID])
            })
            .then(execute: { (p) -> Promise<CBPeripheral> in
                guard let s = p.serviceWithUUID(uuid: self.CarServiceUUID) else {
                    throw DeviceListError.NoAvailableService
                }
                return self.peripheralService!.discoverCharacteristics(from: s, characteristics: [self.CarCharUUID])
            })
            .then(execute: { (p) -> Void in
                cell.status = .checked
                self.delegate?.bleList(didConnectedToPeripheral: p)
                self.dismiss(animated: true, completion: nil)
            })
            .always {
                tableView.isUserInteractionEnabled = true
            }
            .catch(policy: .allErrors) { (err) in
                service.disconnect(peripheral: peripheral)
                cell.status = .uncheck
                tableView.isUserInteractionEnabled = true
                print(err)
        }
    }
}
