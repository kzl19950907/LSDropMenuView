//
//  MarkdownDemoViewController.m
//  LSDropMenuView
//
//  Created by Codegen on 2024/06/11.
//  Copyright © 2024 kzl19950907. All rights reserved.
//

#import "MarkdownDemoViewController.h"
#import "MarkdownParser.h"

@interface MarkdownDemoViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSString *markdownContent;

@end

@implementation MarkdownDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Markdown解析器演示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self loadMarkdownContent];
    [self updateDisplay];
}

- (void)setupUI {
    // 创建分段控制器
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"富文本显示", @"HTML源码"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.segmentedControl];
    
    // 创建文本视图
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textView];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.segmentedControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.textView.topAnchor constraintEqualToAnchor:self.segmentedControl.bottomAnchor constant:20],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.textView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
    ]];
}

- (void)loadMarkdownContent {
    // 从README.md文件加载内容，如果文件不存在则使用示例内容
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"README" ofType:@"md"];
    if (readmePath) {
        NSError *error;
        self.markdownContent = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            self.markdownContent = [self sampleMarkdownContent];
        }
    } else {
        self.markdownContent = [self sampleMarkdownContent];
    }
}

- (NSString *)sampleMarkdownContent {
    return @"# Markdown解析器演示\n\n"
           @"这是一个**功能强大**的Markdown解析器，支持多种语法。\n\n"
           @"## 支持的功能\n\n"
           @"### 文本样式\n"
           @"- **粗体文本**\n"
           @"- *斜体文本*\n"
           @"- ~~删除线文本~~\n"
           @"- `行内代码`\n\n"
           @"### 链接\n"
           @"访问 [GitHub](https://github.com) 了解更多信息。\n\n"
           @"### 引用\n"
           @"> 这是一个引用块\n"
           @"> 可以包含多行内容\n\n"
           @"### 列表\n"
           @"* 无序列表项1\n"
           @"* 无序列表项2\n"
           @"* 无序列表项3\n\n"
           @"1. 有序列表项1\n"
           @"2. 有序列表项2\n"
           @"3. 有序列表项3\n\n"
           @"### 代码块\n"
           @"```swift\n"
           @"let parser = MarkdownParser()\n"
           @"let result = parser.parse(markdownText)\n"
           @"```\n\n"
           @"这个解析器可以将Markdown文本转换为NSAttributedString或HTML格式。";
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    [self updateDisplay];
}

- (void)updateDisplay {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        // 显示富文本
        NSAttributedString *attributedString = [MarkdownParser parseMarkdown:self.markdownContent
                                                                     baseFont:[UIFont systemFontOfSize:16]
                                                                    textColor:[UIColor blackColor]];
        self.textView.attributedText = attributedString;
    } else {
        // 显示HTML源码
        NSString *htmlString = [MarkdownParser parseMarkdownToHTML:self.markdownContent];
        self.textView.text = htmlString;
        self.textView.font = [UIFont fontWithName:@"Courier" size:14] ?: [UIFont monospacedSystemFontOfSize:14 weight:UIFontWeightRegular];
    }
}

@end

