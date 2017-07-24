
//
//  LSDropMenuView.m
//  LSDropMenuView
//
//  Created by Coder_Mr on 2017/7/5.
//  Copyright © 2017年 Coder_Mr. All rights reserved.
//


#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.8]

#define kDefaultOffset CGPointMake(-1,-1) //第一个参数代表左边tab 第二个参数是右边tab 如果为-1 则不包含rightTab
#define kDefaultSelecte [NSIndexPath indexPathForRow:-1 inSection:-1] //-1代表未选择 row代表右边tab选择 section 左边tab选择



#import "LSDropMenuView.h"


@interface LSDropButton ()

@property (nonatomic, strong) UIImageView *indicatorImgView; //选中指示imgView

@property (nonatomic, strong) UILabel *titleLabel; //文字

@property (nonatomic, copy) NSString *title; //

@property (nonatomic, assign) BOOL selected; //是否选中

@property (nonatomic, assign) CGFloat maxWidth; //文字最大宽度

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign) CGFloat titleImgMarginX; //文字 指示imgView 间距

@property (nonatomic, strong) UIImage *indicatorImg;

@property (nonatomic, strong) UIImage *highlightedIndicatorImg;
@end

@implementation LSDropButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _selected = NO;
        self.font = [UIFont systemFontOfSize:10];
        self.color = [UIColor blackColor];
        self.selectedColor = [UIColor blueColor];
        self.titleImgMarginX = 5;
        self.maxWidth = 80;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = self.color;
        [self addSubview:self.titleLabel];
        self.indicatorImgView = [[UIImageView alloc] init];
        self.indicatorImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.indicatorImgView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected{
    
    _selected = selected;
    self.titleLabel.textColor = selected?self.selectedColor:self.color;
    self.indicatorImgView.image = selected?self.highlightedIndicatorImg:self.indicatorImg;
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    //
    CGSize titleSize = [self.title boundingRectWithSize:CGSizeMake(_maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    //img
    CGFloat imgH = 8;
    CGFloat imgW = 8;
    //self
    CGFloat sumW = self.frame.size.width;
    CGFloat sumH = self.frame.size.height;
    CGFloat titleX = (sumW - titleSize.width - self.titleImgMarginX -imgW) / 2;
    
    self.titleLabel.font = self.font;
    self.titleLabel.frame = CGRectMake(titleX, (sumH - titleSize.height) / 2, titleSize.width, titleSize.height);
    self.indicatorImgView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+self.titleImgMarginX, (sumH - imgH) / 2, imgW, imgH);
    self.indicatorImgView.image = self.selected?self.highlightedIndicatorImg:self.indicatorImg;
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = _selected?self.selectedColor:self.color;
    
}

@end










@interface LSIndexPath ()

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;

@end

@implementation LSIndexPath
- (instancetype)init{
    
    if (self = [super init]) {
        
        _column = 0;
        _row = 0;
        
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row{
    
    LSIndexPath *temp = [[self alloc] init];
    temp.column = column;
    temp.row = row;
    return temp;
}

@end




@interface LSTableViewCell : UITableViewCell

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIColor *selecteColor;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *selecteBgColor;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIFont *font;

@end

@interface LSTableViewCell ()

@property (nonatomic, strong) UILabel *ls_textLabel;

@property (nonatomic, strong) UIImageView *selecteImgView;

@end

@implementation LSTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _color = [UIColor blackColor];
        _selecteColor = [UIColor blueColor];
        self.ls_textLabel = [[UILabel alloc] init];
        self.ls_textLabel.textColor = self.color;
        [self addSubview:self.ls_textLabel];
        self.selecteImgView = [[UIImageView alloc] init];
        [self addSubview:self.selecteImgView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat leftX = 25;
    CGFloat rightX = 10;
    CGFloat imgW = 20;
    CGFloat imgH = 20;
    self.ls_textLabel.font = _font;
    self.ls_textLabel.frame = CGRectMake(leftX, 0, self.frame.size.width, self.frame.size.height);
    self.selecteImgView.frame = CGRectMake(self.frame.size.width-rightX-imgW , (self.frame.size.height-imgH)/2, imgW, imgH);
    self.backgroundColor = self.selected?self.selecteBgColor:self.bgColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    self.ls_textLabel.textColor = selected?self.selecteColor:self.color;
    self.selecteImgView.hidden = !selected;
    
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.ls_textLabel.text = title;
}

@end





#define selfX self.frame.origin.x
#define selfY self.frame.origin.y
#define selfW self.frame.size.width
#define selfH self.frame.size.height
#define bottomH [UIScreen mainScreen].bounds.size.height
#define tabH 0.8 * bottomH

@interface LSDropMenuView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isUnFold; //是否展开

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIView *bottomView;

//@property (nonatomic, strong) NSArray <LSIndexPath *> *selecteArray;

@property (nonatomic, strong) NSArray *btns;

@property (nonatomic, assign) NSInteger currentSelectColumn; //当前选中的列

@property (nonatomic, strong) NSMutableArray *offsetArray; //偏移数据

@property (nonatomic, strong) NSMutableArray *indexPathArray; //选中数据

@property (nonatomic, strong) NSMutableArray *tableViewHArray;//背景View 高度

//临时选中记录
@property (nonatomic, assign) NSInteger tempSelectColumn;

@property (nonatomic, assign) CGPoint tempSelectOffset;

@property (nonatomic, assign) NSInteger tempSelectRow;

@end


@implementation LSDropMenuView



- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        _isUnFold = NO;
        _currentSelectColumn = -1;
        _autoSelectPreAction = YES;
        
        _tempSelectRow = -1;
        _tempSelectOffset = kDefaultOffset;
        _tempSelectColumn = -1;
        
        //dropBtn
        _btnColor = [UIColor blackColor];
        _btnHighlightedColor = [UIColor blueColor];
        _btnFont = [UIFont systemFontOfSize:12];
        //cell
        //        _cellTextColor = [UIColor cyanColor];
        //        _cellSelectedTextColor = [UIColor redColor];
        //        _cellTextFont = [UIFont systemFontOfSize:14];
        //        _cellBackgroundColor = [UIColor lightGrayColor];
        //        _cellSelectedBackgroundColor = [UIColor brownColor];
        //选中时右边的指示imgae
        //        _indicatorImage = nil;
        
        _bottomBgColor = kSeparatorColor;
        
        //rowheight
        _rowHeight = 44;
        //
        //
        _tableViewMaxPercentInView = 0.8;
        _autoAdjustTableViewHeightWhenCellUnderFilling = YES;
        
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, selfY+selfH, selfW, 0)];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenuView:)];
        [_bottomView addGestureRecognizer:tapGes];
        
    }
    return self;
}

- (void)setDataSource:(id<LSDropMenuViewDataSource>)dataSource{
    
    _dataSource = dataSource;
    
    [self reloadData];
}

- (void)reloadData{
    _bottomView.backgroundColor = _bottomBgColor;
    //配置菜单按钮
    [self configMenuBtns];
    //配置bottomView 高度缓存
    [self configTableViewH];
    if (!_autoSelectPreAction) {
        return;
    }
    //配置历史选择 位移数据
    [self configHistorySelected];
    
}


#pragma mark --- 初始化选择点按按钮
- (void)configMenuBtns{
    
    for (UIView *temp in self.subviews) {
        
        [temp removeFromSuperview];
    }
    NSInteger btnCount = 1;
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInDropMenuView:)]) {
        
        btnCount = [_dataSource numberOfColumnsInDropMenuView:self];
    }
    
    CGFloat btnW = selfW / btnCount;
    NSMutableArray *temp = [NSMutableArray array];
    for (int i  = 0; i < btnCount; i ++) {
        CGFloat btnX = i * btnW;
        LSDropButton *btn = [[LSDropButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, selfH)];
        //获取默认title
        btn.title = [_dataSource dropMenuView:self titleOfRowsAtIndexPath:[LSIndexPath indexPathWithColumn:i row:0] isRightColumn:NO subRow:0];
        if ([_dataSource dropMenuView:self haveRightAtColumn:i]) {
            
            btn.title = [_dataSource dropMenuView:self titleOfRowsAtIndexPath:[LSIndexPath indexPathWithColumn:i row:0] isRightColumn:YES subRow:0];
        }
        btn.font = _btnFont;
        btn.color = _btnColor;
        btn.selectedColor = _btnHighlightedColor;
        btn.indicatorImg = _btnIndicatorImg;
        btn.highlightedIndicatorImg = _btnHighlightedIndicatorImg;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropMenuBtnClick:)];
        [btn addGestureRecognizer:tapGes];
        [temp addObject:btn];
        [self addSubview:btn];
    }
    _btns = [temp copy];
}

#pragma mark --- 配置tableView的高度
- (void)configTableViewH{
    
    NSInteger num = [_dataSource numberOfColumnsInDropMenuView:self];
    _tableViewHArray = [NSMutableArray array];
    for (int i = 0; i < num; i ++) {
        
        NSInteger tempNum = [_dataSource dropMenuView:self numberOfRowsAtColumn:i isRightColumn:NO leftSelecteRow:0];
        
        CGFloat tempH = _rowHeight;
        
        //auto = NO 不调节 直接全部按_tableViewMaxPercentInView 来
        //auto = YES 调节 超过_tableViewMaxPercentInView 按照_tableViewMaxPercentInView
        //                不超过 原来高度
        if (_delegate && [_delegate respondsToSelector:@selector(dropMenuView:heightForRowsAtColumn:isRightColumn:subRow:)]) {
            
            tempH = [_delegate dropMenuView:self heightForRowsAtColumn:i isRightColumn:NO subRow:0];
            
        }
        
        CGFloat limitH = [UIScreen mainScreen].bounds.size.height * _tableViewMaxPercentInView;
        CGFloat maxH = tempH*tempNum > limitH ?limitH:tempNum*tempH;
        if (!_autoAdjustTableViewHeightWhenCellUnderFilling) {
            
            maxH = limitH;
        }
        [_tableViewHArray addObject:[NSNumber numberWithFloat:maxH]];
    }
    
}

#pragma mark --- 初始化记录offset 选中行列
- (void)configHistorySelected{
    
    _offsetArray = [NSMutableArray array];
    _indexPathArray = [NSMutableArray array];
    for (int i = 0; i < _btns.count; i++) {
        
        [_offsetArray addObject:NSStringFromCGPoint(kDefaultOffset)];
        [_indexPathArray addObject:kDefaultSelecte];
    }
    
}

#pragma mark --- 按钮点击触发事件

- (void)dropMenuBtnClick:(UITapGestureRecognizer *)ges{
    
    LSDropButton *btn = (LSDropButton *)ges.view;
    //改变按钮state
    [self changeSelecteStateWithBtn:btn];
}


- (void)changeSelecteStateWithBtn:(LSDropButton *)btn{
    
    btn.selected = !btn.selected;
    if (_isUnFold) {
        //展开状态
        if (btn.selected) {
            //选中 展开
            _isUnFold = YES;
            //取消原来按钮选中
            LSDropButton *temp = _btns[_currentSelectColumn];
            temp.selected = NO;
            _currentSelectColumn = [_btns indexOfObject:btn];
            
        }else{
            
            _isUnFold = NO;
        }
    }else{
        
        //折叠
        _currentSelectColumn = [_btns indexOfObject:btn];
        _isUnFold = YES;
    }
    //reload子控件
    [self reloadDropMenuView];
}

#pragma mark --- 重新加载子控件

- (void)reloadDropMenuView{
    
    //清除缓存记录 （只点击了lefttable && 有两个table）
    if (_tempSelectColumn != -1 && _tempSelectColumn != _currentSelectColumn) {
        
        _tempSelectColumn = -1;
        _tempSelectRow = -1;
        _tempSelectOffset = CGPointMake(-1, -1);
    }
    //状态转换
    if (_isUnFold) {
        //展开状态
        BOOL haveRight = [_dataSource dropMenuView:self haveRightAtColumn:_currentSelectColumn];
        _leftTableView.frame = CGRectMake(selfX, selfY+selfH, haveRight?selfW/2:selfW, [self.tableViewHArray[_currentSelectColumn] floatValue]);
        _rightTableView.frame = CGRectMake(haveRight?selfW/2:0, selfY+selfH, haveRight?selfW/2:selfW, haveRight?[self.tableViewHArray[_currentSelectColumn] floatValue]:0);
        _bottomView.frame = CGRectMake(selfX, selfY+selfH, selfW, bottomH);
        //重置tab
        [_leftTableView setContentOffset:CGPointZero];
        [_rightTableView setContentOffset:CGPointZero];
        [_leftTableView reloadData];
        _tempSelectRow = 0;
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [_rightTableView reloadData];
        
        //选择选中历史记录 和 offset
        if (_offsetArray) {
            CGPoint offset = CGPointFromString(_offsetArray[_currentSelectColumn]);
            [_leftTableView setContentOffset:CGPointMake(0, offset.x == -1?0:offset.x)];
            [_rightTableView setContentOffset:CGPointMake(0, offset.y == -1?0:offset.y)];
        }
        if (_indexPathArray) {
            NSIndexPath *indexPath = _indexPathArray[_currentSelectColumn];
            
            if (indexPath.section != -1) {
                
                [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            //左边默认选中历史记录选中  然后刷新右侧数据
            _tempSelectRow = indexPath.section;
            [_rightTableView reloadData];
            if (indexPath.row != -1) {
                [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        [self.superview addSubview:_bottomView];
        //        [self.superview bringSubviewToFront:self];
        [self.superview addSubview:_leftTableView];
        [self.superview addSubview:_rightTableView];
        
    }else{
        
        //折叠状态
        BOOL haveRight = [_dataSource dropMenuView:self haveRightAtColumn:_currentSelectColumn];
        [UIView animateWithDuration:0.2 animations:^{
            
            _leftTableView.frame = CGRectMake(selfX, selfY+selfH, haveRight?selfW/2:selfW, 0);
            _rightTableView.frame = CGRectMake(haveRight?selfW/2:selfX, selfY+selfH, haveRight?selfW/2:selfW, 0);
            _bottomView.alpha = 1;
        } completion:^(BOOL finished) {
            
            if (!finished) {
                return ;
            }
            if ([self.superview.subviews containsObject:_bottomView]) {
                
                [_bottomView removeFromSuperview];
            }
        }];
    }
}

#pragma mark --- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _leftTableView) {
        
        NSInteger rows = [_dataSource dropMenuView:self numberOfRowsAtColumn:_currentSelectColumn isRightColumn:NO leftSelecteRow:0];
        return rows;
    }else if(tableView == _rightTableView){
        
        NSInteger rows = [_dataSource dropMenuView:self numberOfRowsAtColumn:_currentSelectColumn isRightColumn:YES leftSelecteRow:_tempSelectRow==-1?0:_tempSelectRow] ;
        return rows;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"LSDropMenuViewCell";
    LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[LSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.color = _cellTextColor;
        cell.selecteColor = _cellSelectedTextColor;
        cell.font = _cellTextFont;
        cell.bgColor = _cellBackgroundColor;
        cell.selecteBgColor = _cellSelectedBackgroundColor;
        cell.selecteImgView.image = _indicatorImage;
    }
    cell.title = [_dataSource dropMenuView:self titleOfRowsAtIndexPath:[LSIndexPath indexPathWithColumn:_currentSelectColumn row:(tableView == _rightTableView?_tempSelectRow==-1?0:_tempSelectRow:indexPath.row)] isRightColumn:(tableView == _rightTableView) subRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL haveRight = [_dataSource dropMenuView:self haveRightAtColumn:_currentSelectColumn];
    if (!haveRight) {
        //只有一个tab
        CGPoint offset = CGPointMake(_leftTableView.contentOffset.y, -1);
        _offsetArray[_currentSelectColumn] = NSStringFromCGPoint(offset);
        _indexPathArray[_currentSelectColumn] = [NSIndexPath indexPathForRow:-1 inSection:indexPath.row];
        NSString *title = [_dataSource dropMenuView:self titleOfRowsAtIndexPath:[LSIndexPath indexPathWithColumn:_currentSelectColumn row:indexPath.row] isRightColumn:haveRight subRow:0];
        LSDropButton *btn = _btns[_currentSelectColumn];
        btn.title = title;
        [self changeSelecteStateWithBtn:btn];
        if (_delegate && [_delegate respondsToSelector:@selector(dropMenuView:didSelectedRowAtIndexPath:isRightColumn:subRow:)]) {
            
            [_delegate dropMenuView:self didSelectedRowAtIndexPath:[LSIndexPath indexPathWithColumn:self.currentSelectColumn row:(tableView == _rightTableView?_tempSelectRow:indexPath.row)] isRightColumn:tableView==_rightTableView subRow:tableView==_rightTableView?indexPath.row:0];
        }
        return;
    }
    if (tableView == _leftTableView && haveRight) {
        
        //暂时记录当前的offset indexPath.row currentColumn
        _tempSelectRow = indexPath.row;
        _tempSelectColumn = _currentSelectColumn;
        _tempSelectOffset = _leftTableView.contentOffset;
        //刷新数据源
        [_rightTableView reloadData];
        
    }
    if (tableView == _rightTableView && haveRight) {
        
        if (_tempSelectRow == -1) {
            //排除未选择left 直接选择right情况
            _tempSelectRow = 0;
            _tempSelectColumn = _currentSelectColumn;
            _tempSelectOffset = _leftTableView.contentOffset;
        }
        //记录offset 选中行
        CGPoint offset = CGPointMake(_tempSelectOffset.y, _rightTableView.contentOffset.y);
        _offsetArray[_currentSelectColumn] = NSStringFromCGPoint(offset);
        _indexPathArray[_currentSelectColumn] = [NSIndexPath indexPathForRow:indexPath.row inSection:_tempSelectRow];
        //改变文字
        NSString *title = [_dataSource dropMenuView:self titleOfRowsAtIndexPath:[LSIndexPath indexPathWithColumn:_currentSelectColumn row:_tempSelectRow] isRightColumn:haveRight subRow:indexPath.row];
        LSDropButton *btn = _btns[_currentSelectColumn];
        btn.title = title;
        if (_delegate && [_delegate respondsToSelector:@selector(dropMenuView:didSelectedRowAtIndexPath:isRightColumn:subRow:)]) {
            
            [_delegate dropMenuView:self didSelectedRowAtIndexPath:[LSIndexPath indexPathWithColumn:self.currentSelectColumn row:(tableView == _rightTableView?_tempSelectRow:indexPath.row)] isRightColumn:tableView==_rightTableView subRow:tableView==_rightTableView?indexPath.row:0];
        }
        [self changeSelecteStateWithBtn:btn];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_delegate && [_delegate respondsToSelector:(@selector(dropMenuView:heightForRowsAtColumn:isRightColumn:subRow:))]) {
        
        BOOL haveRight = [_dataSource dropMenuView:self haveRightAtColumn:_currentSelectColumn];

        if (!haveRight) {
            //只有一个tab
            CGFloat tempH = [_delegate dropMenuView:self heightForRowsAtColumn:_currentSelectColumn isRightColumn:NO subRow:0];
            return tempH;
        }
        
        if (tableView == _leftTableView) {
            
            CGFloat tempH = [_delegate dropMenuView:self heightForRowsAtColumn:_currentSelectColumn isRightColumn:NO subRow:indexPath.row];
            return tempH;
        }
        if (tableView == _rightTableView) {
                        
            CGFloat tempH = [_delegate dropMenuView:self heightForRowsAtColumn:_currentSelectColumn isRightColumn:YES subRow:indexPath.row];
            return tempH;
        }
    }
    
    return _rowHeight;
}




#pragma mark ---  点击收起MenuView
- (void)dismissMenuView:(UIGestureRecognizer *)ges{
    
    LSDropButton *temp = _btns[_currentSelectColumn];
    [self changeSelecteStateWithBtn:temp];
    
}






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
