//
//  myTabbarViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/24/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "myTabbarViewController.h"

@interface myTabbarViewController ()

@end

@implementation myTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    
    tabBarItem1.title = NSLocalizedString(@"目标列表", nil) ;
    tabBarItem2.title = NSLocalizedString(@"数据统计", nil);
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"goalList.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"goalList0.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"data.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"data0.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
   [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }
                                                         forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f] }
                                             forState:UIControlStateSelected];

    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
