//
//  ZZQRCode.h
//  ZZImageAddWaterMark
//
//  Created by zhouzheng on 2017/9/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZQRCode : NSObject

@property (nonatomic, copy) NSString *QRCodeString;
@property (nonatomic, assign) CGFloat size;

@property(nonatomic, strong) UIColor *backgroundColor; //二维码背景色
@property(nonatomic, strong) UIColor *fillColor; //二维码填充色
@property(nonatomic, strong) UIColor *outerColor; //二维码定位图案外层颜色
@property(nonatomic, strong) UIColor *innerColor; //二维码定位图案内层颜色
@property(nonatomic, strong) UIImage *centerImage; //二维码中心logo图片


/**
 二维码图片初始化

 @param QRCodeString 扫描结果
 @param size 二维码大小（正方形）
 */
- (instancetype)initWithQRCodeString:(NSString *)QRCodeString
                                    size:(CGFloat)size;
- (UIImage *)generateQRCodeImage;

@end
