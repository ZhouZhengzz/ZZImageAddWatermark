//
//  ViewController.m
//  ZZImageAddWaterMark
//
//  Created by zhouzheng on 2017/9/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ViewController.h"
#import "ZZImageAddWaterMark.h"
#import "ZZQRCode.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *addTextWatermarkImageview;
@property (weak, nonatomic) IBOutlet UIImageView *addImageWatermarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addQRCodeWatermarkImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"shark"];
    NSString *text = @"我是水印";
    
    //添加文字水印
    UIImage *addTextWatermarkImage = [ZZImageAddWaterMark addWatermarkWithImage:image watermarkText:text rect:CGRectMake(10, 10, 100, 20)];
    _addTextWatermarkImageview.image = addTextWatermarkImage;
    
    
    //添加图片水印
    UIImage *addImageWatermarkImage = [ZZImageAddWaterMark addWatermarkWithImage:image watermarkImage:image rect:CGRectMake(0, 0, 60, 60)];
    _addImageWatermarkImageView.image = addImageWatermarkImage;
    
    
    //添加二维码水印
    ZZQRCode *zzQRCode = [[ZZQRCode alloc] initWithQRCodeString:@"https://github.com/ZhouZhengzz" size:300];
    zzQRCode.backgroundColor = [UIColor yellowColor];
    zzQRCode.fillColor = [UIColor blackColor];
    zzQRCode.outerColor = [UIColor redColor];
    zzQRCode.innerColor = [UIColor greenColor];
    zzQRCode.centerImage = image;
    UIImage *qrCodeImage = [zzQRCode generateQRCodeImage];
    UIImage *addQRCodeWatermarkImage = [ZZImageAddWaterMark addWatermarkWithImage:image watermarkImage:qrCodeImage rect:CGRectMake(0, 0, 100, 100)];
    _addQRCodeWatermarkImageView.image = addQRCodeWatermarkImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
