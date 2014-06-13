//
//  AMVAddConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVHomeConsultController.h"
#import "AMVEventsManagerDelegate.h"

@interface AMVAddConsultController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, AMVEventsManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addAlarmLb;
@property (weak, nonatomic) IBOutlet UISwitch *addAlarmSw;

@property (weak, nonatomic) IBOutlet UISwitch *addToCalandarSw;
@property (weak, nonatomic) IBOutlet UILabel *addToCalendarLb;

@property (nonatomic, strong) AMVConsult *consult;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;
@property (weak, nonatomic) IBOutlet UIPickerView *specialtyPk;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePk;

@end
