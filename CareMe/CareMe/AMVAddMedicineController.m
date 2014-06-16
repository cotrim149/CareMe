//
//  AMVAddMedicineontroller.m
//  CareMe
//
//  Created by Matheus Fonseca on 03/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddMedicineController.h"

@interface AMVAddMedicineController () {
    AMVMedicineDAO *_dao;
    UITextField *_activeField;
    NSArray *_periodTypes;
    NSArray *_periodValues;
}

@end

@implementation AMVAddMedicineController

static NSString * const MEDICINE_HOWUSE_PLACEHOLDER = @"Como administrar..."; // const pointer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVMedicineDAO alloc]init];
        _periodTypes = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)"];
        _periodValues = [self getPeriodValues];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
    
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
    
    self.navigationItem.rightBarButtonItem=completeAddBt;
    
    self.scrollView.contentSize = self.contentView.frame.size;
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
    //    if(_medicinePeriod == nil)
    //        [errorMsg appendString:@"Período em branco.\n"];
    
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
        // Popula a entity
        AMVMedicine *medicine = [[AMVMedicine alloc] init];
        [medicine setName:self.medicineNameTF.text];
        [medicine setDosage:self.medicineDosageTF.text];
        [medicine setHowUse:self.medicineHowUseTV.text];
        [medicine setStartDate: [self getDateComponent:self.startDatePicker] ];
        [medicine setEndDate:[self getDateComponent:self.endDatePicker]];
        
        [medicine setPeriodType:(AMVPeriodEnum)[self.periodPicker selectedRowInComponent:1]];
        
        [medicine setPeriodValue:(NSInteger)[self.periodPicker selectedRowInComponent:0] + 1];
        
        // Salva a entity
        [_dao saveMedicinet:medicine];
        
        [self.navigationController popViewControllerAnimated:YES];
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
    
    aRect.size.height -= kbSize.height + 50;
    
//    CGPointMake(activeField.frame.size.height, activeField.frame.origin.y);
    
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, -(kbSize.height + 20), 0.0);
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    
    
}

-(NSArray *)getPeriodValues{
    
    NSMutableArray *values = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 100; i++) {
        [values addObject:[NSString stringWithFormat:@"%d",i ]];
    }
    
    return [[NSArray alloc]initWithArray:values];
}

@end
