//
//  DRSavedPopAnimationState.h
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

@import UIKit;

@interface DRSavedPopAnimationState : NSObject

@property (strong) CALayer  *layer;
@property (copy)   NSString *keyPath;
@property (strong) id        oldValue;

+ (instancetype)savedStateWithLayer:(CALayer *)layer
                            keyPath:(NSString *)keyPath;

@end
