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
    NSString *cellIdentifier = @"AMVConsultCell";
    [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the view for the selected state
}

-(void)fillWithConsult:(AMVConsult*)consult {
    
    self.textLabel.text = consult.doctorSpeciality;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%02ld/%02ld/%02ld", (long)consult.date.day, (long)consult.date.month, (long)consult.date.year];
    self.detailTextLabel.textColor = [AMVCareMeUtil secondColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    
    self.doctorNameLb.text = [NSString stringWithFormat:@"Dr(a) %@", consult.doctorName];

    self.doctorNameLb.textColor = [AMVCareMeUtil secondColor];
}

@end
