//
//  GIFTests.m
//  GIFTests
//
//  Created by Błażej Szajrych on 16.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import <XCTest/XCTestC.h>
#import <GIF/GIF.h>

static NSString *const kGIFCatGifImagesFolderName = @"cat_gif";

@interface GIFCreationTests : XCTestCase

+ (NSArray<NSString *> *)allCatImagePathsForGif;
+ (void)encodeWithType:(GIFEncodingType)encodingMode toPath:(NSString *)toPath;

@end

@interface GIFCreationTests()

@property(nonatomic, copy, nonnull) NSString *gifPath;

@end

@implementation GIFCreationTests

+ (NSArray<NSString *> *)allCatImagePathsForGif {
    
    static NSArray<NSString *> *allCatImagePaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray<NSString *> *imagePaths = [@[] mutableCopy];
        NSString *dirPath = [[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingPathComponent:kGIFCatGifImagesFolderName];
        
        NSError *dirContentsError;
        NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&dirContentsError];
        
        XCTAssertNil(dirContentsError);
        
        for (NSString *fileName in contents) {
            [imagePaths addObject:[dirPath stringByAppendingPathComponent:fileName]];
        }
        
        XCTAssertTrue(contents.count > 0);
        
        allCatImagePaths = [imagePaths copy];
    });
    
    return allCatImagePaths;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *fileName = [[NSUUID new].UUIDString stringByAppendingPathExtension:@"gif"];
    self.gifPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.gifPath error:nil];
}

- (void)testNormalModeEncoder {
    [GIFCreationTests encodeWithType:GIFEncodingTypeNormalLowMemory toPath:self.gifPath];
}

- (void)testFastModeEncoder {
    [GIFCreationTests encodeWithType:GIFEncodingTypeSimpleFast toPath:self.gifPath];
}

//TODO: Inspect -> Tests for this mode fail!
//- (void)testStableModeEncoder {
//    [self encodeWithType:GIFEncodingTypeStableHighMemory toPath:self.gifPath];
//}

+ (void)encodeWithType:(GIFEncodingType)encodingMode toPath:(NSString *)toPath {
    __block GIFEncoder *encoder = nil;
    
    __block NSError *err;
    [self acquireAllImagesWithSingleImageAction:^(UIImage *image) {
       
        if (!encoder) {
            encoder = [[GIFEncoder alloc] initWithMode:encodingMode width:image.size.width height:image.size.height filePath:toPath];
        }
        
        [encoder encodeFrame:image frameDelay:100 error:&err];
        
        XCTAssertNil(err);
        
    }];
    
    [encoder closeGif];
    
    XCTAssertNotNil(encoder);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:toPath]);
    
    NSError *fileAcquiringError;
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:toPath error:&fileAcquiringError] fileSize];
    XCTAssertNil(fileAcquiringError);
    XCTAssertTrue(fileSize > 0);
    
}

#pragma - mark Helpers

+ (void)acquireAllImagesWithSingleImageAction:(void (^)(UIImage *))imageAction {
    NSArray<NSString *> *imagePaths = [GIFCreationTests allCatImagePathsForGif];
    for (NSString *path in imagePaths) {
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        imageAction(img);
    }
}

@end
