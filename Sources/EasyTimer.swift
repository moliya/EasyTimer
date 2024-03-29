//
//  EasyTimer.swift
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

import UIKit

@objc(KFEasyTimerUpdater)
public protocol EasyTimerUpdater: NSObjectProtocol {
    @objc optional func timerUpdate(interval: TimeInterval)
}

@objc(KFEasyTimer)
open class EasyTimer: NSObject {
    
    enum TimerState {
        case ready
        case running
        case paused
    }
    
    @objc open weak var updater: AnyObject?
    @objc open var interval: TimeInterval = 1
    private lazy var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
    private var state: TimerState = .ready
    
    public var isRunning: Bool {
        return state == .running
    }
    
    public override init() {
        super.init()
    }
    
    deinit {
        if state == .running {
            timer.cancel()
        } else if state == .paused {
            timer.resume()
            timer.cancel()
        }
    }
    
    @objc
    public init(updater: AnyObject, interval: TimeInterval) {
        self.updater = updater
        self.interval = interval
    }
    
    @objc(run)
    public func run() {
        if state != .ready {
            if state == .running {
                return
            }
            if state == .paused {
                timer.resume()
                state = .running
            }
            return
        }
        
        timer.schedule(wallDeadline: .now(), repeating: .milliseconds(Int(interval * 1000)))
        timer.setEventHandler {[weak self] in
            guard let self = self else { return }
            
            let closure: (AnyObject?, TimeInterval) -> Void = {
                if let updater = $0 as? EasyTimerUpdater {
                    updater.timerUpdate?(interval: $1)
                }
            }
            
            let interval = self.interval
            if let tableView = self.updater as? UITableView {
                DispatchQueue.main.async {
                    tableView.visibleCells.forEach { cell in
                        closure(cell, interval)
                    }
                }
                return
            }
            if let collectionView = self.updater as? UICollectionView {
                DispatchQueue.main.async {
                    collectionView.visibleCells.forEach { cell in
                        closure(cell, interval)
                    }
                }
                return
            }
            DispatchQueue.main.async {
                closure(self.updater, interval)
            }
        }
        timer.resume()
        state = .running
    }
    
    @objc(pause)
    public func pause() {
        if state == .running {
            timer.suspend()
            state = .paused
        }
    }
}
