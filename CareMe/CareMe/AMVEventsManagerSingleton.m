//
//  AMVEventsSingleton.m
//  CareMe
//
//  Created by Matheus Fonseca on 10/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVEventsManagerSingleton.h"
#import <EventKit/EventKit.h>
#import "AMVConsultDAO.h"

@implementation AMVEventsManagerSingleton {
    EKEventStore *_store;
    AMVConsultDAO *_dao;
}

static AMVEventsManagerSingleton *_instance;

+(AMVEventsManagerSingleton*) getInstance {
    @synchronized(self)
    {
        if(_instance == nil) {
            _instance = [[self alloc] init];
            [_instance configureManager];
        }
    }
    
    return _instance;
}

-(void) configureManager {
    _store = [[EKEventStore alloc] init];
    _dao = [[AMVConsultDAO alloc] init];
}

-(NSString*) manipulateConsultEvent: (AMVConsult*)consult withAlarm:(BOOL)withAlarm manipulationType:(AMVManipulationType)manipulationType {
    __block BOOL sucess = NO;

    EKEvent *calendarEvent = nil;
    if(manipulationType == CREATE_EVENT)
        calendarEvent  = [EKEvent eventWithEventStore:_store];
    else if(manipulationType == DELETE_EVENT || manipulationType == UPDATE_EVENT)
        calendarEvent  = [_store eventWithIdentifier:consult.eventId];
    
    if(calendarEvent == nil) {
        return nil;
    }
    

    if (manipulationType == CREATE_EVENT || manipulationType == UPDATE_EVENT) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        calendarEvent.title = [NSString stringWithFormat:@"Consulta %@ - Dr(a) %@", consult.doctorSpeciality, consult.doctorName];
        calendarEvent.location = consult.place;
        calendarEvent.endDate = calendarEvent.startDate = [cal dateFromComponents: consult.date];
        calendarEvent.calendar = [_store defaultCalendarForNewEvents];
        
        if(withAlarm) {
            NSTimeInterval alarmOffset1 = -1*60*60; // 1h
            NSTimeInterval alarmOffset2 = -1*60*60*24; // 24h
            EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:alarmOffset1];
            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:alarmOffset2];
            
            [calendarEvent addAlarm:alarm1];
            [calendarEvent addAlarm:alarm2];
        }
    }
    
    if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        
        // ISSSO SO PRECISA SER FEITO UMA UNICA VEEEEZ
//        [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            if (granted) {
//                // code here for when the user allows your app to access the calendar
                NSError *err;
                if(manipulationType == CREATE_EVENT || manipulationType == UPDATE_EVENT)
                    [_store saveEvent:calendarEvent span:EKSpanThisEvent error:&err];
                else if(manipulationType == DELETE_EVENT)
                    [_store removeEvent:calendarEvent span:EKSpanThisEvent error:&err];
                
                if (err == noErr) {
                    sucess = YES;
                }
//            }
        
            //[self.delegate notifyConsultEventResult:sucess manipulationType:manipulationType];
            self.delegate = nil;
//        }];
    } else {
        // code here for iOS < 6.0
        NSError *err;
        if (err == noErr)
            sucess = YES;
        
        [self.delegate notifyConsultEventResult:sucess manipulationType:manipulationType];
        self.delegate = nil;
    }
    
    return  calendarEvent.eventIdentifier;
}

//-(void) addConsultReminder:(AMVConsult *)consult withAlarm: (BOOL) withAlarm{
//    __block BOOL sucess = NO;
//    
//    EKReminder *reminder  = [EKReminder reminderWithEventStore:_store];
//    
//	reminder.title = [NSString stringWithFormat:@"Consulta %@ - Dr(a) %@", consult.doctorSpeciality, consult.doctorName];
//    reminder.location = consult.place;
//    reminder.dueDateComponents = consult.date;
//    
//    [reminder setCalendar:[_store defaultCalendarForNewReminders]];
//    if(withAlarm) {
//        NSTimeInterval alarmOffset = -1*60*10; // 10min
//        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
//        [reminder addAlarm:alarm];
//    }
//    if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//        // iOS 6 and later
//        [_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
//            if (granted) {
//                // code here for when the user allows your app to access the calendar
//                NSError *err;
//                [_store saveReminder:reminder commit:YES error:&error];
//                if (err == noErr) {
//                    sucess = YES;
//                }
//                
//            }
//            [self.delegate notifyMedicineReminderResult:sucess];
//        }];
//    } else {
//        // code here for iOS < 6.0
//        NSError *err;
//        if (err == noErr)
//            sucess = YES;
//        
//        [self.delegate notifyMedicineReminderResult:sucess];
//    }
//}

@end
