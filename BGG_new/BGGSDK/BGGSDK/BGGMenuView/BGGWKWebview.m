//
//  BGGWKWebview.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/28.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGWKWebview.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BGGPCH.h"
#import "IQKeyboardManager.h"
static const NSString *CompanyFirstDomainByRegister = @"qingin.cn";
@interface BGGWKWebview()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    WKWebView *_myWebView;
}
//@property(nonatomic,strong)WKWebView *bggWebView;
@end
@implementation BGGWKWebview
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [IQKeyboardManager sharedManager].enable = NO;
        self.leftButton.hidden = YES;
        self.titView.hidden = NO;
        [self.titView removeFromSuperview];
        self.logoImageView.hidden = YES;
        self.layer.cornerRadius = BGGCornerRadius;
        
    }
    return self;
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
    _myWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:config];
    _myWebView.UIDelegate = self;
    _myWebView.navigationDelegate = self;
    [self addSubview:_myWebView];
    [[_myWebView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"jsToOc"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [_myWebView loadRequest:request];
}



#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  
    
    NSURLRequest *request        = navigationAction.request;
    static NSString *endPayRedirectURL = nil;
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if ([absoluteString containsString:@"/cgi-bin/"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=xd.%@://",CompanyFirstDomainByRegister]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *redirectUrl = nil;
        if ([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
            endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=xd.%@://",CompanyFirstDomainByRegister]];
        }else {
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=xd.%@://",CompanyFirstDomainByRegister]];
        }

       NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        [webView loadRequest:newRequest];

        return;
    }
    
   if ([absoluteString containsString:@"dataString"]) {
            
            NSMutableString *param = [NSMutableString stringWithFormat:@"%@", (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)absoluteString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))];
            
            NSRange range = [param rangeOfString:@"{"];
            // 截取 json 部分
            NSString *param1 = [param substringFromIndex:range.location];
            if ([param1 rangeOfString:@"\"fromAppUrlScheme\":"].length > 0) {
                id json = [self dictionaryWithJsonString:param1]; // 这里为伪代码, 自行转成 dictionary
                if (![json isKindOfClass:[NSDictionary class]]) {
                    decisionHandler(WKNavigationActionPolicyAllow);
                    return;
                }
                
                NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:json];
                dicM[@"fromAppUrlScheme"] = [[NSBundle mainBundle] bundleIdentifier];
                
                NSString *jsonStr = [self dictionaryToJson:dicM]; // 这里为伪代码, 自行转成json
                
                NSString *encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                           (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));

                // 只替换 json 部分
                [param replaceCharactersInRange:NSMakeRange(range.location, param.length - range.location)  withString:encodedString];
                
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:param]]) {
                
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
                    [BGGDataModel sharedInstance].isPaying = true;
                    decisionHandler(WKNavigationActionPolicyCancel);
                    [self dismiss];
                    return;
//                }else{
//                    decisionHandler(WKNavigationActionPolicyCancel);
//                    return;
//                }
                
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
              
            }
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        
        if (![navigationAction.request.URL.absoluteString containsString:@"http://"] && ![navigationAction.request.URL.absoluteString containsString:@"https://"] && [navigationAction.request.URL.absoluteString containsString:@"://"]) {
            [BGGDataModel sharedInstance].isPaying = true;
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            [self dismiss];

        }
    
    
    decisionHandler (WKNavigationActionPolicyAllow);
    
   
//    if([navigationAction.request.URL.absoluteString containsString:@"dataString"] ) {
//        NSURL *openedURL = navigationAction.request.URL;
//
//        NSString *prefixString = [absoluteString substringToIndex:23];
//        NSLog(@"%@",prefixString);
//          NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//        NSLog(@"%@",[[NSBundle mainBundle] bundleIdentifier]);
//         NSString *urlString = [[self xh_URLDecodedString:absoluteString] stringByReplacingOccurrencesOfString:[prefixString substringToIndex:6] withString:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]]];
//
//         if ([urlString hasPrefix:prefixString]) {
//             NSRange rang = [urlString rangeOfString:prefixString];
//             NSString *subString = [urlString substringFromIndex:rang.length];
//             NSString *encodedString = [prefixString stringByAppendingString:[self xh_URLEncodedString:subString]];
//             openedURL = [NSURL URLWithString:encodedString];
//         }
//         [[UIApplication sharedApplication] openURL:openedURL];
//         [self dismiss];
//          decisionHandler(WKNavigationActionPolicyCancel);
//         return;
//    }
   


    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if (self.paramDic) {
        NSString *string1 = [self dictionaryToJson:self.paramDic];

        NSString *jsString = [NSString stringWithFormat:@"bingoSdk.setWebData(1, %@)",string1];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * error) {
            
            
        }];
    }
    
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        
        return nil;
    }
    return dic;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    NSDictionary *dic = message.body;
    
    if ([dic[@"_type"] integerValue] == 1) {
        [self hideNotice];
        [self popView];
        if (self.isPM) {
            if ([BGGDataModel sharedInstance].isLogin) {
                [BGGAPI sharedAPIManeger].hideDragBtn = NO;
            }else{
                [BGGAPI sharedAPIManeger].hideDragBtn = YES;
            }
        }
        
    }
    if ([dic[@"_type"] integerValue] == 11) {
        [self hideNotice];
        [self popView];
        
        [[BGGAPI sharedAPIManeger] BGGSDKLogout];
    }
    if ([dic[@"_type"] integerValue] == 12) {
        [BGGDataModel sharedInstance].userName = dic[@"userName"];
        [BGGDataModel sharedInstance].passWord = dic[@"password"];
    }
    if ([dic[@"_type"] integerValue] == 14) {
        
    }
   
    //如果需要回调，直接调用OC调用JS的方法
}
//- (NSString *)xh_URLDecodedString:(NSString *)urlString {
//    NSString *string = urlString;
//    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    return decodedString;
//}
//
//- (NSString *)xh_URLEncodedString:(NSString *)urlString {
//    NSString *string = urlString;
//    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                                     (CFStringRef)string,
//                                                                                                     NULL,
//                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                                     kCFStringEncodingUTF8));
//    return encodedString;
//}
- (void)dealloc{
    
    [self hideNotice];
    
    _myWebView.UIDelegate = nil;
    _myWebView.navigationDelegate = nil;
    [_myWebView loadHTMLString:@"" baseURL:nil];
    [_myWebView stopLoading];
    _myWebView= nil;
    [[_myWebView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOc"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}




@end
