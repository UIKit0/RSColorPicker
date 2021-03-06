//
//  RSColorFunctions.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/12/13.
//

#import "RSColorFunctions.h"

BMPixel RSPixelFromHSV(CGFloat H, CGFloat S, CGFloat V)
{
    if (S == 0) {
        return BMPixelMake(V, V, V, 1.0);
    }
    if (H == 1) {
        H = 0;
    }

    CGFloat var_h = H * 6.0;
    // Verified `H` is never <0 so (int) is OK:
    int var_i = (int)var_h;
    CGFloat var_1 = V * (1.0 - S);

    if (var_i == 0) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(V, var_3, var_1, 1.0);
    } else if (var_i == 1) {
        CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
        return BMPixelMake(var_2, V, var_1, 1.0);
    } else if (var_i == 2) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(var_1, V, var_3, 1.0);
    } else if (var_i == 3) {
        CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
        return BMPixelMake(var_1, var_2, V, 1.0);
    } else if (var_i == 4) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(var_3, var_1, V, 1.0);
    }
    CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
    return BMPixelMake(V, var_1, var_2, 1.0);
}


void RSHSVFromPixel(BMPixel pixel, CGFloat *h, CGFloat *s, CGFloat *v)
{
    UIColor *color = [UIColor colorWithRed:pixel.red green:pixel.green blue:pixel.blue alpha:1];
    [color getHue:h saturation:s brightness:v alpha:NULL];
}

void RSGetComponentsForColor(float *components, UIColor *color)
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    // this is pretty clever; I'll allow it to stay.
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);

    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

UIImage * RSUIImageWithScale(UIImage *img, CGFloat scale)
{
    return [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
}

/**
 * Returns image that looks like a checkered background.
 */
UIImage * RSOpacityBackgroundImage(CGFloat length, CGFloat scale, UIColor *color) {
    length *= scale;
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, length*0.5, length*0.5)];
    UIBezierPath *rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(length*0.5, length*0.5, length*0.5, length*0.5)];
    UIBezierPath *rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(0, length*0.5, length*0.5, length*0.5)];
    UIBezierPath *rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(length*0.5, 0, length*0.5, length*0.5)];

    UIGraphicsBeginImageContext(CGSizeMake(length, length));

    [color setFill];
    [rectanglePath fill];
    [rectangle2Path fill];

    [[UIColor whiteColor] setFill];
    [rectangle3Path fill];
    [rectangle4Path fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return RSUIImageWithScale(image, scale);
}
