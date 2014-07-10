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
        self.name = [decoder decodeObjectForKey:@"name"];
        self.dosage = [decoder decodeObjectForKey:@"dosage"];
        self.howUse = [decoder decodeObjectForKey:@"howUse"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];
        self.periodValue = [decoder decodeIntegerForKey:@"periodValue"];
        self.periodType = [decoder decodeIntegerForKey:@"periodType"];
        self.reminderId = [decoder decodeObjectForKey:@"reminderId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.dosage forKey:@"dosage"];
    [encoder encodeObject:self.howUse forKey:@"howUse"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeInteger:self.periodValue forKey:@"periodValue"];
    [encoder encodeInteger:self.periodType forKey:@"periodType"];
    [encoder encodeObject:self.reminderId forKey:@"reminderId"];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.dosage=%@", self.dosage];
    [description appendFormat:@", self.howUse=%@", self.howUse];
    [description appendFormat:@", self.startDate=%@", self.startDate];
    [description appendFormat:@", self.endDate=%@", self.endDate];
    [description appendFormat:@", self.periodValue=%li", (long)self.periodValue];
    [description appendFormat:@", self.periodType=%d", self.periodType];
    [description appendFormat:@", self.reminderId=%@", self.reminderId];
    [description appendString:@">"];
    return description;
}

@end
