//
//  AMVMedicineDAO.h
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMVMedicine.h"

@interface AMVMedicineDAO : NSObject

-(void)saveMedicinet:(AMVMedicine*)medicine;
-(NSArray*)listMedicines;

@end
