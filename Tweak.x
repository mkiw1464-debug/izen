#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface IzenPopupVC : UIViewController
@end

@implementation IzenPopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Close button
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.view.bounds.size.width - 50, 20, 40, 40);
    closeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    // WKWebView fullscreen
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSURL *url = [NSURL URLWithString:@"https://izen.lol"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    
    [self.view addSubview:webView];
    [self.view addSubview:closeBtn]; // Close button atas webview
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    BOOL result = %orig;
    
    // Delay sikit supaya root VC dah ready
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *rootVC = application.keyWindow.rootViewController;
        if (rootVC) {
            IzenPopupVC *popup = [[IzenPopupVC alloc] init];
            popup.modalPresentationStyle = UIModalPresentationFullScreen;
            [rootVC presentViewController:popup animated:YES completion:nil];
        }
    });
    
    return result;
}

%end
