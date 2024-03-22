//
//  DetailInfoAnimeController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import UIKit

class DetailInfoAnimeController: UIViewController {
    
    //MARK: - Variables
    var vm: DetailInfoAnimeVM!
    
    var viewsAreHidden: Bool = false {
        didSet {
            //            closeButton.isHidden = viewsAreHidden
            //            cardView?.isHidden = viewsAreHidden
            //            textLabel.isHidden = viewsAreHidden
            UIView.animate(withDuration: 0.6) {
                self.imageV.isHidden = self.viewsAreHidden
                self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
            }
        }
    }
    
    //MARK: - UI Components
    private let imageV: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        imageV.setImageFromStringrURL(stringUrl: vm.anime.coverImage?.extraLarge ?? "")
        setupUI()
        print("I am here")
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(imageV)
        imageV.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imageV.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            imageV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            imageV.heightAnchor.constraint(equalToConstant: 400),
            imageV.widthAnchor.constraint(equalToConstant: 275)
        ])
    }
}
