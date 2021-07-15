//
//  ObjCButtonController.m
//  EasyTimerExample
//
//  Created by carefree on 2021/2/2.
//

#import "ObjCButtonController.h"
#import "EasyTimerExample-Swift.h"

@interface ObjCButtonController ()<KFEasyTimerUpdater>

@property (weak, nonatomic) IBOutlet UIButton   *button;
@property (nonatomic, strong) KFEasyTimer       *timer;
@property (nonatomic, assign) CGFloat           count;

@end

@implementation ObjCButtonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button addTarget:self action:@selector(startCountdown) forControlEvents:UIControlEventTouchUpInside];
    self.timer = [[KFEasyTimer alloc] initWithUpdater:self interval:0.5];
    self.count = 0;
}

- (void)startCountdown {
    if (self.count > 0) {
        return;
    }
    self.count = 30;
    [self.timer run];
}

- (void)dealloc {
    NSLog(@"%@已销毁", NSStringFromClass(self.class));
}

#pragma mark - KFEasyTimerUpdater
- (void)timerUpdateWithInterval:(NSTimeInterval)interval {
    self.count -= interval;
    if (self.count <= 0) {
        [self.timer pause];
        [self.button setTitle:@"点击开始" forState:UIControlStateNormal];
        return;
    }
    [self.button setTitle:[NSString stringWithFormat:@"%zi秒", (NSInteger)self.count] forState:UIControlStateNormal];
}

@end
