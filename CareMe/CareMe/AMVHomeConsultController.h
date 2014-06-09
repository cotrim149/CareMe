//
//  AMVHomeConsultController.h
//  CareMe
//
//  Created by Matheus Fonseca on 29/05/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVHomeConsultController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *visualizationSC;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView *tableViewConsults;
@property (nonatomic, strong) NSMutableArray *consults;
@end
