//
//  GIFTests.m
//  GIFTests
//
//  Created by Błażej Szajrych on 16.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GIF/GIF.h>
#import "GIFTests-Swift.h"

static NSString *const kGIFCatGifImagesFolderName = @"cat_gif";

@interface GIFCreationTests : XCTestCase

+ (void)encodeWithType:(GIFEncodingType)encodingMode toPath:(NSString *)toPath;
+ (TestItemsProvider *)itemsProvider;

@end

@interface GIFCreationTests()

@property(nonatomic, copy, nonnull) NSString *gifPath;

@end

@implementation GIFCreationTests

+ (TestHelper *)helper {
    static dispatch_once_t onceToken;
    static TestHelper *provider;
    dispatch_once(&onceToken, ^{
        provider = [TestHelper new];
    });
    
    return provider;
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
    GIFEncoder* encoder = [self.helper encodeTestFramesToPath:toPath withMode:encodingMode];
    
    XCTAssertNotNil(encoder);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:toPath]);
    
    NSError *fileAcquiringError;
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:toPath error:&fileAcquiringError] fileSize];
    XCTAssertNil(fileAcquiringError);
    XCTAssertTrue(fileSize > 0);
    
}

@end
