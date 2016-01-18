//
//  ViewController.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import "ViewController.h"
#import "DRInspectionView.h"
#import "DRAnimationBlockDelegate.h"
#import "UIView+DR_CustomBlockAnimations.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DRInspectionView *inspectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fadeIn.duration  = 0.75;
  fadeIn.fromValue = @0;
  fadeIn.fillMode = kCAFillModeBoth;
  fadeIn.delegate = [DRAnimationBlockDelegate animationDelegateWithBeginning:^{
    NSLog(@"beginning to fade in");
  } completion:^(BOOL finished) {
    NSLog(@"did fade %@", finished ? @"to the end" : @"but was cancelled");
  }];
  
  self.inspectionView.layer.opacity = 1.0; // change the model value ...
  // ... and add the animation object
  [self.inspectionView.layer addAnimation:fadeIn forKey:@"fade in slowly"];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [UIView DR_popAnimationWithDuration:1 animations:^{
      self.inspectionView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
  });
}

@end
