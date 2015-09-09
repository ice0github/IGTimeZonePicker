//
//  IGTimeZoneItemView.m
//  IGTimeZonePicker
//
//  Created by 桂强 何 on 15/9/9.
//  Copyright (c) 2015年 桂强 何. All rights reserved.
//

#import "IGTimeZoneItemView.h"
#import "IGTimeZoneTool.h"



@interface IGTimeZoneItemView (){
    UIButton *btnInvalid;
    
    NSMutableArray *validButtons;
}

@end


static float const MINUTE = 59;

@implementation IGTimeZoneItemView
@synthesize delegate;
@synthesize titleLabel,validTimeZones;
@synthesize invalidZoneColor,validZoneColor,changeAnimation;



- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self buildUI];
    }
    return self;
}

#pragma mark - ----> 界面
- (void)buildUI{
    self.backgroundColor = [UIColor whiteColor];

    btnInvalid = [UIButton buttonWithType:UIButtonTypeCustom];
    btnInvalid.frame = self.bounds;
    btnInvalid.backgroundColor = invalidZoneColor;
    [btnInvalid addTarget:self action:@selector(handleInvalidButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnInvalid.layer.borderWidth = 0.5;
    btnInvalid.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    [self addSubview:btnInvalid];
    
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width-4, self.bounds.size.height);
    titleLabel.textColor = IGTZColorWithHex(0x808080);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
}

- (void)rebuildValidTimeZoneButtons{
    if (changeAnimation) {
        [validButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = (UIButton*)obj;
            if (obj) {
                [UIView animateWithDuration:0.3 animations:^{
                    btn.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width*0.5, 0, 0, btn.frame.size.height);
                } completion:^(BOOL finished) {
                    [btn removeFromSuperview];
                }];
            }
        }];
    }else{
        [validButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [validButtons removeAllObjects];

    if (validTimeZones && validTimeZones.count > 0) {
        for (int i = 0 ; i<validTimeZones.count; i++) {
            UIButton *btn = nil;
            if (i < validButtons.count) {
                btn = validButtons[i];
            }else{
                btn = [self neoValidButton];
                [self insertSubview:btn belowSubview:titleLabel];
                [validButtons addObject:btn];
            }
            btn.tag = 10000+i;
            IGTimeZone *tz = validTimeZones[i];
            
            float x = (tz.startMinute / MINUTE) * self.bounds.size.width;
            float w = ((tz.endMinute - tz.startMinute) / MINUTE) * self.bounds.size.width;
            if (changeAnimation) {
                btn.frame = CGRectMake(x+w*0.5, 0, 0, self.bounds.size.height);
                [UIView animateWithDuration:0.3 animations:^{
                    btn.frame = CGRectMake(x, 0, w, self.bounds.size.height);
                }];
            }else{
                btn.frame = CGRectMake(x, 0, w, self.bounds.size.height);
            }
        }
    }
}

- (UIButton*)neoValidButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = validZoneColor;
    [button addTarget:self action:@selector(handleValidButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    return button;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSelf];
}

- (void)layoutSelf{
    btnInvalid.frame = self.bounds;
    titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width-4, self.bounds.size.height);
    [self layoutValidTimeZones];
}

- (void)layoutValidTimeZones{
    [validButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton*)obj;
        IGTimeZone *tz = validTimeZones[idx];
        
        float x = (tz.startMinute / MINUTE) * self.bounds.size.width;
        float w = ((tz.endMinute - tz.startMinute) / MINUTE) * self.bounds.size.width;
        btn.frame = CGRectMake(x, 0, w, self.bounds.size.height);
    }];
}



#pragma mark - ----> 数据
- (void)initData{
    validButtons = [[NSMutableArray alloc] init];
    
    changeAnimation = YES;
    
    self.invalidZoneColor = nil;

    self.validZoneColor =nil;
}

- (void)setValidTimeZones:(NSArray *)timeZones{
    validTimeZones = timeZones;
    [self rebuildValidTimeZoneButtons];
}

- (void)setInvalidZoneColor:(UIColor *)color{
    invalidZoneColor = color;
    if (!invalidZoneColor) {
        invalidZoneColor = IGTZColorWithHex(0xf5f5f5);
    }
    btnInvalid.backgroundColor = invalidZoneColor;
}

- (void)setValidZoneColor:(UIColor *)color{
    validZoneColor = color;
    if (!validZoneColor) {
        validZoneColor = IGTZColorWithHex(0x9be07d);
    }
    [validButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = obj;
        if (btn) {
            [btn setBackgroundColor:validZoneColor];
        }
    }];
}

#pragma mark - ----> 事件
- (void)handleInvalidButtonClicked{
    if (delegate && [delegate respondsToSelector:@selector(timeZoneItemViewDidSelectedValidZone:)]) {
        [delegate timeZoneItemViewDidSelectedValidZone:self];
    }
}

- (void)handleValidButtonClicked:(UIButton*)button{
    if (button) {
        NSInteger index = button.tag - 10000;
        if (index < validTimeZones.count) {
            if (delegate && [delegate respondsToSelector:@selector(timeZoneItemView:didSelectedInvalidZone:)]) {
                [delegate timeZoneItemView:self didSelectedInvalidZone:validTimeZones[index]];
            }
        }
    }
}

@end
