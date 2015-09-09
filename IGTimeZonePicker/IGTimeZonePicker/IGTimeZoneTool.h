//
//  IGTimeZoneTool.h
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IGTZColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
                 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


@interface IGTimeZoneTool : NSObject

+(NSDate*)dateWithHour:(NSInteger)hour minute:(NSInteger)minute;

@end
