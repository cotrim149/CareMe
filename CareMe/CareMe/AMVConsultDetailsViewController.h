//
//  AMVConsultDetailsViewController.h
//  CareMe
//
//  Created by Alysson Lopes on 6/5/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVConsult.h"

@interface AMVConsultDetailsViewController : UIViewController
@property (nonatomic, strong) AMVConsult *consult;
@property (weak, nonatomic) IBOutlet UITextView *doctor;
@property (weak, nonatomic) IBOutlet UITextView *place;
@property (weak, nonatomic) IBOutlet UITextView *date;
@end
