//
//  AMVConsultCell.m
//  CareMe
//
//  Created by Alysson Lopes on 6/6/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVConsultCell.h"
#import "AMVCareMeUtil.h"

@implementation AMVConsultCell



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the view for the selected state
}

-(void)fillWithConsult:(AMVConsult*)consult {    
    self.doctorNameLb.text = [NSString stringWithFormat:@"Dr. %@", consult.doctorName];
    self.specialityLb.text = consult.doctorSpeciality;
    self.consultDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu", (long)consult.date.day, (long)consult.date.month, (long)consult.date.year];
    self.consultDate.textColor = [AMVCareMeUtil secondColor];
    self.doctorNameLb.textColor = [AMVCareMeUtil secondColor];
}

@end
