//
//  AMVMedicineDAO.m
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicineDAO.h"
#import "AMVCareMeUtil.h"

@implementation AMVMedicineDAO

-(void)saveMedicinet:(AMVMedicine*)medicine{

    NSMutableArray *medicines = [[NSMutableArray alloc] initWithArray:[self listMedicines]];
    
    [medicines addObject:medicine];
    
    NSData *consultsData = [NSKeyedArchiver archivedDataWithRootObject:medicines];
    
    [consultsData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"medicine"] atomically:YES];
    
}


-(NSArray*)listMedicines{
    NSData *medicinesData = [NSData dataWithContentsOfFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"medicine"]];
    
    NSArray *medicines = [NSKeyedUnarchiver unarchiveObjectWithData:medicinesData];
    
    return medicines;
}

@end
