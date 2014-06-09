//
//  AMVConsultDAO.m
//  CareMe
//
//  Created by Victor de Lima on 05/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultDAO.h"

@implementation AMVConsultDAO

-(void)saveConsult:(AMVConsult*)consult{
    
    NSMutableArray *consultas = [[NSMutableArray alloc] initWithArray:[self listConsult]];
    
    [consultas addObject:consult];

    for (int i=0; i<[consultas count]; i++) {
        NSLog(@"%@",[consultas objectAtIndex:i]);
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:consultas];
    
    [data writeToFile:@"/tmp/consulta.plist" atomically:YES];
    
}


-(NSArray*)listConsult{
    
    NSData *dataConsulta = [NSData dataWithContentsOfFile:@"/tmp/consulta.plist"];
    
    NSArray *consultas = [NSKeyedUnarchiver unarchiveObjectWithData:dataConsulta];
    
    return consultas;
}

@end
