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
        self.doctorSpeciality = [decoder decodeObjectForKey:@"doctorSpeciality"];
        self.date = [decoder decodeObjectForKey:@"date"];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.doctorName forKey:@"doctorName"];
    [encoder encodeObject:self.consultPlace forKey:@"consultPlace"];
    [encoder encodeObject:self.doctorSpeciality forKey:@"doctorSpeciality"];
    [encoder encodeObject:self.date forKey:@"date"];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"nome:%@ \n local:%@ \n Especialidade: %@ \n Data: %@ \n",self.doctorName,self.consultPlace,self.doctorSpeciality,self.date];
}
@end
