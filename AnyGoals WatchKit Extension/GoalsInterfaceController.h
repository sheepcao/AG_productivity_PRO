//
//  GoalsInterfaceController.h
//  AnyGoals
//
//  Created by Eric Cao on 4/9/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "listRowController.h"

@interface GoalsInterfaceController : WKInterfaceController<presentFinishNoteDelegate>
@property (weak, nonatomic) IBOutlet WKInterfaceTable *goalsListTable;

@end
