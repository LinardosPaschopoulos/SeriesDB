//
//  MovieCollectionViewCell.swift
//  Series
//
//  Created by Linardos Paschopoulos on 8/3/23.
//

import UIKit
import RealmSwift

protocol MovieCollectionViewCellDelegate: AnyObject {
    func showMovieDetails(indexPath: Int)
}

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    weak var delegate: MovieCollectionViewCellDelegate?
    private var rowOfIndexPath: Int?
    static let cellId = "MovieCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(movieData: MovieModel?, indexPath: Int, delegate: MovieCollectionViewCellDelegate) {
        self.backgroundColor = .white
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
    
    func update(movieData: MovieDeviceModel?, indexPath: Int, delegate: MovieCollectionViewCellDelegate) {
        self.backgroundColor = .white
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
