//
//  AMVGenericDAOo.h
//  CareMe
//
//  Created by Matheus Fonseca on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMVGenericDAO <NSObject>
@required
-(NSArray*) list;
-(void) save:(id) entity;
@end
