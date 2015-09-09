//
//  IGTimeZonePicker.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "IGTimeZonePicker.h"
#import "NSDate+Escort.h"
#import "NSDate+Helper.h"

#import "IGTimeZoneTool.h"
#import "IGMinuteIntervalArithmeticTool.h"


#define TimeZoneFlagWidth 46
#define TimeZoneItemSpacing 6
#define HeadPadding 6


static int const TAG_ITEM_VIEW = 20000;

@interface IGTimeZonePicker ()<IGTimeZoneItemViewDelegate>{
    UIScrollView *sclMain;
    
    NSMutableArray *segmentValidTimeZones;

    NSMutableArray *timeZoneItemViews;
    NSMutableArray *timeZoneFlagViews;
}

@end

@implementation IGTimeZonePicker
@synthesize invalidTimeZones,timeZone;
@synthesize rowHeight,invalidZoneColor,validZoneColor;
@synthesize delegate;

- (instancetype)init
{
    return [self initWithFrame:CGRectZero timeZone:nil invalidTimeZones:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:CGRectZero timeZone:nil invalidTimeZones:nil];
}

-(instancetype)initWithFrame:(CGRect)frame timeZone:(IGTimeZone*)zone invalidTimeZones:(NSArray*)invalidZones{
    self = [super initWithFrame:frame];
    if (self) {
        timeZone = zone;
        if (!timeZone) {
            timeZone = [IGTimeZone timeZoneWithStartDate:[NSDate dateFromString:@"09-00" withFormat:@"HH-mm"]
                                                 endDate:[NSDate dateFromString:@"22-00" withFormat:@"HH-mm"]];
        }
        invalidTimeZones = invalidZones;
        [self initData];
        [self buildUI];
        [self reloadTimeZone];
    }
    return self;
}


#pragma mark - ----> 界面

- (void)buildUI{
    sclMain = [[UIScrollView alloc] init];
    sclMain.frame = self.bounds;
    sclMain.backgroundColor = [UIColor whiteColor];
    [self addSubview:sclMain];

    [self rebuildTimeZoneViews];
}

-(void)rebuildTimeZoneViews{
    [sclMain.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [timeZoneFlagViews removeAllObjects];
    [timeZoneItemViews removeAllObjects];
    
    if (timeZone) {
        NSInteger orgFrom = self.timeZone.startHour;
        NSInteger orgEnd = self.timeZone.endHour;
        
        float bottomWithLastView = 0.0;
        
        for (NSInteger i = orgFrom ; i<orgEnd+1; i++) {
            NSInteger index = i-orgFrom;
            if (i < orgEnd) {
                IGTimeZoneItemView *itemView = [[IGTimeZoneItemView alloc] init];
                itemView.frame = CGRectMake(TimeZoneFlagWidth, index*rowHeight+index*TimeZoneItemSpacing, sclMain.bounds.size.width, rowHeight);
                itemView.backgroundColor = [UIColor colorWithRed:0.456 green:0.914 blue:1.000 alpha:1.000];
                itemView.delegate = self;
                itemView.tag = TAG_ITEM_VIEW+i;
                itemView.invalidZoneColor = invalidZoneColor;
                itemView.validZoneColor = validZoneColor;
                [sclMain addSubview:itemView];
                [timeZoneItemViews addObject:itemView];
            }
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(5, index*rowHeight, TimeZoneFlagWidth-2*2, TimeZoneItemSpacing*2);
            label.text = [NSString stringWithFormat:@"%.2ld:00",i];
            label.font = [UIFont systemFontOfSize:TimeZoneItemSpacing*2];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            [sclMain addSubview:label];
            [timeZoneFlagViews addObject:label];
            
            bottomWithLastView = index*rowHeight+label.bounds.size.height;
        }
        sclMain.contentSize = CGSizeMake(sclMain.bounds.size.width,
                                         bottomWithLastView);
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSelf];
}

- (void)layoutSelf{
    sclMain.frame = self.bounds;
    [self layoutTimeZoneItemViews];
}

- (void)layoutTimeZoneItemViews{
    [timeZoneItemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IGTimeZoneItemView *itemView = (IGTimeZoneItemView*)obj;
        itemView.frame = CGRectMake(TimeZoneFlagWidth, HeadPadding+idx*rowHeight+(idx+1)*TimeZoneItemSpacing, sclMain.bounds.size.width-TimeZoneFlagWidth-10, rowHeight);
    }];
    
    [timeZoneFlagViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = (UILabel*)obj;
        label.frame = CGRectMake(0, HeadPadding+idx*rowHeight+idx*TimeZoneItemSpacing-TimeZoneItemSpacing*0.5, TimeZoneFlagWidth, TimeZoneItemSpacing*2);
        if (stop) {
            sclMain.contentSize = CGSizeMake(sclMain.bounds.size.width,
                                             label.frame.origin.y+label.frame.size.height+HeadPadding);
        }
    }];
    
}

- (void)reloadTimeZone{
    if (!invalidTimeZones) {
        invalidTimeZones = @[];
    }
    // 清空原有数据
    [segmentValidTimeZones makeObjectsPerformSelector:@selector(removeAllObjects)];
    [segmentValidTimeZones removeAllObjects];
    
    
    // 排序
    [invalidTimeZones enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(IGTimeZone*)obj autoAdaptive];
    }];
    invalidTimeZones = [invalidTimeZones sortedArrayUsingComparator:^NSComparisonResult(IGTimeZone *obj1, IGTimeZone *obj2) {
        if ([obj1.startDate laterDate:obj2.startDate] == obj1.startDate) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    // 初始化容器
    NSInteger orgFrom = self.timeZone.startHour;
    NSInteger orgEnd = self.timeZone.endHour;
    NSMutableArray *segmentInalidTimeZones = [[NSMutableArray alloc] init];

    for (NSInteger i = orgFrom ; i<orgEnd; i++) {
        [segmentValidTimeZones addObject:[[NSMutableArray alloc] init]];
        [segmentInalidTimeZones addObject:[[NSMutableArray alloc] init]];
    }
    
    // 分割不可用的时间段
    for (int i = 0 ; i<invalidTimeZones.count; i++) {
        IGTimeZone *tz = invalidTimeZones[i];
        if (tz.startHour >= orgEnd) {
            continue;
        }
        if (tz.startHour < orgFrom) {
            if (tz.endHour >= orgFrom && tz.endMinute > 0) {
                tz = [IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:tz.endHour
                                                                             minute:0]
                                               endDate:tz.endDate];
            }else{
                continue;
            }
        }
        NSInteger index = tz.startHour - orgFrom;
        
        NSMutableArray *array = segmentInalidTimeZones[index];
        NSInteger gap = tz.endHour - tz.startHour;
        if (gap == 0) {
            // 没跨时段
            [array addObject:[IGTimeZone timeZoneWithStartDate:[tz.startDate copy]
                                                       endDate:[tz.endDate copy]]];
        }else{
            // 跨越了时段，分割成若干个timezone
            for (int i = 0 ; i < gap+1; i++) {
                if (i == 0) {
                    [array addObject:[IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:tz.startHour
                                                                                             minute:tz.startMinute]
                                                               endDate:[IGTimeZoneTool dateWithHour:tz.startHour
                                                                                             minute:59]]];
                }else if (i == gap){
                    NSInteger targetIndex = index + i;
                    if (targetIndex < segmentInalidTimeZones.count) {
                        NSMutableArray *nextArray = segmentInalidTimeZones[targetIndex];
                        [nextArray addObject:[IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:tz.endHour
                                                                                                     minute:0]
                                                                       endDate:[IGTimeZoneTool dateWithHour:tz.endHour
                                                                                                     minute:tz.endMinute]]];
                    }
                }else{
                    NSInteger targetIndex = index + i;
                    if (targetIndex < segmentInalidTimeZones.count) {
                        NSMutableArray *nextArray = segmentInalidTimeZones[targetIndex];
                        [nextArray addObject:[IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:tz.startHour+i
                                                                                                     minute:0]
                                                                       endDate:[IGTimeZoneTool dateWithHour:tz.startHour+i
                                                                                                     minute:59]]];
                    }
                }
            }
        }
    }

    // 计算可用区域
    IGMinuteIntervalArithmeticTool *at = [IGMinuteIntervalArithmeticTool defaultInstance];
    for (int i = 0 ; i<segmentValidTimeZones.count; i++) {
        NSMutableArray *invalidTimeZonesInSegment = segmentInalidTimeZones[i];
        NSMutableArray *validTimeZonesInSegment = segmentValidTimeZones[i];
        
        NSInteger currHour = orgFrom+i;
        
        if (invalidTimeZonesInSegment.count == 0) {
            // 无占用时间
            [validTimeZonesInSegment addObject:[IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:currHour
                                                                                                       minute:0]
                                                                         endDate:[IGTimeZoneTool dateWithHour:currHour
                                                                                                       minute:59]]];
        }else{
            // 计算
            [at reset];
            for (int i = 0 ; i<invalidTimeZonesInSegment.count; i++) {
                IGTimeZone *tz = invalidTimeZonesInSegment[i];
                [at banFrom:tz.startMinute to:tz.endMinute];
            }
            NSArray *ress = [at result];
            for (IGMinuteIntervalArithmeticResult *res in ress) {
                [validTimeZonesInSegment addObject:[IGTimeZone timeZoneWithStartDate:[IGTimeZoneTool dateWithHour:currHour
                                                                                                           minute:res.from]
                                                                             endDate:[IGTimeZoneTool dateWithHour:currHour
                                                                                                           minute:res.to]]];
            }
            
        }
        // 应用到UI
        if (i < timeZoneItemViews.count) {
            IGTimeZoneItemView *itemView = timeZoneItemViews[i];
            itemView.validTimeZones = validTimeZonesInSegment;
            itemView.titleLabel.text = nil;
            if (delegate && [delegate respondsToSelector:@selector(timeZonePicker:titleForIndex:timeZoneFrom:to:)]) {
                itemView.titleLabel.text = [delegate timeZonePicker:self titleForIndex:i timeZoneFrom:currHour to:currHour+1];
            }
        }
    }
    
}

#pragma mark - ----> 数据
- (void)initData{
    rowHeight = 40;
    invalidZoneColor = IGTZColorWithHex(0xf5f5f5);
    validZoneColor = IGTZColorWithHex(0x9be07d);
    
    timeZoneItemViews = [[NSMutableArray alloc] init];
    timeZoneFlagViews = [[NSMutableArray alloc] init];
    segmentValidTimeZones = [[NSMutableArray alloc] init];
}

- (void)setInvalidTimeZones:(NSArray *)zones{
    invalidTimeZones = zones;
    [self reloadTimeZone];
}

- (void)setInvalidZoneColor:(UIColor *)color{
    invalidZoneColor = color;
    [timeZoneItemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IGTimeZoneItemView *itemView = obj;
        if (itemView && [itemView isKindOfClass:[IGTimeZoneItemView class]]) {
            itemView.invalidZoneColor = invalidZoneColor;
        }
    }];
}

- (void)setValidZoneColor:(UIColor *)color{
    validZoneColor = color;
    [timeZoneItemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IGTimeZoneItemView *itemView = obj;
        if (itemView && [itemView isKindOfClass:[IGTimeZoneItemView class]]) {
            itemView.validZoneColor = validZoneColor;
        }
    }];
}

#pragma mark - ----> IGTimeZoneItemViewDelegate
- (void)timeZoneItemViewDidSelectedValidZone:(IGTimeZoneItemView*)itemView{
    if (delegate && [delegate respondsToSelector:@selector(timeZonePickerDidClickedInvalidTimeZone:)]) {
        [delegate timeZonePickerDidClickedInvalidTimeZone:self];
    }

}
- (void)timeZoneItemView:(IGTimeZoneItemView*)itemView didSelectedInvalidZone:(IGTimeZone*)zone{
    if (zone && delegate && [delegate respondsToSelector:@selector(timeZonePicker:didClickedValidTimeZone:)]) {
        [delegate timeZonePicker:self didClickedValidTimeZone:zone];
    }

}

@end
