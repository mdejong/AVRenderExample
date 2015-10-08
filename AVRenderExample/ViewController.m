//
//  ViewController.m
//  AVRenderExample
//
//  Created by Mo DeJong on 10/7/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert(self.button, @"button");
}

- (IBAction) buttonPressed:(id)sender
{
  self.button.hidden = TRUE;
}

@end
