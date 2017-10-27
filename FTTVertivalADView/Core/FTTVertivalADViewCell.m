//
//  FTTVertivalADViewCell.m
//  FTTVertivalADView
//
//  Created by ftt on 2017/10/26.
//  Copyright © 2017年 ftt. All rights reserved.
//

#import "FTTVertivalADViewCell.h"

@interface FTTVertivalADViewCell ()

@end

@implementation FTTVertivalADViewCell

+(instancetype)customCell{
    FTTVertivalADViewCell *cell = [[FTTVertivalADViewCell alloc] init];
    [cell textLabelLayout];
    return cell;
}

-(void)textLabelLayout{
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_textLabel];
}

@end
