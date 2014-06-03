//
//  AMVCareMeUtil.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVCareMeUtil.h"

@implementation AMVCareMeUtil

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

@end
