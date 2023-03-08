//
//  GenreTableViewCell.swift
//  Series
//
//  Created by Linardos Paschopoulos on 8/3/23.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
