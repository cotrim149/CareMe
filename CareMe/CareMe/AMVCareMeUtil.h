//
//  AMVCareMeUtil.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMVCareMeUtil : NSObject

typedef NS_ENUM(short, DAY_PERIOD) {
    MORNING, AFTERNOON, NIGHT
};

#define UIColorFromRGB(rgbValue, alphaValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha: (float)alphaValue]

+(UIColor*) firstColor;
+(UIColor*) secondColor;
+(UIColor*) thirdColor;
+(DAY_PERIOD) dayPeriodNow;

@end
