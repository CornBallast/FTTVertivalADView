//
//  FTTVertivalADView.m
//  FTTVertivalADView
//
//  Created by ftt on 2017/10/26.
//  Copyright © 2017年 ftt. All rights reserved.
//

#import "FTTVertivalADView.h"
#import "FTTVertivalADViewCell.h"
#import "UIView+Debug.h"
@interface FTTVertivalADView ()
@property(nonatomic,strong)NSMutableArray *ADSectionViewArray;
@property(nonatomic,strong)UIView *innerView;
@end

@implementation FTTVertivalADView{
    FTTADViewStyle _style;
    NSInteger _rowCount;
    NSInteger _rowCountToSee;
    CGFloat _rowHeight;
    CGFloat _stayDuration;
    CGFloat _animationDuration;
    //
    NSInteger _totleSectionViewCount;
}
/**
 * 创建AD视图
 */
-(instancetype)initWithFrame:(CGRect)frame style:(FTTADViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _style = style;
        self.ADSectionViewArray = [NSMutableArray new];
    }
    return self;
}

-(void)steupInnerView{
    self.innerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_innerView];
    //
    for (int i = 0; i < _totleSectionViewCount; i ++) {
        UIView *ADSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, (_rowHeight * _rowCount) * i, self.frame.size.width, _rowHeight * _rowCount)];
        for (int j = 0; j < _rowCount; j ++) {
            FTTVertivalADViewCell *cell = nil;
            if (j >= [self.dataSource numberOfRowsInADView]) {
                cell = [FTTVertivalADViewCell customCell];
            }else{
                cell = [self.dataSource ADView:self cellForRow:j];
            }
            cell.frame = CGRectMake(0, _rowHeight * j, self.frame.size.width, _rowHeight);
            cell.textLabel.frame = cell.bounds;
            [ADSectionView addSubview:cell];
        }
        [_innerView addSubview:ADSectionView];
        [self.ADSectionViewArray addObject:ADSectionView];
    }
}

/**
 * 数据整理完成后刷新显示
 */
-(void)reloadData{
    if (![self requiredDataSourceSure]) {
        NSLog(@"请实现DataSource必须的方法");
        return;
    }
    [self cleanADView];
    //
    _stayDuration = 1;
    _animationDuration = 1;
    if ([self optionalDataSourceSure]) {
        _stayDuration = [self.dataSource ADShowDuration];
        _animationDuration = [self.dataSource ADAnimationDuration];
    }
    [self initialADRows];
    [self startRoll];
}

#pragma mark - Private
//初始化或修改广告条目
-(void)initialADRows{
    [self initializDataSoreceConstant];
    [self totleSectionViewCount];
    [self steupInnerView];
}

-(void)cleanADView{
    [self.ADSectionViewArray removeAllObjects];
    [self removeAllSubViews];
}

-(void)startRoll{
    if (_rowCount <= _rowCountToSee) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_stayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        keyFrameAni.removedOnCompletion = NO;
        keyFrameAni.fillMode = kCAFillModeForwards;
        keyFrameAni.duration = [self animationDuration];
        keyFrameAni.repeatCount = NSIntegerMax;
        keyFrameAni.values = [self animationValues];
        keyFrameAni.keyTimes = [self animationKeyTimes];
        [_innerView.layer addAnimation:keyFrameAni forKey:@"ROLLANIMATION"];
    });
}

-(void)totleSectionViewCount{
    if (_style == FTTADViewStyle_VancantFull) {
        _totleSectionViewCount = [self getLeastCommonMultipleWithNum_a:(int)_rowCount num_b:(int)_rowCountToSee] / _rowCount + 1;
    }else if (_style == FTTADViewStyle_VancantEmpty){
        _totleSectionViewCount = 2;
    }
}

-(void)initializDataSoreceConstant{
    _rowCountToSee = [self.dataSource numberOfRowsAbleToSee];
    _rowHeight = [self.dataSource heightForOneRow];
    //
    _rowCount = [self.dataSource numberOfRowsInADView];
    NSInteger plus = _rowCount;
    NSInteger sur = plus % _rowCountToSee;
    if (_style == FTTADViewStyle_VancantEmpty) {
        while (sur) {
            plus ++;
            sur = plus % _rowCountToSee;
        }
        _rowCount = plus;
    }
    //
    CGRect frame = self.frame;
    frame.size.height = _rowHeight * _rowCountToSee;
    self.frame = frame;
}

-(NSArray*)animationValues{
    NSMutableArray *valuesArray = [NSMutableArray new];
    CGFloat oneRollDistance = _rowHeight * _rowCountToSee;
    [valuesArray addObject:@(0)];
    for (int i = 0; i < [self cycleNeedRollCount]; i ++) {
        [valuesArray addObject:@(-oneRollDistance * (i+1))];
        [valuesArray addObject:@(-oneRollDistance * (i+1))];
    }
    return valuesArray;
}

-(NSArray*)animationKeyTimes{
    NSMutableArray *keyTimesArray = [NSMutableArray new];
    CGFloat keyTime = 0;
    [keyTimesArray addObject:@(keyTime)];
    for (int i = 0; i < [self cycleNeedRollCount]; i ++) {
        keyTime += _animationDuration / [self animationDuration];
        [keyTimesArray addObject:@(keyTime)];
        keyTime += _stayDuration / [self animationDuration];
        [keyTimesArray addObject:@(keyTime)];
    }
    return keyTimesArray;
}


-(CGFloat)animationDuration{
    CGFloat customD = 0;
    if ([self optionalDataSourceSure]) {
        for (int i = 0; i < [self cycleNeedRollCount]; i ++) {
            customD += _stayDuration;
            customD += _animationDuration;
        }
    }else{
        customD = [self cycleNeedRollCount] * 2;
    }
    return customD;
}

-(NSInteger)cycleNeedRollCount{
    NSInteger count = 0;
    NSInteger totleRow = (_totleSectionViewCount - 1) * _rowCount;
    NSInteger div = totleRow / _rowCountToSee;
    NSInteger sur = totleRow % _rowCountToSee;
    (sur == 0) ? (count = div) : (count = div + 1);
//    if (sur == 0) {
//        count = div;
//    }else{
//        count = div + 1;
//    }
    return count;
}

-(BOOL)requiredDataSourceSure{
    BOOL dataSourceSure = NO;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInADView)] && [self.dataSource respondsToSelector:@selector(numberOfRowsAbleToSee)] && [self.dataSource respondsToSelector:@selector(heightForOneRow)] && [self.dataSource respondsToSelector:@selector(ADView:cellForRow:)]) {
        dataSourceSure = YES;
    }
    return dataSourceSure;
}

-(BOOL)optionalDataSourceSure{
    BOOL dataSourceSure = NO;
    if ([self.dataSource respondsToSelector:@selector(ADAnimationDuration)] && [self.dataSource respondsToSelector:@selector(ADShowDuration)]) {
        dataSourceSure = YES;
    }
    return dataSourceSure;
}

//求两个数的最小公倍数
-(int)getLeastCommonMultipleWithNum_a:(int)a num_b:(int)b{
    int m, n, c;
    m=a;   n=b;
    while(b!=0)  /* 余数不为0，继续相除，直到余数为0 */
    { c=a%b; a=b;  b=c;}
    return m*n/a;
}

@end
