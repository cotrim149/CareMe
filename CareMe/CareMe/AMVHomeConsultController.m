//
//  AMVHomeConsultController.m
//  CareMe
//
//  Created by Matheus Fonseca on 29/05/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVHomeConsultController.h"

@interface AMVHomeConsultController ()

@end

@implementation AMVHomeConsultController

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
    UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Consulta"
                                                              image:[UIImage imageNamed:@"Calendar-Month.png"]
                                                      selectedImage:[UIImage imageNamed:@"Calendar-Week.png"]];
    self.tabBarItem=consultItem;
    self.title=@"Consulta";
    
//    [self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
