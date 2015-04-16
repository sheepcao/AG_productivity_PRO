//
//  listRowController.h
//  AnyGoals
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

@import WatchKit;

#import "globalVar.h"

@protocol presentFinishNoteDelegate <NSObject>

-(void)presentNoteForGoal:(int)goalID;

@end

@interface listRowController : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rowTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *processSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *finishRateLabel;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *statsRate;


@property int maxAmount;
@property int doneAmount;
@property (nonatomic,strong) FMDatabase *db;
@property int goalID;

@property (nonatomic,strong) id <presentFinishNoteDelegate> noteDelegate;;

-(void)updateRateLabel;

@end
