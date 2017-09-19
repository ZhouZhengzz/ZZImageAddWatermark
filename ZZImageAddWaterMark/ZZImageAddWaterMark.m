//
//  ZZImageAddWaterMark.m
//  ZZImageAddWaterMark
//
//  Created by zhouzheng on 2017/9/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ZZImageAddWaterMark.h"

@implementation ZZImageAddWaterMark


//图片添加文字水印
+ (UIImage *)addWatermarkWithImage:(UIImage *)image watermarkText:(NSString *)watermarkText rect:(CGRect)rect{

    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    // 创建一个graphics context来画我们的东西
    UIGraphicsBeginImageContext(image.size);
    [[UIColor whiteColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    // 然后在把文字画在合适的位置
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                           NSForegroundColorAttributeName:[UIColor redColor]};
    [watermarkText drawInRect:rect withAttributes:dict];
    // 通过下面的语句创建新的UIImage
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    
    return newImage;
}


//图片添加图片水印
+ (UIImage *)addWatermarkWithImage:(UIImage *)image watermarkImage:(UIImage *)watermarkImage rect:(CGRect)rect{

    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    // 创建一个graphics context来画我们的东西 
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    // 然后在把hat画在合适的位置
    [watermarkImage drawInRect:rect];
    // 通过下面的语句创建新的UIImage
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    
    return newImage;

}



@end
