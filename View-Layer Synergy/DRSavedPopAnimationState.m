//
//  DRSavedPopAnimationState.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import "DRSavedPopAnimationState.h"

@implementation DRSavedPopAnimationState

+ (instancetype)savedStateWithLayer:(CALayer *)layer
                            keyPath:(NSString *)keyPath
{
  DRSavedPopAnimationState *savedState = [DRSavedPopAnimationState new];
  savedState.layer    = layer;
  savedState.keyPath  = keyPath;
  savedState.oldValue = [layer valueForKeyPath:keyPath];
  return savedState;
}

@end
