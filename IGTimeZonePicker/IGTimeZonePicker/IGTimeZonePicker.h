//
//  IGTimeZonePicker.h
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGTimeZone.h"
#import "IGTimeZoneItemView.h"
#import "IGTimeZoneTool.h"

@class IGTimeZonePicker;

@protocol IGTimeZonePickerDeleagte <NSObject>

// datasource
- (NSString*)timeZonePicker:(IGTimeZonePicker*)picker titleForIndex:(NSInteger)index timeZoneFrom:(NSInteger)from to:(NSInteger)to;

// selecteion
- (void)timeZonePickerDidClickedInvalidTimeZone:(IGTimeZonePicker*)picker;

- (void)timeZonePicker:(IGTimeZonePicker*)picker didClickedValidTimeZone:(IGTimeZone*)zone;


@end

@interface IGTimeZonePicker : UIView


@property (nonatomic,strong) NSArray *invalidTimeZones;

@property (nonatomic,strong) IGTimeZone *timeZone;

@property (nonatomic,assign) float rowHeight;
@property (nonatomic,strong) UIColor *validZoneColor; // 有效区域的颜色
@property (nonatomic,strong) UIColor *invalidZoneColor; // 无效区间的颜色

@property (nonatomic,weak) id<IGTimeZonePickerDeleagte> delegate;

-(instancetype)initWithFrame:(CGRect)frame timeZone:(IGTimeZone*)zone invalidTimeZones:(NSArray*)invalidZones;

@end
