//
//  AMVConsult.m
//  CareMe
//
//  Created by Victor de Lima on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsult.h"

@implementation AMVConsult

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.doctorName = [decoder decodeObjectForKey:@"doctorName"];
        self.consultPlace = [decoder decodeObjectForKey:@"consultPlace"];
        self.IdDoctorSpeciality = (int)[decoder decodeObjectForKey:@"IdDoctorSpeciality"];
        self.date = [decoder decodeObjectForKey:@"date"];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.doctorName forKey:@"doctorName"];
    [encoder encodeObject:self.consultPlace forKey:@"consultPlace"];
    [encoder encodeInteger:self.IdDoctorSpeciality forKey:@"IdDoctorSpecialityq"];
    [encoder encodeObject:self.date forKey:@"date"];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"nome:%@ \n local:%@ \n Especialidade: %ld \n Data: %@ \n",self.doctorName,self.consultPlace,(long)self.IdDoctorSpeciality,self.date];
}
@end
