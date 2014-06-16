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
        self.place = [decoder decodeObjectForKey:@"place"];
        self.doctorSpeciality = [decoder decodeObjectForKey:@"doctorSpeciality"];
        self.idDoctorSpeciality = [decoder decodeIntegerForKey:@"idDoctorSpeciality"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.eventId = [decoder decodeObjectForKey:@"eventId"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.doctorName forKey:@"doctorName"];
    [encoder encodeObject:self.place forKey:@"place"];
    [encoder encodeObject:self.doctorSpeciality forKey:@"doctorSpeciality"];
    [encoder encodeInteger:self.idDoctorSpeciality forKey:@"idDoctorSpeciality"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.eventId forKey:@"eventId"];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"nome:%@ \n local:%@ \n Especialidade: %@ \n Data: %@ \n",self.doctorName,self.place,self.doctorSpeciality,self.date];
}
@end
