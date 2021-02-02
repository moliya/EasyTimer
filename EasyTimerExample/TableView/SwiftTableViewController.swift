//
//  SwiftTableViewController.swift
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

import UIKit

class SwiftTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let timer = EasyTimer()
    var timeInfo: [(TimeInterval, TimeInterval)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //指定为tableView
        timer.updater = tableView
        //开始计时
        timer.start()
        let now = Date().timeIntervalSince1970
        timeInfo = [
            (
                now, //当前时间开始
                now + 59 * 60 //59分钟后结束
            ),
            (
                now + 24 * 60 * 60, //1天后开始
                now + 48 * 60 * 60 //2天后结束
            ),
            (
                now - 24 * 60 * 60, //1天前开始
                now - 60 * 60 //1小时前结束
            ),
            (
                now, //当前时间开始
                now + 25 * 60 * 60 //25小时后结束
            ),
            (
                now, //当前时间开始
                now + 30 * 60 //30分钟后结束
            ),
            (
                now, //当前时间开始
                now + 10 //10秒后结束
            ),
            (
                now + 20,
                now + 72 * 34
            ),
            (
                now + 15,
                now + 19 * 57
            ),
            (
                now + 10,
                now + 42 * 34
            )
        ]
        tableView.dataSource = self
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? SwiftCountdownCell {
            cell.nowTime = Date().timeIntervalSince1970
            cell.startTime = timeInfo[indexPath.row].0
            cell.endTime = timeInfo[indexPath.row].1
            cell.updateTimeLabel()
        }
        return cell
    }
    
    deinit {
        timer.stop()
    }
}

class SwiftCountdownCell: UITableViewCell, EasyTimerUpdater {
    var nowTime: TimeInterval = Date().timeIntervalSince1970
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        return formatter
    }()
    
    func timerUpdate(interval: TimeInterval) {
        nowTime += interval
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let interval = endTime - nowTime
        if interval <= 0 {
            //已结束
            textLabel?.text = "已结束"
        } else if startTime > nowTime {
            //未开始
            let text = formatter.string(from: Date(timeIntervalSince1970: startTime))
            textLabel?.attributedText = {
                let string = NSMutableAttributedString(string: text + "开始")
                string.addAttributes([
                    NSAttributedString.Key.foregroundColor: UIColor.red
                ], range: NSRange(location: 0, length: text.count))
                return string
            }()
        } else if (interval / 60 / 60) > 24.0 {
            //已开始，24小时后结束
            let text = formatter.string(from: Date(timeIntervalSince1970: endTime))
            textLabel?.attributedText = {
                let string = NSMutableAttributedString(string: text + "截止")
                string.addAttributes([
                    NSAttributedString.Key.foregroundColor: UIColor.red
                ], range: NSRange(location: 0, length: text.count))
                return string
            }()
        } else if (interval / 60 / 60) < 24.0 {
            //已开始，24小时内结束
            let hour = Int(interval / 60 / 60)
            let minute = Int((interval - Double(hour * 60 * 60)) / 60)
            let second = Int(interval - Double(hour * 60 * 60) - Double(minute * 60))
            var text = String(format: "%02d:%02d:%02d", hour, minute, second)
            if interval <= 0 {
                text = "00:00:00"
            }
            textLabel?.attributedText = {
                let string = NSMutableAttributedString(string: "距离结束还剩" + text)
                string.addAttributes([
                    NSAttributedString.Key.foregroundColor: UIColor.red
                ], range: NSRange(location: 6, length: text.count))
                return string
            }()
        }
    }
}
