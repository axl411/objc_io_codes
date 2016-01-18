//
//  UIView+DR_CustomBlockAnimations.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

@import ObjectiveC.runtime;
#import "UIView+DR_CustomBlockAnimations.h"
#import "DRSavedPopAnimationState.h"

static void *DR_currentAnimationContext = NULL;
static void *DR_popAnimationContext     = &DR_popAnimationContext;
static void *UIViewDR_savedPopAnimationStates = &UIViewDR_savedPopAnimationStates;

@implementation UIView (DR_CustomBlockAnimations)

+ (void)load
{
  SEL originalSelector = @selector(actionForLayer:forKey:);
  SEL extendedSelector = @selector(DR_actionForLayer:forKey:);
  
  Method originalMethod = class_getInstanceMethod(self, originalSelector);
  Method extendedMethod = class_getInstanceMethod(self, extendedSelector);
  
  NSAssert(originalMethod, @"original method should exist");
  NSAssert(extendedMethod, @"exchanged method should exist");
  
  if(class_addMethod(self, originalSelector, method_getImplementation(extendedMethod), method_getTypeEncoding(extendedMethod))) {
    class_replaceMethod(self, extendedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, extendedMethod);
  }
}

- (id<CAAction>)DR_actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
  if (DR_currentAnimationContext == DR_popAnimationContext) {
    [[UIView DR_savedPopAnimationStates] addObject:[DRSavedPopAnimationState savedStateWithLayer:layer
                                                                                         keyPath:event]];
    
    // no implicit animation (it will be added later)
    return (id<CAAction>)[NSNull null];
  }
  
  // call the original implementation
  return [self DR_actionForLayer:layer forKey:event]; // yes, they are swizzled
}

+ (void)DR_popAnimationWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations
{
  DR_currentAnimationContext = DR_popAnimationContext;
  
  // do the animation (which will trigger callbacks to the swizzled delegate method)
  animations();
  
  [[self DR_savedPopAnimationStates] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    DRSavedPopAnimationState *savedState   = (DRSavedPopAnimationState *)obj;
    CALayer *layer    = savedState.layer;
    NSString *keyPath = savedState.keyPath;
    id oldValue       = savedState.oldValue;
    id newValue       = [layer valueForKeyPath:keyPath];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    CGFloat easing = 0.2;
    CAMediaTimingFunction *easeIn  = [CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :(1.0-easing) :1.0];
    CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithControlPoints:easing :0.0 :0.0 :1.0];
    
    anim.duration = duration;
    anim.keyTimes = @[@0, @(0.35), @1];
    anim.values = @[oldValue, newValue, oldValue];
    anim.timingFunctions = @[easeIn, easeOut];
    
    // back to old value without an animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:oldValue forKeyPath:keyPath];
    [CATransaction commit];
    
    // animate the "pop"
    [layer addAnimation:anim forKey:keyPath];
    
  }];
  
  // clean up (remove all the stored state)
  [[self DR_savedPopAnimationStates] removeAllObjects];
  
  DR_currentAnimationContext = nil;
}

+ (NSMutableArray *)DR_savedPopAnimationStates
{
  NSMutableArray *array = objc_getAssociatedObject(self, UIViewDR_savedPopAnimationStates);
  if (array == nil) {
    array = [NSMutableArray new];
    objc_setAssociatedObject(self, UIViewDR_savedPopAnimationStates, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return array;
}

@end
