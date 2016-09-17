//
//  GIFCreationTests.h
//  GIF
//
//  Created by Błażej Szajrych on 17.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GIFCreationTests : XCTestCase

+ (NSArray<NSString *> *)allCatImagePathsForGif;
+ (void)encodeWithType:(GIFEncodingType)encodingMode toPath:(NSString *)toPath;

@end