//
//  BGGNoticeView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/7/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGNoticeView.h"
#import "BGGPCH.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "IQKeyboardManager.h"

@interface BGGNoticeView()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    WKWebView *_myWebView;
}
@end
@implementation BGGNoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.rightButton.hidden = NO;
           self.titView.hidden = NO;
           self.titlabel.text = @"公告";
           self.logoImageView.hidden = YES;
           
          
       }
       return self;
}
-(void)rightbuttonClick:(UIButton *)sender{
        if (self.rightBtnClickBlock) {
            self.rightBtnClickBlock(self, sender);
        }
        if ([BGGDataModel sharedInstance].viewArray.count == 1) {
            [self dismiss];
            return;
        }
        [self popView];
    }
-(void)setWebUrl:(NSString *)webUrl{
    _webUrl = webUrl;
    NSString *jScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:wkUScript];
    _myWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50) configuration:config];
    _myWebView.UIDelegate = self;
    _myWebView.navigationDelegate = self;
    [self addSubview:_myWebView];
   // [[_myWebView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"jsToOc"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [_myWebView loadRequest:request];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  
    decisionHandler (WKNavigationActionPolicyAllow);
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
}
- (void)dealloc{
    _myWebView.UIDelegate = nil;
    _myWebView.navigationDelegate = nil;
    [_myWebView loadHTMLString:@"" baseURL:nil];
    [_myWebView stopLoading];
    _myWebView= nil;
   // [[_myWebView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOc"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
