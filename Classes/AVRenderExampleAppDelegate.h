//
//  AVRenderExampleAppDelegate.h
//  AVRenderExample
//
//  Created by Moses DeJong on 5/16/11.
//
//  See AVRenderExampleViewController.h for description of this example app.

#import <UIKit/UIKit.h>

@class AVRenderExampleViewController;

@interface AVRenderExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVRenderExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AVRenderExampleViewController *viewController;

@end

