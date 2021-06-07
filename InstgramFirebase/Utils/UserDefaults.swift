//
//  UserDefaults.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 05/04/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//


import UIKit

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}



//struct Book: Codable {
//    var title: String
//    var authorName: String
//    var pageCount: Int
//}
//let playingItMyWay = Book(title: "Playing It My Way", authorName: "Sachin Tendulkar & Boria Mazumder", pageCount: 486)
//let userDefaults = UserDefaults.standard
//do {
//    try userDefaults.setObject(playingItMyWay, forKey: "MyFavouriteBook")
//} catch {
//    print(error.localizedDescription)
//}
//
//let userDefaults = UserDefaults.standard
//do {
//    let playingItMyWay = try userDefaults.getObject(forKey: "MyFavouriteBook", castTo: Book.self)
//    print(playingItMyWay)
//} catch {
//    print(error.localizedDescription)
//}
//
//// Output
//// Book(title: "Playing It My Way", authorName: "Sachin Tendulkar & Boria Mazumder", pageCount: 486)
