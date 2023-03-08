//
//  Extensions.swift
//  myMovieDataBase
//
//  Created by Linardos Paschopoulos on 28/1/23.
//

import UIKit
import Realm
import RealmSwift

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

extension UILabel {
    func labelColorChange(text: String, color: UIColor, from start: Int, length: Int) {
        let myMutableString = NSMutableAttributedString(string: text)
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: start, length: length))
        self.attributedText = myMutableString
    }
}
