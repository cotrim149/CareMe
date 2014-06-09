//
//  AMVMedicine.h
//  CareMe
//
//  Created by Victor de Lima on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMVMedicine : NSObject <NSCoding>

@property (nonatomic) NSString *medicineName;
@property (nonatomic) NSString *medicineDosage;
@property (nonatomic) NSString *medicineHowUse;
@property (nonatomic) NSDateComponents *startDate;
@property (nonatomic) NSDateComponents *endDate;

@end
