//
//  TodayViewController.h
//  AnyGoalWidget
//
//  Created by Eric Cao on 3/27/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "VBPieChart.h"
#import "GoalObj.h"

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *Backview;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *allPieScroll;

@property (strong,nonatomic) NSMutableArray *pieArray;
@property (strong,nonatomic) NSMutableArray *midTextArray;
@property (strong,nonatomic) NSArray *doneAmountArray;
@property (strong, nonatomic) NSMutableArray *allGoals;
@property (weak, nonatomic) IBOutlet UIButton *OpenAppBtn;

- (IBAction)openApp:(id)sender;

//@property (strong,nonatomic) VBPieChart *pie;
//
//@property (strong, nonatomic)  UILabel *total_Amount;
//@property (strong, nonatomic)  UILabel *done_Amount;
@end
