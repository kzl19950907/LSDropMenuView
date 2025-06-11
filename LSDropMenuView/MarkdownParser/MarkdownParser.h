//
//  MarkdownParser.h
//  LSDropMenuView
//
//  Created by Codegen on 2024/06/11.
//  Copyright © 2024 kzl19950907. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Markdown解析器 - 支持常见的Markdown语法解析
 * 可以将Markdown文本转换为NSAttributedString用于显示
 */
@interface MarkdownParser : NSObject

/**
 * 解析Markdown文本为NSAttributedString
 * @param markdownText 要解析的Markdown文本
 * @return 解析后的富文本
 */
+ (NSAttributedString *)parseMarkdown:(NSString *)markdownText;

/**
 * 解析Markdown文本为NSAttributedString，支持自定义样式
 * @param markdownText 要解析的Markdown文本
 * @param baseFont 基础字体
 * @param textColor 基础文本颜色
 * @return 解析后的富文本
 */
+ (NSAttributedString *)parseMarkdown:(NSString *)markdownText
                             baseFont:(UIFont *)baseFont
                            textColor:(UIColor *)textColor;

/**
 * 解析Markdown文本为HTML
 * @param markdownText 要解析的Markdown文本
 * @return HTML字符串
 */
+ (NSString *)parseMarkdownToHTML:(NSString *)markdownText;

@end

NS_ASSUME_NONNULL_END

