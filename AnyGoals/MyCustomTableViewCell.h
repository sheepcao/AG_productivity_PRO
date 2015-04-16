//
//  MyCustomTableViewCell.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "SWTableViewCell.h"
#import "PieView.h"
#import "CycleView.h"
#import "VBPieChart.h"
#import "globalVar.h"

@interface MyCustomTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GoalName;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet PieView *pieView;
@property (weak, nonatomic) IBOutlet CycleView *innerCycle;
@property (weak, nonatomic) IBOutlet UILabel *goalStatus;
@property (strong, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) IBOutlet UILabel *doneAmount;
@property (weak, nonatomic) IBOutlet UIImageView *reminderShow;
@property (weak, nonatomic) IBOutlet UIImageView *statusShow;
@property (weak, nonatomic) IBOutlet UIImageView *urgentShow;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSpecific;

@property (strong, nonatomic)  UILabel *total_Amount;
@property (strong, nonatomic)  UILabel *done_Amount;

@property (strong, nonatomic)  VBPieChart *pie;
@property (weak, nonatomic) IBOutlet UIImageView *rightSwipeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *liftSwipeIcon;

//@property (strong,nonatomic)VBPieChart *pie;
//@property (nonatomic, strong) NSArray *chartValues;


-(void)setupUI;

@end
