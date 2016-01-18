//
//  UIView+DR_CustomBlockAnimations.h
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DR_CustomBlockAnimations)

+ (void)DR_popAnimationWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations;

@end
