//
//  AMVCareMeUtil.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVCareMeUtil.h"

@implementation AMVCareMeUtil

static NSDateFormatter *_df;

+(UIColor*) firstColor {
    return UIColorFromRGB(0xa0c5e7, 1);
}
+(UIColor*) secondColor {
    return UIColorFromRGB(0x504e4e, 1);
}
+(UIColor*) thirdColor {
    return [UIColor whiteColor];
}

+(DAY_PERIOD) dayPeriodNow {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    int hour = (int)[components hour];
    
    DAY_PERIOD dayPeriod = 0;
    if(hour < 12)
        dayPeriod = MORNING;
    else if (hour < 18)
        dayPeriod = AFTERNOON;
    else
        dayPeriod = NIGHT;
    
    return dayPeriod;
}

// Sufixos serao "medicine" e "consult"
+(NSString *)getDocumentsFilePathWithSuffix:(NSString *)suffix {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/CareMe_%@.plist", documentsPath, suffix];
}

+(void) deleteAllPlists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:[self getDocumentsFilePathWithSuffix:@"consult"] error:nil];
    [fileManager removeItemAtPath:[self getDocumentsFilePathWithSuffix:@"medicine"] error:nil];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
