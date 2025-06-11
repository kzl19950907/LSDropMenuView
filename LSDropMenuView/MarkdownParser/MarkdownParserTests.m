//
//  MarkdownParserTests.m
//  LSDropMenuView
//
//  Created by Codegen on 2024/06/11.
//  Copyright © 2024 kzl19950907. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MarkdownParser.h"

@interface MarkdownParserTests : XCTestCase

@end

@implementation MarkdownParserTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBasicMarkdownParsing {
    NSString *markdown = @"# 标题\n\n这是**粗体**和*斜体*文本。";
    NSAttributedString *result = [MarkdownParser parseMarkdown:markdown];
    
    XCTAssertNotNil(result);
    XCTAssertTrue(result.length > 0);
}

- (void)testHTMLOutput {
    NSString *markdown = @"# 标题\n\n这是**粗体**文本。";
    NSString *html = [MarkdownParser parseMarkdownToHTML:markdown];
    
    XCTAssertNotNil(html);
    XCTAssertTrue([html containsString:@"<h1>"]);
    XCTAssertTrue([html containsString:@"<strong>"]);
}

- (void)testEmptyInput {
    NSAttributedString *result = [MarkdownParser parseMarkdown:@""];
    XCTAssertNotNil(result);
    XCTAssertEqual(result.length, 0);
    
    NSString *html = [MarkdownParser parseMarkdownToHTML:@""];
    XCTAssertNotNil(html);
}

- (void)testNilInput {
    NSAttributedString *result = [MarkdownParser parseMarkdown:nil];
    XCTAssertNotNil(result);
    XCTAssertEqual(result.length, 0);
    
    NSString *html = [MarkdownParser parseMarkdownToHTML:nil];
    XCTAssertNotNil(html);
}

- (void)testLinkParsing {
    NSString *markdown = @"访问 [GitHub](https://github.com) 了解更多。";
    NSAttributedString *result = [MarkdownParser parseMarkdown:markdown];
    
    XCTAssertNotNil(result);
    XCTAssertTrue(result.length > 0);
    
    // 检查是否包含链接属性
    __block BOOL hasLink = NO;
    [result enumerateAttributesInRange:NSMakeRange(0, result.length)
                               options:0
                            usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[NSLinkAttributeName]) {
            hasLink = YES;
            *stop = YES;
        }
    }];
    
    XCTAssertTrue(hasLink);
}

- (void)testCodeBlockParsing {
    NSString *markdown = @"```swift\nlet code = \"test\"\n```";
    NSString *html = [MarkdownParser parseMarkdownToHTML:markdown];
    
    XCTAssertTrue([html containsString:@"<pre><code>"]);
    XCTAssertTrue([html containsString:@"</code></pre>"]);
}

- (void)testListParsing {
    NSString *markdown = @"* 项目1\n* 项目2\n\n1. 有序项目1\n2. 有序项目2";
    NSString *html = [MarkdownParser parseMarkdownToHTML:markdown];
    
    XCTAssertTrue([html containsString:@"<ul><li>"]);
    XCTAssertTrue([html containsString:@"<ol><li>"]);
}

- (void)testQuoteParsing {
    NSString *markdown = @"> 这是一个引用";
    NSString *html = [MarkdownParser parseMarkdownToHTML:markdown];
    
    XCTAssertTrue([html containsString:@"<blockquote>"]);
}

@end

