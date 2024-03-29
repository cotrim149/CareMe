//
//  AMVAddMedicineontroller.h
//  CareMe
//
//  Created by Matheus Fonseca on 03/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVCareMeUtil.h"
#import "AMVMedicine.h"
#import "AMVMedicineDAO.h"

@interface AMVAddMedicineController : UIViewController <UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic) AMVMedicine *medicineToBeEdited;

@property (weak, nonatomic) IBOutlet UITextField *medicineNameTF;
@property (weak, nonatomic) IBOutlet UITextField *medicineDosageTF;
@property (weak, nonatomic) IBOutlet UITextView *medicineHowUseTV;

@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *startDate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIControl *contentView;
@property (nonatomic) UIDatePicker *startDatePicker;
@property (nonatomic) UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *periodPicker;
@property (weak, nonatomic) IBOutlet UISwitch *addToRemindersSw;
@property (weak, nonatomic) IBOutlet UILabel *addToRemindersLb;
@property (weak, nonatomic) IBOutlet UISwitch *addAlarmSw;
@property (weak, nonatomic) IBOutlet UILabel *addAlarmLb;

@property (weak, nonatomic) IBOutlet UILabel *infoLb;
@property (weak, nonatomic) IBOutlet UIButton *infoReminderBt;
@property (weak, nonatomic) IBOutlet UIButton *infoAlarmBt;
@end
