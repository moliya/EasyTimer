//
//  SwiftButtonController.swift
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

import UIKit

class SwiftButtonController: UIViewController {

    @IBOutlet weak var button: UIButton!
    var timer: EasyTimer!
    var count: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        timer = EasyTimer(updater: self, interval: 0.5)
    }

    @objc func startCountdown() {
        if count > 0 {
            return
        }
        count = 30
        timer.start()
    }
    
    deinit {
        timer.stop()
    }
}

extension SwiftButtonController: EasyTimerUpdater {
    func timerUpdate(interval: TimeInterval) {
        count -= interval
        if count <= 0 {
            timer.stop()
            button.setTitle("点击开始", for: .normal)
            return
        }
        button.setTitle("\(Int(count))秒", for: .normal)
    }
}
