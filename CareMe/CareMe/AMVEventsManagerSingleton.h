//
//  AMVEventsSingleton.h
//  CareMe
//
//  Created by Matheus Fonseca on 10/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMVConsult.h"
#import "AMVEventsManagerDelegate.h"

@interface AMVEventsManagerSingleton : NSObject

@property(strong) id<AMVEventsManagerDelegate> delegate;

+(AMVEventsManagerSingleton*) getInstance;
-(instancetype) init __attribute__((unavailable("init not available")));
-(void) addConsultEvent: (AMVConsult*) consult withAlarm: (BOOL) withAlarm;
-(void) addConsultReminder: (AMVConsult*) consult withAlarm: (BOOL) withAlarm;;

@end