### GIF - Objective-C wrapper for a C++ GIF library

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This framework is based on the **Android NDK GIF** Library, forked and hooked up as a submodule, that can be found [here](https://github.com/waynejo/android-ndk-gif).
Small adjustments to the `C++` code have been made to make it compilable as `Objective-C++`.

The project currently only supports encoding. But with little effort decoding can also be added.
Two modes are available:
- *ENCODING_TYPE_SIMPLE_FAST*
- *ENCODING_TYPE_NORMAL_LOW_MEMORY*

The original project also includes *ENCODING_TYPE_STABLE_HIGH_MEMORY* but currently there are some problems with it.

Example usgae can be found in the *GIFExample* project:

```swift
...
        var encoder: GIFEncoder? = nil
        for path in paths {
            guard let image = UIImage(contentsOfFile: path) else {
                print("Could not acquire image at path \(path)")
                continue
            }
            if encoder == nil {
                encoder = GIFEncoder(mode: .NormalLowMemory, width: UInt(image.size.width), height: UInt(image.size.height), filePath: gifPath)
            }
            do {
                try encoder?.encodeFrame(image, frameDelay: 250)
            } catch {
                print("Could not create frame for image at path \(path)")
            }
        }

        encoder?.closeGif()
```

### Helpfull articles:
- [Wrapping C++ code](http://robnapier.net/wrapping-cppfinal-edition)
- [Getting pixel data from CGIImage](https://developer.apple.com/library/content/qa/qa1509/_index.html)

