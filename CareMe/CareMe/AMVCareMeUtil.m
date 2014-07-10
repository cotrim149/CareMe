//
//  AMVCareMeUtil.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVCareMeUtil.h"
#import "AMVConsultDAO.h"
#import "AMVMedicineDAO.h"

@implementation AMVCareMeUtil

static NSDateFormatter *_df;

+ (CAGradientLayer*) gradientBgLayer {
    UIColor *colorOne = UIColorFromRGB(0xE9FDFF, 0.5);
    UIColor *colorTwo = UIColorFromRGB(0xF6F6F6, 0.5);
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

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
    
    return [self dayPeriodForDate:components];
}

+(DAY_PERIOD) dayPeriodForDate: (NSDateComponents*) components{
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

+(void) seedDatabase {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    AMVConsultDAO *dao = [[AMVConsultDAO alloc] init];
    for(int i = 0; i < 10; i++) {
        AMVConsult *consult = [[AMVConsult alloc] init];
        
        if(i % 2 == 0)
            consult.date = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:1*60*60*24*10]];
        else
            consult.date = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:-1*60*60*24*10]];
        consult.doctorSpeciality = @"Clínica";
        consult.idDoctorSpeciality = 5;
        consult.doctorName = [NSString stringWithFormat:@"Doutor %d", i];
        consult.place = [NSString stringWithFormat:@"Lugar %d", i];
        consult.eventId = nil;
        [dao saveConsult:consult];
    }
    
    AMVMedicineDAO *dao2 = [[AMVMedicineDAO alloc] init];
    for(int i = 0; i < 10; i++) {
        AMVMedicine *medicine = [[AMVMedicine alloc] init];
        
        if(i % 2 == 0)
            medicine.endDate = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:1*60*60*24*10]];
        else
            medicine.endDate = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:-1*60*60*24*10]];
        
        medicine.name = [NSString stringWithFormat:@"Remédio %d", i];
        medicine.dosage = @"Dosagem";
        medicine.howUse = [NSString stringWithFormat:@"Como usar o remédio '%d'", i];
        medicine.startDate = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:-1*60*60*24*30]];
        medicine.periodValue = 1;
        medicine.periodType = DAY;
        medicine.reminderId = nil;
        
        [dao2 saveMedicinet:medicine];
    }
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
