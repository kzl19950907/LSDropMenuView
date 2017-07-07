//
//  ViewController.m
//  LSDropMenuView
//
//  Created by Coder_Mr on 2017/7/5.
//  Copyright © 2017年 Coder_Mr. All rights reserved.
//

#import "ViewController.h"
#import "LSDropMenuView.h"

@interface ViewController () <LSDropMenuViewDelegate, LSDropMenuViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSDropMenuView *_menuView = [[LSDropMenuView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    
    _menuView.btnFont = [UIFont systemFontOfSize:13];
    _menuView.btnColor = [UIColor lightGrayColor];
    _menuView.btnHighlightedColor = [UIColor blueColor];
    _menuView.cellTextFont = [UIFont systemFontOfSize:13];
    _menuView.cellTextColor = [UIColor lightGrayColor];
    _menuView.cellSelectedTextColor = [UIColor blueColor];
    _menuView.cellTextFont = [UIFont systemFontOfSize:14];
    _menuView.cellBackgroundColor = [UIColor whiteColor];
    _menuView.cellSelectedBackgroundColor = [UIColor colorWithRed:243.0/255 green:248.0/255 blue:251.0/255 alpha:0];
    

    _menuView.delegate = self;
    _menuView.dataSource = self;
    [self.view addSubview:_menuView];

    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40)];
    v.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:v];
    
}



- (NSInteger)numberOfColumnsInDropMenuView:(LSDropMenuView *)view{
    
    return 3;
}

- (BOOL)dropMenuView:(LSDropMenuView *)view haveRightAtColumn:(NSInteger)column{
    
    return column==0|column==2;
}

- (NSInteger)dropMenuView:(LSDropMenuView *)view numberOfRowsAtColumn:(NSInteger)column isRightColumn:(BOOL)is leftSelecteRow:(NSInteger)leftRow{
    
    if (is) {
        
        return 10;
    }
    
    return 15;
    
}

- (NSString *)dropMenuView:(LSDropMenuView *)view titleOfRowsAtIndexPath:(LSIndexPath *)indexPath isRightColumn:(BOOL)is subRow:(NSInteger)row{
    
    
    if (is && (indexPath.column==0 || indexPath.column == 2)) {
        
        NSString *str = [NSString stringWithFormat:@"右 %ld %ld",indexPath.row,row];
        return str;
    }
    
    NSString *str1 = [NSString stringWithFormat:@"左 %ld",indexPath.row];
    
    
    return str1
    ;
}


- (void)dropMenuView:(LSDropMenuView *)view didSelectedRowAtIndexPath:(LSIndexPath *)indexPath isRightColumn:(BOOL)is subRow:(NSInteger)row{
    
    NSString *str = is?@"右":@"左";
    
    NSLog(@"选中第 %ld column 第 %ld row %@-%ld",indexPath.column,indexPath.row,str,row);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
