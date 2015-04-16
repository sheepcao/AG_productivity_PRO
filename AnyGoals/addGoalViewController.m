//
//  addGoalViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/12/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "addGoalViewController.h"
#import "ATCTransitioningDelegate.h"
#import "CustomDatePickerActionSheet.h"

@interface addGoalViewController ()<UITextFieldDelegate,UITextViewDelegate,DatePickerActionSheetDelegate>
@property (nonatomic,strong) ATCTransitioningDelegate *atcTD;
@property (nonatomic,strong) UIDatePicker *remindTimePicker;
@property (nonatomic,strong) UITextView *reminderNote;
@property (nonatomic,strong) UISwitch *reminderSwitch;

@property (nonatomic,strong) UILabel * timeSelected;
@property (nonatomic,strong) CustomDatePickerActionSheet *custom;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *reminderTime;
@end

@implementation addGoalViewController

@synthesize goalNameField;
@synthesize actionTimesField;
@synthesize startTimeField;
@synthesize endTimeField;
@synthesize textfieldArray;
@synthesize remindTimePicker;
@synthesize timeSelected;
@synthesize custom;
@synthesize db;
@synthesize reminderTime;
@synthesize reminderNote;
@synthesize reminderSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    goalNameField = [[UITextField alloc] init];
    actionTimesField = [[UITextField alloc] init];
    startTimeField = [[UIButton alloc] init];
    endTimeField = [[UIButton alloc] init];

    
    textfieldArray = [[NSMutableArray alloc] initWithObjects:goalNameField,actionTimesField,startTimeField,endTimeField, nil];
    custom = [[CustomDatePickerActionSheet alloc] initWithDelegate:self];


    [self setupUI];
    [self drawAline];
    
    

}

-(void)drawAline
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.goalInfoScrollView.frame.origin.y-1, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line];
}
#pragma mark system language
- (BOOL)isSystemLangChinese
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    if([language compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }else
    {
        return NO;
    }
}


-(void)setupUI
{
    
    //init position of bar buttons
    [self.pageTitle setFrame:CGRectMake(SCREEN_WIDTH-130/2, 30, 130, 40)];
    [self.backBtn setFrame:CGRectMake(20, self.pageTitle.frame.origin.y, 45, 35)];
    [self.saveBtn setFrame:CGRectMake(SCREEN_WIDTH-20-45, self.pageTitle.frame.origin.y, 45, 35)];
    

    self.goalInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.pageTitle.frame.origin.y+50, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pageTitle.frame.origin.y+50))];
    self.goalInfoScrollView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0];
    if (IS_IPHONE_4_OR_LESS) {
        self.goalInfoScrollView.contentSize = CGSizeMake(self.goalInfoScrollView.frame.size.width, self.goalInfoScrollView.frame.size.height+100);

    }else
    {
        self.goalInfoScrollView.contentSize = CGSizeMake(self.goalInfoScrollView.frame.size.width, self.goalInfoScrollView.frame.size.height);

    }
    self.goalInfoScrollView.showsVerticalScrollIndicator = NO;
    self.goalInfoScrollView.showsHorizontalScrollIndicator = NO;

    
    [self.view addSubview:self.goalInfoScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.goalInfoScrollView addGestureRecognizer:tap];
    
    for (int i = 0; i <2; i++) {
     
        UIImageView *editingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 40 + 50*i, 25, 25)];
        [editingImage setImage:[UIImage imageNamed:@"pen.png"]];
        [self.goalInfoScrollView addSubview:editingImage];
        
        UITextField *txtfield = self.textfieldArray[i];
        
        [txtfield setFrame:CGRectMake(45, 30 + 50*i, SCREEN_WIDTH-45-45, 35)];
        
        txtfield.borderStyle = UITextBorderStyleNone;
        txtfield.delegate=self;
        [self.goalInfoScrollView addSubview:txtfield];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, txtfield.frame.origin.y+txtfield.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
        [line setBackgroundColor:[UIColor grayColor]];
        [self.goalInfoScrollView addSubview:line];
        
    }
    [goalNameField setReturnKeyType:UIReturnKeyDone];

    actionTimesField.keyboardType = UIKeyboardTypeNumberPad;
    for (int i = 2; i <4; i++) {
        
        UIImageView *editingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 40 + 50*i, 25, 25)];
        [editingImage setImage:[UIImage imageNamed:@"pen.png"]];
        [self.goalInfoScrollView addSubview:editingImage];
        
        UIButton *timeBtn = self.textfieldArray[i];
        
        [timeBtn setFrame:CGRectMake(45, 30 + 50*i, SCREEN_WIDTH-45-45, 35)];
        
        timeBtn.layer.borderWidth = 0;
        timeBtn.tag = i;
        [timeBtn addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.goalInfoScrollView addSubview:timeBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, timeBtn.frame.origin.y+timeBtn.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
        [line setBackgroundColor:[UIColor grayColor]];
        [self.goalInfoScrollView addSubview:line];
        
    }

    goalNameField.textAlignment = NSTextAlignmentCenter;
    actionTimesField.textAlignment = NSTextAlignmentCenter;
    [startTimeField setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [endTimeField setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    startTimeField.titleLabel.textAlignment = NSTextAlignmentLeft;


    UILabel *reminder = [[UILabel alloc] initWithFrame:CGRectMake(50, endTimeField.frame.origin.y+endTimeField.frame.size.height+30, 200, 35)];
    reminder.textAlignment = NSTextAlignmentLeft;
    reminder.text = NSLocalizedString(@"\t提醒我",nil);
    reminder.textColor = [UIColor lightGrayColor];
    
    reminderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, reminder.frame.origin.y+1, 51, 31)];
    [reminderSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, reminder.frame.origin.y+reminder.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self.goalInfoScrollView addSubview:line];
    [self.goalInfoScrollView addSubview:reminderSwitch];
    [self.goalInfoScrollView addSubview:reminder];



    
    
    remindTimePicker = [[UIDatePicker alloc] init];
    timeSelected = [[UILabel alloc] init];
    
    reminderNote = [[UITextView alloc] init];
    reminderNote.delegate = self;
    reminderNote.font = [UIFont systemFontOfSize:17.0f];

    reminderNote.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0];
    
//    if (self.isNewGoal) {
//
//    }else
//    {
//        //to do select from db...
//    }

    [remindTimePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    
    if(self.isNewGoal)
    {
        goalNameField.placeholder = NSLocalizedString(@"目标名称",nil);
        actionTimesField.placeholder = NSLocalizedString(@"行动次数",nil);
        
        [startTimeField setTitle:NSLocalizedString(@"开始时间",nil) forState:UIControlStateNormal];
        [endTimeField setTitle:NSLocalizedString(@"截至时间",nil) forState:UIControlStateNormal];
        
        reminderTime = @"";
        [reminderNote setText:NSLocalizedString(@"点击编辑提醒备注...",nil)];
        [reminderNote setTextColor:[UIColor lightGrayColor]];
        
    }else
    {
        if (self.editingGoal) {
            [goalNameField setText:self.editingGoal.goalName];
            [actionTimesField setText:[NSString stringWithFormat:@"%d",[self.editingGoal.amount intValue]]];
            [startTimeField setTitle:self.editingGoal.startTime forState:UIControlStateNormal];
            [endTimeField setTitle:self.editingGoal.endTime forState:UIControlStateNormal];
            if (![self.editingGoal.reminder isEqualToString:@""]) {
                
                [reminderSwitch setOn:YES];
                [self switchAction:reminderSwitch];
                
            }
            
            reminderTime = self.editingGoal.reminder;

            [reminderNote setText:self.editingGoal.reminderNote];
            if ([self.editingGoal.reminderNote isEqualToString:NSLocalizedString(@"点击编辑提醒备注...",nil)]) {
                [reminderNote setTextColor:[UIColor lightGrayColor]];

            }else
            {
                [reminderNote setTextColor:[UIColor blackColor]];

            }
            
            
        }
        
        
    }
}



#pragma mark switch action
-(void)switchAction:(id)sender
{
    [self.view endEditing:YES];
    [custom close];
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        
        [remindTimePicker setFrame:CGRectMake(10, switchButton.frame.origin.y+45, SCREEN_WIDTH-20, (SCREEN_WIDTH-10)*0.46)];
        remindTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        timeSelected = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 150, remindTimePicker.frame.origin.y+remindTimePicker.frame.size.height, 300, 30)];
        timeSelected.textAlignment = NSTextAlignmentCenter ;
        
        [reminderNote setFrame:CGRectMake(45, timeSelected.frame.origin.y+timeSelected.frame.size.height+2, remindTimePicker.frame.size.width, remindTimePicker.frame.size.height/2)];

        
        //to do .. select reminder time in db and show.include setting date picker.
        if (self.isNewGoal || [reminderTime isEqualToString:@""]) {
            reminderTime = NSLocalizedString(@"未选择",nil);
            [timeSelected setText:[NSString stringWithFormat:NSLocalizedString(@"已选时间: %@",nil),reminderTime]];
        }else
        {
            reminderTime = self.editingGoal.reminder;
            [timeSelected setText:[NSString stringWithFormat:NSLocalizedString(@"已选时间: %@",),reminderTime]];
            
            NSDateFormatter *reminderDateFormatter = [[NSDateFormatter alloc] init];
            reminderDateFormatter.dateFormat = @"yyyy/MM/dd HH:mm"; // 设置时间和日期的格式
            
            NSDate *remindDate =[reminderDateFormatter dateFromString:reminderTime];
            
            [remindTimePicker setDate:remindDate animated:YES];
            
            
        }
        
        
        if (!remindTimePicker.superview) {
            [self.goalInfoScrollView addSubview:remindTimePicker];
            [self.goalInfoScrollView addSubview:timeSelected];
            [self.goalInfoScrollView addSubview:reminderNote];
        }

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];

        [UIView commitAnimations];
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];
        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];
            [self.goalInfoScrollView setContentOffset:CGPointMake(0, 185)];


        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];

        }
        
    }else {
        if (remindTimePicker.superview) {
            [remindTimePicker removeFromSuperview];
            [timeSelected removeFromSuperview];
            [reminderNote removeFromSuperview];
        }
        if (![reminderTime isEqualToString:@""]) {
            reminderTime = @"";
        }
        [UIView beginAnimations:nil context:NULL];

        [UIView setAnimationDuration:0.35f];

        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];

        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+100)];
            
        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height)];
        }
    }
}
#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [remindTimePicker date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy/MM/dd HH:mm"; // 设置时间和日期的格式
    
    reminderTime =[selectDateFormatter stringFromDate:select];
    
    NSString *dateAndTime =[NSString stringWithFormat:NSLocalizedString(@"已选时间:%@",nil),reminderTime] ;
    
    [timeSelected setText:dateAndTime];
    
    NSLog(@"date:%@",dateAndTime);
    // 在控制台打印消息
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)timeSelect:(UIButton *)sender
{
    
    //eric: custom action sheet.
    
    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];
    
    [custom setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    [self.view addSubview:custom];
    custom.tag = sender.tag;
    [custom showInView];

}
- (void)dateChanged:(CustomDatePickerActionSheet *)datePickerActionSheet {
    NSLog(@"date %@", datePickerActionSheet.date.debugDescription);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];

    
    if (datePickerActionSheet.tag == 2) {
        [startTimeField setTitle:[dateFormat stringFromDate:[datePickerActionSheet date]] forState:UIControlStateNormal];
    }else
    {
        [endTimeField setTitle:[dateFormat stringFromDate:[datePickerActionSheet date]] forState:UIControlStateNormal];

    }
}


-(BOOL)checkTimeValidation
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *start = [dateFormat dateFromString:startTimeField.titleLabel.text];
    NSDate *end = [dateFormat dateFromString:endTimeField.titleLabel.text];
    
    if ([start compare:end] == NSOrderedAscending)
    {
        return true;
    }else
    {
        UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请注意",nil) message:NSLocalizedString(@"目标开始时间应设置在截至时间之后!",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
        [reminderError show];
        return false;
    }


    
}


-(BOOL)checkReminderValidation
{
    if (![reminderTime isEqualToString:@""]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *reminder = [dateFormat dateFromString:reminderTime];
        
        if ([reminder compare:[NSDate date]] == NSOrderedDescending)
        {
            return TRUE;
        }else
        {
            UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请注意",nil) message:NSLocalizedString(@"提醒时间应为未来的某一时刻!",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [reminderError show];
            return false;

        }

    }else
    {
        return TRUE;
    }

    
    
}
-(BOOL)checkInfoValidation
{

    if (goalNameField.text.length>0 && actionTimesField.text.length>0 && ![startTimeField.titleLabel.text isEqualToString:NSLocalizedString(@"开始时间",nil)] && ![endTimeField.titleLabel.text isEqualToString:NSLocalizedString(@"截至时间",nil)]) {
        return TRUE;
    }
    UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请注意",nil) message:NSLocalizedString(@"请完整设置目标基本信息!",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    [reminderError show];
    return false;
}
-(BOOL)checkActionAmountValidation
{
    
    if (actionTimesField.text.length>0 && [actionTimesField.text intValue]>0) {
        return TRUE;
    }else
    {
        UIAlertView *actionTimesError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请注意",nil) message:NSLocalizedString(@"行动次数不能为0.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
        [actionTimesError show];
        return false;
    }

}

- (IBAction)saveGoal:(id)sender {

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    if ([self checkReminderValidation] && [self checkInfoValidation] && [self checkTimeValidation] && [self checkActionAmountValidation]) {
        
        NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
        NSString *docsPath = [storeURL absoluteString];
        
//        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
        NSString *remindNote = NSLocalizedString(@"点击编辑提醒备注...",nil);
        
        if (reminderNote.superview) {
            remindNote = reminderNote.text;
        }
        
        db = [FMDatabase databaseWithPath:dbPath];
        
        if (![db open]) {
            NSLog(@"Could not open db.");
            return;
        }
        [MobClick event:@"addGoalEnd"];

        if(self.isNewGoal)
        {
            int maxRemindID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxNotificationID"] intValue];
            
            BOOL sql = [db executeUpdate:@"insert into GOALSINFO (goalName, startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote,isFinished,isGiveup,remindID) values (?,?,?,?,?,?,?,?,?,?,?)" , goalNameField.text, startTimeField.titleLabel.text,endTimeField.titleLabel.text,[NSNumber numberWithInt:[actionTimesField.text intValue]],[NSNumber numberWithInt:0],timeNow,reminderTime,remindNote,[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[[NSUserDefaults standardUserDefaults] objectForKey:@"maxNotificationID"]];
            
            if (!sql) {
                NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }else
            {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(maxRemindID+1)] forKey:@"maxNotificationID"];
                
                [self startLocalNotificationWithTime:reminderTime andTitle:goalNameField.text andDescription:remindNote andRemindID:maxRemindID];
            }
            [db close];
        }else
        {
            
             int maxRemindID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxNotificationID"] intValue];
            
            if ([self.editingGoal.amount_DONE intValue]>=[actionTimesField.text intValue]) {
                [db close];
                UIAlertView *overAmountAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请注意",nil) message:NSLocalizedString(@"您已经完成的行动次数超过了您输入的总行动次数,请修改",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles:nil, nil];
                [overAmountAlert show];
                return;

            }

            
           BOOL sql = [db executeUpdate:@"update GOALSINFO set goalName = ?, startTime= ?,endTime =?,amount=?,lastUpdateTime=?,reminder=?,reminderNote=?,isFinished=?,isGiveup=?,remindID=? where goalID = ?" , goalNameField.text, startTimeField.titleLabel.text,endTimeField.titleLabel.text,[NSNumber numberWithInt:[actionTimesField.text intValue]],timeNow,reminderTime,remindNote,[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[[NSUserDefaults standardUserDefaults] objectForKey:@"maxNotificationID"],self.editingGoal.goalID];
            if (!sql) {
                NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(maxRemindID+1)] forKey:@"maxNotificationID"];

                
                [self startLocalNotificationWithTime:reminderTime andTitle:goalNameField.text andDescription:remindNote andRemindID:maxRemindID];
            }
            [db close];
        }
        
        [self.navigationController popViewControllerAnimated:YES];


    }

   
}
-(void)startLocalNotificationWithTime:(NSString *)remdTime andTitle:(NSString *)title andDescription:(NSString *)detail andRemindID:(int)remindID{
    NSLog(@"startLocalNotification");
    
    if ([reminderTime isEqualToString:@""]) {
        return;
    }
    if ([detail isEqualToString:NSLocalizedString(@"点击编辑提醒备注...",nil)]) {
        detail = @"";
        [MobClick event:@"remindNote"];

    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    
    NSDate *remindTime = [dateFormat dateFromString:remdTime];
    
    NSTimeInterval remindTimeByNow = [remindTime timeIntervalSinceDate:[NSDate date]];
//
    UILocalNotification *notification = [[UILocalNotification alloc] init];
//
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:remindTimeByNow];
    NSLog(@"interval:%f",remindTimeByNow);
    notification.alertTitle = title;
    if(detail.length >0)
    {
        notification.alertBody = [NSString stringWithFormat:@"%@",detail];
        
    }else
    {
        notification.alertBody = title;
    }
//    notification.alertTitle = title;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
//    notification.applicationIconBadgeNumber = 10;
    
    notification.category = @"goalActionAmount";
    
    NSDictionary *nitificationDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:remindID],@"remindID", nil];
    
    notification.userInfo = nitificationDic;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [MobClick event:@"reminder"];

}

- (IBAction)backHome:(id)sender {
//    [self setupTransitioningDelegate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupTransitioningDelegate{
    
    
    // Set up our delegate
    self.atcTD = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:ATCTransitionAnimationTypeBounce
                                                              dismissalTransition:ATCTransitionAnimationTypeBounce
                                                                        direction:ATCTransitionAnimationDirectionBottom
                                                                         duration:0.65f];
    self.navigationController.delegate = self.atcTD;
    
    
}

#pragma mark textfiled delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];


}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [custom close];
    return YES;
}// return NO to disallow editing.


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
-(void)dismissKeyboard {
    

    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];
    if ([reminderNote isFirstResponder]) {
        [reminderNote resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];
        
        [UIView commitAnimations];
        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];

        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];

        }

    }
    
}
#pragma mark textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if ([textView.text isEqualToString:NSLocalizedString(@"点击编辑提醒备注...",nil)]) {
        textView.text = @"";

    }
    textView.textColor = [UIColor blackColor];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    if(IS_IPHONE_4_OR_LESS)
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+390)];

        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 390)];

    }else if (IS_IPHONE_5)
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+330)];
        
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 330)];
    }else if (IS_IPHONE_6)
    {
    [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+250)];

    [self.goalInfoScrollView setContentOffset:CGPointMake(0, 250)];
    }else
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+240)];
        
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 240)];
    }
    [UIView commitAnimations];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [textView setText:NSLocalizedString(@"点击编辑提醒备注...",nil)];
        [textView setTextColor:[UIColor lightGrayColor]];
    }


    if (IS_IPHONE_4_OR_LESS) {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 200)];
        
        
    }else
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];

        
    }
    
}


@end
