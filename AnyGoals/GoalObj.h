//
//  GoalObj.h
//  AnyGoals
//
//  Created by Eric Cao on 3/16/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoalObj : NSObject

@property (strong , nonatomic) NSNumber *goalID;
@property (strong , nonatomic) NSString *goalName;
@property (strong , nonatomic) NSString *startTime;
@property (strong , nonatomic) NSString *endTime;
@property (strong , nonatomic) NSNumber *amount;
@property (strong , nonatomic) NSNumber *amount_DONE;
@property (strong , nonatomic) NSString *lastUpdateTime;
@property (strong , nonatomic) NSString *reminder;
@property (strong , nonatomic) NSString *reminderNote;
@property (strong , nonatomic) NSNumber *isFinished;
@property (strong , nonatomic) NSNumber *isGiveup;





@end

