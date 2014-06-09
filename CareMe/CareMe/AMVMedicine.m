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
}

@end
