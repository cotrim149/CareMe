//
//  AMVConsultCell.h
//  CareMe
//
//  Created by Alysson Lopes on 6/6/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVConsult.h"

@interface AMVConsultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLb;

-(void) fillWithConsult: (AMVConsult*) consult;
@end
