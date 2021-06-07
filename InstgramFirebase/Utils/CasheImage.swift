////
////  CasheImage.swift
////  InstgramFirebase
////
////  Created by Ahmad Eisa on 05/04/2021.
////  Copyright © 2021 Ahmad Eisa. All rights reserved.
////
//
//import UIKit
//// Declares in-memory image cache
//protocol ImageCacheType: class {
//    // Returns the image associated with a given url
//    func image(for url: URL) -> UIImage?
//    // Inserts the image of the specified url in the cache
//    func insertImage(_ image: UIImage?, for url: URL)
//    // Removes the image of the specified url in the cache
//    func removeImage(for url: URL)
//    // Removes all images from the cache
//    func removeAllImages()
//    // Accesses the value associated with the given key for reading and writing
//    subscript(_ url: URL) -> UIImage? { get set }
//}
//
//
//
//extension UIImage {
//
//    func decodedImage() -> UIImage {
//        guard let cgImage = cgImage else { return self }
//        let size = CGSize(width: cgImage.width, height: cgImage.height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        guard let decodedImage = context?.makeImage() else { return self }
//        return UIImage(cgImage: decodedImage)
//    }
//}
//
//final class ImageCache {
//
//    // 1st level cache, that contains encoded images
//    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.countLimit = config.countLimit
//        return cache
//    }()
//    // 2nd level cache, that contains decoded images
//    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.totalCostLimit = config.memoryLimit
//        return cache
//    }()
//    private let lock = NSLock()
//    private let config: Config
//
//    struct Config {
//        let countLimit: Int
//        let memoryLimit: Int
//
//        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
//    }
//
//    init(config: Config = Config.defaultConfig) {
//        self.config = config
//    }
//}
//
//
//
//extension ImageCache: ImageCacheType {
//    func insertImage(_ image: UIImage?, for url: URL) {
//        guard let image = image else { return removeImage(for: url) }
//        let decodedImage = image.decodedImage()
//
//        lock.lock(); defer { lock.unlock() }
//        imageCache.setObject(decodedImage, forKey: url as AnyObject)
//        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
//    }
//
//    func removeImage(for url: URL) {
//        lock.lock(); defer { lock.unlock() }
//        imageCache.removeObject(forKey: url as AnyObject)
//        decodedImageCache.removeObject(forKey: url as AnyObject)
//    }
//}
//
//
//
//extension ImageCache {
//    func image(for url: URL) -> UIImage? {
//        lock.lock(); defer { lock.unlock() }
//        // the best case scenario -> there is a decoded image
//        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
//            return decodedImage
//        }
//        // search for image data
//        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            let decodedImage = image.decodedImage()
//            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
//            return decodedImage
//        }
//        return nil
//    }
//}
//
//
//extension ImageCache {
//    subscript(_ key: URL) -> UIImage? {
//        get {
//            return image(for: key)
//        }
//        set {
//            return insertImage(newValue, for: key)
//        }
//    }
//}
//
//
//final class ImageLoader {
//    private let cache = ImageCache()
//
//    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
//        if let image = cache[url] {
//            return Just(image).eraseToAnyPublisher()
//        }
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { (data, response) -> UIImage? in return UIImage(data: data) }
//            .catch { error in return Just(nil) }
//            .handleEvents(receiveOutput: {[unowned self] image in
//                guard let image = image else { return }
//                self.cache[url] = image
//            })
//            .subscribe(on: backgroundQueue)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//
//}
