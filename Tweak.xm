#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Delay 1.5 saat biar app stabil
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showWebPopup];
    });
    
    return result;
}

%new
- (void)showWebPopup {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    if (!keyWindow) return;

    // Overlay gelap
    UIView *overlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
    overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    overlay.tag = 9999;

    // Container popup
    CGFloat width = keyWindow.bounds.size.width - 40;
    CGFloat height = keyWindow.bounds.size.height - 160;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(20, 80, width, height)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 16;
    container.clipsToBounds = YES;

    // Header dengan title + close button
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    header.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:1.0];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, width - 80, 28)];
    title.text = @"izen.lol";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:18];
    [header addSubview:title];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(width - 48, 4, 36, 36);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];

    [container addSubview:header];

    // WebView — load izen.lol
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, width, height - 44)];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:@"https://izen.lol"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [container addSubview:webView];

    [overlay addSubview:container];
    [keyWindow addSubview:overlay];
}

%new
- (void)closePopup:(UIButton *)sender {
    UIView *container = sender.superview.superview;
    UIView *overlay = container.superview;
    [overlay removeFromSuperview];
}

%end
