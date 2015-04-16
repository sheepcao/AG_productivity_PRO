//
//  FirstViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CommonUtility.h"
#import "globalVar.h"
#import "SWTableViewCell.h"

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>



@property (nonatomic,strong) NSMutableArray *processingTasks;
@property (nonatomic,strong) NSMutableArray *finishedTasks;
@property (nonatomic,strong) NSMutableArray *giveupTasks;
@property (nonatomic,strong) NSMutableArray *notyetTasks;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *goalTypeSegment;
- (IBAction)goalTypeChanged:(id)sender;
- (IBAction)addNewGoal:(id)sender;
- (IBAction)settingTapped:(id)sender;


@property (nonatomic,strong) FMDatabase *db;

@end

