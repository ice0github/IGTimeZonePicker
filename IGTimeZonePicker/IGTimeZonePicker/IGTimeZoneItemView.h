//
//  IGTimeZoneItemView.h
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGTimeZone.h"

@class IGTimeZoneItemView;


@protocol IGTimeZoneItemViewDelegate <NSObject>

- (void)timeZoneItemViewDidSelectedValidZone:(IGTimeZoneItemView*)itemView;
- (void)timeZoneItemView:(IGTimeZoneItemView*)itemView didSelectedInvalidZone:(IGTimeZone*)timeZone;

@end

@interface IGTimeZoneItemView : UIView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSArray *validTimeZones;

@property (nonatomic,assign) BOOL changeAnimation;

@property (nonatomic,strong) UIColor *validZoneColor; // 有效区域的颜色
@property (nonatomic,strong) UIColor *invalidZoneColor; // 无效区间的颜色

@property (nonatomic,weak) id<IGTimeZoneItemViewDelegate> delegate;

@end
