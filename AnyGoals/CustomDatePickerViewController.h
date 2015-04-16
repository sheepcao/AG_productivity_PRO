//
//  CustomDatePickerViewController.h
//  OptumJoints
//
//  Created by Lan Tran on 8/6/13.
//  Copyright (c) 2013 Vinasource. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate;

@interface CustomDatePickerViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIButton *okButton;
@property(nonatomic, strong) IBOutlet UIDatePicker * datePicker;
@property(nonatomic, weak) id<CustomDatePickerDelegate> delegate;

+ (CustomDatePickerViewController*)controllerWithDelegate:(id<CustomDatePickerDelegate>)delegate;

-(IBAction)tapButtonDone:(id)sender;
- (IBAction)dateValueChanged:(id)sender;
@end

@protocol CustomDatePickerDelegate<NSObject>
@required
-(void)didTapButtonDone:(CustomDatePickerViewController*)viewController;
@end
