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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillWithMedicine:(AMVMedicine*)medicine {
    self.name.text = medicine.name;
    self.endDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu",medicine.endDate.day,medicine.endDate.month,medicine.endDate.year];
    self.endDate.textColor = [AMVCareMeUtil secondColor];
    self.untilLabel.textColor = [AMVCareMeUtil secondColor];
    
//    self.doctorNameLb.text = [NSString stringWithFormat:@"Dr. %@", consult.doctorName];
//    self.specialityLb.text = consult.doctorSpeciality;
//    self.consultDate.text = [NSString stringWithFormat:@"%02lu/%02lu/%02lu", consult.date.day, consult.date.month, consult.date.year];
//    self.consultDate.textColor = [AMVCareMeUtil secondColor];
//    self.doctorNameLb.textColor = [AMVCareMeUtil secondColor];
}

@end
