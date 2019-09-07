//
//  BaseViewController.m
//  DemoTest
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL can_scroll;
@property(nonatomic,strong)UIScrollView *scrollview;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollStop:) name:@"childScrollStop" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollStop:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollStop:) name:@"MainTableScroll" object:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)childScrollStop:(NSNotification *)user{
    
    if ([user.name isEqualToString:@"childScrollStop"]) {
        
        self.can_scroll = NO;
        [self.scrollview setContentOffset:CGPointZero];
        
    }else if ([user.name isEqualToString:@"childScrollCan"]){
        
        self.can_scroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        
        self.can_scroll = NO;
        [self.scrollview setContentOffset:CGPointZero];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_can_scroll) {
        
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
    self.scrollview = scrollView;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
