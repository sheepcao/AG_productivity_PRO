//
//  GoalsInterfaceController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/9/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "GoalsInterfaceController.h"
#import "listRowController.h"
#import "globalVar.h"
#import "GoalObj.h"


@interface GoalsInterfaceController()


@property (nonatomic,strong) NSMutableArray *processingTasks;
@property (nonatomic,strong) NSMutableArray *finishedTasks;
@property (nonatomic,strong) NSMutableArray *giveupTasks;
@property (nonatomic,strong) NSMutableArray *notyetTasks;
@property (nonatomic,strong) FMDatabase *db;

@end


@implementation GoalsInterfaceController
@synthesize db;

int goalType;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        goalType = 0;
        // Initialize variables here.
        // Configure interface objects here.
       
        self.processingTasks = [[NSMutableArray alloc] init];
        self.finishedTasks = [[NSMutableArray alloc] init];
        self.notyetTasks = [[NSMutableArray alloc] init];
        self.giveupTasks = [[NSMutableArray alloc] init];
//        self.Goals = ;
        NSLog(@"07");
        
    }
    
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self setTitle:context];
    
    if ([context isEqualToString:NSLocalizedString(@"In process",nil)]) {

        goalType = 0;
        
    }else if([context isEqualToString:NSLocalizedString(@"Finished",nil)])
    {
        goalType = 1;
        
    }else if([context isEqualToString:NSLocalizedString(@"Scheduled",nil)])
    {
        goalType = 2;

    }else if([context isEqualToString:NSLocalizedString(@"Abandoned",nil)])
    {
        goalType = 3;

    }


}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    switch (goalType) {
        case 0:
            [self configProcessingTasks];
            [self loadTableRowsfor:self.processingTasks];
            break;
        case 1:
            [self configFinishedTasks];
            [self loadTableRowsfor:self.finishedTasks];
            break;
        case 2:
            [self configNotyetTasks];
            [self loadTableRowsfor:self.notyetTasks];
            break;
        case 3:
            [self configGiveupTasks];
            [self loadTableRowsfor:self.giveupTasks];
            break;
        default:
            break;
    }
    

}

- (void)loadTableRowsfor:(NSMutableArray *)Goals {
    [self.goalsListTable setNumberOfRows:Goals.count withRowType:@"listRow"];
    
    // Create all of the table rows.
    [Goals enumerateObjectsUsingBlock:^(GoalObj *rowData, NSUInteger idx, BOOL *stop) {
        listRowController *elementRow = [self.goalsListTable rowControllerAtIndex:idx];
        
        [elementRow.rowTitle setText:[NSString stringWithFormat:@"%@/%@",rowData.amount_DONE,rowData.amount]];
        [elementRow.finishRateLabel setText:rowData.goalName];
        [elementRow.processSlider setNumberOfSteps:[rowData.amount integerValue]];
        elementRow.doneAmount = [rowData.amount_DONE intValue];
        elementRow.maxAmount = [rowData.amount intValue];
        elementRow.goalID = [rowData.goalID intValue];
        
      
//        float rate = [rowData.amount_DONE doubleValue]/[rowData.amount doubleValue];
//        [elementRow.processSlider setValue:rate];
        
        elementRow.noteDelegate = self;
        if (![Goals isEqual:self.processingTasks]) {
            [elementRow.processSlider setEnabled:NO];
        }
        
        [elementRow updateRateLabel];

    }];
}

-(void)presentNoteForGoal:(int)goalID
{
   
    [self updateDataForTable:@"GOALSINFO" setColomn:@"isFinished" toData:[NSNumber numberWithInt:1] whereColomn:@"goalID" isData:[NSNumber numberWithInt:goalID]];
 

    
    [self pushControllerWithName:@"goalFinish" context:nil];

}
-(void)updateDataForTable:(NSString *)tableName setColomn:(NSString *)toColomn toData:(id)dstData whereColomn:(NSString *)strColomn isData:(id)strData
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,toColomn,dstData,strColomn,strData];
    
    BOOL sql = [db executeUpdate:sqlCommand];
    if (!sql) {
        NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
    }
    [db close];
    
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark task configuration

-(void)configProcessingTasks
{
    
    if (self.processingTasks.count > 0) {
        [self.processingTasks removeAllObjects];
    }
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    

    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER,remindID INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path11:%@",dbPath);
    
    
    // time now...
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,amount,amount_DONE from GOALSINFO where isFinished = ? AND startTime <= ? AND isGiveup = ?", [NSNumber numberWithInt:0],timeNow,[NSNumber numberWithInt:0]];
    while ([rs next]) {
       
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];

        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];

        
        
        [self.processingTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}


-(void)configFinishedTasks
{
    
    if (self.finishedTasks.count > 0) {
        [self.finishedTasks removeAllObjects];
    }
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
//    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
//    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
//    
//    [db executeUpdate:createGoalTable];
//    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path:%@",dbPath);
    
    
    // time now...
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,amount,amount_DONE from GOALSINFO where isFinished = ? AND startTime <= ? AND isGiveup = ?", [NSNumber numberWithInt:1],timeNow, [NSNumber numberWithInt:0]];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];

        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];

        
        [self.finishedTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}

-(void)configNotyetTasks
{
    
    if (self.notyetTasks.count > 0) {
        [self.notyetTasks removeAllObjects];
    }
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
//    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
//    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
//    
//    [db executeUpdate:createGoalTable];
//    [db executeUpdate:createUrgentTable];
//    
//    
//    NSLog(@"db path:%@",dbPath);
//    
//    
    // time now...
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName, amount,amount_DONE from GOALSINFO where startTime > ? AND isGiveup = ?",timeNow,[NSNumber numberWithInt:0]];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];

        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];

        
        [self.notyetTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}


-(void)configGiveupTasks
{
    
    if (self.giveupTasks.count > 0) {
        [self.giveupTasks removeAllObjects];
    }
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
//    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
//    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
//    
//    [db executeUpdate:createGoalTable];
//    [db executeUpdate:createUrgentTable];
//    
//    
    NSLog(@"db path:%@",dbPath);
    
    
    
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName, amount,amount_DONE from GOALSINFO where isGiveup = ?",[NSNumber numberWithInt:1]];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];

        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];

        [self.giveupTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}



@end



