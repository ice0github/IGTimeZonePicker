//
//  IGMinuteIntervalArithmeticTool.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "IGMinuteIntervalArithmeticTool.h"


@implementation IGMinuteIntervalArithmeticResult

+ (instancetype)resultFrom:(NSInteger)i1 to:(NSInteger)i2{
    IGMinuteIntervalArithmeticResult *res = [[IGMinuteIntervalArithmeticResult alloc] init];
    res.from = i1;
    res.to = i2;
    return res;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld > %ld", self.from,self.to];
}

@end

@interface IGMinuteIntervalArithmeticTool (){
    NSMutableArray *minuteArray;
}

@end

@implementation IGMinuteIntervalArithmeticTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

+(instancetype)defaultInstance
{
    static IGMinuteIntervalArithmeticTool *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[IGMinuteIntervalArithmeticTool alloc] init];
        
    });
    return _sharedInstance;
}

- (void)reset{
    if (!minuteArray) {
        minuteArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i<60; i++) {
            [minuteArray addObject:@(YES)];
        }
    }else{
        for (int i = 0 ; i<minuteArray.count; i++) {
            minuteArray[i] = @(YES);
        }
    }
}

- (void)banFrom:(NSInteger)from to:(NSInteger)to{
    if (from >= 0 && from < minuteArray.count) {
        for (NSInteger i = from ; i<to; i++) {
            if (i < minuteArray.count) {
                minuteArray[i] = @(NO);
            }
        }
    }
}

- (NSArray*)result{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    BOOL flag = NO;
    
    NSInteger from = 0;
    
    for (int i = 0 ; i<minuteArray.count; i++) {
        BOOL mark = [minuteArray[i] boolValue];
        if (i == minuteArray.count - 1) {
            if (flag) {
                [array addObject:[IGMinuteIntervalArithmeticResult resultFrom:from to:i]];
            }
            break;
        }
        if (mark) {
            if (!flag){
                flag = YES;
                from = i;
            }
        }else{
            if (flag) {
                flag = NO;
                [array addObject:[IGMinuteIntervalArithmeticResult resultFrom:from to:i]];
            }
        }
    }

    return array;
}


@end
