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
        _dao = [[AMVMedicineDAO alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addAndConfigureComponents];
}

-(void)addAndConfigureComponents{
    CGRect layerFrame = CGRectMake(0, 0, self.deleteBt.frame.size.width, self.deleteBt.frame.size.height);
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
    [self.deleteBt.layer addSublayer:line];

    self.name.text = [NSString stringWithFormat:@"Remédio: %@",self.medicine.name];
    self.dosage.text = [NSString stringWithFormat:@"Dosagem: %@", self.medicine.dosage];
    self.howUseTF.text = [NSString stringWithFormat:@"Como usar: %@", self.medicine.howUse];
    self.startDate.text = [NSString stringWithFormat:@"Início: %02lu/%02lu/%02lu",self.medicine.startDate.day, self.medicine.startDate.month, self.medicine.startDate.year];
    
    self.endDate.text = [NSString stringWithFormat:@"Fim: %02lu/%02lu/%02lu",self.medicine.endDate.day, self.medicine.endDate.month, self.medicine.endDate.year];
    
    NSArray *periods = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)"];
    
    self.period.text = [NSString stringWithFormat:@"Tomar a cada %ld %@", self.medicine.periodValue, [periods objectAtIndex:self.medicine.periodType]];
    
    UIBarButtonItem *editBt = [[UIBarButtonItem alloc] initWithTitle:@"Editar"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(editMedicine)];
    self.navigationItem.rightBarButtonItem = editBt;

    
}

-(void)viewWillAppear:(BOOL)animated{
    self.name.text = self.medicine.name;
    self.dosage.text = self.medicine.dosage;
    self.howUseTF.text = self.medicine.howUse;
    self.startDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu %02lu:%02lu",(long)self.medicine.startDate.day,(long)self.medicine.startDate.month, (long)self.medicine.startDate.year, (long)self.medicine.startDate.hour, (long)self.medicine.startDate.minute];
    self.endDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",(long)self.medicine.endDate.day,(long)self.medicine.endDate.month, (long)self.medicine.endDate.year];
    
    NSArray *periods = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)"];

    self.period.text = [NSString stringWithFormat:@"Tomar a cada %ld %@", self.medicine.periodValue, [periods objectAtIndex:self.medicine.periodType]];

    
    //    self.endDate.text = self.medicine.startDate.text;
//    self.startDate.text = self.startDate.text;
//    self.period.text = self.
//    self.endDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",(long)_medicineToBeEdited.endDate.day,(long)_medicineToBeEdited.endDate.month, (long)_medicineToBeEdited.endDate.year];
//    self.startDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu %02lu:%02lu",(long)_medicineToBeEdited.startDate.day,(long)_medicineToBeEdited.startDate.month, (long)_medicineToBeEdited.startDate.year, (long)_medicineToBeEdited.startDate.hour, (long)_medicineToBeEdited.startDate.minute];
//    [self.periodPicker selectRow:_medicineToBeEdited.periodValue -1 inComponent:0 animated:YES];
//    [self.periodPicker selectRow:_medicineToBeEdited.periodType inComponent:1 animated:YES];
    
}

-(void)editMedicine {
    AMVAddMedicineController *addMedicineController = [[AMVAddMedicineController alloc] init];


    addMedicineController.medicineToBeEdited = [[AMVMedicine alloc] init];
    
    addMedicineController.medicineToBeEdited.name = self.medicine.name;
    addMedicineController.medicineToBeEdited.dosage = self.medicine.dosage;
    addMedicineController.medicineToBeEdited.howUse = self.medicine.howUse;
    addMedicineController.medicineToBeEdited.endDate = self.medicine.endDate;
    addMedicineController.medicineToBeEdited.startDate = self.medicine.startDate;
    addMedicineController.medicineToBeEdited.periodValue = self.medicine.periodValue;
    addMedicineController.medicineToBeEdited.periodType = self.medicine.periodType;

    self.medicine = addMedicineController.medicineToBeEdited;

    [self.navigationController pushViewController:addMedicineController animated:YES];
}

-(IBAction)deleteMedicine:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tem certeza que deseja apagar o Medicamento?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Apagar Medicamento" otherButtonTitles:nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [_dao deleteMedicine:self.medicine];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
