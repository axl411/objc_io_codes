//
//  DRInspectionView.m
//  View-Layer Synergy
//
//  Created by 顾超 on Jan/18/16.
//  Copyright © 2016 顾超. All rights reserved.
//

#import "DRInspectionView.h"
#import "DRInspectionLayer.h"

@implementation DRInspectionView

+ (Class)layerClass
{
  return [DRInspectionLayer class];
}

@end
