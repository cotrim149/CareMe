//
//  AMVEventsManagerDelegate.h
//  CareMe
//
//  Created by Matheus Fonseca on 11/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMVEventsManagerDelegate <NSObject>

typedef NS_ENUM(short, AMVManipulationType) {
    CREATE_EVENT, DELETE_EVENT, UPDATE_EVENT
};

-(void) notifyConsultEventResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType;

@end
