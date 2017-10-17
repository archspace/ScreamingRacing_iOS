//
//  ViewController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/10/3.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let recBtn = UIButton()
    let powLabel = UILabel()
    let recSession = AVAudioSession.sharedInstance()
    var recorder:AVAudioRecorder?
    let meterQueue = OperationQueue()
    var filePath:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSession()
        meterQueue.qualityOfService = .userInitiated
    }
    
    func setupSession() {
        do {
            try recSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recSession.setActive(true)
            recSession.requestRecordPermission({ [unowned self] (allowed) in
                DispatchQueue.main.async {
                    if !allowed {
                        self.recBtn.isEnabled = false
                        print("session not allowed")
                    }
                }
            })
        }catch{
            
        }
    }
    
    func setupUI() {
        recBtn.layer.borderWidth = 1
        recBtn.layer.borderColor = UIColor.black.cgColor
        recBtn.layer.cornerRadius = 10
        recBtn.setTitle("Record", for: .normal)
        recBtn.setTitleColor(UIColor.black, for: .normal)
        recBtn.setTitleColor(UIColor.gray, for: .highlighted)
        recBtn.setTitleColor(UIColor.lightGray, for: .disabled)
        view.addSubview(recBtn)
        recBtn.addTarget(self, action: #selector(onRecord(sender:)), for: .touchUpInside)
        
        powLabel.text = "0"
        powLabel.font = UIFont.systemFont(ofSize: 20)
        powLabel.textColor = UIColor.black
        powLabel.textAlignment = .center
        view.addSubview(powLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recBtn.frame = CGRect(x: view.bounds.midX - 50, y: view.bounds.maxY - 20 - 30, width: 100, height: 30)
        powLabel.frame = CGRect(x: view.bounds.midX - 100, y: view.bounds.minY + 60, width: 200, height: 200)
    }
    
    @objc func onRecord(sender:UIButton) {
        if recorder == nil {
            startRecord()
        }else {
            finishRecording(successed: true)
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
            recorder?.delegate = self
            recorder?.record()
            recorder?.isMeteringEnabled = true
            recBtn.setTitle("Stop", for: .normal)
        }catch {
            finishRecording(successed: false)
            return
        }
        let opr = BlockOperation()
        opr.addExecutionBlock { [unowned self] () in
            while(!opr.isCancelled){
                guard let recorder = self.recorder else {
                    return
                }
                recorder.updateMeters()
                let avgPow = recorder.averagePower(forChannel: 0)
                let peakPow = recorder.peakPower(forChannel: 0)
                DispatchQueue.main.async {
                    self.onUpdatePower(peak: peakPow, avg: avgPow)
                }
                usleep(500)
            }
        }
        meterQueue.addOperation(opr)
    }
    
    func finishRecording(successed:Bool) {
        meterQueue.cancelAllOperations()
        recorder?.stop()
        recorder = nil
        recBtn.setTitle("Record", for: .normal)
        do {
            try FileManager.default.removeItem(at: filePath!)
        }catch {
            print(error)
        }
    }
    
    func onUpdatePower(peak:Float, avg:Float) {
        powLabel.text = String.init(format: "%.2f", avg)
    }
}

extension ViewController: AVAudioRecorderDelegate {
    
}

