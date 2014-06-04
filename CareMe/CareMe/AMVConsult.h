//
//  AMVConsult.h
//  CareMe
//
//  Created by Victor de Lima on 04/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMVConsult : NSObject <NSCoding>
@property (nonatomic) NSString *doctorName;
@property (nonatomic) NSString *consultPlace;
@property (nonatomic) NSInteger IdDoctorSpeciality;
@property (nonatomic) NSDateComponents *date;

@end
