//
//  AMVMedicineCell.m
//  CareMe
//
//  Created by Alysson Lopes on 6/9/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVMedicineCell.h"
#import "AMVCareMeUtil.h"

@implementation AMVMedicineCell

- (void)awakeFromNib
{
    NSString *cellIdentifier = @"AMVMedicineCell";
    [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillWithMedicine:(AMVMedicine*)medicine {
    self.textLabel.text = medicine.name;
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",(long)medicine.endDate.day,(long)medicine.endDate.month,(long)medicine.endDate.year];
    self.detailTextLabel.textColor = [AMVCareMeUtil secondColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];

    self.untilLabel.textColor = [AMVCareMeUtil secondColor];
    
}

@end
