//
//  ViewController.swift
//  myMovieDataBase
//
//  Created by Linardos Paschopoulos on 27/1/23.
//

import UIKit
import Alamofire
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var loadDataFromCall = true
    var myMoviesModel: [MovieModel]?
    var myMoviesDeviceModel: [MovieDeviceModel]?
    var genres = Set<String>()
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Series"
        let textAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = .white
        
        let nib1 = UINib.init(nibName: GenreTableViewCell.cellId, bundle: nil)
        
        self.tableView.register(nib1, forCellReuseIdentifier:  GenreTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        fetchData(url: "https://api.tvmaze.com/shows?fbclid=IwAR2RFhaxaktLBvQ7rV1OTq47psl5ke3zUxcG9isnnsBsISJKpDfTSP4rI18")
    }
    
    func fetchData(url: String) {
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { [self] response in
            switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode([MovieApiModel].self, from: data!)

                        self.loadDataFromCall = true
                        self.movieApiModelToMovieModel(movieApiModel: jsonData)
                        self.saveDataToDevice()
                        self.tableView.reloadData()
                    } catch {
                        print(error.localizedDescription)
                        self.loadDataFromCall = false
                        self.loadDataFromDevice()
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.loadDataFromCall = false
                    self.loadDataFromDevice()
                    self.tableView.reloadData()
            }
        }
    }
    
    func movieApiModelToMovieModel(movieApiModel: [MovieApiModel]) {
        var tempMovieArray = [MovieModel]()
        
        for movie in movieApiModel {
            var tempMovie = MovieModel()
            
            tempMovie.name = movie.name
            tempMovie.url = movie.url
            tempMovie.rating = movie.rating?["average"] ?? 0.0
            tempMovie.summary = movie.summary
            tempMovie.premiered = movie.premiered
            tempMovie.ended = movie.ended
            tempMovie.genres = movie.genres

            guard let url = URL(string: (movie.image?["medium"] ?? "") ?? "") else {
                return
            }
            
            if let data = try? Data(contentsOf: url) {
                tempMovie.image = UIImage(data: data)
            }

            tempMovieArray.append(tempMovie)
        }
        
        self.myMoviesModel = tempMovieArray
    }
    
    func saveDataToDevice() {
        do {
            self.realm.beginWrite()
            self.realm.delete(realm.objects(MovieDeviceModel.self))

            self.myMoviesModel?.forEach({ movie in
                let movieDeviceModel = MovieDeviceModel()

                movieDeviceModel.name = movie.name ?? ""
                if let rating = movie.rating {
                    movieDeviceModel.rating = String(format: "Rating: %.1f", rating)
                } else {
                    movieDeviceModel.rating = "Rating: not available"
                }
                movieDeviceModel.url = movie.url ?? "not available"
                movieDeviceModel.summary = movie.summary ?? ""
                movieDeviceModel.premiered = movie.premiered ?? ""
                movieDeviceModel.ended = movie.ended ?? "not available"
                movieDeviceModel.imageOnDevice = movie.image?.jpegData(compressionQuality: 1.0) as NSData? ?? NSData()
                movie.genres?.forEach({ genre in
                    let movieDeviceGenreModel = MovieDeviceGenreModel()
                    
                    movieDeviceGenreModel.genreName = genre
                    movieDeviceModel.genres.append(movieDeviceGenreModel)
                    self.genres.insert(genre)
                })
                
                self.realm.add(movieDeviceModel)
            })

            try self.realm.commitWrite()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func loadDataFromDevice() {
        let results = realm.objects(MovieDeviceModel.self)
        let movieDeviceModelArray = results.toArray(ofType: MovieDeviceModel.self)
        var moviesDeviceArray = [MovieDeviceModel]()

        for movie in movieDeviceModelArray {
            let tempMovieDeviceModel = MovieDeviceModel()

            tempMovieDeviceModel.name = movie.name
            tempMovieDeviceModel.rating = movie.rating
            tempMovieDeviceModel.summary = movie.summary
            tempMovieDeviceModel.url = movie.url
            tempMovieDeviceModel.premiered = movie.premiered
            tempMovieDeviceModel.imageOnDevice = movie.imageOnDevice
            tempMovieDeviceModel.ended = movie.ended
            tempMovieDeviceModel.genres = movie.genres
            
            tempMovieDeviceModel.genres.forEach({genre in
                self.genres.insert(genre.genreName)
            })
            
            moviesDeviceArray.append(tempMovieDeviceModel)
        }

        self.myMoviesDeviceModel = moviesDeviceArray
        self.tableView.reloadData()
    }
    
    @IBAction func refreshView(_ sender: Any) {
        self.fetchData(url: "https://api.tvmaze.com/shows?fbclid=IwAR2RFhaxaktLBvQ7rV1OTq47psl5ke3zUxcG9isnnsBsISJKpDfTSP4rI18")
    }
}

extension ViewController: MovieTableViewCellDelegate {
    func showMovieDetails(indexPath: Int) {
        if loadDataFromCall {
            if let movie = myMoviesModel?[indexPath] {
                let movieDetailViewController = MovieDetailsViewController(movie: movie.name, officialSite: movie.url ,premiere: movie.premiered, summary: movie.summary, ended: movie.ended)
                
                navigationController?.pushViewController(movieDetailViewController, animated: true)
            } else {
                // showAlert()
            }
        } else {
            if let movie = myMoviesDeviceModel?[indexPath] {
                let movieDetailViewController = MovieDetailsViewController(movie: movie.name, officialSite: movie.url ,premiere: movie.premiered, summary: movie.summary, ended: movie.ended)
                
                navigationController?.pushViewController(movieDetailViewController, animated: true)
            } else {
                // showAlert()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.cellId) as! GenreTableViewCell
        
        if self.loadDataFromCall {
            if let movies = myMoviesModel {
                cell.updateWithMovieModel(movieArray: movies, genre: Array(genres)[indexPath.row], loadDataFromCall: loadDataFromCall)
            }
        } else {
            if let movies = myMoviesDeviceModel {
                cell.updateWithMovieDeviceModel(movieArray: movies, genre: Array(genres)[indexPath.row], loadDataFromCall: loadDataFromCall)
            }
        }
        
        return cell
    }
}
