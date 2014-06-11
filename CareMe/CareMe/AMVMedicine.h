//
//  AMVMedicine.h
//  CareMe
//
//  Created by Victor de Lima on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, AMVPeriodEnum){
    HOUR,
    WEEK
};

@interface AMVMedicine : NSObject <NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *dosage;
@property (nonatomic) NSString *howUse;
@property (nonatomic) NSDateComponents *startDate;
@property (nonatomic) NSDateComponents *endDate;
@property (nonatomic) NSInteger *periodValue;
@property (nonatomic) AMVPeriodEnum period;

@end
