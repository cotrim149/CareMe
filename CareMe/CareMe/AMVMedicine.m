//
//  AMVMedicine.m
//  CareMe
//
//  Created by Victor de Lima on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicine.h"

@implementation AMVMedicine

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.medicineName = [decoder decodeObjectForKey:@"medicineName"];
        self.medicineDosage = [decoder decodeObjectForKey:@"medicineDosage"];
        self.medicineHowUse = [decoder decodeObjectForKey:@"medicineHowUse"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.medicineName forKey:@"medicineName"];
    [encoder encodeObject:self.medicineDosage forKey:@"medicineDosage"];
    [encoder encodeObject:self.medicineHowUse forKey:@"medicineHowUse"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
}

@end
