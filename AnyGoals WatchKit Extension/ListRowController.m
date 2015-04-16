//
//  listRowController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "listRowController.h"


@implementation listRowController
@synthesize db;

- (instancetype)init {
    // Always call super first.
    self = [super init];
    if (self){
        // It is now safe to access interface objects.
        [self.rowTitle setText:@"Hello New World"];
    }
    NSLog(@"04");
    return self;
}
- (IBAction)sliderAction:(float)value {
    
    NSLog(@"Slider value is now: %f", value);
    if (value<1.00001 &&value>-0.0001) {
       
        if (value>(float)self.doneAmount/(float)self.maxAmount) {
            self.doneAmount++;
        }else if (value<(float)self.doneAmount/(float)self.maxAmount)
        {
            self.doneAmount--;
        }
        [self updateDB:self.goalID];
        [self updateRateLabel];

        if (self.doneAmount == self.maxAmount) {
            [self.noteDelegate presentNoteForGoal:self.goalID];
        }
        
    }
}
-(void)updateRateLabel
{
    [self.rowTitle setText:[NSString stringWithFormat:@"%d/%d",self.doneAmount,self.maxAmount]];
    int goalStatus = [self checkProcess];
    switch (goalStatus) {
        case 1:
            [self.rowTitle setTextColor:[UIColor colorWithRed:250/255.0f green:34/255.0f blue:75/255.0f alpha:1.0f]];
            [self.processSlider setColor:[UIColor colorWithRed:250/255.0f green:34/255.0f blue:75/255.0f alpha:1.0f]];

            break;
        case 2:
            [self.rowTitle setTextColor:[UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f]];
            [self.processSlider setColor:[UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f]];
            break;
        case 3:
            [self.rowTitle setTextColor:[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]];
            [self.processSlider setColor:[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]];
            break;
        default:
            break;
    }
    CGFloat rate = (float)self.doneAmount/(float)self.maxAmount;

    [self.processSlider setValue:rate];
}

-(void)updateDB:(int)goalID
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];

    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    BOOL sql = [db executeUpdate:@"update GOALSINFO set amount_DONE=? where goalID = ?" ,[NSNumber numberWithInt:self.doneAmount],[NSNumber numberWithInt:goalID]];
    if (!sql) {
        NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
    }
    [db close];
    
}


-(int)checkProcess
{
    
    CGFloat rate = (float)self.doneAmount/(float)self.maxAmount;
    
    if ( rate<1/3.0f) {
        
        return 1; //represent initial stage goal...
        
    }else if((rate>= 1/3.0f )&& (rate <= 2/3.0f))
    {
        return 2; //represent Mid stage goal...
        
    }else
    {
        return 3; //represent final stage goal...
        
    }
    
    
}
@end
