//
//  MovieDetailsViewController.swift
//  myMovieDataBase
//
//  Created by Linardos Paschopoulos on 28/1/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var premierLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var endedLabel: UILabel!
    
    private var movie: String?
    private var link: String?
    private var premiere: String?
    private var summary: String?
    private var ended: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(buttonTappedAction(_:)))
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.image = UIImage(named: "Back_button")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.movieLabel.text = self.movie
        if let link = self.link {
            let text = "Official site: \(link)"
            self.linkLabel.labelColorChange(text: text, color: UIColor.blue, from: 15, length: text.count - 16)
            
            if link != "not available" {
                let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
                
                linkLabel.isUserInteractionEnabled = true
                linkLabel.addGestureRecognizer(guestureRecognizer)
            }
        } else {
            self.linkLabel.text = "Official site: not available"
        }
        
        self.premierLabel.text = "Premiered: \(premiere ?? "not available")"
        self.endedLabel.text = "Ended: \(ended ?? "not available")"
 
        let htmlString = summary
        
        guard let data = htmlString?.data(using: .utf8)! else { return }
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        self.summaryLabel.attributedText = attributedString
        self.summaryLabel.font = UIFont(name: self.summaryLabel.font.description, size: 18.0)
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    init(movie: String?, officialSite: String?, premiere: String?, summary: String?, ended: String?) {
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
        self.movie = movie
        self.link = officialSite
        self.premiere = premiere
        self.summary = summary
        self.ended = ended
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func labelClicked(_ sender: Any) {
        if let link = self.link {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }
    }

    @objc func buttonTappedAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
