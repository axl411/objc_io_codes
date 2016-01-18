//
//  DRInspectionLayer.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import "DRInspectionLayer.h"

@implementation DRInspectionLayer

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
  NSLog(@"adding animation: %@", [anim debugDescription]);
  [super addAnimation:anim forKey:key];
}

@end
