//
//  AMVMedicineDetailsViewController.m
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicineDetailsViewController.h"
#import "AMVEventsManagerSingleton.h"

@interface AMVMedicineDetailsViewController ()

@end

@implementation AMVMedicineDetailsViewController {
    AMVEventsManagerSingleton *_eventsManager;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVMedicineDAO alloc] init];
        _eventsManager = [AMVEventsManagerSingleton getInstance];
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
    
    UIBarButtonItem *editBt = [[UIBarButtonItem alloc] initWithTitle:@"Editar"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(editMedicine)];
    self.navigationItem.rightBarButtonItem = editBt;
}

-(void)viewWillAppear:(BOOL)animated{
    self.name.text = self.medicine.name;
    self.dosage.text = self.medicine.dosage;
    self.howUse.text = self.medicine.howUse;
    [self.howUse sizeToFit];
    self.startDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu %02lu:%02lu",(long)self.medicine.startDate.day,(long)self.medicine.startDate.month, (long)self.medicine.startDate.year, (long)self.medicine.startDate.hour, (long)self.medicine.startDate.minute];
    self.endDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",(long)self.medicine.endDate.day,(long)self.medicine.endDate.month, (long)self.medicine.endDate.year];
    
    NSArray *periods = @[@"Hora(s)", @"Dias(s)", @"Semana(s)", @"Mês(es)", @"Ano(s)"];

    self.period.text = [NSString stringWithFormat:@"Tomar a cada %ld %@", self.medicine.periodValue, [periods objectAtIndex:self.medicine.periodType]];
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
    addMedicineController.medicineToBeEdited.reminderId = self.medicine.reminderId;
    

    self.medicine = addMedicineController.medicineToBeEdited;

    [self.navigationController pushViewController:addMedicineController animated:YES];
}

-(IBAction)deleteMedicine:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tem certeza que deseja apagar o Medicamento?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Apagar Medicamento" otherButtonTitles:nil,nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}

-(void)notifyMedicineReminderResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
    NSString *msg = nil;
    if(result == YES) {
        switch (manipulationType) {
            case CREATE_EVENT:
                msg = @"Medicamento foi adicionado aos lembretes!";
                break;
            case UPDATE_EVENT:
                msg = @"Medicamento foi atualizado dos lembretes!";
                break;
            case DELETE_EVENT:
                msg = @"Medicamento foi removido dos lembretes!";
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
                              message:@"Não foi possível acessar os seus lembretes. Verifique as permissões do app."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        if(self.medicine.reminderId != nil) {
            NSString *reminderId = [_eventsManager manipulateMedicineReminder:self.medicine withAlarm:NO manipulationType:DELETE_EVENT];
            [self notifyMedicineReminderResult:(reminderId != nil) manipulationType:DELETE_EVENT];
        }
        
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
