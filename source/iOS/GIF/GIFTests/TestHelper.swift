//
//  TestHelper.swift
//  GIF
//
//  Created by Błażej Szajrych on 20.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

import Foundation
import GIF
import XCTest

public class TestHelper: NSObject {
    
    private let itemsProvider = TestItemsProvider()
    
    public func encodeTestFramesToPath( toPath: String, withMode: GIFEncodingType) -> GIFEncoder? {
        return self.encodeFramesInPaths(self.itemsProvider.provideTestFrames(), toPath: toPath, withMode: withMode)
    }
    
    public func encodeFramesInPaths(framePaths: [String],  toPath: String, withMode: GIFEncodingType) -> GIFEncoder? {
        var encoder: GIFEncoder? = nil;
        
        self.acquireAllImagesWithSingleImageAction(framePaths, action: { image in
            
            if encoder == nil {
                let width: UInt = UInt(image.size.width)
                let height: UInt = UInt(image.size.height)
                
                encoder = GIFEncoder(mode: withMode, width: width, height: height, filePath: toPath)
            }
            
            do {
                try encoder?.encodeFrame(image, frameDelay: 100)
            } catch {
                XCTAssertTrue(false)
            }
            
        })
        
        encoder?.closeGif()
        
        return encoder
    }
    
    public func acquireAllImagesWithSingleImageAction(paths: [String], action: (image: UIImage) -> ()) {
        paths.forEach { (path) in
            guard let image = UIImage(contentsOfFile: path) else { return }
            action(image: image)
        }
    }
    
}