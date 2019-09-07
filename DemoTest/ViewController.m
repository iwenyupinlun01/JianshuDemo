//
//  ViewController.m
//  DemoTest
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "TestTableView.h"

#import "WMPageController.h"
#import "OneViewTableTableViewController.h"
#import "SecondViewTableViewController.h"
#import "ThirdViewCollectionViewController.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

static CGFloat const headViewHeight = 256;


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WMPageControllerDelegate>
@property(nonatomic ,strong)TestTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,assign)BOOL canScroll;
@end

@implementation ViewController
@synthesize mainTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
    self.navigationItem.title = @"简书个人中心页面";
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)MainTableScroll:(NSNotification *)user{
    
    self.canScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==mainTableView) {
        
        CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"tabOffsetY:%f",offsetY);
        if (offsetY>=tabOffsetY) {
            self.canScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"childScrollCan" object:nil];
        }else{
            
            if (!self.canScroll) {
                
                 [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height-64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    OneViewTableTableViewController * oneVc  = [OneViewTableTableViewController new];
    SecondViewTableViewController * twoVc  = [SecondViewTableViewController new];
    ThirdViewCollectionViewController * thirdVc  = [ThirdViewCollectionViewController new];
    
    NSArray *viewControllers = @[oneVc,twoVc,thirdVc];
    
    NSArray *titles = @[@"first",@"second",@"third"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 85;
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}
-(TestTableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[TestTableView alloc]initWithFrame:CGRectMake(0,64,Main_Screen_Width,Main_Screen_Height-64)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
        
    }
    return mainTableView;
}
@end
