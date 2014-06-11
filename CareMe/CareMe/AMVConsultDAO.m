//
//  AMVConsultDAO.m
//  CareMe
//
//  Created by Victor de Lima on 05/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultDAO.h"
#import "AMVCareMeUtil.h"

@implementation AMVConsultDAO

static NSArray * _specialities;

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (_specialities == nil) {
            _specialities = @[@"Acupuntura", @"Alergista", @"Anestesiologia", @"Cardiologia", @"Cirurgião",
                              @"Clinica", @"Dermatologia", @"Endocrinologia", @"Gastroenterologia",
                              @"Geriatria", @"Ginecologia", @"Infectologia", @"Nefrologia",@"Oftamologia",
                              @"Oncologia", @"Ortopedia", @"Otorrinolaringologia", @"Pediatria",
                              @"Pneumologia", @"Reumatologia", @"Urologia"];
        }
    }
    return self;
}

-(void)saveConsult:(AMVConsult*)consult{
    
    NSMutableArray *consults = [[NSMutableArray alloc] initWithArray:[self listConsults]];
    
    [consults addObject:consult];

    NSData *consultsData = [NSKeyedArchiver archivedDataWithRootObject:consults];
    
    [consultsData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"consult"] atomically:YES];
    
}


-(NSArray*)listConsults {
    NSData *consultsData = [NSData dataWithContentsOfFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"consult"]];
    
    NSArray *consults = [NSKeyedUnarchiver unarchiveObjectWithData:consultsData];
    
    return consults;
}

-(NSArray*)listSpecialities {
    return _specialities;
}

-(void)deleteConsultWithIndex:(int)index{
    NSMutableArray *consults = [[NSMutableArray alloc] initWithArray:[self listConsults]];
    
    [consults removeObjectAtIndex:index];
    
    NSData *consultsData = [NSKeyedArchiver archivedDataWithRootObject:consults];
    
    [consultsData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"consult"] atomically:YES];

    
}

@end
