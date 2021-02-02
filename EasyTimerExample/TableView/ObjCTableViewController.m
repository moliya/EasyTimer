//
//  ObjCTableViewController.m
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

#import "ObjCTableViewController.h"

@interface ObjCTableViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) KFEasyTimer        *timer;
@property (nonatomic, strong) NSArray            *timeInfo;

@end

@implementation ObjCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [[KFEasyTimer alloc] init];
    self.timer.updater = self.tableView;
    [self.timer start];
    NSTimeInterval now = NSDate.date.timeIntervalSince1970;
    self.timeInfo = @[
        @[
            @(now), //当前时间开始
            @(now + 59 * 60) //59分钟后结束
        ],
        @[
            @(now + 24 * 60 * 60), //1天后开始
            @(now + 48 * 60 * 60) //2天后结束
        ],
        @[
            @(now - 24 * 60 * 60), //1天前开始
            @(now - 60 * 60) //1小时前结束
        ],
        @[
            @(now), //当前时间开始
            @(now + 25 * 60 * 60) //25小时后结束
        ],
        @[
            @(now), //当前时间开始
            @(now + 30 * 60) //30分钟后结束
        ],
        @[
            @(now), //当前时间开始
            @(now + 10) //10秒后结束
        ],
        @[
            @(now + 20),
            @(now + 72 * 34)
        ],
        @[
            @(now + 15),
            @(now + 19 * 57)
        ],
        @[
            @(now + 10),
            @(now + 42 * 34)
        ]
    ];
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)dealloc {
    [self.timer stop];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ObjCCountdownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.nowTime = NSDate.date.timeIntervalSince1970;
    cell.startTime = [[self.timeInfo[indexPath.row] firstObject] doubleValue];
    cell.endTime = [[self.timeInfo[indexPath.row] lastObject] doubleValue];
    [cell updateTimeLabel];
    return cell;
}

@end

@implementation ObjCCountdownCell

- (NSDateFormatter *)formatter {
    if (_formatter) {
        return _formatter;
    }
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"MM月dd日 HH:mm:ss";
    _formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    return _formatter;
}

- (void)updateTimeLabel {
    NSTimeInterval interval = self.endTime - self.nowTime;
    if (interval <= 0) {
        //已结束
        self.textLabel.text = @"已结束";
    } else if (self.startTime > self.nowTime) {
        //未开始
        NSString *text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.startTime]];
        self.textLabel.attributedText = ({
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@开始", text]];
            [string addAttributes:@{
                NSForegroundColorAttributeName: UIColor.redColor
            } range:NSMakeRange(0, text.length)];
            string;
        });
    } else if ((interval / 60 / 60) > 24.0) {
        //已开始，24小时后结束
        NSString *text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.endTime]];
        self.textLabel.attributedText = ({
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@截止", text]];
            [string addAttributes:@{
                NSForegroundColorAttributeName: UIColor.redColor
            } range:NSMakeRange(0, text.length)];
            string;
        });
    } else if ((interval / 60 / 60) < 24.0) {
        //已开始，24小时内结束
        NSInteger hour = interval / 60 / 60;
        NSInteger minute = (interval - (hour * 60 * 60)) / 60;
        NSInteger second = interval - (hour * 60 * 60) - (minute * 60);
        NSString *text = [NSString stringWithFormat:@"%02zi:%02zi:%02zi", hour, minute, second];
        if (interval <= 0) {
            text = @"00:00:00";
        }
        self.textLabel.attributedText = ({
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离结束还剩%@", text]];
            [string addAttributes:@{
                NSForegroundColorAttributeName: UIColor.redColor
            } range:NSMakeRange(6, text.length)];
            string;
        });
    }
}

#pragma mark - KFEasyTimerUpdater
- (void)timerUpdateWithInterval:(NSTimeInterval)interval {
    self.nowTime += interval;
    [self updateTimeLabel];
}

@end
