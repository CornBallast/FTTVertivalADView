//
//  FTTVertivalADView.h
//  FTTVertivalADView
//
//  Created by ftt on 2017/10/26.
//  Copyright © 2017年 ftt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FTTVertivalADView,FTTVertivalADViewCell;

typedef enum : NSUInteger{
    FTTADViewStyle_VancantFull,
    FTTADViewStyle_VancantEmpty,
}FTTADViewStyle;

@protocol FTTVertivalADViewDataSource<NSObject>
@required
/**
 * 一共多少条广告
 */
-(NSInteger)numberOfRowsInADView;
/**
 * 一次显示多少条光告
 */
-(NSInteger)numberOfRowsAbleToSee;
/**
 * 每条广告的高度
 */
-(CGFloat)heightForOneRow;
/**
 * 返回每条广告
 */
-(FTTVertivalADViewCell*)ADView:(FTTVertivalADView*)ADView cellForRow:(NSInteger)row;
@optional
/**
 * 每条广告滚动的动画时间
 */
-(CGFloat)ADAnimationDuration;
/**
 * 每条广告滚动完成后停留的时间
 */
-(CGFloat)ADShowDuration;
@end

@protocol FTTVertivalADViewDelegate<NSObject>
@optional
-(FTTVertivalADViewCell*)ADView:(FTTVertivalADView*)ADView didSelectRow:(NSInteger)row;

@end

@interface FTTVertivalADView : UIView
@property(nonatomic,weak) id<FTTVertivalADViewDelegate> delegate;
@property(nonatomic,weak) id<FTTVertivalADViewDataSource> dataSource;
/**
 * 创建AD视图
 */
-(instancetype)initWithFrame:(CGRect)frame style:(FTTADViewStyle)style;
/**
 * 数据整理完成后刷新显示
 */
-(void)reloadData;

@end
