//
//  AMVHomeMedicineController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVHomeMedicineController.h"
#import "AMVCareMeUtil.h"
#import "AMVAddMedicineController.h"

@interface AMVHomeMedicineController ()

@end

@implementation AMVHomeMedicineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Medicamentos"
                                                                  image:[UIImage imageNamed:@"Medicine.png"]
                                                          selectedImage:[UIImage imageNamed:@"Medicine.png"]];
        self.tabBarItem=consultItem;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addComponentsAndConfigureStyle];
}

-(void) addComponentsAndConfigureStyle {
    self.title=@"Medicamentos";
    
    UIBarButtonItem *addMedicineBt = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addMedicine)
                                     ];
    addMedicineBt.tintColor = [AMVCareMeUtil secondColor];
    
    self.navigationItem.rightBarButtonItem=addMedicineBt;
    
    self.dayPeriodSC.tintColor = [AMVCareMeUtil firstColor];
    [self.dayPeriodSC setTitle:@"Manhã" forSegmentAtIndex:0];
    [self.dayPeriodSC setTitle:@"Tarde" forSegmentAtIndex:1];
    [self.dayPeriodSC setTitle:@"Noite" forSegmentAtIndex:2];
    [self.dayPeriodSC setTitle:@"Todos" forSegmentAtIndex:3];
    
    self.dayPeriodSC.selectedSegmentIndex = (int) [AMVCareMeUtil dayPeriodNow];
}


-(void) addMedicine {
    [self.navigationController pushViewController:[[AMVAddMedicineController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
