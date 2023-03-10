//
//  GenreTableViewCell.swift
//  Series
//
//  Created by Linardos Paschopoulos on 8/3/23.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadDataFromCall = true
    var myMoviesModel = [MovieModel]()
    var myMoviesDeviceModel = [MovieDeviceModel]()
    static let cellId = "GenreTableViewCell"

    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let nib1 = UINib.init(nibName:  MovieCollectionViewCell.cellId, bundle: nil)
        self.collectionView.register(nib1, forCellWithReuseIdentifier:  MovieCollectionViewCell.cellId)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateWithMovieModel(movieArray: [MovieModel], genre: String, loadDataFromCall: Bool) {
        self.genreLabel.text = genre
        self.loadDataFromCall = loadDataFromCall
        
        movieArray.forEach({movie in
            if let genres = movie.genres {
                if genres.contains(genre) {
                    self.myMoviesModel.append(movie)
                }
            }
        })
        
        self.collectionView.reloadData()
    }
    
    func updateWithMovieDeviceModel(movieArray: [MovieDeviceModel], genre: String, loadDataFromCall: Bool) {
        self.genreLabel.text = genre
        self.loadDataFromCall = loadDataFromCall
        
        movieArray.forEach({ movie in
            let movieDeviceGenreModel = MovieDeviceGenreModel()
            
            movieDeviceGenreModel.genreName = genre
            if movie.genres.contains(movieDeviceGenreModel) {
                self.myMoviesDeviceModel.append(movie)
            }
        })
        
        self.collectionView.reloadData()
    }
}

extension GenreTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.loadDataFromCall {
            return self.myMoviesModel.count
        } else {
            return self.myMoviesDeviceModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.cellId, for: indexPath) as! MovieCollectionViewCell
    
        if self.loadDataFromCall {
            cell.update(movieData: myMoviesModel[indexPath.row], indexPath: indexPath.row, delegate: self)
        } else {
            cell.update(movieData: myMoviesDeviceModel[indexPath.row], indexPath: indexPath.row, delegate: self)
        }
        
        return cell
    }
}

extension GenreTableViewCell: MovieCollectionViewCellDelegate {
    func showMovieDetails(indexPath: Int) {
        func showMovieDetails(indexPath: Int) {
            if loadDataFromCall {
                let movieDetailViewController = MovieDetailsViewController(movie: myMoviesModel[indexPath].name, officialSite: myMoviesModel[indexPath].url ,premiere: myMoviesModel[indexPath].premiered, summary: myMoviesModel[indexPath].summary, ended: myMoviesModel[indexPath].ended)
                    print("ONE OF THESE DAYS...")
                    // navigationController?.pushViewController(movieDetailViewController, animated: true)

            } else {

                    let movieDetailViewController = MovieDetailsViewController(movie: myMoviesDeviceModel[indexPath].name, officialSite: myMoviesDeviceModel[indexPath].url ,premiere: myMoviesDeviceModel[indexPath].premiered, summary: myMoviesDeviceModel[indexPath].summary, ended: myMoviesDeviceModel[indexPath].ended)
                    print("ONE OF THESE DAYS...")
                    // navigationController?.pushViewController(movieDetailViewController, animated: true)

            }
        }
    }
}
