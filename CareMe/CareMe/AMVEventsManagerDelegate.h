//
//  AMVEventsManagerDelegate.h
//  CareMe
//
//  Created by Matheus Fonseca on 11/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMVEventsManagerDelegate <NSObject>
-(void) notifyConsultEventResult: (BOOL) result;
-(void) notifyMedicineReminderResult: (BOOL) result;

@end
