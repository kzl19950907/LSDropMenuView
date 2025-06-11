//
//  MarkdownParser.m
//  LSDropMenuView
//
//  Created by Codegen on 2024/06/11.
//  Copyright © 2024 kzl19950907. All rights reserved.
//

#import "MarkdownParser.h"

@implementation MarkdownParser

+ (NSAttributedString *)parseMarkdown:(NSString *)markdownText {
    return [self parseMarkdown:markdownText
                      baseFont:[UIFont systemFontOfSize:16]
                     textColor:[UIColor blackColor]];
}

+ (NSAttributedString *)parseMarkdown:(NSString *)markdownText
                             baseFont:(UIFont *)baseFont
                            textColor:(UIColor *)textColor {
    if (!markdownText || markdownText.length == 0) {
        return [[NSAttributedString alloc] init];
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    NSArray *lines = [markdownText componentsSeparatedByString:@"\n"];
    
    for (NSInteger i = 0; i < lines.count; i++) {
        NSString *line = lines[i];
        NSAttributedString *parsedLine = [self parseLine:line baseFont:baseFont textColor:textColor];
        [result appendAttributedString:parsedLine];
        
        // 添加换行符（除了最后一行）
        if (i < lines.count - 1) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    
    return [result copy];
}

+ (NSAttributedString *)parseLine:(NSString *)line
                         baseFont:(UIFont *)baseFont
                        textColor:(UIColor *)textColor {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    // 处理标题
    if ([line hasPrefix:@"# "]) {
        NSString *title = [line substringFromIndex:2];
        UIFont *titleFont = [UIFont boldSystemFontOfSize:baseFont.pointSize * 1.5];
        NSDictionary *attributes = @{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: textColor
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:attributes]];
    }
    else if ([line hasPrefix:@"## "]) {
        NSString *title = [line substringFromIndex:3];
        UIFont *titleFont = [UIFont boldSystemFontOfSize:baseFont.pointSize * 1.3];
        NSDictionary *attributes = @{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: textColor
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:attributes]];
    }
    else if ([line hasPrefix:@"### "]) {
        NSString *title = [line substringFromIndex:4];
        UIFont *titleFont = [UIFont boldSystemFontOfSize:baseFont.pointSize * 1.1];
        NSDictionary *attributes = @{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: textColor
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:attributes]];
    }
    // 处理引用
    else if ([line hasPrefix:@"> "]) {
        NSString *quote = [line substringFromIndex:2];
        UIFont *quoteFont = [UIFont italicSystemFontOfSize:baseFont.pointSize];
        NSDictionary *attributes = @{
            NSFontAttributeName: quoteFont,
            NSForegroundColorAttributeName: [UIColor grayColor],
            NSBackgroundColorAttributeName: [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@"  " stringByAppendingString:quote] attributes:attributes]];
    }
    // 处理列表
    else if ([line hasPrefix:@"* "] || [line hasPrefix:@"- "]) {
        NSString *listItem = [line substringFromIndex:2];
        NSString *bulletPoint = @"• ";
        NSDictionary *bulletAttributes = @{
            NSFontAttributeName: baseFont,
            NSForegroundColorAttributeName: textColor
        };
        NSDictionary *textAttributes = @{
            NSFontAttributeName: baseFont,
            NSForegroundColorAttributeName: textColor
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:bulletPoint attributes:bulletAttributes]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:listItem attributes:textAttributes]];
    }
    // 处理有序列表
    else if ([self isOrderedListItem:line]) {
        NSDictionary *attributes = @{
            NSFontAttributeName: baseFont,
            NSForegroundColorAttributeName: textColor
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:line attributes:attributes]];
    }
    // 处理代码块
    else if ([line hasPrefix:@"```"]) {
        UIFont *codeFont = [UIFont fontWithName:@"Courier" size:baseFont.pointSize] ?: [UIFont monospacedSystemFontOfSize:baseFont.pointSize weight:UIFontWeightRegular];
        NSDictionary *attributes = @{
            NSFontAttributeName: codeFont,
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1.0],
            NSBackgroundColorAttributeName: [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
        };
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:line attributes:attributes]];
    }
    // 处理普通文本（包含内联样式）
    else {
        NSAttributedString *parsedInline = [self parseInlineStyles:line baseFont:baseFont textColor:textColor];
        [result appendAttributedString:parsedInline];
    }
    
    return [result copy];
}

+ (NSAttributedString *)parseInlineStyles:(NSString *)text
                                 baseFont:(UIFont *)baseFont
                                textColor:(UIColor *)textColor {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    NSString *currentText = text;
    
    // 基础属性
    NSDictionary *baseAttributes = @{
        NSFontAttributeName: baseFont,
        NSForegroundColorAttributeName: textColor
    };
    
    // 处理粗体 **text**
    currentText = [self processInlineStyle:currentText
                                    result:result
                                   pattern:@"\\*\\*([^*]+)\\*\\*"
                            baseAttributes:baseAttributes
                           customAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:baseFont.pointSize]}];
    
    // 处理斜体 *text*
    currentText = [self processInlineStyle:currentText
                                    result:result
                                   pattern:@"\\*([^*]+)\\*"
                            baseAttributes:baseAttributes
                           customAttributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:baseFont.pointSize]}];
    
    // 处理删除线 ~~text~~
    currentText = [self processInlineStyle:currentText
                                    result:result
                                   pattern:@"~~([^~]+)~~"
                            baseAttributes:baseAttributes
                           customAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    // 处理行内代码 `code`
    UIFont *codeFont = [UIFont fontWithName:@"Courier" size:baseFont.pointSize] ?: [UIFont monospacedSystemFontOfSize:baseFont.pointSize weight:UIFontWeightRegular];
    currentText = [self processInlineStyle:currentText
                                    result:result
                                   pattern:@"`([^`]+)`"
                            baseAttributes:baseAttributes
                           customAttributes:@{
                               NSFontAttributeName: codeFont,
                               NSBackgroundColorAttributeName: [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
                           }];
    
    // 处理链接 [text](url)
    currentText = [self processLinks:currentText result:result baseAttributes:baseAttributes];
    
    // 添加剩余的普通文本
    if (currentText.length > 0) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:currentText attributes:baseAttributes]];
    }
    
    return [result copy];
}

+ (NSString *)processInlineStyle:(NSString *)text
                          result:(NSMutableAttributedString *)result
                         pattern:(NSString *)pattern
                  baseAttributes:(NSDictionary *)baseAttributes
                 customAttributes:(NSDictionary *)customAttributes {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) return text;
    
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    if (matches.count == 0) return text;
    
    NSMutableString *remainingText = [text mutableCopy];
    NSInteger offset = 0;
    
    for (NSTextCheckingResult *match in matches) {
        NSRange fullRange = NSMakeRange(match.range.location - offset, match.range.length);
        NSRange contentRange = NSMakeRange(match.rangeAtIndex:1.location - offset, match.rangeAtIndex:1.length);
        
        // 添加匹配前的文本
        if (fullRange.location > 0) {
            NSString *beforeText = [remainingText substringToIndex:fullRange.location];
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:beforeText attributes:baseAttributes]];
        }
        
        // 添加样式化的文本
        NSString *styledText = [remainingText substringWithRange:contentRange];
        NSMutableDictionary *styledAttributes = [baseAttributes mutableCopy];
        [styledAttributes addEntriesFromDictionary:customAttributes];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:styledText attributes:styledAttributes]];
        
        // 移除已处理的文本
        [remainingText deleteCharactersInRange:NSMakeRange(0, fullRange.location + fullRange.length)];
        offset += fullRange.location + fullRange.length;
    }
    
    return [remainingText copy];
}

+ (NSString *)processLinks:(NSString *)text
                    result:(NSMutableAttributedString *)result
            baseAttributes:(NSDictionary *)baseAttributes {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[([^\\]]+)\\]\\(([^\\)]+)\\)" options:0 error:&error];
    if (error) return text;
    
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    if (matches.count == 0) return text;
    
    NSMutableString *remainingText = [text mutableCopy];
    NSInteger offset = 0;
    
    for (NSTextCheckingResult *match in matches) {
        NSRange fullRange = NSMakeRange(match.range.location - offset, match.range.length);
        NSRange textRange = NSMakeRange(match.rangeAtIndex:1.location - offset, match.rangeAtIndex:1.length);
        NSRange urlRange = NSMakeRange(match.rangeAtIndex:2.location - offset, match.rangeAtIndex:2.length);
        
        // 添加链接前的文本
        if (fullRange.location > 0) {
            NSString *beforeText = [remainingText substringToIndex:fullRange.location];
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:beforeText attributes:baseAttributes]];
        }
        
        // 添加链接文本
        NSString *linkText = [remainingText substringWithRange:textRange];
        NSString *linkURL = [remainingText substringWithRange:urlRange];
        NSMutableDictionary *linkAttributes = [baseAttributes mutableCopy];
        linkAttributes[NSForegroundColorAttributeName] = [UIColor blueColor];
        linkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        linkAttributes[NSLinkAttributeName] = linkURL;
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:linkText attributes:linkAttributes]];
        
        // 移除已处理的文本
        [remainingText deleteCharactersInRange:NSMakeRange(0, fullRange.location + fullRange.length)];
        offset += fullRange.location + fullRange.length;
    }
    
    return [remainingText copy];
}

+ (BOOL)isOrderedListItem:(NSString *)line {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+\\. " options:0 error:&error];
    if (error) return NO;
    
    NSArray *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
    return matches.count > 0;
}

+ (NSString *)parseMarkdownToHTML:(NSString *)markdownText {
    if (!markdownText || markdownText.length == 0) {
        return @"";
    }
    
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><body>"];
    NSArray *lines = [markdownText componentsSeparatedByString:@"\n"];
    
    BOOL inCodeBlock = NO;
    
    for (NSString *line in lines) {
        if ([line hasPrefix:@"```"]) {
            if (inCodeBlock) {
                [html appendString:@"</pre>"];
                inCodeBlock = NO;
            } else {
                [html appendString:@"<pre><code>"];
                inCodeBlock = YES;
            }
            continue;
        }
        
        if (inCodeBlock) {
            [html appendFormat:@"%@\n", [self escapeHTML:line]];
            continue;
        }
        
        if ([line hasPrefix:@"# "]) {
            NSString *title = [line substringFromIndex:2];
            [html appendFormat:@"<h1>%@</h1>", [self escapeHTML:title]];
        } else if ([line hasPrefix:@"## "]) {
            NSString *title = [line substringFromIndex:3];
            [html appendFormat:@"<h2>%@</h2>", [self escapeHTML:title]];
        } else if ([line hasPrefix:@"### "]) {
            NSString *title = [line substringFromIndex:4];
            [html appendFormat:@"<h3>%@</h3>", [self escapeHTML:title]];
        } else if ([line hasPrefix:@"> "]) {
            NSString *quote = [line substringFromIndex:2];
            [html appendFormat:@"<blockquote>%@</blockquote>", [self escapeHTML:quote]];
        } else if ([line hasPrefix:@"* "] || [line hasPrefix:@"- "]) {
            NSString *listItem = [line substringFromIndex:2];
            [html appendFormat:@"<ul><li>%@</li></ul>", [self processInlineHTMLStyles:[self escapeHTML:listItem]]];
        } else if ([self isOrderedListItem:line]) {
            NSRange range = [line rangeOfString:@". "];
            if (range.location != NSNotFound) {
                NSString *listItem = [line substringFromIndex:range.location + range.length];
                [html appendFormat:@"<ol><li>%@</li></ol>", [self processInlineHTMLStyles:[self escapeHTML:listItem]]];
            }
        } else if (line.length > 0) {
            [html appendFormat:@"<p>%@</p>", [self processInlineHTMLStyles:[self escapeHTML:line]]];
        } else {
            [html appendString:@"<br>"];
        }
    }
    
    [html appendString:@"</body></html>"];
    return [html copy];
}

+ (NSString *)processInlineHTMLStyles:(NSString *)text {
    NSMutableString *result = [text mutableCopy];
    
    // 处理粗体
    result = [[result stringByReplacingOccurrencesOfString:@"\\*\\*([^*]+)\\*\\*"
                                                withString:@"<strong>$1</strong>"
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, result.length)] mutableCopy];
    
    // 处理斜体
    result = [[result stringByReplacingOccurrencesOfString:@"\\*([^*]+)\\*"
                                                withString:@"<em>$1</em>"
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, result.length)] mutableCopy];
    
    // 处理删除线
    result = [[result stringByReplacingOccurrencesOfString:@"~~([^~]+)~~"
                                                withString:@"<del>$1</del>"
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, result.length)] mutableCopy];
    
    // 处理行内代码
    result = [[result stringByReplacingOccurrencesOfString:@"`([^`]+)`"
                                                withString:@"<code>$1</code>"
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, result.length)] mutableCopy];
    
    // 处理链接
    result = [[result stringByReplacingOccurrencesOfString:@"\\[([^\\]]+)\\]\\(([^\\)]+)\\)"
                                                withString:@"<a href=\"$2\">$1</a>"
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, result.length)] mutableCopy];
    
    return [result copy];
}

+ (NSString *)escapeHTML:(NSString *)text {
    NSMutableString *result = [text mutableCopy];
    [result replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"'" withString:@"&#39;" options:0 range:NSMakeRange(0, result.length)];
    return [result copy];
}

@end

