//
//  ViewController.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "ViewController.h"
#import "IGTimeZonePicker.h"

@interface ViewController ()<IGTimeZonePickerDeleagte>{
    IGTimeZonePicker *tzPicker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildUI];
}

- (void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];

    tzPicker = [[IGTimeZonePicker alloc] init];
    tzPicker.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-164);
    tzPicker.backgroundColor = [UIColor colorWithRed:0.818 green:1.000 blue:0.996 alpha:1.000];
    tzPicker.delegate = self;
    [self.view addSubview:tzPicker];
    
    [self performSelector:@selector(after2s) withObject:nil afterDelay:2];
}
- (void)after4s{
    tzPicker.invalidTimeZones = @[];
}

- (void)after2s{
    tzPicker.invalidTimeZones = @[
                                  [self zone:8 :10 :9 : 0], // 跨Picker时间区间下限
                                  
                                  [self zone:8 :10 :9 : 5], // 部分跨Picker时间区间下限
                                  
                                  [self zone:9 :10 :10 :30], // 跨小时区间
                                  
                                  [self zone:11 :5 :11 :15], // 单个小时区间多个无效区域-1
                                  [self zone:11 :20 :11 :30],
                                  [self zone:11 :40 :11 :59],
                                  
                                  [self zone:12 :0 :12 :60], // 完整的一小时占用

                                  [self zone:13 :45 :13 :15], // 日期数据互换
                                  
                                  [self zone:14 :0 :14 :30], // 单个小时区间多个无效区域-2
                                  [self zone:14 :40 :14 :60],
                                  
                                  [self zone:9 :10 :10 :30], // 跨小时区间 - 反向
                                  
                                  [self zone:21 :30 :22 :39], // 跨Picker时间区间上限
                                  
                                  [self zone:22 :0 :22 :59] // 部分跨Picker时间区间上限
                                  ];
    
    [self performSelector:@selector(after4s) withObject:nil afterDelay:2];

}

- (IGTimeZone*)zone:(NSInteger)sh :(NSInteger)sm :(NSInteger)eh :(NSInteger)em{
    return [IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:sh
                                                                   minute:sm]
                                     endDate:[IGTimeZoneTool dateWithHour:eh
                                                                   minute:em]];
}


- (NSString*)timeZonePicker:(IGTimeZonePicker*)picker titleForIndex:(NSInteger)index timeZoneFrom:(NSInteger)from to:(NSInteger)to{
    if (index%2 == 0) {
        return @"100块";
    }
    return nil;
}

- (void)timeZonePickerDidClickedInvalidTimeZone:(IGTimeZonePicker*)picker{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                    message:@"请选择绿色的地方"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)timeZonePicker:(IGTimeZonePicker*)picker didClickedValidTimeZone:(IGTimeZone*)zone{
    if (zone) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:[NSString stringWithFormat:@"%.2ld:%.2ld - %.2ld:%.2ld",zone.startHour,zone.startMinute,zone.endHour,zone.endMinute]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
