//
//  UIView+Debug.h
//
//  Created by ys on 29/08/16.
//  Copyright (c) 2016 ys. All rights reserved.
//

#import "UIView+Debug.h"

@implementation UIView (Debug)


- (void)removeAllSubViews
{
    NSArray* arr = self.subviews;
    for (UIView* v in arr) {
        [v removeFromSuperview];
    }
}

@end
