//
//  ZZImageAddWaterMark.h
//  ZZImageAddWaterMark
//
//  Created by zhouzheng on 2017/9/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZImageAddWaterMark : NSObject


/**
 图片添加文字水印

 @param image 要添加水印的图片
 @param watermarkText 水印文字
 @param rect 水印文字位置
 @return 添加完水印的图片
 */
+ (UIImage *)addWatermarkWithImage:(UIImage *)image
                     watermarkText:(NSString *)watermarkText
                              rect:(CGRect)rect;



/**
 图片添加图片水印

 @param image 要添加水印的图片
 @param watermarkImage 水印图片
 @param rect 水印图片位置
 @return 添加完水印的图片
 */
+ (UIImage *)addWatermarkWithImage:(UIImage *)image
                    watermarkImage:(UIImage *)watermarkImage
                              rect:(CGRect)rect;






@end
