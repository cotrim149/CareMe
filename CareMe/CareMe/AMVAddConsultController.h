//
//  AMVAddConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVHomeConsultController.h"
#import "AMVConsult.h"

@interface AMVAddConsultController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *addAlarmLb;
@property (weak, nonatomic) IBOutlet UISwitch *addAlarmSw;

@property (weak, nonatomic) IBOutlet UISwitch *addToCalandarSw;
@property (weak, nonatomic) IBOutlet UILabel *addToCalendarLb;

@property (nonatomic, strong) AMVConsult *consultToBeEdited;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;
@property (weak, nonatomic) IBOutlet UIPickerView *specialtyPk;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (nonatomic) IBOutlet UIDatePicker *datePk;

@end
