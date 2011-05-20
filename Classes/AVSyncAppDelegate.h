//
//  AVSyncAppDelegate.h
//  AVSync
//
//  Created by Moses DeJong on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVSyncViewController;

@interface AVSyncAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVSyncViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AVSyncViewController *viewController;

@end

