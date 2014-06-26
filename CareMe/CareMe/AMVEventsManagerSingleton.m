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
#import "AMVCareMeUtil.h"

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
    
    EKEvent *calendarEvent = nil;
    if(manipulationType == CREATE_EVENT)
        calendarEvent  = [EKEvent eventWithEventStore:_store];
    else if(manipulationType == DELETE_EVENT || manipulationType == UPDATE_EVENT)
        calendarEvent  = [_store eventWithIdentifier:consult.eventId];
    
    if(calendarEvent == nil) {
        return nil;
    }
    
    calendarEvent.alarms = [[NSArray alloc] init];
    if (manipulationType == CREATE_EVENT || manipulationType == UPDATE_EVENT) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        calendarEvent.title = [NSString stringWithFormat:@"Consulta %@ - Dr(a) %@", consult.doctorSpeciality, consult.doctorName];
        calendarEvent.location = consult.place;
        calendarEvent.endDate = calendarEvent.startDate = [cal dateFromComponents: consult.date];
        calendarEvent.calendar = [_store defaultCalendarForNewEvents];

        if(manipulationType == UPDATE_EVENT && withAlarm == NO)
            calendarEvent.alarms = [[NSArray alloc] init];
        if(withAlarm) {
            if(manipulationType == UPDATE_EVENT)
                calendarEvent.alarms = [[NSArray alloc] init];

            NSTimeInterval alarmOffset1 = -1*60*60; // 1h
            NSTimeInterval alarmOffset2 = -1*60*60*24; // 24h
            EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:alarmOffset1];
            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:alarmOffset2];
            
            [calendarEvent addAlarm:alarm1];
            [calendarEvent addAlarm:alarm2];
        }
    }
    
    NSError __block *err;
    NSLock __block *lock = [[NSLock alloc] init];

    if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            [lock lock];
            if (granted) {
                if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
                    [_store saveEvent:calendarEvent span:EKSpanThisEvent error:&err];
                else if(manipulationType == DELETE_EVENT)
                    [_store removeEvent:calendarEvent span:EKSpanThisEvent error:&err];
            }
            [lock unlock];
        }];
    } else {
        if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
            [_store saveEvent:calendarEvent span:EKSpanThisEvent error:&err];
        else if(manipulationType == DELETE_EVENT)
            [_store removeEvent:calendarEvent span:EKSpanThisEvent error:&err];
    }
    [NSThread sleepForTimeInterval:.3];
    [lock lock];
    [lock unlock];
    
    if (err != noErr) {
        NSLog(@"Error manipulating data: %@", err);
        return nil;
    }
    
   if(manipulationType == DELETE_EVENT)
       return @"";
   else
       return  calendarEvent.eventIdentifier;
}

-(NSString*) manipulateMedicineReminder: (AMVMedicine*)medicine withAlarm:(BOOL)withAlarm manipulationType:(AMVManipulationType)manipulationType {
    
    EKReminder *reminder = nil;

    if(manipulationType == CREATE_EVENT) {
        reminder = [EKReminder reminderWithEventStore:_store];
    } else if(manipulationType == DELETE_EVENT || manipulationType == UPDATE_EVENT) {
        EKCalendarItem *calendarItem = [_store calendarItemWithIdentifier:medicine.reminderId];
        reminder = (EKReminder*) calendarItem;
    }

    if(reminder == nil)
        return nil;
    
    if (manipulationType == CREATE_EVENT || manipulationType == UPDATE_EVENT) {
        reminder.title = [NSString stringWithFormat:@"Remédio %@ (%@)", medicine.name, medicine.dosage];
        reminder.calendar = [_store defaultCalendarForNewReminders];
        reminder.dueDateComponents = medicine.endDate;
        reminder.startDateComponents = medicine.startDate;

        EKRecurrenceRule *recurrence = nil;
        NSDate *endDateRecurrence = [[NSCalendar currentCalendar] dateFromComponents:medicine.endDate];
        
        switch (medicine.periodType) {
            case HOUR:
                recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDateRecurrence]];
                break;
            case DAY:
                recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:medicine.periodValue end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDateRecurrence]];
                break;
            case WEEK:
                    recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:medicine.periodValue end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDateRecurrence]];
                break;
            case MONTH:
                    recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:medicine.periodValue end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDateRecurrence]];
                break;
            case YEAR:
                    recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:medicine.periodValue end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDateRecurrence]];
                break;
            
        }
        [reminder addRecurrenceRule:recurrence];
        
        reminder.alarms = [[NSArray alloc] init];
        
        if(withAlarm) {
            if(medicine.periodType == HOUR) {
                int numberOfAlarms = (int) (24 / medicine.periodValue);
                for(int i = 0; i < numberOfAlarms; i++) {
                    NSTimeInterval alarmOffset = (-1*60*10) + (i*1*60*60*medicine.periodValue);
                    
                    NSDate *alarmDate = [[[NSCalendar currentCalendar] dateFromComponents:medicine.startDate] dateByAddingTimeInterval:alarmOffset];
                    
                    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
                    [reminder addAlarm:alarm];
                }
            } else {
                NSTimeInterval alarmOffset = -1*60*10; // 10min
                NSDate *alarmDate = [[[NSCalendar currentCalendar] dateFromComponents:medicine.startDate] dateByAddingTimeInterval:alarmOffset];
                
                EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
                [reminder addAlarm:alarm];
            }
        }
    }
    
    NSError __block *err;
    NSLock __block *lock = [[NSLock alloc] init];
    if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            [lock lock];
            if(granted) {
                if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
                    [_store saveReminder:reminder commit:YES error:&err];
                else if(manipulationType == DELETE_EVENT)
                    [_store removeReminder:reminder commit:YES error:&err];
            }
            [lock unlock];
        }];
    } else {
        if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
            [_store saveReminder:reminder commit:YES error:&err];
        else if(manipulationType == DELETE_EVENT)
            [_store removeReminder:reminder commit:YES error:&err];
    }
    
    [NSThread sleepForTimeInterval:.3];
    [lock lock];
    [lock unlock];
    
    if (err != noErr) {
        NSLog(@"Error manipulating data: %@", err);
        return nil;
    }
    
    if(manipulationType == DELETE_EVENT)
        return @"";
    else
        return reminder.calendarItemIdentifier;
}

@end
