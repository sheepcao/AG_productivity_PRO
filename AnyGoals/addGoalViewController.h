//
//  addGoalViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/12/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "GoalObj.h"

@interface addGoalViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *goalInfoScrollView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) UITextField *goalNameField;
@property (strong, nonatomic) UITextField *actionTimesField;
@property (strong, nonatomic) UIButton *startTimeField;
@property (strong, nonatomic) UIButton *endTimeField;
@property (nonatomic,strong) NSMutableArray *textfieldArray;
@property (nonatomic,strong) GoalObj *editingGoal;

@property BOOL isNewGoal;



- (IBAction)saveGoal:(id)sender;

- (IBAction)backHome:(id)sender;
@end
