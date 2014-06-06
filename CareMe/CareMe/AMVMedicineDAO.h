//
//  AMVMedicineDAO.h
//  CareMe
//
//  Created by Victor de Lima on 06/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMVMedicine.h"
@interface AMVMedicineDAO : NSObject

-(void)saveConsult:(AMVMedicine*)medicine;
-(NSArray*)listConsult;

@end
