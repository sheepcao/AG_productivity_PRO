//
//  SecondViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

@import GoogleMobileAds;


#import <UIKit/UIKit.h>
#import "PieView.h"
#import "globalVar.h"
#import "GoalObj.h"

#import "VBPieChart.h"

#import "MobClick.h"

#import "GoogleMobileAds/GADInterstitial.h"


//#import "BaiduMobAdInterstitial.h"

//#import "UMSocialSinaHandler.h"
//#import "UMSocialSnsService.h"
//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialFacebookHandler.h"


@interface SecondViewController : UIViewController<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;


@property (nonatomic,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet PieView *PiesView;
//@property (weak, nonatomic) IBOutlet PieView *totalPie;
//@property (weak, nonatomic) IBOutlet PieView *finishPie;
//@property (weak, nonatomic) IBOutlet PieView *urgentPie;
//@property (weak, nonatomic) IBOutlet PieView *weeklyPie;
//@property (weak, nonatomic) IBOutlet PieView *monthlyPie;


@property (strong, nonatomic)  VBPieChart *totalPie;
@property (strong, nonatomic)  VBPieChart *finishPie;
@property (strong, nonatomic)  VBPieChart *urgentPie;
@property (strong, nonatomic)  VBPieChart *weeklyPie;
@property (strong, nonatomic)  VBPieChart *monthlyPie;


@property (strong, nonatomic) UILabel *totalPieLabel;
@property (strong, nonatomic) UILabel *finishPieLabel;
@property (strong, nonatomic) UILabel *urgentPieLabel;
@property (strong, nonatomic) UILabel *weeklyPieLabel;
@property (strong, nonatomic) UILabel *monthlyPieLabel;


@property (strong, nonatomic) NSMutableArray *allGoals;
- (IBAction)settingTapped:(id)sender;

- (IBAction)shareTapped:(id)sender;
@end

