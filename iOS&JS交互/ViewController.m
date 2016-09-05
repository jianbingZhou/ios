//
//  ViewController.m
//  iOS&JS交互
//
//  Created by Terra MacBook on 16/8/24.
//  Copyright © 2016年 JianbingZhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *imagePikcerController;
}
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [webView sizeToFit];
    [self.view addSubview:webView];
    self.webView = webView;
    
   // NSURL *url = [NSURL URLWithString:@"http://www.hua.com/?sid=emar"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,450, 200, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //[NSURLConnection connectionWithRequest:request delegate:<#(nullable id)#>]
}

- (void)btnClick {
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"clikc('这里的zzzz变成了lalalala')"];
}

#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"****%@",request.URL.absoluteString);
    NSString *requestString = request.URL.absoluteString;
    if ([requestString hasPrefix:@"zjb://"]) {
        NSArray  *strings = [requestString componentsSeparatedByString:@"zjb://"];
        NSString *methodName = strings[1];
        SEL selector = NSSelectorFromString(methodName);
        [self performSelector: selector];
        return NO;
    }
    NSString *js = @"document.getElementById('body').style.margin = '100px';";
    js = @"document.getElementsByTagName('body')[0].style.marginTop = '100px';";
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    
    return YES;
}




- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"document.title";
   // NSString *title =   [webView stringByEvaluatingJavaScriptFromString:js];
    
    js = @"document.body.clientWidth||window.innerWidth||document.documentElement.clientWidth";
   // NSString *widht =  [webView stringByEvaluatingJavaScriptFromString:js];
    js = @"document.body.clientHeight";
    NSString *height = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"%@&&&&&&&&&&&:%@",NSStringFromCGRect(webView.frame),height);
}

- (void)getImage {
    imagePikcerController = [[UIImagePickerController alloc] init];
    imagePikcerController.delegate = self;
    imagePikcerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePikcerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"***%@",image);
    
   // [imagePikcerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
 //   NSLog(@"***%@",info);
//    NSString *jsString = @"document.getElementById('image').src ='2.png';";
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *filePath = [self filePath:[fm stringFromDate:[NSDate date]]];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [imageData writeToFile:filePath options:NSDataWritingAtomic error:nil];
//    NSString *jsString = [NSString stringWithFormat: @"document.getElementById('image').src ='%@';",filePath];
//    UIImage *myImage = [UIImage imageWithContentsOfFile:filePath];
//    NSLog(@"%@************%@",myImage,filePath);//0x7fbd71cc9e80
//     //0x7fbd71f96e80 0x7fbd74102f00
    
    
  [self performSelector:@selector(changeImage:) withObject:filePath afterDelay:1];
//    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    
    
    [imagePikcerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeImage:(NSString *)url {
    NSString *str = [NSString stringWithFormat:@"changeImage('%@')",url];
    
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}

- (void)delay:(NSString *)js {
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    [imagePikcerController dismissViewControllerAnimated:YES completion:nil];

}


- (NSString *)filePath:(NSString *)timeString {
    //timeString = @"my";
    NSString *str = [NSString stringWithFormat:@"documents/%@.png",timeString];
     NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        return filePath;
    }else {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        
    }
    return filePath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"***)imagePickerControllerDidCancel");
    [imagePikcerController dismissViewControllerAnimated:YES completion:nil];

}





@end
