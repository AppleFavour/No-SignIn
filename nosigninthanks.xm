#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Created by Turann_ on 25/01/2024

void nosignin_debug(){
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"No Sign-in injected %@ (%@) OS Version: %@:", bundleName, bundleID, OSVersion);

}

%hook UIApplication
    -(void)finishedTest:(id)arg1 extraResults:(id)arg2 { nosignin_debug(); %orig; }
%end

%hook UIWindow
    -(void)finishedTest:(id)arg1 extraResults:(id)arg2 { nosignin_debug(); %orig; }
%end

/*
%hook UILabel
-(void)setText:(NSString *)arg1 {
    if ([arg1 isEqualToString:@"sometext"]) { arg1 = @"© Turann_"; }
    %orig;
}
%end 
*/

// NoSignInThanks.h
@interface UIAlertController (RegexMatch)
- (NSString *)RegexMatchForPartialMatch:(NSString *)keyword;
@end

@implementation UIAlertController (RegexMatch)
- (NSString *)RegexMatchForPartialMatch:(NSString *)keyword { return [NSString stringWithFormat:@".*%@.*", keyword]; }
@end

%hook UIAlertController
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Alert Details - Title: %@ - Message: %@", [self title], [self message]);

    NSArray *keywords = @[
        @"Sign in with Apple ID", 
        @"Apple kimliği ile giriş yapın",
        @"Connectez-vous avec Apple",
        @"Mit Apple anmelden",
        @"Accedi con Apple",
        @"Meld je aan met Apple",
        @"Inicia sesión con Apple",
        @"Вход с Apple",
        @"Увійдіть за допомогою Apple",
        @"Logga in med Apple",
        @"Prijavite se sa Apple",
        @"Conectează-te cu Apple",
        @"Iniciar sessão com a Apple",
        @"Prijavite se s Appleom",
        @"تسجيل الدخول بواسطة Apple"
    ];
    NSString *title = [self title];
    for (NSString *keyword in keywords) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", [self RegexMatchForPartialMatch:keyword]];
        if ([predicate evaluateWithObject:title]) {
            NSLog(@"Hello World! - Detected Sign-in alert with possible match: %@", keyword);
            NSLog(@"Dismissing alert...");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
                NSLog(@"Alert dismissed.");
            });
            break;
        }
    }
}
%end
