//
//  FTTVertivalADViewCell.h
//  FTTVertivalADView
//
//  Created by ftt on 2017/10/26.
//  Copyright © 2017年 ftt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTVertivalADViewCell : UIView
/**
 * 获取获取提供的Cell实例，只提供一个Lable显示文字
 */
+(instancetype)customCell;
/**
 * 设置Cell的显示文字Label
 */
@property(nonatomic,strong)UILabel *textLabel;
@end
