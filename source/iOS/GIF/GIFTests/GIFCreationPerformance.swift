//
//  GIFCreationPerformance.swift
//  GIF
//
//  Created by Błażej Szajrych on 19.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

import XCTest
import GIF

class GIFCreationPerformance: XCTestCase {
    
    private let helper = TestHelper()
    private var path: String? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let fileName = "\(NSUUID().UUIDString).gif"
        self.path = "\(NSTemporaryDirectory())/\(fileName)"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        guard let path = self.path else {
            XCTAssertTrue(false)
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testPerformanceFastModePerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.encodeWithMode(.SimpleFast)
        }
    }
    
    func testPerformanceNormalModePerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            self.encodeWithMode(.NormalLowMemory)
        }
    }
    
    func encodeWithMode(mode: GIFEncodingType) {
        
        guard let path = self.path else {
            XCTAssertTrue(false)
            return
        }
        
        let encoder = self.helper.encodeTestFramesToPath(path, withMode: mode)
        XCTAssertTrue(encoder != nil)
    }
    
}
