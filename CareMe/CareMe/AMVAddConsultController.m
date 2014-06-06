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

@interface AMVAddConsultController ()

@end

@implementation AMVAddConsultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _especialidades = [[NSArray alloc] initWithObjects:
                           @"Acupuntura", @"Alergista", @"Anestesiologia", @"Cardiologia", @"Cirurgião",
                           @"Clinica", @"Dermatologia", @"Endocrinologia", @"Gastroenterologia",
                           @"Geriatria", @"Ginecologia", @"Infectologia", @"Nefrologia",@"Oftamologia",
                           @"Oncologia", @"Ortopedia", @"Otorrinolaringologia", @"Pediatria",
                           @"Pneumologia", @"Reumatologia", @"Urologia", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addComponentsAndConfigureStyle];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) addComponentsAndConfigureStyle {
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    
    self.navigationItem.rightBarButtonItem=completeAddBt;
    
    self.specialtyPk.transform = CGAffineTransformMakeScale(1, 0.8);
    
    [self.specialtyPk selectRow:((int)[_especialidades count]/2) inComponent:0 animated:YES];
    
    self.datePk.transform = CGAffineTransformMakeScale(1, 0.8);
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

-(NSInteger)getPickerEspecialityID{
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
        
    }
    else{
        
        // Popula a entity
        AMVConsult *consult = [[AMVConsult alloc] init];
        
        [consult setConsultPlace:self.placeTF.text];
        [consult setDoctorName:self.doctorNameTF.text];
        [consult setIdDoctorSpeciality:[self getPickerEspecialityID]];
        [consult setDate:[self getPickerDate]];
        
        // Salva a entity
        
        AMVConsultDAO *consultDAO = [[AMVConsultDAO alloc] init];
        
        [consultDAO saveConsult:consult];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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
    return [_especialidades count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_especialidades objectAtIndex:row];
}


@end
