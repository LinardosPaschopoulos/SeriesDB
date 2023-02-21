//
//  MovieTableViewCell.swift
//  myMovieDataBase
//
//  Created by Linardos Paschopoulos on 27/1/23.
//

import UIKit
import RealmSwift

protocol MovieTableViewCellDelegate: AnyObject {
    func showMovieDetails(indexPath: Int)
}

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    weak var delegate: MovieTableViewCellDelegate?
    private var rowOfIndexPath: Int?
    static let cellId = "MovieTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(movieData: MovieModel?, indexPath: Int, delegate: MovieTableViewCellDelegate) {
        self.backgroundColor = .white
        self.selectionStyle = .none

        self.rowOfIndexPath = indexPath
        self.delegate = delegate
        self.nameLabel.text = movieData?.name
        self.movieImageView.image = movieData?.image
        if let rating = movieData?.rating {
            self.ratingLabel.text = "Rating: \(String(format: "%.1f", rating))"
        } else {
            self.ratingLabel.text = "Rating: not available"
        }
    }
    
    func update(movieData: MovieDeviceModel?, indexPath: Int, delegate: MovieTableViewCellDelegate) {
        self.backgroundColor = .white
        self.selectionStyle = .none

        self.rowOfIndexPath = indexPath
        self.delegate = delegate
        self.nameLabel.text = movieData?.name
        if let imageData = movieData?.imageOnDevice {
            self.movieImageView.image = UIImage(data: imageData as Data)
        }
        self.ratingLabel.text = movieData?.rating
    }
    
    @IBAction func showDetailsButtonPressed(_ sender: Any) {
        self.delegate?.showMovieDetails(indexPath: rowOfIndexPath ?? 0)
    }
}
//
//infix operator ???: NilCoalescingPrecedence
//
//public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
//    switch optional {
//        case let value?: return String(describing: value)
//        case nil: return defaultValue()
//    }
//}
