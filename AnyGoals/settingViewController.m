//
//  settingViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/21/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "settingViewController.h"


@interface settingViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *settingItems;
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.settingItems = [NSArray arrayWithObjects:NSLocalizedString(@"教程",nil),NSLocalizedString(@"音效",nil),NSLocalizedString(@"评论",nil),NSLocalizedString(@"团队作品",nil), NSLocalizedString(@"联系方式",nil),NSLocalizedString(@"分享好友",nil),nil];
    
    
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.settingItems.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell_1)
    {
        cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 1) {
        
        cell_1.textLabel.text = self.settingItems[indexPath.row];
        
        cell_1.backgroundColor = [UIColor clearColor];
        
        cell_1.detailTextLabel.font = [UIFont systemFontOfSize:30.0];
        cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
        [cell_1 setAccessoryType:UITableViewCellAccessoryNone];
        cell_1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(tableView.frame.size.width-70, 18, 60, 30)];
       
        if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"SoundSwitch"] isEqualToString:@"off"]) {
            soundSwitch.on = NO;
        }else
        {
            soundSwitch.on = YES;
        }
        [cell_1 addSubview:soundSwitch];
        [soundSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        
    }else if(indexPath.row == 4)
    {
        
        cell_1.textLabel.text = self.settingItems[indexPath.row];
        
        cell_1.backgroundColor = [UIColor clearColor];
        
        cell_1.detailTextLabel.font = [UIFont systemFontOfSize:13.5];
        cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
        cell_1.detailTextLabel.text = @"sheepcao1986@163.com";
        [cell_1 setAccessoryType:UITableViewCellAccessoryNone];

    }
    else
    {
        
        cell_1.textLabel.text = self.settingItems[indexPath.row];
        
        cell_1.backgroundColor = [UIColor clearColor];
        
        cell_1.detailTextLabel.font = [UIFont systemFontOfSize:30.0];
        cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
        [cell_1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    


    return cell_1;


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self showScrollView];
            [MobClick event:@"tutorail"];

            break;
        case 1:
            
            break;
        case 2:
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
            [MobClick event:@"review"];


            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
            [MobClick event:@"allApps"];


            break;
        case 5:
            
            [self shareApp];
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)shareApp
{
    
    UIImage *iconImage = [UIImage imageNamed:@"icon512"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:NSLocalizedString(@"目标,没有终点,AnyGoal伴您一路前行！",nil)                                       defaultContent:NSLocalizedString(@"我的目标状态",nil)
                                                image:[ShareSDK pngImageWithImage:iconImage]
                                                title:@"AnyGoal"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"目标,没有终点,AnyGoal伴您一路前行！",nil)
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [MobClick event:@"share"];
                                    
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    

}

#pragma mark switch action
-(void)switchAction:(UISwitch *)sender
{
    if (sender.isOn) {
        NSLog(@"sound on");
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"SoundSwitch"];
    }else
    {
        NSLog(@"sound off");
        
        [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"SoundSwitch"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TEACHING page
-(void) showScrollView{
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 6, [UIScreen mainScreen].bounds.size.height);
    
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 6; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        
        //将要加载的图片放入imageView 中
        UIImage *image;

        if ([self isSystemLangChinese]) {
            if (IS_IPHONE_4_OR_LESS) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            }else
            {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"%d%d",i,i]];
            }
        }else
        {
            if (IS_IPHONE_4_OR_LESS) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"%dEn",i]];
            }else
            {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"%d%dEn",i,i]];
            }
        }
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
    }
    
    float offside = 0;
    
    if (IS_IPHONE_6P) {
        offside = 27;
    }else if(IS_IPHONE_6)
    {
        offside = 15;

    }else if(IS_IPHONE_4_OR_LESS)
    {
        offside = -44;
    }
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, self.view.frame.size.height - 45- offside - 49, 50, 40)];
    pageConteol.numberOfPages = 6;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    pageConteol.tag = 201;
    pageConteol.pageIndicatorTintColor = [UIColor whiteColor];
    pageConteol.currentPageIndicatorTintColor = [UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f];

    
//    UIButton *startNow = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, pageConteol.frame.origin.y+pageConteol.frame.size.height+5, 80, 40)];
//    
//    [startNow setImage:[UIImage imageNamed:@"startNow"] forState:UIControlStateNormal];
//    [startNow addTarget:self action:@selector(scrollViewDisappear:) forControlEvents:UIControlEventTouchUpInside];
//    
//    startNow.tag = 301;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview: pageConteol];
//    [self.view addSubview:startNow];
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
//    UIButton *button = (UIButton *)[self.view viewWithTag:301];
    
    //当显示到最后一页时，让滑动图消失
    if (page.currentPage == 5) {
        
        
        
//        [button setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        
        //调用方法，使滑动图消失
        [self performSelector:@selector(scrollViewDisappear) withObject:nil afterDelay:2.0];
//        [self scrollViewDisappear];
    }else
    {
//        [button setImage:[UIImage imageNamed:@"startNow"] forState:UIControlStateNormal];
        
    }
}


-(void)scrollViewDisappear{
    
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:0.6f animations:^{
        
        //        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        scrollView.alpha = 0.1;
        page.alpha = 0.1;
//        sender.alpha = 0.1;
//        [sender removeFromSuperview];
        
        
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:NO];
        
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
//        if (sender.superview) {
//            [sender removeFromSuperview];
//            
//        }
        
    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}




- (IBAction)backToMain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
@end
