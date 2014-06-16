//
//  AMVHomeConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 29/05/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(short, AMVConsultVisualizationType) {
    VT_DATE, VT_SPECIALITY, VT_PLACE
};

@interface AMVHomeConsultController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSString *_titleLeftBarButtonEditing;
    NSString *_titleLeftBarButtonOK;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *visualizationSC;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView *tableViewConsults;

@end
