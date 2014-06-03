//
//  AMVAddConsultController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddConsultController.h"
#import "AMVCareMeUtil.h"

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
    
    self.tabBarController.tabBar.hidden = YES;
    self.specialtyPk.transform = CGAffineTransformMakeScale(1, 0.8);
    [self.specialtyPk selectRow:4 inComponent:0 animated:YES];

    self.datePk.transform = CGAffineTransformMakeScale(1, 0.8);
    
    // Do any additional setup after loading the view from its nib.
}

-(void) addComponentsAndConfigureStyle {
    
    self.tabBarController.tabBar.translucent = YES;
    
    UIBarButtonItem *completeAddBt = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addCompleted)];
    
    self.navigationItem.rightBarButtonItem=completeAddBt;
}

-(void) addCompleted {
    [self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"%d",[self.specialtyPk selectedRowInComponent:0]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)addSymptoms:(id)sender {
    
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
