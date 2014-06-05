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
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:consult];
    
    [data writeToFile:@"/tmp/consulta.plist" atomically:YES];

}


-(NSArray*)listConsult{
    
    //        NSData *dataConsulta = [NSData dataWithContentsOfFile:@"/tmp/consulta.plist"];
    //        AMVConsult *consultaCarregada = [NSKeyedUnarchiver unarchiveObjectWithData:dataConsulta];
    //        NSLog(@"Doctor name: %@",consultaCarregada.doctorName);
    
    
    return nil;
}

@end
