//
//  AVRenderExampleViewController.h
//  AVRenderExample
//
//  Created by Moses DeJong on 5/16/11.
//
//  This view controller is a very simple iPhone app example that contains just 1 button.
//  When the button is pressed to movie composition module inside the AVAnimator library
//  is invoked to generate a movie that is a composite of 2 existing movies. The result
//  movie (.mvid file) is then played in the UI. The composition process is not really
//  fast since each frame is generated and then written to disk. The composite operation
//  reads composition information from the Comp.plist file, it then decodes the v1.mp4 and
//  v2.mp4 files attached to the project to v1.mvid and v2.mvid. The two movies are
//  composed into a single movie using the specific timing and x,y data indicated in
//  the Comp.plist file. Finally, the composed movie is played in the GUI.

#import <UIKit/UIKit.h>

@class AVAnimatorView;
@class MovieControlsViewController;
@class MovieControlsAdaptor;
@class AVOfflineComposition;

@interface AVRenderExampleViewController : UIViewController {
  UIWindow *m_window;
  UIButton *m_renderButton;
  AVAnimatorView *m_animatorView;
  MovieControlsViewController *m_movieControlsViewController;
  MovieControlsAdaptor *m_movieControlsAdaptor;
  AVOfflineComposition *m_composition;
}

@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, retain) IBOutlet UIButton *renderButton;
@property (nonatomic, retain) AVAnimatorView *animatorView;
@property (nonatomic, retain) MovieControlsViewController *movieControlsViewController;
@property (nonatomic, retain) MovieControlsAdaptor *movieControlsAdaptor;
@property (nonatomic, retain) AVOfflineComposition *composition;

- (IBAction) renderButton:(id)target;

- (void) setupNotification;

@end

