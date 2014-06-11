//
//  AMVAddConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVConsult.h"

@interface AMVAddConsultController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) AMVConsult *consult;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;
@property (weak, nonatomic) IBOutlet UIPickerView *specialtyPk;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePk;

@end
