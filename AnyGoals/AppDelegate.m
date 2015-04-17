//
//  AppDelegate.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <Crashlytics/Crashlytics.h>

#import "GoalObj.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaHandler.h"
//#import "UMSocialFacebookHandler.h"
@interface AppDelegate ()
@property (nonatomic,strong) FMDatabase *db;

@end

@implementation AppDelegate
@synthesize db;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initDB];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"maxNotificationID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"maxNotificationID"];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        UIMutableUserNotificationAction *addAction = [[UIMutableUserNotificationAction alloc] init];
        addAction.identifier = @"ADD_ONE";
        addAction.title = @"+1";
        addAction.activationMode = UIUserNotificationActivationModeBackground;
        addAction.destructive = NO;
        addAction.authenticationRequired = NO;
        
        UIMutableUserNotificationCategory *inviteCategory =
        [[UIMutableUserNotificationCategory alloc] init];
        
        // Identifier to include in your push payload and local notification
        inviteCategory.identifier = @"goalActionAmount";
        
        // Add the actions to the category and set the action context
        [inviteCategory setActions:@[addAction]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];

        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|
                                                       UIUserNotificationTypeSound categories:categories]];
    }
    
    [Crashlytics startWithAPIKey:@"bc367a445f88cf5a5c02a54966d1432f00fe93f0"];
    
    [MobClick startWithAppkey:@"550fd791fd98c52c94000eea" reportPolicy:REALTIME   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
    [self setShareIDs];
    
    //social share
//    [UMSocialData setAppKey:@"550fd791fd98c52c94000eea"];
//    
//    
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    [UMSocialWechatHandler setWXAppId:@"wx060aa2d39d56bf11" appSecret:@"2e4304f47f496fd7bee18fa8affcaa0e" url:REVIEW_URL];
//   
//    [UMSocialFacebookHandler setFacebookAppID:@"862357590489225" shareFacebookWithURL:REVIEW_URL];
//
//
      return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

-(void)setShareIDs
{
    [ShareSDK registerApp:@"6d6489c42740"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"3447785301"
                               appSecret:@"27243b808d207dfd8a7b0d3c6ea6fb90"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"3447785301"
                                appSecret:@"27243b808d207dfd8a7b0d3c6ea6fb90"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
       //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104547680"
                           appSecret:@"aWuri4nkHJTuhSEZ"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104547680"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx060aa2d39d56bf11"
                           wechatCls:[WXApi class]];
    
    
    [ShareSDK connectWeChatWithAppId:@"wx060aa2d39d56bf11"   //微信APPID
                           appSecret:@"2e4304f47f496fd7bee18fa8affcaa0e"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"1603504083226872"
                              appSecret:@"abf54f81fba06d9278aa2e67ea225feb"];
    

}


- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply{
    // Receives text input result from the WatchKit app extension.
    NSLog(@"User Info: %@", userInfo);
    if ([[userInfo objectForKey:@"goalID"] isEqualToString:@"Maybe"])
    {
        reply(@{@"Confirmation" : @"Maybe MaybeMaybeMaybeMaybeMaybeMaybe."});
        
    }else
    {
        
        // Sends a confirmation message to the WatchKit app extension that the text input result was received.
        reply(@{@"Confirmation" : @"Text was received."});
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    if([identifier isEqualToString:@"ADD_ONE"])
    {
        NSNumber *remindID = [notification.userInfo objectForKey:@"remindID"];
        [self updateDB:remindID];
        
        NSLog(@"+++");
        
    }
    completionHandler(nil);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if([identifier isEqualToString:@"ADD_ONE"])
    {
        BOOL sql = [db executeUpdate:@"update GOALSINFO set amount_DONE=? where goalID = ?" ,@3,@1];
        if (!sql) {
            NSLog(@"ERROR123: %d - %@", db.lastErrorCode, db.lastErrorMessage);
        }
        
        NSLog(@"++++++");
        
    }
    completionHandler(nil);
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
    

}

-(void)updateDB:(NSNumber *)remindID
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,startTime,endTime,amount,amount_DONE,reminderNote from GOALSINFO where remindID = ?",remindID];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];
        oneGoal.startTime = [rs stringForColumn:@"startTime"];
        oneGoal.endTime = [rs stringForColumn:@"endTime"];
        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];
        oneGoal.reminderNote = [rs stringForColumn:@"reminderNote"];
        
        if (([oneGoal.amount_DONE intValue]+1) >=[oneGoal.amount intValue]) {
            BOOL sql = [db executeUpdate:@"update GOALSINFO set amount_DONE=?,isFinished=? where goalID = ?" ,[NSNumber numberWithInt:([oneGoal.amount_DONE intValue]+1)],[NSNumber numberWithInt:1],oneGoal.goalID];
            if (!sql) {
                NSLog(@"ERROR123: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }
        }else
        {
            BOOL sql = [db executeUpdate:@"update GOALSINFO set amount_DONE=? where goalID = ?" ,[NSNumber numberWithInt:([oneGoal.amount_DONE intValue]+1)],oneGoal.goalID];
            if (!sql) {
                NSLog(@"ERROR123: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }
        }
        
        
    }
    
    [db close];
    

    


    
}


@end
