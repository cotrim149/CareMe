//
//  AMVHomeMedicineController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVHomeMedicineController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayPeriodSC;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView *medicineTable;
@end
