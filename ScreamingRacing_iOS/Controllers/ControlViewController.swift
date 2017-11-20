//
//  ControlViewController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/7.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import PinLayout
import AVFoundation
import CoreMotion

class ControlViewController: UIViewController {
    
    let speedbar = SpeedBarView()
    let gyroball = SoundGyroBallView()
    let dirButton = UIButton()
    let nameLabel = UILabel()
    let listButton = UIButton()
    var isBackward = false
    var rotationRate:CGFloat = 0
    var speedRate:CGFloat = 0
    
    let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let recSession = AVAudioSession.sharedInstance()
    var recorder:AVAudioRecorder?
    let meterQueue = OperationQueue()
    var filePath:URL?
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMeters()
        NotificationCenter.default.addObserver(self, selector: #selector(finishRecording), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishRecording), name: .UIApplicationWillTerminate, object: nil)
    }
    
    private func setupUI(){
        view.backgroundColor = AppColor.ControllBackground
        view.addSubview(speedbar)
        view.addSubview(gyroball)
        view.addSubview(dirButton)
        dirButton.setImage(UIImage(named: "direction"), for: .normal)
        dirButton.addTarget(self, action: #selector(onDirBackward), for: .touchDown)
        dirButton.addTarget(self, action: #selector(onDirForward), for: .touchUpInside)
        dirButton.addTarget(self, action: #selector(onDirForward), for: .touchUpOutside)
        view.addSubview(nameLabel)
        nameLabel.text = "-"
        nameLabel.textAlignment = .center
        nameLabel.textColor = AppColor.Name
        view.addSubview(listButton)
        listButton.setImage(UIImage(named: "expand_arrow"), for: .normal)
        listButton.tintColor = AppColor.Name
        listButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        startRecord()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.bounds.width
        speedbar.pin.center().width(w * 0.9).height(w * 0.6)
        gyroball.pin.center().width(100).height(100)
        dirButton.pin.width(82).height(82).bottom(42).hCenter()
        nameLabel.pin.height(25).hCenter().top(30).minWidth(20)
        listButton.pin.width(20).height(25).right(of: nameLabel, aligned: .center)
    }

    @objc func onDirForward(){
        isBackward = false
    }
    
    @objc func onDirBackward(){
        isBackward = true
    }
    
    let transitionManager = DropDownTransitionManager(transitionDuration: 0.5, topOffset:55)
    
    @objc func showList(){
        let list = BLEListViewController()
        list.modalPresentationStyle = .custom
        list.transitioningDelegate = transitionManager
        present(list, animated: true, completion: nil)
    }
    
    func setupMeters() {
        do {
            try recSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recSession.setActive(true)
            recSession.requestRecordPermission({(allowed) in
                DispatchQueue.main.async {
                    if !allowed {print("session not allowed")}
                }
            })
        }catch{
            print(error)
        }
    }
    
    func startRecord() {
        let fileName = UUID().uuidString
        filePath = docUrl?.appendingPathComponent(fileName).appendingPathExtension("m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: filePath!, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
            motionManager.gyroUpdateInterval = 0.05
            motionManager.accelerometerUpdateInterval = 0.05
            motionManager.startDeviceMotionUpdates()
        }catch {
            print(error)
            return
        }
        let opr = BlockOperation()
        opr.addExecutionBlock { [unowned self] () in
            var counter = 0
            while(!opr.isCancelled){
                guard let recorder = self.recorder else {
                    return
                }
                recorder.updateMeters()
                var avgPow = recorder.averagePower(forChannel: 0)
                if avgPow < -40 {
                    avgPow = -40
                }
                let rate = CGFloat( (avgPow + 40) / 40)
                let gZ = self.motionManager.deviceMotion?.gravity.z ?? 0,
                gX = self.motionManager.deviceMotion?.gravity.x ?? 0,
                rotationY = CGFloat(atan2(gZ, gX)/Double.pi + 0.5)
                DispatchQueue.main.async {
                    self.speedRate = rate
                    self.speedbar.setSpeedRate(speed: rate)
                    self.rotationRate = rotationY
                    self.gyroball.setSpeedRate(rate: rate, andGyroRate: rotationY)
                    let ballCenterRange = self.speedbar.frame.size.width * 0.3
                    self.gyroball.pin.hCenter(rotationY * ballCenterRange)
                }
                usleep(50000)
                counter += 1
            }
        }
        meterQueue.addOperation(opr)
    }
    
    @objc func finishRecording() {
        meterQueue.cancelAllOperations()
        recorder?.stop()
        motionManager.stopDeviceMotionUpdates()
        recorder = nil
        if filePath == nil {
            return
        }
        var err:Error?
        do {
            try FileManager.default.removeItem(at: filePath!)
        }catch {
            err = error
        }
        if err == nil {
            filePath = nil
        }
    }
}
