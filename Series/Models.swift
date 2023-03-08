//
//  ProjectClasses.swift
//  myMovieDataBase
//
//  Created by Linardos Paschopoulos on 27/1/23.
//

import UIKit
import RealmSwift

struct MovieApiModel: Codable {
    var name: String?
    var rating: [String : Double?]?
    var image: [String : String?]?
    var url: String?
    var summary: String?
    var premiered: String?
    var ended: String?
    var genres: [String]?
}

struct MovieModel {
    var name: String?
    var rating: Double?
    var image: UIImage?
    var url: String?
    var summary: String?
    var premiered: String?
    var ended: String?
    var genres: [String]?
}

class MovieDeviceModel: Object {
    @objc dynamic var name: String = String()
    @objc dynamic var rating: String = String()
    @objc dynamic var imageOnDevice: NSData = NSData()
    @objc dynamic var url: String = String()
    @objc dynamic var summary: String = String()
    @objc dynamic var premiered: String = String()
    @objc dynamic var ended: String = String()
    var genres = List<MovieDeviceGenreModel>()
}

class MovieDeviceGenreModel: Object {
    @objc dynamic var genre: String = String()
}
