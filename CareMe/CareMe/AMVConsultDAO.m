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
            _specialities = @[@"Acupuntura", @"Anestesiologia", @"Angiologia", @"Cardiologia", @"Cirurgia",
                              @"Clínica", @"Coloproctologia", @"Dermatologia", @"Endocrinologia", @"Endoscopia", @"Exames", @"Gastroenterologia", @"Genética",
                              @"Geriatria", @"Ginecologia", @"Hematologia", @"Homeopatia", @"Imunologia", @"Infectologia", @"Mastologia",@"Nefrologia", @"Nutrologia", @"Odontologia", @"Oftamologia",
                              @"Oncologia", @"Ortopedia", @"Otorrinolaringologia", @"Pediatria",
                              @"Pneumologia", @"Psiquiatria", @"Reumatologia", @"Urologia", @"Outros"];
        }
    }
    return self;
}

-(void)saveConsult:(AMVConsult*)consult{
    
    NSMutableArray *consults = [[NSMutableArray alloc] initWithArray:[self listConsults]];
    
    [consults insertObject:consult atIndex:0];

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

-(void)deleteConsult:(AMVConsult*)consult{
    int index=0;
    
    NSMutableArray *consults = [[NSMutableArray alloc] initWithArray:[self listConsults]];
    
    for (int i=0; i< [consults count]; i++) {
        AMVConsult *tempConsult = [consults objectAtIndex:i];
        
        if([tempConsult.doctorName isEqualToString:consult.doctorName]
           && [tempConsult.place isEqualToString:consult.place]
           && tempConsult.idDoctorSpeciality == consult.idDoctorSpeciality
           && [tempConsult.date isEqual:consult.date]) {
            index = i;
        }
    }
    
    [consults removeObjectAtIndex:index];
    
    NSData *consultsData = [NSKeyedArchiver archivedDataWithRootObject:consults];
    
    [consultsData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"consult"] atomically:YES];

    
}

@end
