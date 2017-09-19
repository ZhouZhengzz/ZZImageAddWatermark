//
//  ZZQRCode.m
//  ZZImageAddWaterMark
//
//  Created by zhouzheng on 2017/9/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ZZQRCode.h"

typedef NS_ENUM(NSInteger, ZZQRPosition)
{
    TopLeft,
    TopRight,
    BottomLeft,
    Center,
    QuietZone
};


@implementation ZZQRCode
{
    CIImage *_outPutImage;
}

#pragma mark - 初始化
- (instancetype)initWithQRCodeString:(NSString *)QRCodeString size:(CGFloat)size {
    self = [super init];
    if (self) {
        _QRCodeString = @"zhouzheng";
        _backgroundColor = [UIColor whiteColor];
        _fillColor = [UIColor blackColor];
        
        _QRCodeString = QRCodeString;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect rect = CGRectMake(0, 0, size, size);
        _size = CGRectGetWidth(rect) * scale;
    }
    return self;
}

#pragma mark - 生成二维码图片
- (UIImage *)generateQRCodeImage {
    
    [self generateQRCodeFilter];
    
    UIImage *OriginalImg = [self createNonInterpolatedUIImageFormCIImage:_outPutImage withSize:_size];
    UIGraphicsBeginImageContextWithOptions(OriginalImg.size, NO, [[UIScreen mainScreen] scale]);
    [OriginalImg drawInRect:CGRectMake(0,0 , _size, _size)];
    
    if (_outerColor) {
        [self changeOuterColor];
    }
    if (_innerColor) {
        [self changeInnerColor];
    }
    if (_centerImage) {
        [self changeCenterImage];
    }
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

//使用CIFilter滤镜类生成二维码
- (void)generateQRCodeFilter
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [_QRCodeString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    
    CIColor *color1 = [CIColor colorWithCGColor:_fillColor.CGColor];
    CIColor *color2 = [CIColor colorWithCGColor:_backgroundColor.CGColor];

    //iOS 8之前
    CIFilter *newFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [newFilter setDefaults];
    [newFilter setValue:filter.outputImage forKey:@"inputImage"];
    [newFilter setValue:color1 forKey:@"inputColor0"];
    [newFilter setValue:color2 forKey:@"inputColor1"];
    
//    //iOS 8之后
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: filter.outputImage ,@"inputImage",
//                                color1,@"inputColor0",
//                                color2,@"inputColor1",nil];
//    CIFilter *newFilter = [CIFilter filterWithName:@"CIFalseColor" withInputParameters:parameters];
    
    _outPutImage = [newFilter outputImage]; //拿到二维码图片
}

//对生成的二维码进行加工，使其更清晰
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceRGB颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    return outputImage;
}

#pragma mark - 属性定制
//改变二维码定位图案外层颜色
- (void)changeOuterColor {

    [self changeOuterPositionColor:_outerColor withPosition:TopLeft];
    [self changeOuterPositionColor:_outerColor withPosition:TopRight];
    [self changeOuterPositionColor:_outerColor withPosition:BottomLeft];

}

//改变二维码定位图案内层颜色
- (void)changeInnerColor {
    
    CIImage *coreImage = [CIImage imageWithColor:[CIColor colorWithCGColor:_innerColor.CGColor]];
    CIFilter *cifiter = [CIFilter filterWithName:@"CICrop"];
    [cifiter setValue:[CIVector vectorWithX:0
                                          Y:0
                                          Z:10
                                          W:10]
               forKey:@"inputRectangle"];
    [cifiter setValue:coreImage forKey:@"inputImage"];
    CIImage* filteredImage = cifiter.outputImage;
    UIImage* colorImage = [UIImage imageWithCIImage:filteredImage];
    
    [self changePositionInnerColor:colorImage withPosition:TopLeft];
    [self changePositionInnerColor:colorImage withPosition:TopRight];
    [self changePositionInnerColor:colorImage withPosition:BottomLeft];
}

//添加二维码中心logo图
- (void)changeCenterImage {

    [self changePositionInnerColor:_centerImage withPosition:Center];
}


- (void)changeOuterPositionColor:(UIColor *)color withPosition:(ZZQRPosition)position {
    
    UIBezierPath *path = [self outerPositionPathWidth:_size withVersion:[self fetchVersion] wihtPosition:position];
    [color setStroke];
    [path stroke];
}

- (void)changePositionInnerColor:(UIImage *) image withPosition:(ZZQRPosition)position{
    
    CGRect rect = [self innerPositionRectWidth:_size withVersion:[self fetchVersion] wihtPosition:position];
    [image drawInRect:rect];
}


#pragma mark - 获取二维码定位图案位置

//二维码一共有40个尺寸。官方叫版本Version。Version 1是21 x 21的矩阵，Version 2是 25 x 25的矩阵，Version 3是29的尺寸，每增加一个version，就会增加4的尺寸，公式是：(V-1)4 + 21（V是版本号） 最高Version 40，(40-1)4+21 = 177，所以最高是177 x 177 的正方形。


//获取Version
- (CGFloat)fetchVersion {
    
    return ((_outPutImage.extent.size.width - 21)/4.0 + 1);
}

//换算成绘制坐标
//定位图案外层坐标
- (UIBezierPath *) outerPositionPathWidth:(CGFloat)width withVersion:(CGFloat )version wihtPosition:(ZZQRPosition) position
{
    CGFloat zonePathWidth = width/((version - 1) * 4 + 21);
    CGFloat positionFrameWidth = zonePathWidth * 6;
    CGPoint topLeftPoint = CGPointMake(zonePathWidth * 1.5, zonePathWidth * 1.5);
    CGRect rect = CGRectMake(topLeftPoint.x - 0.2, topLeftPoint.y - 0.2, positionFrameWidth, positionFrameWidth);
    
    rect = CGRectIntegral(rect);
    rect = CGRectInset(rect, 1, 1);
    UIBezierPath *path;
    CGFloat offset;
    switch (position) {
        case TopLeft:
            
            path = [UIBezierPath bezierPathWithRect:rect];
            path.lineWidth = zonePathWidth + 1.5;
            path.lineCapStyle = kCGLineCapSquare;
            break;
        case TopRight:
            
            offset = width - positionFrameWidth - topLeftPoint.x * 2;
            rect = CGRectOffset(rect, offset, 0);
            path = [UIBezierPath bezierPathWithRect:rect];
            path.lineWidth = zonePathWidth + 1.5;
            path.lineCapStyle = kCGLineCapSquare;
            break;
        case BottomLeft:
            
            offset = width - positionFrameWidth - topLeftPoint.x * 2;
            rect = CGRectOffset(rect, 0, offset);
            path = [UIBezierPath bezierPathWithRect:rect];
            path.lineWidth = zonePathWidth + 1.5;
            path.lineCapStyle = kCGLineCapSquare;
            break;
        case QuietZone:
            rect = CGRectMake(zonePathWidth * 0.5, zonePathWidth * 0.5, width - zonePathWidth, width - zonePathWidth);
            path = [UIBezierPath bezierPathWithRect:rect];
            path.lineWidth = zonePathWidth + [UIScreen mainScreen].scale;
            path.lineCapStyle = kCGLineCapSquare;
            break;
        default:
            
            path = [UIBezierPath bezierPath];
            break;
    }
    return path;
}


//定位图案内层坐标包括中心图片位置
- (CGRect)innerPositionRectWidth:(CGFloat )width withVersion:(CGFloat )version wihtPosition:(ZZQRPosition) position
{
    CGFloat leftMargin = width * 3 / ((version - 1) * 4 + 21);
    CGFloat tileWidth = leftMargin;
    CGFloat centerImageWith = width * 10 / ((version - 1) * 4 + 21);
    
    CGRect rect = CGRectMake(leftMargin + 1.5, leftMargin + 1.5, leftMargin - 3, leftMargin - 3);
    rect = CGRectIntegral(rect);
    rect = CGRectInset(rect, -1, -1);
    
    CGFloat offset;
    switch (position) {
        case TopLeft:
            
            break;
        case TopRight:
            
            offset = width - tileWidth - leftMargin*2;
            rect = CGRectOffset(rect, offset, 0);
            break;
        case BottomLeft:
            
            offset = width - tileWidth - leftMargin * 2;
            rect = CGRectOffset(rect, 0, offset);
            break;
        case Center:
            
            rect = CGRectMake(CGPointZero.x, CGPointZero.y, centerImageWith, centerImageWith);
            offset = width/2 - centerImageWith/2;
            rect = CGRectOffset(rect, offset, offset);
            break;
        default:
            rect = CGRectZero;
            break;
    }
    
    return rect;
}


@end
