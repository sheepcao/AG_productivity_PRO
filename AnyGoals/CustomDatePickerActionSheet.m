//
//  CustomDatePickerActionSheet.m
//  OptumJoints
//
//  Created by Lan Tran on 8/5/13.
//  Copyright (c) 2013 Vinasource. All rights reserved.
//

#import "CustomDatePickerActionSheet.h"
#import "CustomDatePickerViewController.h"
#import "globalVar.h"

#define PICKER_BOUNDARY CGRectMake(0, 20,SCREEN_WIDTH, SCREEN_HEIGHT-20)
#define CUSTOM_SHEET_HEIGHT 210

@interface CustomDatePickerActionSheet ()<CustomDatePickerDelegate>

@property (strong,nonatomic) UIView *superViewHere;
@end

@implementation CustomDatePickerActionSheet

#pragma mark
#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.title = nil;
//        self.delegate = nil;
    }
    return self;
}

#pragma mark
#pragma mark - Common methods

- (CustomDatePickerActionSheet*)initWithDelegate:(id<DatePickerActionSheetDelegate>)delegate
{
    self = [super initWithFrame:PICKER_BOUNDARY];
    if (self) {
        self.datePickerBoundary = PICKER_BOUNDARY;
        self.datePickerActionSheetDelegate = delegate;
        self.controller = [CustomDatePickerViewController controllerWithDelegate:self];
        
        [self addSubview:self.controller.view];
    }
    return self;
}

- (NSDate *)date
{
    return self.controller.datePicker.date;
}

- (void)setDate:(NSDate *)date
{
    [self.controller.datePicker setDate:date];
}

- (void)setMaximumDate:(NSDate *)date
{
    [self.controller.datePicker setMaximumDate:date];
}

- (void)setMinimumDate:(NSDate *)date
{
    [self.controller.datePicker setMinimumDate:date];
}

-(void)setPickerMode:(UIDatePickerMode)mode{
    [self.controller.datePicker setDatePickerMode:mode];
}

- (void)didTapButtonDone:(CustomDatePickerViewController *)viewController
{
    [self close];
    [self.datePickerActionSheetDelegate dateChanged:self];
}

- (void)showInView
{
//    [super showInView:view];
    [self setBounds:self.datePickerBoundary];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = [self frame];
    frame.origin.y -= CUSTOM_SHEET_HEIGHT;//eric: action view height
    [self setFrame:frame];
    [UIView commitAnimations];

}

- (void)close
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = [self frame];
    frame.origin.y += CUSTOM_SHEET_HEIGHT+40;//eric: action view height
    [self setFrame:frame];
    [UIView commitAnimations];
//    [self dismissWithClickedButtonIndex:0 animated:YES];
}




#pragma mark
#pragma mark - GenderPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}



@end
