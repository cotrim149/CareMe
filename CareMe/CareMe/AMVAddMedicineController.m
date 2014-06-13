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
    UITextField *activeField;
}

@end

@implementation AMVAddMedicineController

static NSString * const MEDICINE_HOWUSE_PLACEHOLDER = @"Como administrar..."; // const pointer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVMedicineDAO alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
    
    self.startDatePiker = [[UIDatePicker alloc]init];
    
    [self.startDatePiker setDate:[NSDate date]];
    [self.startDatePiker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.startDatePiker addTarget:self action:@selector(updateStartDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.startDate setInputView:self.startDatePiker];
    
    self.endDatePiker = [[UIDatePicker alloc]init];
    
    [self.endDatePiker setDate:[NSDate date]];
    [self.endDatePiker setDatePickerMode:UIDatePickerModeDate];
    [self.endDatePiker addTarget:self action:@selector(updateEndDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.endDate setInputView:self.endDatePiker];
    
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
        //        [medicine setStartDate:_medicinePeriod.startDay];
        //        [medicine setEndDate:_medicinePeriod.endDay];
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
    
    NSString *dateString = [format stringFromDate:self.startDatePiker.date];
    
    self.startDate.text = dateString;
    
}

-(void)updateEndDate:(id)sender
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [format stringFromDate:self.endDatePiker.date];
    
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
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
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

@end
