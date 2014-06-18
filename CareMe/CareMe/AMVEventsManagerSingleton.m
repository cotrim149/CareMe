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
    
    if([self checkLockFile] == NO) {
        if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
            // iOS 6 and later
            [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    [self createLockFile];
                }
            }];
        } else {
            [self createLockFile];
        }
    }
    if([self checkLockFile] == YES) {
        NSError *err;
        if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
            [_store saveEvent:calendarEvent span:EKSpanThisEvent error:&err];
        else if(manipulationType == DELETE_EVENT)
            [_store removeEvent:calendarEvent span:EKSpanThisEvent error:&err];
        
        if (err != noErr) {
            NSLog(@"Error manipulating data: %@", err);
            return nil;
        }
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
            default:
                    break;
            
        }
        [reminder addRecurrenceRule:recurrence];
        
        if(manipulationType == UPDATE_EVENT && withAlarm == NO)
            reminder.alarms = [[NSArray alloc] init];

        if(withAlarm) {
            if(manipulationType == UPDATE_EVENT)
                reminder.alarms = [[NSArray alloc] init];
            if(medicine.periodType == HOUR) {
                int hoursLeft =  24 - (int) medicine.startDate.hour;
                int numberOfAlarms = (int) (hoursLeft / medicine.periodValue);
                for(int i = 0; i < numberOfAlarms; i++) {
                    NSTimeInterval alarmOffset = (-1*60*10) + (i*1*60*60*medicine.periodValue);
                    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
                    [reminder addAlarm:alarm];
                }
            } else {
                NSTimeInterval alarmOffset = -1*60*10; // 10min
                EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
                
                [reminder addAlarm:alarm];
            }
        }
    }
    
    if([self checkLockFile] == NO) {
        if ([_store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
            // iOS 6 and later
            [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    [self createLockFile];
                }
            }];
        } else {
            [self createLockFile];
        }
    }

    if([self checkLockFile] == YES) {
        NSError *err;
        if(manipulationType == UPDATE_EVENT || manipulationType == CREATE_EVENT)
            [_store saveReminder:reminder commit:YES error:&err];
        else if(manipulationType == DELETE_EVENT)
            [_store removeReminder:reminder commit:YES error:&err];
        
        if (err != noErr) {
            NSLog(@"Error manipulating data: %@", err);
            return nil;
        }
    }
    
    if(manipulationType == DELETE_EVENT)
        return @"";
    else
        return ((EKCalendarItem*)reminder).calendarItemIdentifier;

}


-(BOOL) checkLockFile {
    NSString *lockFile = [AMVCareMeUtil getDocumentsFilePathWithSuffix:@"lock"];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:lockFile];
}

-(void) createLockFile {
    NSString *lockFile = [AMVCareMeUtil getDocumentsFilePathWithSuffix:@"lock"];
    
    [[NSData data] writeToFile:lockFile options:NSDataWritingAtomic error:nil];
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
