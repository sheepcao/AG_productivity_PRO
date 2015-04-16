//
//  NotificationController.h
//  AnyGoals WatchKit Extension
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NotificationController : WKUserNotificationInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *alertTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *alertBody;

@end
