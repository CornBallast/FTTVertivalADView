//
//  ViewController.m
//  FTTVertivalADView
//
//  Created by ys on 2017/10/26.
//  Copyright © 2017年 ys. All rights reserved.
//

#import "ViewController.h"
#import "FTTVertivalADView.h"
#import "FTTVertivalADViewCell.h"
@interface ViewController ()<FTTVertivalADViewDelegate,FTTVertivalADViewDataSource>
@property(nonatomic,strong)NSArray *textArray;
@end

@implementation ViewController{
    FTTVertivalADView *ADView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textArray = @[@"广告1",@"广告2",@"广告3",@"广告4",@"广告5",@"广告6",@"广告7",@"广告8"];
    ADView = [[FTTVertivalADView alloc] initWithFrame:CGRectMake(100, 100, 200, 40) style:FTTADViewStyle_VancantEmpty];
    ADView.layer.borderColor = [UIColor grayColor].CGColor;
    ADView.layer.borderWidth = 1;
    ADView.delegate = self;
    ADView.dataSource = self;
    [self.view addSubview:ADView];
    //
    [ADView reloadData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.textArray = @[@"二次广告1",@"二次广告2",@"二次广告3",@"二次广告4",@"二次广告5"];
    [ADView reloadData];
}

-(NSInteger)numberOfRowsInADView{
    return self.textArray.count;
}

-(NSInteger)numberOfRowsAbleToSee{
    return 3;
}

-(CGFloat)heightForOneRow{
    return 40.0;
}

//-(CGFloat)ADAnimationDuration{
//    return 1.0f;
//}
//
//-(CGFloat)ADShowDuration{
//    return 3.0f;
//}

-(FTTVertivalADViewCell *)ADView:(FTTVertivalADView *)ADView cellForRow:(NSInteger)row{
    FTTVertivalADViewCell *cell = [FTTVertivalADViewCell customCell];
    cell.textLabel.text = self.textArray[row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
