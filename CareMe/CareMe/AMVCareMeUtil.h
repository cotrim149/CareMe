//
//  AMVCareMeUtil.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface AMVCareMeUtil : NSObject

typedef NS_ENUM(short, DAY_PERIOD) {
    MORNING, AFTERNOON, NIGHT, ALL
};

#define UIColorFromRGB(rgbValue, alphaValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha: (float)alphaValue]

+(UIColor*) firstColor;
+(UIColor*) secondColor;
+(UIColor*) thirdColor;
+ (CAGradientLayer*) gradientBgLayer;
+(DAY_PERIOD) dayPeriodNow;
+(DAY_PERIOD) dayPeriodForDate:(NSDateComponents*) components;
+(NSString*) getDocumentsFilePathWithSuffix:(NSString*) suffix;
+(void) deleteAllPlists;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
