//
//  AMVMedicineDetailsViewController.h
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVMedicine.h"

@interface AMVMedicineDetailsViewController : UIViewController
@property (strong, nonatomic) AMVMedicine *medicine;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
