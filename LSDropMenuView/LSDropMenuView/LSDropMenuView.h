//
//  LSDropMenuView.h
//  LSDropMenuView
//
//  Created by Coder_Mr on 2017/7/5.
//  Copyright © 2017年 Coder_Mr. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LSDropMenuView;
@class LSIndexPath;

@protocol LSDropMenuViewDataSource <NSObject>

@required

/**
 column是否有两行tableView
 */
- (BOOL)dropMenuView:(LSDropMenuView *)view haveRightAtColumn:(NSInteger)column;


/**
 column中有多少row 如果is 为YES 则返回第二个tableView中row的个数
 */
- (NSInteger)dropMenuView:(LSDropMenuView *)view numberOfRowsAtColumn:(NSInteger)column isRightColumn:(BOOL)is leftSelecteRow:(NSInteger)leftRow;


/**
 indexPath.column indexPath.row 对应按钮的列数  里边tableView.row(左边table)
 is为YES 则subRow是右边tableView.row
 
 */
- (NSString *)dropMenuView:(LSDropMenuView *)view titleOfRowsAtIndexPath:(LSIndexPath *)indexPath isRightColumn:(BOOL)is subRow:(NSInteger)row;

@optional

/**
 返回有多少列 （按钮默认是每个column的第一个cell文字的title）
 */
- (NSInteger)numberOfColumnsInDropMenuView:(LSDropMenuView *)view;



@end


@protocol LSDropMenuViewDelegate <NSObject>


@optional


/**
 返回每个展示tableView的rowheight （default 44）
 */
- (CGFloat)dropMenuView:(LSDropMenuView *)view heightForRowsAtColumn:(NSInteger)column isRightColumn:(BOOL)is subRow:(NSInteger)row;

/**
 选中第indexPath.column个btn下的左边tab的indexPath.row
 is为YES subRow是右边tab选中的row
 
 */
- (void)dropMenuView:(LSDropMenuView *)view didSelectedRowAtIndexPath:(LSIndexPath *)indexPath isRightColumn:(BOOL)is subRow:(NSInteger)row;


@end


@interface LSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column; //列

@property (nonatomic, assign) NSInteger row; //行

@property (nonatomic, assign) NSInteger subRow; //subRow

@end

@interface LSDropButton : UIView



@end



@interface LSDropMenuView : UIView

@property (nonatomic, weak) id <LSDropMenuViewDelegate> delegate;

@property (nonatomic, weak) id <LSDropMenuViewDataSource> dataSource;

@property (nonatomic, assign) BOOL autoSelectPreAction; //自动选择上次所选item Default is YES

//dropBtn
@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, strong) UIColor *btnHighlightedColor;
@property (nonatomic, strong) UIFont *btnFont;
@property (nonatomic, strong) UIImage *btnIndicatorImg;
@property (nonatomic, strong) UIImage *btnHighlightedIndicatorImg;
//cell
@property (nonatomic, strong) UIColor *cellTextColor;
@property (nonatomic, strong) UIColor *cellSelectedTextColor;
@property (nonatomic, strong) UIFont *cellTextFont;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;
//选中时右边的指示imgae
@property (nonatomic, strong) UIImage *indicatorImage;
//背景View
@property (nonatomic, strong) UIColor *bottomBgColor;
//default 80% of Screen
@property (nonatomic, assign) CGFloat tableViewMaxPercentInView;

//cell不能填充满bottomView时 自动调节tableView 高度
@property (nonatomic, assign) BOOL autoAdjustTableViewHeightWhenCellUnderFilling;

//default 44
@property (nonatomic, assign) CGFloat rowHeight;



- (void)reloadData;
@end
