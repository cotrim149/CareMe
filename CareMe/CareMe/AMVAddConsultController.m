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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addComponentsAndConfigureStyle];
    
    self.tabBarController.tabBar.hidden = YES;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

@end
