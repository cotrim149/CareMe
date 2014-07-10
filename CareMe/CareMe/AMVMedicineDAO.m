//
//  AMVMedicineDAO.m
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicineDAO.h"

@implementation AMVMedicineDAO

-(void)saveMedicinet:(AMVMedicine*)medicine{

    NSMutableArray *medicines = [[NSMutableArray alloc] initWithArray:[self listMedicines]];
    
    [medicines insertObject:medicine atIndex:0];
    
    NSData *consultsData = [NSKeyedArchiver archivedDataWithRootObject:medicines];
    
    [consultsData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"medicine"] atomically:YES];
    
}


-(NSArray*)listMedicines{
    NSData *medicinesData = [NSData dataWithContentsOfFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"medicine"]];
    
    NSArray *medicines = [NSKeyedUnarchiver unarchiveObjectWithData:medicinesData];
    
    return medicines;
}

-(void)deleteMedicine:(AMVMedicine*)medicine{
    int index=0;
    
    NSMutableArray *medicines = [[NSMutableArray alloc] initWithArray:[self listMedicines]];
    
    for (int i=0; i< [medicines count]; i++) {
        AMVMedicine *tempMedicine = [medicines objectAtIndex:i];
        
        if([tempMedicine.name isEqualToString:medicine.name]
           && [tempMedicine.dosage isEqualToString:medicine.dosage]
           && [tempMedicine.howUse isEqualToString: medicine.howUse]
           && [tempMedicine.startDate isEqual:medicine.startDate]
           && [tempMedicine.endDate isEqual:medicine.endDate]) {
            index = i;
        }
    }
    
    [medicines removeObjectAtIndex:index];
    
    NSData *medicinesData = [NSKeyedArchiver archivedDataWithRootObject:medicines];
    
    [medicinesData writeToFile:[AMVCareMeUtil getDocumentsFilePathWithSuffix:@"medicine"] atomically:YES];
    
    
}

@end
