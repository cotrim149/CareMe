//
//  AMVAddMedicineontroller.m
//  CareMe
//
//  Created by Matheus Fonseca on 03/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAddMedicineController.h"
#import "AMVCareMeUtil.h"

@interface AMVAddMedicineController ()

@end

@implementation AMVAddMedicineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addComponentsAndConfigureStyle];
}

-(void) addComponentsAndConfigureStyle {
    self.navigationItem.backBarButtonItem.title = @"Medicamentos";
    
    self.medicineHowUseTV.layer.borderColor = [AMVCareMeUtil secondColor].CGColor;
    self.medicineHowUseTV.layer.borderWidth = 1.0f; //make border 1px thick
    
    self.medicineHowUseTV.layer.cornerRadius = 5.0f;
    
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

-(void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
