//
//  CustomDatePickerViewController.m
//  OptumJoints
//
//  Created by Lan Tran on 8/6/13.
//  Copyright (c) 2013 Vinasource. All rights reserved.
//

#import "CustomDatePickerViewController.h"
#import "globalVar.h"

#define CONTROLLER_IDENTIFIER @"CustomDatePickerViewController"

@interface CustomDatePickerViewController ()

@end

@implementation CustomDatePickerViewController

+ (CustomDatePickerViewController*)controllerWithDelegate:(id<CustomDatePickerDelegate>)delegate
{
    CustomDatePickerViewController* vc = [[CustomDatePickerViewController alloc] initWithNibName:CONTROLLER_IDENTIFIER bundle:nil];
    vc.delegate = delegate;
    
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIColor whiteColor],
//                                NSForegroundColorAttributeName,
//                                 nil];
    [self.view setFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT)];

    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [self.datePicker setLocale:locale];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)tapButtonDone:(id)sender{
    [self.delegate didTapButtonDone:self];
}

- (IBAction)dateValueChanged:(id)sender {
    
    NSLog(@"%@",_datePicker.date);
}

@end
