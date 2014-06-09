//
//  AMVConsultDAO.h
//  CareMe
//
//  Created by Victor de Lima on 05/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMVConsult.h"

@interface AMVConsultDAO : NSObject

-(void)saveConsult:(AMVConsult*)consult;
-(NSArray*)listConsults;
-(NSArray*)listSpecialities;
@end
