//
//  AVSyncAppDelegate.h
//  AVSync
//
//  Created by Moses DeJong on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVRenderExampleViewController;

@interface AVRenderExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVRenderExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AVRenderExampleViewController *viewController;

@end

