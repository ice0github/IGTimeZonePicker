//
//  IGMinuteIntervalArithmeticTool.h
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGMinuteIntervalArithmeticResult : NSObject
@property (nonatomic,assign) NSInteger from;
@property (nonatomic,assign) NSInteger to;

+ (instancetype)resultFrom:(NSInteger)i1 to:(NSInteger)i2;

@end

@interface IGMinuteIntervalArithmeticTool : NSObject
+(instancetype)defaultInstance;

- (void)reset;

- (void)banFrom:(NSInteger)from to:(NSInteger)to;

- (NSArray*)result;

@end
