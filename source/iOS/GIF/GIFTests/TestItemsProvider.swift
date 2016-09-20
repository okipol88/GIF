//
//  TestItemsProvider.swift
//  GIF
//
//  Created by Błażej Szajrych on 19.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

import Foundation

public protocol TestItemProvidable: NSObjectProtocol {
    func provideTestFrames() -> [String]
}

public class TestItemsProvider: NSObject, TestItemProvidable {
    private let kGIFCatGifImagesFolderName = "cat_gif"
    
    private lazy var items: [String] = { [unowned self] in
        let  dirPath = "\(NSBundle(forClass: self.dynamicType).bundlePath)/\(self.kGIFCatGifImagesFolderName)"
        var paths = [String]()
        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(dirPath)
            paths = contents.map { return "\(dirPath)/\($0)"}
        } catch {
            print("Error \(error)")
        }
        return paths
    }()
    
    public override init() {
        super.init()
    }

    public func provideTestFrames() -> [String] {
        return self.items
    }
}