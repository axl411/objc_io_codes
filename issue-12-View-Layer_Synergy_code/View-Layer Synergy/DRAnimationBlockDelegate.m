//
//  DRAnimationBlockDelegate.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import "DRAnimationBlockDelegate.h"
@import QuartzCore;

@implementation DRAnimationBlockDelegate

+ (instancetype)animationDelegateWithBeginning:(void (^)(void))beginning
                                    completion:(void (^)(BOOL))completion
{
  DRAnimationBlockDelegate *result = [DRAnimationBlockDelegate new];
  result.start = beginning;
  result.stop  = completion;
  return result;
}

- (void)animationDidStart:(CAAnimation *)anim
{
  if (self.start) {
    self.start();
  }
  self.start = nil;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  if (self.stop) {
    self.stop(flag);
  }
  self.stop = nil;
}

@end
