//
//  WYCustomAlertView.m
//  CustomAlertViewDemo
//
//  Created by guozengying on 2017/3/8.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "WYCustomAlertView.h"

#define MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCALE_Width (MAINSCREEN_WIDTH/375.0)
#define SCALE_Height (MAINSCREEN_HEIGHT/667.0)
#define WINDOW [UIApplication sharedApplication].keyWindow


NSInteger const alertW = 300;
NSInteger const alertH = 165;
CGFloat   const alertRadius = 8.f;
NSInteger const WYTag = 10;

NSInteger const sheetH = 140;
CGFloat   const sheetRadius = 5.f;

static WYCustomAlertView * instance;
static dispatch_once_t onceToken;
@interface WYCustomAlertView()

@property (nonatomic, strong) UIView * alertView;
@property (nonatomic, strong) UIView * sheet;


@end

@implementation WYCustomAlertView

- (void)clear{
    onceToken = 0;
}
+ (WYCustomAlertView *)shareAlertView{
    
    dispatch_once(&onceToken, ^{
        instance = [[WYCustomAlertView alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}
#pragma mark -- alertView
- (void)showAlertWithMessage:(NSString *)message okBtn:(NSString *)okTitle cancleBtn:(NSString *)cancleTitle{
    
    if (message) {
        [self addSubview:self.alertView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sos"]];
        imageView.frame = CGRectMake(0, 20*SCALE_Height, 10, 40*SCALE_Height);
        imageView.centerX = self.alertView.width/2.0;
        [self.alertView addSubview:imageView];
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, imageView.bottom+5*SCALE_Height,self.alertView.width,25*SCALE_Height);
        titleLab.text = message;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:15.f];
        [self.alertView addSubview:titleLab];
        
        UILabel * Hline = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab.bottom+25*SCALE_Height, MAINSCREEN_WIDTH, 1)];
        Hline.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        [self.alertView addSubview:Hline];
        
        NSArray * arr = @[cancleTitle,okTitle];
        CGFloat btnHeight = alertH*SCALE_Height - Hline.bottom;
        for (NSInteger i = 0; i < 2; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame  = CGRectMake((self.alertView.width/2.0)*i,Hline.bottom,self.alertView.width/2.0, btnHeight);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            button.tag = WYTag+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:button];
        }
        UILabel * Vline = [[UILabel alloc] initWithFrame:CGRectMake(alertW/2.0, Hline.bottom, 1, btnHeight)];
        Vline.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        [self.alertView addSubview:Vline];
    }
}

- (void)showAlertView{
    [WINDOW  addSubview:self];
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buttonClick:(UIButton *)button{
//    while (self.subviews.count) {
//        [self.subviews.lastObject removeFromSuperview];
//    }
    [self.alertView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    if (self.resultBlock) {
        self.resultBlock(button.tag);
    }
}
#pragma mark -- actionSheet 
- (void)showActionSheetWithName:(NSString *)name message:(NSString *)message num:(NSString *)num cancle:(BOOL)cancale{
    if (name) {
        
        [self addSubview:self.sheet];
        
        UIImageView * headerPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        headerPic.layer.cornerRadius = 25;
        headerPic.layer.masksToBounds = YES;
        headerPic.layer.borderColor = [UIColor whiteColor].CGColor;
        headerPic.layer.borderWidth = 1.f;
        headerPic.backgroundColor = [UIColor cyanColor];
        [self.sheet addSubview:headerPic];
        
        UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerPic.right+15, 15*SCALE_Height, 150, 20*SCALE_Height)];
        nameLab.font = [UIFont boldSystemFontOfSize:15.f];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.text = name;
        [self.sheet addSubview:nameLab];
        
        NSString * str = [NSString stringWithFormat:@"已响应:%@人",num];
        UILabel * countLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.right, nameLab.top, self.sheet.width - nameLab.right - 10, nameLab.height)];
        countLab.textAlignment = NSTextAlignmentRight;
        NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:str];
        [attri addAttributes:@{NSFontAttributeName:
                       [UIFont systemFontOfSize:13.f],NSForegroundColorAttributeName:[UIColor cyanColor]}
                       range:NSMakeRange(0, 4)];
        [attri addAttributes:@{NSFontAttributeName:
                       [UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor whiteColor]}
                       range:NSMakeRange(4, str.length-4)];
        countLab.attributedText = attri;
        [self.sheet addSubview:countLab];
        
        UILabel * messageLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.left, nameLab.bottom,self.sheet.width-10-nameLab.left, 50*SCALE_Height)];
        messageLab.textColor = [UIColor whiteColor];
        messageLab.font = [UIFont systemFontOfSize:15.f];
        messageLab.numberOfLines = 2;
        messageLab.textAlignment = NSTextAlignmentLeft;
        messageLab.text= message;
        [self.sheet addSubview:messageLab];

        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:cancale ? @"取消求救":@"前往救援" forState:UIControlStateNormal];
        [button setBackgroundColor:cancale ? [UIColor redColor]:[UIColor yellowColor] ];
        [button setTitleColor:cancale ? [UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.frame = CGRectMake(10,self.sheet.height - 50 , self.sheet.width-20, 40);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
        [self.sheet addSubview:button];
        [self sheetShow];
    }
}

- (void)showActionSheetWithDestination:(NSString *)destination detail:(NSString *)detail{
    
    if (destination) {
        [self addSubview:self.sheet];
        UIImageView * headerPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25*SCALE_Height, 25, 25)];
        headerPic.backgroundColor = [UIColor whiteColor];
        [self.sheet addSubview:headerPic];
        
        UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerPic.right+15, 25*SCALE_Height, 150, 25*SCALE_Height)];
        nameLab.font = [UIFont boldSystemFontOfSize:15.f];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.text = destination;
//        nameLab.backgroundColor = [UIColor redColor];
        [self.sheet addSubview:nameLab];
        
        UILabel * messageLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.left, nameLab.bottom,self.sheet.width-10-nameLab.left, 25*SCALE_Height)];
        messageLab.textColor = [UIColor whiteColor];
        messageLab.font = [UIFont systemFontOfSize:15.f];
        messageLab.numberOfLines = 0;
//        messageLab.backgroundColor = [UIColor cyanColor];
        messageLab.textAlignment = NSTextAlignmentLeft;
        messageLab.text= detail;
        [self.sheet addSubview:messageLab];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"开启导航" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor yellowColor];
        button.frame = CGRectMake(10,self.sheet.height - 50 , self.sheet.width-20, 40);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
        [self.sheet addSubview:button];
        [self sheetShow];
    }
}

- (void)sheetShow{
    [WINDOW addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.sheet.frame = CGRectMake(10, MAINSCREEN_HEIGHT - sheetH*SCALE_Height -10, MAINSCREEN_WIDTH -20, sheetH*SCALE_Height);
    }];
}

- (void)helpClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheet.frame = CGRectMake(10,sheetH*SCALE_Height+10+MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH -20, sheetH*SCALE_Height);
        
    } completion:^(BOOL finished) {
        [self.sheet.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
    if (self.resultBlock) {
        self.resultBlock(WYTag);
    }
}
#pragma mark -- setter --
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertW * SCALE_Width, alertH * SCALE_Height)];
        _alertView.center = self.center;
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = alertRadius;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}
- (UIView *)sheet{
    if (!_sheet) {
        _sheet = [[UIView alloc] initWithFrame:CGRectMake(10, (sheetH*SCALE_Height+10+MAINSCREEN_HEIGHT), MAINSCREEN_WIDTH - 20, sheetH*SCALE_Height)];
        _sheet.backgroundColor = [UIColor blackColor];
        _sheet.layer.cornerRadius = sheetRadius;
        _sheet.layer.masksToBounds = YES;
    }
    return _sheet;
}
@end

@implementation UIView (WYView)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (UIView * (^)(CGFloat x))setX
{
    return ^(CGFloat x) {
        self.x = x;
        return self;
    };
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (UIView *(^)(UIColor *color)) setColor
{
    return ^ (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView *(^)(CGRect frame)) setFrame
{
    return ^ (CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGSize size)) setSize
{
    return ^ (CGSize size) {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        return self;
    };
}

- (UIView *(^)(CGPoint point)) setCenter
{
    return ^ (CGPoint point) {
        self.center = point;
        return self;
    };
}

- (UIView *(^)(NSInteger tag)) setTag
{
    return ^ (NSInteger tag) {
        self.tag = tag;
        return self;
    };
}


@end

