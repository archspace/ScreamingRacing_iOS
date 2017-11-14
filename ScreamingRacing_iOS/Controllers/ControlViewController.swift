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

class ControlViewController: UIViewController {
    
    let speedbar = SpeedBarView()
    let gyroball = SoundGyroBallView()
    let testControl = UISlider()
    
    let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let recSession = AVAudioSession.sharedInstance()
    var recorder:AVAudioRecorder?
    let meterQueue = OperationQueue()
    var filePath:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSession()
        NotificationCenter.default.addObserver(self, selector: #selector(finishRecording), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    private func setupUI(){
        view.backgroundColor = AppColor.ControllBackground
        view.addSubview(speedbar)
        view.addSubview(gyroball)
        view.addSubview(testControl)
        testControl.addTarget(self, action: #selector(testChange(sender:)), for: .valueChanged)
    }
    
    override func viewWillLayoutSubviews() {
        startRecord()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.bounds.width
        speedbar.pin.center().width(w * 0.9).height(w * 0.6)
        gyroball.pin.center().width(100).height(100)
        testControl.pin.width(250).below(of: speedbar, aligned: .center)
    }

    @objc func testChange(sender:UISlider) {
        speedbar.setSpeedRate(speed: CGFloat(sender.value))
        gyroball.setSpeedRate(rate: CGFloat(sender.value))
    }
    
    func setupSession() {
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
            recorder?.record()
            recorder?.isMeteringEnabled = true
            
        }catch {
            print(error)
            return
        }
        let opr = BlockOperation()
        opr.addExecutionBlock { [unowned self] () in
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
                DispatchQueue.main.async {
                    self.speedbar.setSpeedRate(speed: rate)
                    self.gyroball.setSpeedRate(rate: rate)
                }
                usleep(50000)
            }
        }
        meterQueue.addOperation(opr)
    }
    
    @objc func finishRecording() {
        meterQueue.cancelAllOperations()
        recorder?.stop()
        recorder = nil
        do {
            try FileManager.default.removeItem(at: filePath!)
        }catch {
            print(error)
        }
    }
}
