//
//  settingViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/21/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"

@interface settingViewController : UIViewController
- (IBAction)backToMain:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end
