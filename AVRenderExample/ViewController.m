//
//  ViewController.m
//  AVRenderExample
//
//  Created by Mo DeJong on 10/7/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "ViewController.h"

#import "AVAnimatorView.h"

#import "AVAnimatorMedia.h"

#import "AV7zAppResourceLoader.h"

#import "AVMvidFrameDecoder.h"

#import "AVFileUtil.h"

#import "AVOfflineComposition.h"

#import "MovieControlsViewController.h"
#import "MovieControlsAdaptor.h"

@interface ViewController ()

@property(nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) IBOutlet UIButton *button;

@property (nonatomic, retain) AVAnimatorView *animatorView;

@property (nonatomic, retain) MovieControlsViewController *movieControlsViewController;
@property (nonatomic, retain) MovieControlsAdaptor *movieControlsAdaptor;
@property (nonatomic, retain) AVOfflineComposition *composition;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert(self.button, @"button");
}

- (IBAction) buttonPressed:(id)sender
{
  self.button.hidden = TRUE;
  
  [self loadAnimatorView];
}

- (void) loadAnimatorView
{
  // The UIWindow the movie controls will be loaded into can't be null at this point
  UIWindow *window = self.view.window;
  NSAssert(window != nil, @"window is nil");
  self.window = window;
  
  // Don't use this view and view controller, make the movie controllers the primary view
  [self.view removeFromSuperview];
  
  CGRect frame = CGRectMake(0, 0, 480, 320);
  self.animatorView = [AVAnimatorView aVAnimatorViewWithFrame:frame];
  
  // Create Render Object
  
  NSString *resFilename = @"Comp.plist";
  
  NSDictionary *plistDict = (NSDictionary*) [AVOfflineComposition readPlist:resFilename];
  
  AVOfflineComposition *comp = [AVOfflineComposition aVOfflineComposition];
  
  self.composition = comp;
  
  [self setupNotification];
  
  NSLog(@"start rendering lossless movie in background");
  
  [comp compose:plistDict];
  
  return;
}

- (void) stopAnimator
{
  if (self.movieControlsAdaptor != nil) {
    [self.movieControlsAdaptor stopAnimator];
    self.movieControlsAdaptor = nil;
    self.movieControlsViewController.mainWindow = nil;
  }
  
  {
    // Remove the very large comp file rendered to disk. The
    // next time a render was done the logic would remove
    // the previous output comp anyway, but since this file is so
    // very large (more than 2 gigabytes) it is better to remove
    // it right away to avoid leaving it on disk on accident.
    
    AVAnimatorMedia *media = self.animatorView.media;
    
    AVMvidFrameDecoder *frameDecoder = (AVMvidFrameDecoder*) media.frameDecoder;
    
    NSString *tmpCompPath = frameDecoder.filePath;
    
    if ((1))
    {
      BOOL worked;
      worked = [[NSFileManager defaultManager] removeItemAtPath:tmpCompPath error:nil];
      NSAssert(worked, @"could not remove tmp file");
    } else {
      NSLog(@"did not remove rendered file: %@", tmpCompPath);
    }
  }
  
  [self.animatorView removeFromSuperview];
  self.animatorView = nil;
  
  self.movieControlsViewController = nil;
  
  UIWindow *window = self.window;
  NSAssert(window != nil, @"window is nil");
  [window addSubview:self.view];
}

// Notification indicates that all animations in a loop are now finished

- (void)animatorDoneNotification:(NSNotification*)notification {
  NSLog( @"animatorDoneNotification" );
  
  // Unlink all notifications
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [self stopAnimator];
}

- (IBAction) renderButton:(id)target
{
  [self loadAnimatorView];
  return;
}

- (void) setupNotification
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(finishedLoadNotification:)
                                               name:AVOfflineCompositionCompletedNotification
                                             object:self.composition];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(failedToLoadNotification:)
                                               name:AVOfflineCompositionFailedNotification
                                             object:self.composition];
}

- (void) finishedLoadNotification:(NSNotification*)notification
{
  NSLog(@"finished rendering lossless movie");
  
  UIWindow *window = self.window;
  NSAssert(window != nil, @"window is nil");
  NSAssert(window, @"window");

  window.backgroundColor = [UIColor blackColor];
  
  NSString *filename = self.composition.destination;
  
  AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
  
  // Create res loader
  
  AVAppResourceLoader *resLoader = [AVAppResourceLoader aVAppResourceLoader];
  // Phony resource name, becomes no-op since the comp file exists already
  resLoader.movieFilename = filename;
  
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  BOOL worked;
  worked = [frameDecoder openForReading:filename];
  NSAssert(worked, @"frameDecoder openForReading failed");
  
  
  self.movieControlsViewController = [MovieControlsViewController movieControlsViewController:self.animatorView];
  
  // A MovieControlsViewController can only be placed inside a toplevel window!
  // Unlike a normal controller, you can't invoke [window addSubview:movieControlsViewController.view]
  // to place a MovieControlsViewController in a window. Just set the mainWindow property instead.
  
  self.movieControlsViewController.mainWindow = window;
  
  self.movieControlsAdaptor = [MovieControlsAdaptor movieControlsAdaptor];
  self.movieControlsAdaptor.animatorView = self.animatorView;
  self.movieControlsAdaptor.movieControlsViewController = self.movieControlsViewController;
  
  // Associate Media with the view that it will be rendered into
  
  [self.animatorView attachMedia:media];
  
  // This object needs to listen for the AVAnimatorDoneNotification to update the GUI
  // after movie loops are finished playing.
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(animatorDoneNotification:)
                                               name:AVAnimatorDoneNotification
                                             object:self.animatorView.media];
  
  [self.movieControlsAdaptor startAnimator];
  
  return;
}

- (void) failedToLoadNotification:(NSNotification*)notification
{
  AVOfflineComposition *comp = (AVOfflineComposition*)notification.object;
  
  NSString *errorString = comp.errorString;
  
  NSLog(@"failed rendering lossless movie: \"%@\"", errorString);
  
  UIWindow *window = self.window;
  NSAssert(window != nil, @"window is nil");
  window.backgroundColor = [UIColor blackColor];
}

@end
