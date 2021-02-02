//
//  ObjCTableViewController.h
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

#import <UIKit/UIKit.h>
#import "EasyTimerExample-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjCTableViewController : UIViewController

@end

@interface ObjCCountdownCell : UITableViewCell<KFEasyTimerUpdater>

@property (nonatomic, assign) NSTimeInterval nowTime;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, strong) NSDateFormatter *formatter;

- (void)updateTimeLabel;

@end

NS_ASSUME_NONNULL_END
