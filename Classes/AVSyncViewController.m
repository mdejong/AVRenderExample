//
//  AVSyncViewController.m
//  AVSync
//
//  Created by Moses DeJong on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AVSyncViewController.h"

#import "AVAnimatorView.h"

#import "MovieControlsViewController.h"
#import "MovieControlsAdaptor.h"

#import "AVAnimatorMedia.h"

#import "AV7zAppResourceLoader.h"

#import "AVMvidFrameDecoder.h"

#import "AVFileUtil.h"

@implementation AVSyncViewController

@synthesize container = m_container;
@synthesize slowButton = m_slowButton;
@synthesize fastButton = m_fastButton;

@synthesize animatorView = m_animatorView;
@synthesize movieControlsViewController = m_movieControlsViewController;
@synthesize movieControlsAdaptor = m_movieControlsAdaptor;

- (void)dealloc {
  self.container = nil;
  self.slowButton = nil;
  self.fastButton = nil;
  self.animatorView = nil;
  self.movieControlsViewController = nil;
  self.movieControlsAdaptor = nil;
  [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert(self.container, @"container not set in NIB");
  NSAssert(self.slowButton, @"slowButton not set in NIB");
  NSAssert(self.fastButton, @"fastButton not set in NIB");
}


- (void) loadIntoMovieControls:(AVAnimatorMedia*)media
{
  // Create Movie Controls and let it manage the AVAnimatorView
  
	self.movieControlsViewController = [MovieControlsViewController movieControlsViewController:self.animatorView];
  
  // A MovieControlsViewController can only be placed inside a toplevel window!
  // Unlike a normal controller, you can't invoke [window addSubview:movieControlsViewController.view]
  // to place a MovieControlsViewController in a window. Just set the mainWindow property instead.
  
  self.movieControlsViewController.mainWindow = self.view.window;
  
  self.movieControlsAdaptor = [MovieControlsAdaptor movieControlsAdaptor];
  self.movieControlsAdaptor.animatorView = self.animatorView;
  self.movieControlsAdaptor.movieControlsViewController = self.movieControlsViewController;
  
  // Media needs to be attached to the view after the view
  // has been added to the window system.
  
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

- (void) loadAnimatorView
{
  [self.container removeFromSuperview];
  
  CGRect frame = CGRectMake(0, 0, 480, 320);
  self.animatorView = [AVAnimatorView aVAnimatorViewWithFrame:frame];
  
  // Extract FILENAME.mvid from FILENAME.mvid.7z attached as app resource. The compressed .mvid
  // is smaller than a compressed .mov and smaller than a compressed .apng for this video content.
  
  NSString *resourcePrefix = @"LS_C_Major_Open_4ths";
  NSString *videoResourceArchiveName = [NSString stringWithFormat:@"%@.mvid.7z", resourcePrefix];
  NSString *videoResourceEntryName = [NSString stringWithFormat:@"%@.mvid", resourcePrefix];
  NSString *resourceTail = [resourcePrefix lastPathComponent];
  NSString *videoResourceOutName = [NSString stringWithFormat:@"%@.mvid", resourceTail];
  NSString *videoResourceOutPath = [AVFileUtil getTmpDirPath:videoResourceOutName];

  AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
  
  AV7zAppResourceLoader *resLoader = [AV7zAppResourceLoader aV7zAppResourceLoader];
  resLoader.archiveFilename = videoResourceArchiveName;
  resLoader.movieFilename = videoResourceEntryName;
  resLoader.outPath = videoResourceOutPath;    
  
  media.resourceLoader = resLoader;  
  
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
    
  [self loadIntoMovieControls:media];
  
  [media startAnimator];  
}

- (IBAction) doSlowButton:(id)target
{
  [self loadAnimatorView];
  return;
}

- (IBAction) doFastButton:(id)target
{
  [self loadAnimatorView];
  return;
}

@end
