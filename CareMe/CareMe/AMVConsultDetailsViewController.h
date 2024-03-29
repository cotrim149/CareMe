//
//  AMVConsultDetailsViewController.h
//  CareMe
//
//  Created by Alysson Lopes on 6/5/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVConsult.h"
#import "AMVCareMeUtil.h"
#import "AMVConsultDAO.h"
#import "AMVAddConsultController.h"
#import "AMVEventsManagerSingleton.h"

@interface AMVConsultDetailsViewController : UIViewController <UIActionSheetDelegate>
@property (nonatomic, strong) AMVConsult *consult;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLb;
@property (weak, nonatomic) IBOutlet UILabel *consultPlaceLb;
@property (weak, nonatomic) IBOutlet UILabel *consultDateLb;
@property (weak, nonatomic) IBOutlet UILabel *doctorSpecialityLb;
@property (weak, nonatomic) IBOutlet UIButton *deleteConsultBt;

@end
