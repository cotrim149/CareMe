//
//  AMVConsultService.m
//  CareMe
//
//  Created by Alysson Lopes on 6/6/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultService.h"
#import "AMVConsultDAO.h"

@interface AMVConsultService ()

@end

@implementation AMVConsultService

+(NSMutableArray *) getAll{
    
    AMVConsultDAO *consultDAO = [[AMVConsultDAO alloc] init];
    
    NSMutableArray *consults = [[NSMutableArray alloc]initWithArray:[consultDAO listConsult]];
    
    return consults;
}

@end
