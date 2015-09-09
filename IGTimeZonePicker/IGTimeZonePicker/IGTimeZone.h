//
//  IGTimeZone.h
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGTimeZone : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,copy) NSDate *startDate;
@property (nonatomic,copy) NSDate *endDate;
@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,strong) NSObject *extra;

+ (instancetype)timeZoneWithStartDate:(NSDate*)from endDate:(NSDate*)to;

- (void)autoAdaptive;

- (NSInteger)startHour;
- (NSInteger)startMinute;
- (NSInteger)endHour;
- (NSInteger)endMinute;
@end
