//
//  IGTimeZone.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "IGTimeZone.h"
#import "NSDate+IGTool.h"

@implementation IGTimeZone
@synthesize title,startDate,endDate,tag,extra;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self autoAdaptive];
    }
    return self;
}

+ (instancetype)timeZoneWithStartDate:(NSDate*)from endDate:(NSDate*)to{
    IGTimeZone *tz = [[IGTimeZone alloc] init];
    tz.startDate = from;
    tz.endDate = to;
    [tz autoAdaptive];
    return tz;
}

- (void)autoAdaptive{
    if (!startDate && !endDate) {
        startDate = [NSDate date];
        endDate = [startDate copy];
    }else if (startDate && !endDate){
        endDate = startDate;
    }else if (!startDate && endDate){
        startDate = endDate;
    }else if (startDate && endDate){
        if ([startDate laterDate:endDate] == startDate) {
            NSDate *temp = startDate;
            startDate = endDate;
            endDate = temp;
        }
    }
}

- (NSInteger)startHour{
    if (startDate) {
        return startDate.hour;
    }
    return 0;
}
- (NSInteger)startMinute{
    if (startDate) {
        return startDate.minute;
    }
    return 0;
}
- (NSInteger)endHour{
    if (endDate) {
        return endDate.hour;
    }
    return 0;
}

- (NSInteger)endMinute{
    if (endDate) {
        return endDate.minute;
    }
    return 0;
}

@end
