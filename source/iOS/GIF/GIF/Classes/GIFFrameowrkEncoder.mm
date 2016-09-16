//
//  CPPWrapper.m
//  GIF
//
//  Created by Błażej Szajrych on 16.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import "GIFFrameowrkEncoder.h"
#import "EncodingType.h"
#import <CoreGraphics/CoreGraphics.h>
#import "GIFImageUtils.h"

@interface GIFEncoder () {
    BOOL _useDither;
}

@property (nonatomic, readonly) GifEncoder* encoder;

@end

@implementation GIFEncoder

#pragma mark lifecycle

+ (EncodingType)typeWithType:(GIFEncodingType)encodingType {
    switch (encodingType) {
        case GIFEncodingTypeNormalLowMemory:
            return ENCODING_TYPE_NORMAL_LOW_MEMORY;
            
        case GIFEncodingTypeSimpleFast:
            return ENCODING_TYPE_SIMPLE_FAST;
            
        case GIFEncodingTypeStableHighMemory:
            return ENCODING_TYPE_STABLE_HIGH_MEMORY;
            
        default:
            break;
    }
    
    return ENCODING_TYPE_NORMAL_LOW_MEMORY;
}

- (instancetype)initWithEncoder:(GifEncoder *)encoder {
    if (self = [super init]) {
        _encoder = encoder;
    }
    
    return self;
}

- (instancetype)initWithMode:(GIFEncodingType)encodingTypeMode width:(NSUInteger)width height:(NSUInteger)height filePath:(nonnull NSString *)filePath {
    if (self = [super init]) {
        _encoder = new GifEncoder([GIFEncoder typeWithType:encodingTypeMode]);
        _encoder->init(width, height, [filePath UTF8String]);
    }
    
    return self;
}

- (void)dealloc {
    self.encoder->release();
    delete _encoder;
}

#pragma mark accesors

- (NSUInteger)width {
    return self.encoder->getWidth();
}

- (NSUInteger)height {
    return  self.encoder->getHeight();
}

- (BOOL)useDither {
    return _useDither;
}

- (void)setUseDither:(BOOL)useDither {
    _useDither = useDither;
    self.encoder->setDither(useDither);
}

#pragma mark methods

- (void)encodeFrame:(UIImage *)frame frameDelay:(NSUInteger)delayMiliseconds {
    
    int32_t delayMS = delayMiliseconds > INT32_MAX
    ? INT32_MAX
    : (int32_t)delayMiliseconds;
    
    CGImageRef imageRef = frame.CGImage;
    
    // The encoder only supports ARGB_8888 -> check and if not then convert
    
    [GIFImageUtils acquireImageDataOfImage:imageRef onAcquired:^(void *data) {
        uint32_t *pixels = (uint32_t *)data;
        self.encoder->encodeFrame(pixels, delayMS);
    }];
}

#pragma mark - HELPERS


@end

