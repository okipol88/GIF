//
//  GIFImageUtils.h
//  GIF
//
//  Created by Błażej Szajrych on 16.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import <CoreGraphics/CGImage.h>

typedef void(^OnImageDataAcquired)(void* data);

@interface GIFImageUtils : NSObject

+ (void) acquireImageDataOfImage:(CGImageRef)inImage  onAcquired:(OnImageDataAcquired)onAcquiredAction;
+ (CGContextRef) createRGBABitmapContext:(CGImageRef)inImage;

@end
