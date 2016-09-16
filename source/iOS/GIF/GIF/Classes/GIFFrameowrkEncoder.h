//
//  CPPWrapper.h
//  GIF
//
//  Created by Błażej Szajrych on 16.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

typedef NS_ENUM(NSInteger, GIFEncodingType){
    GIFEncodingTypeSimpleFast,
    GIFEncodingTypeStableHighMemory,
    GIFEncodingTypeNormalLowMemory
};

NS_ASSUME_NONNULL_BEGIN

@interface GIFEncoder : NSObject

- (instancetype)initWithMode:(GIFEncodingType)encodingTypeMode width:(NSUInteger)width height:(NSUInteger)height filePath:(NSString *)filePath;

@property(nonatomic, readonly) NSUInteger width;
@property(nonatomic, readonly) NSUInteger height;
@property(nonatomic) BOOL useDither;

- (void)encodeFrame:(UIImage *)frame frameDelay:(NSUInteger)delay;

@end

@interface GIFEncoder (Unavailable)

- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

@interface GIFEncoder (Additions)
#if __cplusplus

#include "GifEncoder.h"

- (nonnull instancetype)initWithEncoder:(nonnull GifEncoder *)encoder;

#endif

@end
