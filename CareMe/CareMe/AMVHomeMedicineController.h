//
//  AMVHomeMedicineController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVCareMeUtil.h"
#import "AMVAddMedicineController.h"
#import "AMVMedicineDAO.h"
#import "AMVMedicineCell.h"
#import "AMVMedicine.h"
#import "AMVMedicineDetailsViewController.h"

@interface AMVHomeMedicineController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSString *_titleLeftBarButtonEditing;
    NSString *_titleLeftBarButtonOK;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayPeriodSC;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMedicines;


@end
