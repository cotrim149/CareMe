//
//  AMVAddMedicineontroller.m
//  CareMe
//
//  Created by Matheus Fonseca on 03/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddMedicineController.h"
#import "AMVEventsManagerSingleton.h"

@interface AMVAddMedicineController () {
    AMVMedicineDAO *_dao;
    UITextField *_activeField;
    NSArray *_periodTypes;
    NSArray *_periodValues;
    AMVEventsManagerSingleton *_eventsManager;
}

@end

@implementation AMVAddMedicineController

static NSString * const MEDICINE_HOWUSE_PLACEHOLDER = @"Como administrar..."; // const pointer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVMedicineDAO alloc]init];
        _periodTypes = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)", @"Ano(s)"];
        _periodValues = [self getPeriodValues:HOUR];
        _eventsManager = [AMVEventsManagerSingleton getInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
    
    if(_medicineToBeEdited){
        _periodValues = [self getPeriodValues:_medicineToBeEdited.periodType];
        [self.periodPicker reloadComponent:0];
        
        self.medicineNameTF.text = _medicineToBeEdited.name;
        self.medicineDosageTF.text = _medicineToBeEdited.dosage;
        if(![_medicineToBeEdited.howUse isEqualToString:@""])
            self.medicineHowUseTV.text = _medicineToBeEdited.howUse;
        self.endDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",(long)_medicineToBeEdited.endDate.day,(long)_medicineToBeEdited.endDate.month, (long)_medicineToBeEdited.endDate.year];
        self.startDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu %02lu:%02lu",(long)_medicineToBeEdited.startDate.day,(long)_medicineToBeEdited.startDate.month, (long)_medicineToBeEdited.startDate.year, (long)_medicineToBeEdited.startDate.hour, (long)_medicineToBeEdited.startDate.minute];
        if(self.medicineToBeEdited.periodType == HOUR) {
            int i;
            for(i = 0; i < 7; i++)
                if([_periodValues[i] intValue] == _medicineToBeEdited.periodValue)
                    break;
            
            [self.periodPicker selectRow:i inComponent:0 animated:YES];
        } else {
            [self.periodPicker selectRow:_medicineToBeEdited.periodValue -1 inComponent:0 animated:YES];
        }
        [self.periodPicker selectRow:_medicineToBeEdited.periodType inComponent:1 animated:YES];
        
        self.addToRemindersSw.on = (_medicineToBeEdited.reminderId) ? YES : NO;
        self.addAlarmSw.enabled = self.addToRemindersSw.isOn ? YES : NO;
    }
    
    self.startDatePicker = [[UIDatePicker alloc]init];
    
    [self.startDatePicker setDate:[NSDate date]];
    [self.startDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.startDatePicker addTarget:self action:@selector(updateStartDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.startDate setInputView:self.startDatePicker];
    
    self.endDatePicker = [[UIDatePicker alloc]init];
    
    [self.endDatePicker setDate:[NSDate date]];
    [self.endDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.endDatePicker addTarget:self action:@selector(updateEndDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.endDate setInputView:self.endDatePicker];
    
}

-(void) addComponentsAndConfigureStyle {
    
    self.medicineNameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.medicineDosageTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.medicineHowUseTV.delegate = self;
    self.medicineHowUseTV.text = MEDICINE_HOWUSE_PLACEHOLDER;
    if (!_medicineToBeEdited || [_medicineToBeEdited.howUse isEqualToString:@""])
        self.medicineHowUseTV.textColor = [UIColor lightGrayColor];
    self.medicineHowUseTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.medicineHowUseTV.layer.borderWidth =  0.3f;
    self.medicineHowUseTV.layer.cornerRadius = 5.0f;
    
    self.periodPicker.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    
    self.navigationItem.rightBarButtonItem = completeAddBt;
    
    self.addToRemindersSw.onTintColor = [AMVCareMeUtil firstColor];
    self.addAlarmSw.onTintColor = [AMVCareMeUtil firstColor];
    
    CGRect layerFrame = CGRectMake(0, 0, self.addToRemindersLb.frame.size.width, self.addToRemindersLb.frame.size.height);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, 0); // top line
    CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height); // bottom line
    CAShapeLayer * line = [CAShapeLayer layer];
    line.path = path;
    line.lineWidth = 0.3;
    line.frame = layerFrame;
    line.strokeColor = [AMVCareMeUtil secondColor].CGColor;
    [self.addToRemindersLb.layer addSublayer:line];
    
    layerFrame = CGRectMake(0, 0, self.addAlarmLb.frame.size.width, self.addAlarmLb.frame.size.height);
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height); // bottom line
    line = [CAShapeLayer layer];
    line.path = path;
    line.lineWidth = 0.3;
    line.frame = layerFrame;
    line.strokeColor = [AMVCareMeUtil secondColor].CGColor;
    [self.addAlarmLb.layer addSublayer:line];
    
    [self.infoAlarmBt setImage:[UIImage imageNamed:@"info_icon.png"] forState:UIControlStateNormal];
    [self.infoReminderBt setImage:[UIImage imageNamed:@"info_icon.png"] forState:UIControlStateNormal];
    
    [self.infoLb setHidden:YES];
    
    self.infoLb.userInteractionEnabled = YES;
    
    self.infoLb.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInfoLabel)];
    [self.infoLb addGestureRecognizer:tapGesture];

    
}

-(IBAction)infoReminder:(id)sender{
    
    [self.infoLb setHidden:NO];
    
    self.infoLb.text = @"Adiciona o remédio aos lembretes do iOS";
    
    
}

-(IBAction)infoAlarm:(id)sender{
    
    [self.infoLb setHidden:NO];

    self.infoLb.text = @"Adicionar um alarme 10 minutos antes de cada horário em que se deve administrar o remédio";
}

-(void)dismissInfoLabel{
    [self.infoLb setHidden:YES];
}


- (IBAction)hideKeyboard:(id)sender {
    [sender endEditing:YES];
}

-(void) addCompleted {
    NSMutableString *errorMsg = [[NSMutableString alloc] init];
    
    if([self.medicineNameTF.text isEqualToString:@""])
        [errorMsg appendString:@"Nome do medicamento em branco.\n"];
    if([self.medicineDosageTF.text isEqualToString:@""])
        [errorMsg appendString:@"Dosagem em branco.\n"];
    if([self.startDate.text isEqualToString:@""])
        [errorMsg appendString:@"Data/hora de início em branco.\n"];
    if([self.endDate.text isEqualToString:@""])
        [errorMsg appendString:@"Data final em branco.\n"];

    
    if(![errorMsg isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Erro!"
                              message:errorMsg
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
    else{
        // EDITADO
        if(_medicineToBeEdited){
            [_dao deleteMedicine:_medicineToBeEdited];
            
            _medicineToBeEdited.name = self.medicineNameTF.text;
            _medicineToBeEdited.dosage = self.medicineDosageTF.text;

            if(![self.medicineHowUseTV.text isEqualToString:MEDICINE_HOWUSE_PLACEHOLDER])
                _medicineToBeEdited.howUse = self.medicineHowUseTV.text;
            else
                _medicineToBeEdited.howUse = @"";
            
            _medicineToBeEdited.startDate = [self getDateComponent:self.startDatePicker];
            _medicineToBeEdited.endDate = [self getDateComponent:self.endDatePicker];
            _medicineToBeEdited.periodType = (AMVPeriodEnum) [self.periodPicker selectedRowInComponent:1];
            NSString *periodValueString = (NSString*)[_periodValues objectAtIndex:[self.periodPicker selectedRowInComponent:0]];
            _medicineToBeEdited.periodValue = [periodValueString intValue];
            
            if(_medicineToBeEdited.reminderId != nil) {
                NSString *reminderId = [_eventsManager manipulateMedicineReminder:_medicineToBeEdited withAlarm:self.addAlarmSw.isOn manipulationType:UPDATE_EVENT];
                [self notifyMedicineReminderResult:(reminderId != nil) manipulationType:UPDATE_EVENT];
                _medicineToBeEdited.reminderId = reminderId;
            } else if (self.addToRemindersSw.isOn) {
                NSString *reminderId = [_eventsManager manipulateMedicineReminder:_medicineToBeEdited withAlarm:self.addAlarmSw.isOn manipulationType:CREATE_EVENT];
                [self notifyMedicineReminderResult:(reminderId != nil) manipulationType:CREATE_EVENT];
                _medicineToBeEdited.reminderId = reminderId;
            }
            
            [_dao saveMedicinet:_medicineToBeEdited];
         
        // NOVO
        } else {
            // Popula a entity
            AMVMedicine *medicine = [[AMVMedicine alloc] init];
            medicine.name = self.medicineNameTF.text;
            medicine.dosage = self.medicineDosageTF.text;
            medicine.howUse = self.medicineHowUseTV.text;
            if(![self.medicineHowUseTV.text isEqualToString:MEDICINE_HOWUSE_PLACEHOLDER])
                medicine.howUse = self.medicineHowUseTV.text;
            else
                medicine.howUse = @"";
            medicine.startDate = [self getDateComponent:self.startDatePicker];
            medicine.endDate = [self getDateComponent:self.endDatePicker];
            medicine.periodType = (AMVPeriodEnum) [self.periodPicker selectedRowInComponent:1];
            NSString *periodValueString = (NSString*)[_periodValues objectAtIndex:[self.periodPicker selectedRowInComponent:0]];
            medicine.periodValue = [periodValueString intValue];
            
            if(self.addToRemindersSw.isOn) {
                NSString *reminderId = [_eventsManager manipulateMedicineReminder:medicine withAlarm:self.addAlarmSw.isOn manipulationType:CREATE_EVENT];
                [self notifyMedicineReminderResult:(reminderId != nil) manipulationType:CREATE_EVENT];
                medicine.reminderId = reminderId;
            }
            
            // Salva a entity
            [_dao saveMedicinet:medicine];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)notifyMedicineReminderResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
    NSString *msg = nil;
    if(result == YES) {
        switch (manipulationType) {
            case CREATE_EVENT:
                msg = @"Medicamento foi adicionado aos lembretes!";
                break;
            case UPDATE_EVENT:
                msg = @"Medicamento foi atualizado dos lembretes!";
                break;
            case DELETE_EVENT:
                msg = @"Medicamento foi removido dos lembretes!";
                break;
                
            default:
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta!"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta!"
                              message:@"Não foi possível acessar os seus lembretes. Verifique as permissões do app."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:MEDICINE_HOWUSE_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = MEDICINE_HOWUSE_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    [textView resignFirstResponder];
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateStartDate:(id)sender
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    NSString *dateString = [format stringFromDate:self.startDatePicker.date];
    
    self.startDate.text = dateString;
    
    [self.endDatePicker setMinimumDate:self.startDatePicker.date];
    
}

-(void)updateEndDate:(id)sender
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [format stringFromDate:self.endDatePicker.date];
    
    self.endDate.text = dateString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification
{
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height + _activeField.frame.size.height;
    
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

-(NSDateComponents *)getDateComponent:(UIDatePicker *) datePicker{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit  |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit   |
                                                         NSHourCalendarUnit  |
                                                         NSMinuteCalendarUnit|
                                                         NSSecondCalendarUnit) fromDate:datePicker.date];
    return components;
}

///Period Picker

// returns the number of 'columns' to display.

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //set number of rows
    
    if(component == 0)
    {
        return [_periodValues count];
    }else
    {
        return [_periodTypes count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [_periodValues objectAtIndex:row];
    }
    else
    {
        return [_periodTypes objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 1) {
        _periodValues = [self getPeriodValues:(AMVPeriodEnum) [self.periodPicker selectedRowInComponent:1]];
        [self.periodPicker reloadComponent:0];
    }
}

-(NSArray *)getPeriodValues: (AMVPeriodEnum) periodType{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    
    if(periodType == HOUR) {
        for (int i = 1; i <= 24; i++) {
            if(24 % i == 0)
                [values addObject:[NSString stringWithFormat:@"%d",i ]];
        }
    } else {
        for (int i = 1; i <= 30; i++)
            [values addObject:[NSString stringWithFormat:@"%d",i ]];
        
    }
    
    return [[NSArray alloc]initWithArray:values];
}

- (IBAction)addToRemindersChange:(id)sender {
    self.addAlarmSw.enabled = self.addToRemindersSw.isOn ? YES : NO;
}

@end
