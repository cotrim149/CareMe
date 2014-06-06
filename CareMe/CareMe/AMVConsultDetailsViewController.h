//
//  AMVConsultDetailsViewController.h
//  CareMe
//
//  Created by Alysson Lopes on 6/5/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVConsultDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *consulta;
@property (weak, nonatomic) IBOutlet UITextView *dadosConsulta;
@end
