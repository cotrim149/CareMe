//
//  AMVAddConsultController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddConsultController.h"
#import "AMVCareMeUtil.h"
#import "AMVConsult.h"
#import "AMVConsultDAO.h"
#import "AMVEventsManagerSingleton.h"
#import "AMVHomeConsultController.h"

@interface AMVAddConsultController () {
    AMVConsultDAO *_dao;
    NSArray *_specialities;
    AMVEventsManagerSingleton *_eventsManager;
}

@end

@implementation AMVAddConsultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVConsultDAO alloc] init];
        _specialities = [_dao listSpecialities];
        _eventsManager = [AMVEventsManagerSingleton getInstance];
        _eventsManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
}

-(void) addComponentsAndConfigureStyle {
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    
    self.navigationItem.rightBarButtonItem=completeAddBt;
    
    self.specialtyPk.transform = CGAffineTransformMakeScale(1, 0.8);
    
    [self.specialtyPk selectRow:((int)[_specialities count]/2) inComponent:0 animated:YES];
    
    self.datePk.transform = CGAffineTransformMakeScale(1, 0.8);
    
    [self.datePk setMinimumDate:[NSDate date]];
    
    
    CGRect layerFrame = CGRectMake(0, 0, self.addToCalendarLb.frame.size.width, self.addToCalendarLb.frame.size.height);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, 0); // top line
    CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height); // bottom line
    CAShapeLayer * line = [CAShapeLayer layer];
    line.path = path;
    line.lineWidth = 0.5;
    line.frame = layerFrame;
    line.strokeColor = [AMVCareMeUtil secondColor].CGColor;
    [self.addToCalendarLb.layer addSublayer:line];
    
    layerFrame = CGRectMake(0, 0, self.addToCalendarLb.frame.size.width, self.addToCalendarLb.frame.size.height);
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height); // bottom line
    line = [CAShapeLayer layer];
    line.path = path;
    line.lineWidth = 0.5;
    line.frame = layerFrame;
    line.strokeColor = [AMVCareMeUtil secondColor].CGColor;
    [self.addAlarmLb.layer addSublayer:line];
}

-(void)notifyConsultEventResult:(BOOL)result {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if(result == YES) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta!"
                                  message:@"Consulta adicionada aos eventos!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta!"
                                  message:@"Não foi possível adicionar a consulta aos eventos. Verifique as permissões do app."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    });
}

-(void)notifyMedicineReminderResult:(BOOL)result {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if(result == YES) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta!"
                                  message:@"Consulta foi adicionada aos lembretes!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta!"
                                  message:@"Não foi possível adicionar a consulta aos lembretes. Verifique as permissões do app."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    });

}


- (IBAction)hideKeyboard:(id)sender {
    [sender endEditing:YES];
}

-(NSDateComponents *)getPickerDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit  |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit   |
                                                         NSHourCalendarUnit  |
                                                         NSMinuteCalendarUnit|
                                                         NSSecondCalendarUnit) fromDate:self.datePk.date];
    return components;
}

-(NSInteger)getPickerEspecialityID {
    return [self.specialtyPk selectedRowInComponent:0];
}

-(void) addCompleted {
    NSMutableString *errorMsg = [[NSMutableString alloc] init];
    
    
    if([self.placeTF.text isEqualToString:@""]){
        [errorMsg appendString:@"Local da consulta em branco.\n"];
    }

    if([self.doctorNameTF.text isEqualToString:@""]){
        [errorMsg appendString:@"Nome do médico em branco.\n"];
    }

    if(![errorMsg isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Campo em branco"
                              message:errorMsg
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        // Popula a entity
        AMVConsult *consult = [[AMVConsult alloc] init];
        
        consult.place = self.placeTF.text;
        consult.doctorName = self.doctorNameTF.text;
        consult.idDoctorSpeciality = [self getPickerEspecialityID];
        consult.doctorSpeciality = [_specialities objectAtIndex:[self getPickerEspecialityID]];
        consult.date = [self getPickerDate];
        
        // Salva a entity
        [_dao saveConsult:consult];
        
        if(self.addToCalandarSw.isOn) {
            [_eventsManager addConsultEvent:consult withAlarm:self.addAlarmSw.isOn];
        }

        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)addToCalendarChange:(id)sender {
    self.addAlarmSw.enabled = self.addToCalandarSw.isOn ? YES : NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


// Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_specialities count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_specialities objectAtIndex:row];
}


@end
