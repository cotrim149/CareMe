//
//  AMVAddMedicineontroller.m
//  CareMe
//
//  Created by Matheus Fonseca on 03/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddMedicineController.h"
#import "AMVCareMeUtil.h"
#import "DSLCalendarView.h"
#import "AMVMedicine.h"

@interface AMVAddMedicineController () {
    DSLCalendarRange *_medicinePeriod;
}

@end

@implementation AMVAddMedicineController

static NSString * const MEDICINE_HOWUSE_PLACEHOLDER = @"Como administrar..."; // const pointer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addComponentsAndConfigureStyle];

}

-(void) addComponentsAndConfigureStyle {
    
    self.medicineHowUseTV.delegate = self;
    self.medicineHowUseTV.text = MEDICINE_HOWUSE_PLACEHOLDER;
    self.medicineHowUseTV.textColor = [UIColor lightGrayColor];
    self.medicineHowUseTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.medicineHowUseTV.layer.borderWidth = 1.0f; //make border 1px thick
    self.medicineHowUseTV.layer.cornerRadius = 5.0f;
    
    self.medicineNameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.medicineDosageTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    
    self.periodCalendarView.delegate = self;
    
    self.navigationItem.rightBarButtonItem=completeAddBt;
    
    self.scrollView.contentSize = self.contentView.frame.size;
}

- (IBAction)hideKeyboard:(id)sender {
    [sender endEditing:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

-(void) addCompleted {
    NSMutableString *errorMsg = [[NSMutableString alloc] init];
    
    if([self.medicineNameTF.text isEqualToString:@""])
        [errorMsg appendString:@"Nome do medicamento em branco.\n"];
    if([self.medicineDosageTF.text isEqualToString:@""])
        [errorMsg appendString:@"Dosagem em branco.\n"];
    if(_medicinePeriod == nil)
        [errorMsg appendString:@"Período em branco.\n"];
    
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
        [medicine setStartDate:_medicinePeriod.startDay];
        [medicine setEndDate:_medicinePeriod.endDay];
        // Salva a entity
        
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

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        _medicinePeriod = range;
        self.scrollView.scrollEnabled = YES;
    }

}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    
    self.scrollView.scrollEnabled = NO;
    
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {

}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
