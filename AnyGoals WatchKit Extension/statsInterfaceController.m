//
//  statsInterfaceController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/9/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "statsInterfaceController.h"
#import "listRowController.h"
#import "globalVar.h"
#import "GoalObj.h"

@interface statsInterfaceController()
@property (strong,nonatomic) NSMutableArray *rowItemsNames;
@property (strong, nonatomic) NSMutableArray *allGoals;
@property (nonatomic,strong) FMDatabase *db;

@end


@implementation statsInterfaceController
@synthesize db;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        

        self.rowItemsNames = [NSMutableArray arrayWithObjects:NSLocalizedString(@"总体进度",nil),NSLocalizedString(@"完成进度",nil),NSLocalizedString(@"紧迫比例",nil),NSLocalizedString(@"周活跃目标",nil),NSLocalizedString(@"月活跃目标",nil),nil];
        NSLog(@"02");
        
    }
    
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self initDB];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loadTableRows];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)loadTableRows {
    [self.statsTable setNumberOfRows:self.rowItemsNames.count/2 withRowType:@"listRow"];
    

    for (int i = 0; i<5; i++) {
        listRowController *elementRow = [self.statsTable rowControllerAtIndex:i];
        if ((![self isSystemLangChinese]) && (i >2) ) {
            
            UIFont *font = [UIFont systemFontOfSize:10];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                        forKey:NSFontAttributeName];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.rowItemsNames[i] attributes:attrsDictionary];
            
            [elementRow.rowTitle setAttributedText:attrString];
        }else
        {
            [elementRow.rowTitle setText:self.rowItemsNames[i]];

        }
        
        if (self.allGoals.count == 0) {
            [elementRow.statsRate setText:@"0%"];
            
        }else
        {
            
            NSString *rate = [NSString stringWithFormat:@"%@%%",self.rowItemsNames[i+5]];
            [elementRow.statsRate setText:rate];
        }

    }
    
    
}

-(void)caculateRates
{
    NSNumber *totalProcess = [NSNumber numberWithInt: ([self calculateTotalProcess]*100)];
    [self.rowItemsNames addObject:totalProcess];

    NSNumber *finishedProcess = [NSNumber numberWithInt:[self calculateFinishedGoal]*100/self.allGoals.count];
    [self.rowItemsNames addObject:finishedProcess];

    NSNumber *urgentProcess = [NSNumber numberWithInt:[self calculateUrgentGoal]*100/self.allGoals.count];
    [self.rowItemsNames addObject:urgentProcess];

    NSNumber *weeklyProcess = [NSNumber numberWithInt:[self calculateWeeklyProcess]*100/self.allGoals.count];
    [self.rowItemsNames addObject:weeklyProcess];

    NSNumber *monthlyProcess = [NSNumber numberWithInt:[self calculateMonthlyProcess]*100/self.allGoals.count];
    [self.rowItemsNames addObject:monthlyProcess];

}


-(void)initDB
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    if (!self.allGoals) {
        self.allGoals = [[NSMutableArray alloc] init];
    }else
    {
        [self.allGoals removeAllObjects];
    }
    
    FMResultSet *rs = [db executeQuery:@"select goalID,startTime,endTime,amount,amount_DONE,lastUpdateTime,isFinished,isGiveup from GOALSINFO"];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        oneGoal.startTime = [rs stringForColumn:@"startTime"];
        oneGoal.endTime = [rs stringForColumn:@"endTime"];
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];
        oneGoal.lastUpdateTime = [rs stringForColumn:@"lastUpdateTime"];
        oneGoal.isFinished = [NSNumber numberWithInt: [rs intForColumn:@"isFinished"]];
        oneGoal.isGiveup = [NSNumber numberWithInt: [rs intForColumn:@"isGiveup"]];
        
        [self.allGoals addObject:oneGoal];
        
    }
    
    [db close];
    
    [self caculateRates];
    
}



-(CGFloat)calculateTotalProcess
{
    CGFloat finishedAction = 0.0f;
    CGFloat totalActions = 0.0f;
    CGFloat totalRate = 0.0f;
    
    for (GoalObj *goal in self.allGoals) {
        if ([goal.isGiveup intValue] == 0) {
            CGFloat rate = [goal.amount_DONE doubleValue]/[goal.amount doubleValue];
            finishedAction = finishedAction+100*rate;
            totalActions+=100;
        }
    }
    
    totalRate = finishedAction/totalActions;
    return totalRate;
}

-(int)calculateFinishedGoal
{
    int finishedGoal = 0;
    
    for (GoalObj *goal in self.allGoals) {
        if ([goal.isFinished intValue] == 1) {
            
            finishedGoal++;
        }
    }
    
    return finishedGoal;
}

-(CGFloat)calculateWeeklyProcess
{
    int weeklyActive = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    
    for (GoalObj *goal in self.allGoals) {
        NSDate *lastUpdateTime = [dateFormat dateFromString:goal.lastUpdateTime];
        NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeByNow<7*24*60*60) {
            weeklyActive++;
        }
        
        
    }
    
    return weeklyActive;
}

-(CGFloat)calculateMonthlyProcess
{
    int monthActive = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    
    for (GoalObj *goal in self.allGoals) {
        NSDate *lastUpdateTime = [dateFormat dateFromString:goal.lastUpdateTime];
        NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeByNow<30*24*60*60) {
            monthActive++;
        }
        
        
    }
    
    return monthActive;
}

-(int)calculateUrgentGoal
{
    
    int urgentGoal = 0;
    
    
    for (GoalObj *goal in self.allGoals) {
        
        if ([goal.isGiveup intValue] == 0) {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSDate *startTime = [dateFormat dateFromString:goal.startTime];
            NSDate *endTime = [dateFormat dateFromString:goal.endTime];
            
            NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:startTime];
            NSTimeInterval timeByEnd = [endTime timeIntervalSinceDate:startTime];
            NSTimeInterval timeRemaining = timeByEnd -timeByNow;
            
            CGFloat goalRate = ([goal.amount intValue] - [goal.amount_DONE intValue])/[goal.amount intValue];
            
            if ( timeRemaining/timeByEnd <= goalRate/1.8  && [goal.isFinished intValue] == 0) {
                
                urgentGoal++;
                
            }
        }
    }
    
    return urgentGoal;
    
    
    
}

#pragma mark system language
- (BOOL)isSystemLangChinese
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    if([language compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }else
    {
        return NO;
    }
}

@end



