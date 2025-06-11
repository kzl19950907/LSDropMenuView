# Markdown解析器

一个功能强大的iOS Markdown解析器，支持将Markdown文本转换为NSAttributedString或HTML格式。

## 功能特性

### 支持的Markdown语法

- **标题** (H1, H2, H3)
- **文本样式**
  - **粗体** (`**文本**`)
  - *斜体* (`*文本*`)
  - ~~删除线~~ (`~~文本~~`)
  - `行内代码` (`` `代码` ``)
- **链接** (`[文本](URL)`)
- **引用** (`> 引用文本`)
- **列表**
  - 无序列表 (`* 项目` 或 `- 项目`)
  - 有序列表 (`1. 项目`)
- **代码块** (``` 代码块 ```)

### 输出格式

1. **NSAttributedString** - 用于在UILabel、UITextView等控件中显示富文本
2. **HTML** - 用于Web显示或其他需要HTML格式的场景

## 使用方法

### 基本用法

```objective-c
#import "MarkdownParser.h"

// 解析为NSAttributedString（使用默认样式）
NSString *markdownText = @"# 标题\n\n这是**粗体**和*斜体*文本。";
NSAttributedString *attributedString = [MarkdownParser parseMarkdown:markdownText];

// 在UITextView中显示
UITextView *textView = [[UITextView alloc] init];
textView.attributedText = attributedString;
```

### 自定义样式

```objective-c
// 使用自定义字体和颜色
UIFont *baseFont = [UIFont systemFontOfSize:18];
UIColor *textColor = [UIColor darkGrayColor];

NSAttributedString *styledText = [MarkdownParser parseMarkdown:markdownText
                                                      baseFont:baseFont
                                                     textColor:textColor];
```

### 转换为HTML

```objective-c
// 解析为HTML字符串
NSString *htmlString = [MarkdownParser parseMarkdownToHTML:markdownText];

// 在UIWebView中显示
UIWebView *webView = [[UIWebView alloc] init];
[webView loadHTMLString:htmlString baseURL:nil];
```

## 演示

项目中包含了一个演示控制器 `MarkdownDemoViewController`，展示了如何使用解析器：

```objective-c
#import "MarkdownDemoViewController.h"

// 在你的应用中显示演示
MarkdownDemoViewController *demoVC = [[MarkdownDemoViewController alloc] init];
[self.navigationController pushViewController:demoVC animated:YES];
```

## 测试

项目包含了完整的单元测试，验证解析器的各项功能：

- 基本Markdown语法解析
- HTML输出格式
- 边界情况处理（空输入、nil输入等）
- 链接解析
- 代码块解析
- 列表解析
- 引用解析

运行测试：
```bash
xcodebuild test -scheme LSDropMenuView -destination 'platform=iOS Simulator,name=iPhone 14'
```

## 文件结构

```
MarkdownParser/
├── MarkdownParser.h              # 解析器头文件
├── MarkdownParser.m              # 解析器实现
├── MarkdownDemoViewController.h  # 演示控制器头文件
├── MarkdownDemoViewController.m  # 演示控制器实现
├── MarkdownParserTests.m         # 单元测试
└── README.md                     # 说明文档
```

## 性能特点

- 轻量级实现，无外部依赖
- 支持实时解析
- 内存使用优化
- 支持大文档解析

## 扩展性

解析器采用模块化设计，可以轻松扩展支持更多Markdown语法：

1. 在 `parseLine:baseFont:textColor:` 方法中添加新的行级语法处理
2. 在 `parseInlineStyles:baseFont:textColor:` 方法中添加新的内联样式处理
3. 在 `parseMarkdownToHTML:` 方法中添加对应的HTML输出支持

## 许可证

本项目遵循MIT许可证。

