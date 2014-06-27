//
//  AMVAddConsultController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

// TODO
    // Prints (cadastrar previamente 5 entidades de cada):
        // Home de consultas com filtragem textual
        // Home de medicamentos
        // Tela de adição de consulta
        // Tela de detalhes do medicamento
        // Tela de alarme da consulta (alarme é 1h antes)
        // Tela de alarme do medicamento (alarme é 10min antes)
    // Concertar o scroll da view depois de acionar um picker/teclado
    // SE DER: Colocar ícone 'i' (a esquerda do label) para acionar um popup com infomações sobre os swiches
        // Adicionar aos lembretes? ----> Adiciona o remédio aos lembretes do iOS
        // Adicionar alarme? ----> Adicionar um alarme 10 minutos antes de cada horário em que se deve administrar o remédio

        // Adicionar ao calendário? ----> Adiciona a consulta aos calendário do iOS
        // Adicionar alarmes? ----> Adicionar dois alarmes, um para 1 dia antes da consulta e outro para 1 hora antes
    // Publicar o app

#import "AMVAddConsultController.h"
#import "AMVCareMeUtil.h"
#import "AMVConsultDAO.h"
#import "AMVEventsManagerSingleton.h"
#import "AMVHomeConsultController.h"

@interface AMVAddConsultController () {
    AMVConsultDAO *_dao;
    NSArray *_specialities;
    AMVEventsManagerSingleton *_eventsManager;
    UITextField *_activeField;
    UIEdgeInsets _oldScrollContentInset;
    UIEdgeInsets _oldScrollIndicatorInsets;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
    
    self.datePk = [[UIDatePicker alloc]init];
    self.datePk.minimumDate = [NSDate date];
    [self.datePk setDate:[NSDate date]];
    
    
    if(_consultToBeEdited){
        self.doctorNameTF.text = _consultToBeEdited.doctorName;
        self.placeTF.text = _consultToBeEdited.place;
        [self.specialtyPk selectRow:_consultToBeEdited.idDoctorSpeciality inComponent:0 animated:YES];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [self.datePk setDate:[calendar dateFromComponents:_consultToBeEdited.date]];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy hh:mm"];
        
        NSString *dateString = [format stringFromDate:[calendar dateFromComponents:_consultToBeEdited.date]];
        
        self.dateTF.text = dateString;
        
        self.addToCalandarSw.on = (_consultToBeEdited.eventId) ? YES : NO;
        self.addAlarmSw.enabled = self.addToCalandarSw.isOn ? YES : NO;
    }
    
    [self.datePk setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.datePk addTarget:self action:@selector(updateConsultDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.dateTF setInputView:self.datePk];
    
}

-(void) addComponentsAndConfigureStyle {
    
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    self.navigationItem.rightBarButtonItem=completeAddBt;
    
    self.specialtyPk.transform = CGAffineTransformMakeScale(1.1, 0.8);
    
    [self.specialtyPk selectRow:5 inComponent:0 animated:YES];
    
    self.datePk.transform = CGAffineTransformMakeScale(1, 0.8);

    if(_consultToBeEdited) {
        NSDate *editedConsultDate = [[NSCalendar currentCalendar] dateFromComponents: _consultToBeEdited.date];
        NSDate *nowDate = [NSDate date];
        NSDate *oldestDate = [editedConsultDate earlierDate:nowDate];
        self.datePk.minimumDate = oldestDate;
    } else {
        self.datePk.minimumDate = [NSDate date];
    }
    
    self.addToCalandarSw.onTintColor = [AMVCareMeUtil firstColor];
    self.addAlarmSw.onTintColor = [AMVCareMeUtil firstColor];
    
    CGRect layerFrame = CGRectMake(0, 0, self.addToCalendarLb.frame.size.width, self.addToCalendarLb.frame.size.height);
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
    [self.addToCalendarLb.layer addSublayer:line];
    
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
    
    [self.infoAlarmBt setImage:[UIImage imageNamed:@"info_icon.png"]  forState:UIControlStateNormal];
    
    [self.infoCalendarbt setImage:[UIImage imageNamed:@"info_icon.png"] forState:UIControlStateNormal];
    [self.infoLb setHidden:YES];

    self.infoLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInfoLabel)];
    [self.infoLb addGestureRecognizer:tapGesture];
}

-(IBAction)infoCalendar:(id)sender{
    
    [self.infoLb setHidden:NO];
    
    self.infoLb.text = @"Adiciona a consulta aos calendário do iOS";
    
}


-(IBAction)infoAlarm:(id)sender{
    
    [self.infoLb setHidden:NO];
    self.infoLb.text = @"Adicionar dois alarmes, um para 1 dia antes da consulta e outro para 1 hora antes";
}

-(void)dismissInfoLabel{
    [self.infoLb setHidden:YES];
}

-(void)notifyConsultEventResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
        NSString *msg = nil;
        if(result == YES) {
            switch (manipulationType) {
                case CREATE_EVENT:
                    msg = @"Consulta foi adicionada aos eventos!";
                    break;
                case UPDATE_EVENT:
                    msg = @"Consulta foi atualizada aos aventos!";
                    break;
                case DELETE_EVENT:
                    msg = @"Consulta foi removida dos eventos!";
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
                                  message:@"Não foi possível acessar os seus eventos. Verifique as permissões do app."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
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
    
    if([self.dateTF.text isEqualToString:@""]){
        [errorMsg appendString:@"Data da consulta em branco.\n"];
    }

    if(![errorMsg isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Campo em branco"
                              message:errorMsg
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
        
    } else {
        // EDITANDO
        if(_consultToBeEdited){
            [_dao deleteConsult:_consultToBeEdited];
            
            _consultToBeEdited.place = self.placeTF.text;
            _consultToBeEdited.doctorName = self.doctorNameTF.text;
            _consultToBeEdited.idDoctorSpeciality = [self getPickerEspecialityID];
            _consultToBeEdited.doctorSpeciality = [_specialities objectAtIndex:[self getPickerEspecialityID]];
            _consultToBeEdited.date = [self getPickerDate];
            
            if(_consultToBeEdited.eventId != nil) {
                NSString *eventId = [_eventsManager manipulateConsultEvent:_consultToBeEdited withAlarm:self.addAlarmSw.isOn manipulationType:UPDATE_EVENT];
                
                [self notifyConsultEventResult:(eventId != nil) manipulationType:UPDATE_EVENT];
                _consultToBeEdited.eventId = eventId;
            } else if (self.addToCalandarSw.isOn) {
                NSString *eventId = [_eventsManager manipulateConsultEvent:_consultToBeEdited withAlarm:self.addAlarmSw.isOn manipulationType:CREATE_EVENT];
                
                [self notifyConsultEventResult:(eventId != nil) manipulationType:CREATE_EVENT];
                _consultToBeEdited.eventId = eventId;
            }
            

            [_dao saveConsult:_consultToBeEdited];
            
        // NOVO
        } else {
            // Popula a entity
            AMVConsult *consult = [[AMVConsult alloc] init];
            
            consult.place = self.placeTF.text;
            consult.doctorName = self.doctorNameTF.text;
            consult.idDoctorSpeciality = [self getPickerEspecialityID];
            consult.doctorSpeciality = [_specialities objectAtIndex:[self getPickerEspecialityID]];
            consult.date = [self getPickerDate];
            
            if(self.addToCalandarSw.isOn) {
                NSString *eventId = [_eventsManager manipulateConsultEvent:consult withAlarm:self.addAlarmSw.isOn manipulationType:CREATE_EVENT];
                
                [self notifyConsultEventResult:(eventId != nil) manipulationType:CREATE_EVENT];
                
                consult.eventId = eventId;
            }
            
            // Salva a entity
            [_dao saveConsult:consult];
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

-(void)updateConsultDate:(id)sender
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    NSString *dateString = [format stringFromDate:self.datePk.date];
    
    self.dateTF.text = dateString;
    
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


@end
