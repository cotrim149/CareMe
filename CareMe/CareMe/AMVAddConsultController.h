//
//  AMVAddConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVAddConsultController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_especialidades;
    
}
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;
@property (weak, nonatomic) IBOutlet UIButton *symptomsBt;
@property (weak, nonatomic) IBOutlet UIPickerView *specialtyPk;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePk;


@end
