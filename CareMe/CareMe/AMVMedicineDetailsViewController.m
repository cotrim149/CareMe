//
//  AMVMedicineDetailsViewController.m
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicineDetailsViewController.h"

@interface AMVMedicineDetailsViewController ()

@end

@implementation AMVMedicineDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    self.name.text = [NSString stringWithFormat:@"Remédio: %@",self.medicine.name];
    self.dosage.text = [NSString stringWithFormat:@"Dosagem: %@", self.medicine.dosage];
    self.howUseTF.text = [NSString stringWithFormat:@"Como usar: %@", self.medicine.howUse];
    self.startDate.text = [NSString stringWithFormat:@"Início: %02lu/%02lu/%02lu",self.medicine.startDate.day, self.medicine.startDate.month, self.medicine.startDate.year];
    
    self.endDate.text = [NSString stringWithFormat:@"Fim: %02lu/%02lu/%02lu",self.medicine.endDate.day, self.medicine.endDate.month, self.medicine.endDate.year];
    
    NSArray *periods = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)"];
    
    self.period.text = [NSString stringWithFormat:@"Tomar a cada %ld %@", self.medicine.periodValue, [periods objectAtIndex:self.medicine.periodType]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
