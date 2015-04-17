//
//  SecondViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "SecondViewController.h"
#import "settingViewController.h"

#define pieSize ([[UIScreen mainScreen] bounds].size.width)/3.2

@interface SecondViewController ()
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic, strong) NSArray *chartValues;

@end

@implementation SecondViewController

@synthesize db;
@synthesize timer;

bool adWillShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    adWillShow = 1 ;

}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"111111111111111111111,<<<>>>>>");
    [MobClick event:@"goStats"];

    [super viewDidAppear:animated];
    
    [self setupPies];
    
    [self initDB];

    
    
    if (self.allGoals.count == 0) {
        
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":@0, @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":@1, @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.totalPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        [self.finishPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        [self.urgentPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        [self.weeklyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        [self.monthlyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        
        [self.totalPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"总体进度:%.0f%%",nil),0.0f]];
        [self.finishPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"完成进度:%.0f%%",nil),0.0f]];
        [self.urgentPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"紧迫比例:%.0f%%",nil),0.0f]];
        [self.weeklyPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"周活跃目标:%.0f%%",nil),0.0f]];
        [self.monthlyPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"月活跃目标:%.0f%%",nil),0.0f]];
        
    }else
    {
        
        
        //total Pie
        NSNumber *totalProcess = [NSNumber numberWithInt: ([self calculateTotalProcess]*100)];
        NSMutableArray *totalProcessNumbers = [NSMutableArray array];
        [totalProcessNumbers addObject:totalProcess];
        [totalProcessNumbers addObject:[NSNumber numberWithInt:(100 - [totalProcess intValue] )]];
        
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.totalPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        [self.totalPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"总体进度:%.0f%%",nil),(100 * [totalProcessNumbers[0] doubleValue]/100.0f)]];
        //
        //    self.totalPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
        //
        //    self.totalPie.sliceValues = totalProcessNumbers;//must set sliceValue at the last step..
        
        
        //finished Pie
        
        NSNumber *finishedProcess = [NSNumber numberWithInt:[self calculateFinishedGoal]];
        NSMutableArray *finishedProcessNumbers = [NSMutableArray array];
        [finishedProcessNumbers addObject:finishedProcess];
        [finishedProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [finishedProcess integerValue] )]];
        
        
        
        
        //urgent Pie
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":finishedProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":finishedProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.finishPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        [self.finishPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"完成进度:%.0f%%",nil),(100 * [finishedProcessNumbers[0] doubleValue]/self.allGoals.count)]];
        
        
        
        
        NSNumber *urgentProcess = [NSNumber numberWithInt:[self calculateUrgentGoal]];
        NSMutableArray *urgentProcessNumbers = [NSMutableArray array];
        [urgentProcessNumbers addObject:urgentProcess];
        [urgentProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [urgentProcess integerValue] )]];
        
        //    self.urgentPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
        //
        //    self.urgentPie.sliceValues = urgentProcessNumbers;//must set
        //
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":urgentProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":urgentProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.urgentPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        [self.urgentPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"紧迫比例:%.0f%%",nil),(100 * [urgentProcessNumbers[0] doubleValue]/self.allGoals.count)]];
        //weekly Pie
        
        NSNumber *weeklyProcess = [NSNumber numberWithInt:[self calculateWeeklyProcess]];
        NSMutableArray *weeklyProcessNumbers = [NSMutableArray array];
        [weeklyProcessNumbers addObject:weeklyProcess];
        [weeklyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [weeklyProcess integerValue] )]];
        
        //    self.weeklyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
        //
        //    self.weeklyPie.sliceValues = weeklyProcessNumbers;//must set
        //
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":weeklyProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":weeklyProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.weeklyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        [self.weeklyPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"周活跃目标:%.0f%%",nil),(100 * [weeklyProcessNumbers[0] doubleValue]/self.allGoals.count)]];
        
        
        //monthly Pie
        
        
        NSNumber *monthlyProcess = [NSNumber numberWithInt:[self calculateMonthlyProcess]];
        NSMutableArray *monthlyProcessNumbers = [NSMutableArray array];
        [monthlyProcessNumbers addObject:monthlyProcess];
        [monthlyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [monthlyProcess integerValue] )]];
        
        self.chartValues = @[
                             @{@"name":@"first", @"value":monthlyProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                             @{@"name":@"second", @"value":monthlyProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                             
                             ];
        
        [self.monthlyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        
        [self.monthlyPieLabel setText:[NSString stringWithFormat:NSLocalizedString(@"月活跃目标:%.0f%%",nil),(100 * [monthlyProcessNumbers[0] doubleValue]/self.allGoals.count)]];
    }
//    self.monthlyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//    self.monthlyPie.sliceValues = monthlyProcessNumbers;//must set
//    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timer != nil)
    {
        
        
        [timer invalidate];
        
        
        timer = nil;
        
        
    }
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

-(void)setupPies
{
    CGFloat offside = 0;
    CGFloat offsideY = 0;

    CGFloat size_offside = 0;
    if([[[UIDevice currentDevice]systemVersion] floatValue] <= 8.0)
    {
        offsideY = -20;

    }
    
    if (IS_IPHONE_4_OR_LESS) {
        offside += 20;
        size_offside += 20;
    }
    
    
    if (!self.totalPie) {
        self.totalPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.totalPie];
        self.totalPie.backgroundColor = [UIColor clearColor];
        self.totalPie.lineColor = [UIColor clearColor];

    }
    [self.totalPie setFrame:CGRectMake(SCREEN_WIDTH/2-(pieSize-size_offside)/2, self.PiesView.frame.size.height/2-pieSize/2-20+offside+offsideY, pieSize-size_offside, pieSize-size_offside)];
    [self.totalPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.totalPie.layer setShadowRadius:1.2];
    [self.totalPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.totalPie.layer setShadowOpacity:0.7];

    [self.totalPie setEnableStrokeColor:YES];
    [self.totalPie setHoleRadiusPrecent:0];
    

    if (!self.totalPieLabel) {
        self.totalPieLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.totalPie.frame.origin.x-offside/2-3, self.totalPie.frame.origin.y+self.totalPie.frame.size.height+3, pieSize+6, 25)];
        self.totalPieLabel.textAlignment = NSTextAlignmentCenter;
        self.totalPieLabel.backgroundColor = [UIColor clearColor];
        self.totalPieLabel.font =[UIFont systemFontOfSize:12.5f];
        [self.PiesView addSubview:self.totalPieLabel];
    }
    
    
    if (!self.finishPie) {
        self.finishPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.finishPie];
        self.finishPie.backgroundColor = [UIColor clearColor];
        self.finishPie.lineColor = [UIColor clearColor];

    }
    [self.finishPie setFrame:CGRectMake((SCREEN_WIDTH-2*pieSize)/3, self.totalPie.frame.origin.y-pieSize-30+size_offside+offside/2, pieSize-size_offside, pieSize-size_offside)];
    [self.finishPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.finishPie.layer setShadowRadius:1.2];
    [self.finishPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.finishPie.layer setShadowOpacity:0.7];
    
    [self.finishPie setEnableStrokeColor:YES];
    [self.finishPie setHoleRadiusPrecent:0];
    if (!self.finishPieLabel) {
        self.finishPieLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.finishPie.frame.origin.x-offside+8, self.finishPie.frame.origin.y+self.finishPie.frame.size.height+3, pieSize+2, 25)];
        self.finishPieLabel.textAlignment = NSTextAlignmentCenter;
        self.finishPieLabel.backgroundColor = [UIColor clearColor];
        self.finishPieLabel.font =[UIFont systemFontOfSize:12.5f];

        [self.PiesView addSubview:self.finishPieLabel];
    }
    
    
    if (!self.urgentPie) {
        self.urgentPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.urgentPie];
        self.urgentPie.backgroundColor = [UIColor clearColor];
        self.urgentPie.lineColor = [UIColor clearColor];

    }
    [self.urgentPie setFrame:CGRectMake(2*(SCREEN_WIDTH-2*pieSize)/3+pieSize+offside, self.finishPie.frame.origin.y, pieSize-size_offside, pieSize-size_offside)];
    [self.urgentPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.urgentPie.layer setShadowRadius:1.2];
    [self.urgentPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.urgentPie.layer setShadowOpacity:0.7];
    
    [self.urgentPie setEnableStrokeColor:YES];
    [self.urgentPie setHoleRadiusPrecent:0];
    if (!self.urgentPieLabel) {
        self.urgentPieLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.urgentPie.frame.origin.x-8, self.urgentPie.frame.origin.y+self.urgentPie.frame.size.height+3, pieSize+6, 25)];
        self.urgentPieLabel.textAlignment = NSTextAlignmentCenter;
        self.urgentPieLabel.backgroundColor = [UIColor clearColor];
        self.urgentPieLabel.font =[UIFont systemFontOfSize:12.5f];

        [self.PiesView addSubview:self.urgentPieLabel];
    }
    
    
    if (!self.weeklyPie) {
        self.weeklyPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.weeklyPie];
        self.weeklyPie.backgroundColor = [UIColor clearColor];
        self.weeklyPie.lineColor = [UIColor clearColor];

    }
    [self.weeklyPie setFrame:CGRectMake((SCREEN_WIDTH-2*pieSize)/3, self.totalPie.frame.origin.y+pieSize+30-size_offside-offside, pieSize-size_offside, pieSize-size_offside)];
    [self.weeklyPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.weeklyPie.layer setShadowRadius:1.2];
    [self.weeklyPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.weeklyPie.layer setShadowOpacity:0.7];
    
    [self.weeklyPie setEnableStrokeColor:YES];
    [self.weeklyPie setHoleRadiusPrecent:0];
    if (!self.weeklyPieLabel) {
        self.weeklyPieLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weeklyPie.frame.origin.x-offside-6, self.weeklyPie.frame.origin.y+self.weeklyPie.frame.size.height+3, pieSize+10+12, 25)];
        self.weeklyPieLabel.textAlignment = NSTextAlignmentCenter;
        self.weeklyPieLabel.backgroundColor = [UIColor clearColor];
        self.weeklyPieLabel.font =[UIFont systemFontOfSize:12.5f];

        [self.PiesView addSubview:self.weeklyPieLabel];
    }
    
    
    
    if (!self.monthlyPie) {
        self.monthlyPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.monthlyPie];
        self.monthlyPie.backgroundColor = [UIColor clearColor];
        self.monthlyPie.lineColor = [UIColor clearColor];

    }
    [self.monthlyPie setFrame:CGRectMake(2*(SCREEN_WIDTH-2*pieSize)/3+pieSize+offside, self.weeklyPie.frame.origin.y, pieSize-size_offside, pieSize-size_offside)];
    [self.monthlyPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.monthlyPie.layer setShadowRadius:1.2];
    [self.monthlyPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.monthlyPie.layer setShadowOpacity:0.7];
    
    [self.monthlyPie setEnableStrokeColor:YES];
    [self.monthlyPie setHoleRadiusPrecent:0];
    if (!self.monthlyPieLabel) {
        self.monthlyPieLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.monthlyPie.frame.origin.x-11, self.monthlyPie.frame.origin.y+self.monthlyPie.frame.size.height+3, pieSize+10+15, 25)];
        self.monthlyPieLabel.textAlignment = NSTextAlignmentCenter;
        self.monthlyPieLabel.backgroundColor = [UIColor clearColor];
        self.monthlyPieLabel.font =[UIFont systemFontOfSize:12.5f];

        [self.PiesView addSubview:self.monthlyPieLabel];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingTapped:(id)sender {
    
    settingViewController *mySetting = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
    
    self.navigationController.delegate = nil;
    
    [self.navigationController pushViewController:mySetting animated:YES];
}

- (IBAction)shareTapped:(id)sender {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.PiesView.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.PiesView.frame.size);    //获取图像
    [self.PiesView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageShare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"AnyGoal"
                                       defaultContent:NSLocalizedString(@"我的目标状态",nil)
                                                image:[ShareSDK pngImageWithImage:imageShare]
                                                title:@"AnyGoal"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"我的目标状态如图所示",nil)
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [MobClick event:@"share"];

                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    

    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"550fd791fd98c52c94000eea"
//                                      shareText:@"AnyGoal\n我的目标状态"
//                                     shareImage:imageShare
//                                shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToFacebook]
//                                       delegate:(id)self];
//    
//
//    
//    // music url
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:REVIEW_URL];
//    
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = REVIEW_URL;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = REVIEW_URL;
//    
//    [UMSocialData defaultData].extConfig.facebookData.url =REVIEW_URL;
//
//  
//    
    
    
}


#pragma mark big advertisement
//
//-(void)dealloc
//{
//    _dmInterstitial.delegate = nil; // please set delegete = nil first
//}
//- (NSString *)publisherId
//{
//    return  @"d64de853"; //@"your_own_app_id";
//}
//
//- (NSString*) appSpec
//{
//    //注意：该计费名为测试用途，不会产生计费，请测试广告展示无误以后，替换为您的应用计费名，然后提交AppStore.
//    return @"d64de853";
//}
@end
