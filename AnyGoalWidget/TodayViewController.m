//
//  TodayViewController.m
//  AnyGoalWidget
//
//  Created by Eric Cao on 3/27/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic,strong) FMDatabase *db;

@end

@implementation TodayViewController
@synthesize db;
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 100);

    
    self.pieArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.midTextArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSArray *textArray = @[NSLocalizedString(@"总进度",nil),NSLocalizedString(@"完成度",nil),NSLocalizedString(@"紧迫度",nil)];

    [self initDB];
    
    for (int i = 0; i<3; i++) {
        
        NSLog(@"screen:%f",SCREEN_WIDTH);
        VBPieChart *pie = [[VBPieChart alloc] init];
        [pie setFrame:CGRectMake(i*(SCREEN_WIDTH-30)/3 +9, 7, 92, 92)];
        [pie setBackgroundColor:[UIColor clearColor]];
        pie.lineColor = [UIColor clearColor];
        
        [pie setEnableStrokeColor:NO];
        [pie setHoleRadiusPrecent:0.9];
        NSMutableArray *totalProcessNumbers = [NSMutableArray array];

        if (self.allGoals.count == 0) {
            
            
            NSArray *chartValues = @[
                                     @{@"name":@"first", @"value":@0, @"color":[UIColor colorWithRed:250/255.0f green:35/255.0f blue:75/255.0f alpha:1.0f]},
                                     @{@"name":@"second", @"value":@1, @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                     
                                     ];
            
            
            [pie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
            
        }
        else
        {
            
            if (i == 0) {
                NSNumber *totalProcess = [NSNumber numberWithInt: ([self calculateTotalProcess]*100)];
                [totalProcessNumbers addObject:totalProcess];
                [totalProcessNumbers addObject:[NSNumber numberWithInt:(100 - [totalProcess intValue] )]];
            }else if (i == 1)
            {
                NSNumber *finishedProcess = [NSNumber numberWithInt:[self calculateFinishedGoal]];
                [totalProcessNumbers addObject:finishedProcess];
                [totalProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [finishedProcess integerValue] )]];
                
            }else if(i ==2)
            {
                NSNumber *urgentProcess = [NSNumber numberWithInt:[self calculateUrgentGoal]];
                [totalProcessNumbers addObject:urgentProcess];
                [totalProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [urgentProcess integerValue] )]];
            }
            
            double goalStatus = [totalProcessNumbers[0] doubleValue]/([totalProcessNumbers[1] doubleValue]+[totalProcessNumbers[0] doubleValue]);
            if (goalStatus<(1/3.0f)){
                
                NSArray *chartValues;
                if (i==2) {
                    chartValues = @[
                                    @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                                    @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                    
                                    ];
                }else
                {
                    chartValues = @[
                                    @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:250/255.0f green:35/255.0f blue:75/255.0f alpha:1.0f]},
                                    @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                    
                                    ];
                }
                
                [pie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
                
            }else if (goalStatus<(2/3.0f) && goalStatus >=(1/3.0f))
            {
                NSArray *chartValues = @[
                                         @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f]},
                                         @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                         
                                         ];
                
                [pie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
            }else if(goalStatus>=(2/3.0f))
            {
                NSArray *chartValues;
                if (i==2) {
                    chartValues = @[
                                    @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:250/255.0f green:35/255.0f blue:75/255.0f alpha:1.0f]},
                                    @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                    
                                    ];
                }else
                {
                    chartValues = @[
                                    @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                                    @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]},
                                    
                                    ];
                }
 
                
                [pie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
                
            }
            
            
        }
        
        
        UILabel *midText = [[UILabel alloc] initWithFrame:CGRectMake(0, pie.frame.size.height/2-30, pie.frame.size.width, 60)];
        midText.textAlignment = NSTextAlignmentCenter;
        midText.backgroundColor = [UIColor clearColor];
        midText.textColor = [UIColor whiteColor];
        [midText setText:textArray[i]];
        
        [pie addSubview:midText];
        [self.view addSubview:pie];
        
        [self.pieArray addObject:pie];
        [self.midTextArray addObject:midText];
        
    }
    
    
    [self.view bringSubviewToFront:self.OpenAppBtn];
//    [self updatePies];


    [MobClick event:@"todayWidget"];

    NSLog(@"ads");
//    [self.allPieScroll setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
}

-(void)updatePies
{

    NSLog(@"pies:%@",self.pieArray);
    for (int i = 0; i<3; i++) {
      
        NSArray *chartValues = @[
                                 @{@"name":@"first", @"value":@2, @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                                 @{@"name":@"second", @"value":@3, @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                                 
                                 ];
        VBPieChart *vbpie = self.pieArray[i];
        
        [vbpie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
        
    }
    
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    defaultMarginInsets.bottom = 5.0;
    defaultMarginInsets.left = 26.0;

    return defaultMarginInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
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

- (IBAction)openApp:(id)sender {
    
    NSURL *pjURL = [NSURL URLWithString:@"AnyGoal://"];

    [self.extensionContext openURL:pjURL completionHandler:nil];
}
@end
