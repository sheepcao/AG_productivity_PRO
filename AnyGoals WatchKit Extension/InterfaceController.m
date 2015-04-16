//
//  InterfaceController.m
//  AnyGoals WatchKit Extension
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "InterfaceController.h"
#import "ListRowController.h"
#import "statusListInterfaceController.h"


@interface InterfaceController()
@property (nonatomic,strong) FMDatabase *db;

@end


@implementation InterfaceController
@synthesize db;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        
        // Retrieve the data. This could be accessed from the iOS app via a shared container.
        
    }
    
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self initDB];
    NSLog(@"1111");
    
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)listTap {
    
    [self pushControllerWithName:@"statusListInterfaceController" context:nil];

    NSLog(@"1111111");
}
- (IBAction)statsTap {
    [self pushControllerWithName:@"statsInterfaceController" context:nil];
    
    NSLog(@"222222222222");
}

-(void)initDB
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    //    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER,remindID INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path11:%@",dbPath);

}

@end



