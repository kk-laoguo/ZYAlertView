//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by guozengying on 2017/3/8.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "ViewController.h"
#import "WYCustomAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
- (IBAction)alertView:(id)sender {
    WYCustomAlertView * alert = [WYCustomAlertView shareAlertView];
    [alert showAlertWithMessage:@"确定取消请求求救?" okBtn:@"确定" cancleBtn:@"取消"];
    [alert showAlertView];
}
- (IBAction)sheet:(id)sender {
    [[WYCustomAlertView shareAlertView] showActionSheetWithName:@"王阳" message:@"我是傻逼我是傻逼我是傻逼我是傻逼我是傻逼我是傻逼" num:@"500" cancle:YES];
}
- (IBAction)buttonClick:(id)sender {
    [[WYCustomAlertView shareAlertView] showActionSheetWithDestination:@"苏州" detail:@"财富广场"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
