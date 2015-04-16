//
//  CustomDatePickerActionSheet.h
//  OptumJoints
//
//  Created by Lan Tran on 8/5/13.
//  Copyright (c) 2013 Vinasource. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerActionSheetDelegate;

@class CustomDatePickerViewController;

@interface CustomDatePickerActionSheet : UIView

@property(nonatomic, strong) CustomDatePickerViewController * controller;
@property(nonatomic) CGRect datePickerBoundary;
@property(nonatomic, weak) id<DatePickerActionSheetDelegate> datePickerActionSheetDelegate;

- (CustomDatePickerActionSheet*)initWithDelegate:(id<DatePickerActionSheetDelegate>)delegate;
- (NSDate *)date;

- (void)setDate:(NSDate *)date;
- (void)setMaximumDate:(NSDate *)date;
- (void)setMinimumDate:(NSDate *)date;
- (void)setPickerMode:(UIDatePickerMode)mode;

- (void)close;
//eric:
- (void)showInView;

@end

@protocol DatePickerActionSheetDelegate <NSObject>
@required
- (void) dateChanged:(CustomDatePickerActionSheet *)datePickerActionSheet;
@end
