//
//  IGTimeZoneTool.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "IGTimeZoneTool.h"
#import "NSDate+Helper.h"

@implementation IGTimeZoneTool

+(NSDate*)dateWithHour:(NSInteger)hour minute:(NSInteger)minute{
    return [NSDate dateFromString:[NSString stringWithFormat:@"%ld-%ld",[IGTimeZoneTool hourWithInteger:hour],[IGTimeZoneTool minuteWithInteger:minute]]
                       withFormat:@"HH-mm"];
    
}

+(NSInteger)hourWithInteger:(NSInteger)i{
    if (i < 0) {
        return 0;
    }
    if (i > 23) {
        return 23;
    }
    return i;
}

+(NSInteger)minuteWithInteger:(NSInteger)i{
    if (i < 0) {
        return 0;
    }
    if (i > 59) {
        return 59;
    }
    return i;
}


@end
