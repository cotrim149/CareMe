//
//  AMVConsultDetailsViewController.m
//  CareMe
//
//  Created by Alysson Lopes on 6/5/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultDetailsViewController.h"
#import "AMVCareMeUtil.h"


@interface AMVConsultDetailsViewController ()

@end

@implementation AMVConsultDetailsViewController

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
    
    self.doctorNameLb.text = self.consult.doctorName;
    self.consultDateLb.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu", self.consult.date.day, self.consult.date.month, self.consult.date.year];
    self.consultPlaceLb.text = self.consult.place;
    self.doctorSpecialityLb.text = self.consult.doctorSpeciality;
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"DELETOU");
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
