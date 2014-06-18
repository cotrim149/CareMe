//
//  AMVConsultDetailsViewController.m
//  CareMe
//
//  Created by Alysson Lopes on 6/5/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultDetailsViewController.h"

@interface AMVConsultDetailsViewController ()

@end

@implementation AMVConsultDetailsViewController {
    AMVConsultDAO *_dao;
    AMVEventsManagerSingleton *_eventsManager;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dao = [[AMVConsultDAO alloc] init];
        _eventsManager = [AMVEventsManagerSingleton getInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addAndConfigureComponents];
}

-(void) addAndConfigureComponents {
    CGRect layerFrame = CGRectMake(0, 0, self.deleteConsultBt.frame.size.width, self.deleteConsultBt.frame.size.height);
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
    [self.deleteConsultBt.layer addSublayer:line];
    
    UIBarButtonItem *editBt = [[UIBarButtonItem alloc] initWithTitle:@"Editar"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(editConsult)];
    
    self.navigationItem.rightBarButtonItem=editBt;
}

-(void)notifyConsultEventResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSString *msg = nil;
        if(result == YES) {
            switch (manipulationType) {
                case UPDATE_EVENT:
                    msg = @"Consulta foi atualizada aos aventos!";
                    break;
                case DELETE_EVENT:
                    msg = @"Consulta foi removida dos eventos!";
                    break;
                case CREATE_EVENT:
                    msg = @"Consulta foi adicionada aos aventos!";
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
    });
    
}


-(void)viewWillAppear:(BOOL)animated {
    self.doctorNameLb.text = self.consult.doctorName;
    self.consultDateLb.text = [NSString stringWithFormat:@"%02ld/%02ld/%02ld %02ld:%02ld", (long)self.consult.date.day, (long)self.consult.date.month, (long)self.consult.date.year, (long)self.consult.date.hour, (long)self.consult.date.minute];
    self.consultPlaceLb.text = self.consult.place;
    self.doctorSpecialityLb.text = self.consult.doctorSpeciality;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editConsult {
    AMVAddConsultController *addConsultController = [[AMVAddConsultController alloc] init];
    
    addConsultController.consultToBeEdited = [[AMVConsult alloc] init];
    addConsultController.consultToBeEdited.date = self.consult.date;
    addConsultController.consultToBeEdited.doctorName = self.consult.doctorName;
    addConsultController.consultToBeEdited.doctorSpeciality = self.consult.doctorSpeciality;
    addConsultController.consultToBeEdited.idDoctorSpeciality = self.consult.idDoctorSpeciality;
    addConsultController.consultToBeEdited.place = self.consult.place;
    
    self.consult = addConsultController.consultToBeEdited;
    
    [self.navigationController pushViewController:addConsultController animated:YES];
}

- (IBAction)deleteConsult:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tem certeza que deseja apagar a Consulta?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Apagar Consulta" otherButtonTitles:nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [_dao deleteConsult:self.consult];
        NSString *eventId = [_eventsManager manipulateConsultEvent:self.consult withAlarm:NO manipulationType:DELETE_EVENT];
        [self notifyConsultEventResult:(eventId != nil) manipulationType:DELETE_EVENT];
        [self.navigationController popViewControllerAnimated:YES];
    } 
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
