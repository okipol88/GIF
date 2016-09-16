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
    
    //TODO: Inspect -> Tests for this mode fail!
//    GIFEncodingTypeStableHighMemory,
    
    GIFEncodingTypeNormalLowMemory
};

NS_ASSUME_NONNULL_BEGIN

extern NSString *const GIFErrorDomain;

extern int const kGIFErrorCouldNotEncodeFrame;

@interface GIFEncoder : NSObject

- (instancetype)initWithMode:(GIFEncodingType)encodingTypeMode width:(NSUInteger)width height:(NSUInteger)height filePath:(NSString *)filePath;

@property(nonatomic, readonly) NSUInteger width;
@property(nonatomic, readonly) NSUInteger height;
@property(nonatomic) BOOL useDither;

- (BOOL)encodeFrame:(UIImage *)frame frameDelay:(NSUInteger)delay error:(NSError **)error;
- (void)closeGif;

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
