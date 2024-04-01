//
//  MatchDetailController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import UIKit

class MatchDetailController: UIViewController, AnimeCardWithLabelPotocol {
    
    
    
    //MARK: - Variables
    var vm: MatchDetailVM!
    
    //MARK: - UI Components
    
    //    private let backButton = CustomButton(text: "Close", type: .medium, strokeColor: .mainPurple)
    private let backButton = CustomCircleButton(rotate: 1, stroke: true)
    private let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.contentInsetAdjustmentBehavior = .never
        scrollV.backgroundColor = .white
        scrollV.showsVerticalScrollIndicator = false
        return scrollV
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let genresHeader = CustomSectionHeaderView(headerName: "Genres")
    private let genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(TagCellView.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    private let formatsHeader = CustomSectionHeaderView(headerName: "Formats")
    private let formatsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(TagCellView.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    private let matchedHeader = CustomSectionHeaderView(headerName: "Matched")
    private let matchedAnimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(AnimeCardWithLabelViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    private let skippedHeader = CustomSectionHeaderView(headerName: "Skipped")
    private let skippedAnimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(AnimeCardWithLabelViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        formatsCollectionView.dataSource = self
        formatsCollectionView.delegate = self
        matchedAnimeCollectionView.delegate = self
        matchedAnimeCollectionView.dataSource = self
        skippedAnimeCollectionView.delegate = self
        skippedAnimeCollectionView.dataSource = self
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(genresHeader)
        genresHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(genresCollectionView)
        genresCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(formatsHeader)
        formatsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(formatsCollectionView)
        formatsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(matchedHeader)
        matchedHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(matchedAnimeCollectionView)
        matchedAnimeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(skippedHeader)
        skippedHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(skippedAnimeCollectionView)
        skippedAnimeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1020),
            
            backButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            genresHeader.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            genresHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            genresHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            genresHeader.heightAnchor.constraint(equalToConstant: 25),
            
            genresCollectionView.topAnchor.constraint(equalTo: genresHeader.bottomAnchor, constant: 10),
            genresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genresCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            formatsHeader.topAnchor.constraint(equalTo: genresCollectionView.bottomAnchor, constant: 15),
            formatsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            formatsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            formatsHeader.heightAnchor.constraint(equalToConstant: 25),
            
            formatsCollectionView.topAnchor.constraint(equalTo: formatsHeader.bottomAnchor, constant: 10),
            formatsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formatsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formatsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            matchedHeader.topAnchor.constraint(equalTo: formatsCollectionView.bottomAnchor, constant: 15),
            matchedHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            matchedHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            matchedHeader.heightAnchor.constraint(equalToConstant: 30),
            
            matchedAnimeCollectionView.topAnchor.constraint(equalTo: matchedHeader.bottomAnchor, constant: 15),
            matchedAnimeCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            matchedAnimeCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            matchedAnimeCollectionView.heightAnchor.constraint(equalToConstant: 290),
            
            skippedHeader.topAnchor.constraint(equalTo: matchedAnimeCollectionView.bottomAnchor, constant: 15),
            skippedHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            skippedHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            skippedHeader.heightAnchor.constraint(equalToConstant: 30),
            
            skippedAnimeCollectionView.topAnchor.constraint(equalTo: skippedHeader.bottomAnchor, constant: 15),
            skippedAnimeCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skippedAnimeCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            skippedAnimeCollectionView.heightAnchor.constraint(equalToConstant: 290),
        ])
    }
    
    //MARK: - Selectors
    @objc private func backButtonTapped() {
        vm.dismiss()
    }
    
    //MARK: - Delegate
    func didTapCell(with anime: Anime) {
        print("I am here")
        vm.goToDetail(anime: anime)
    }
}


extension MatchDetailController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == genresCollectionView {
            if vm.match.genres.count == 0 {
                return 1
            } else {
                return vm.match.genres.count
            }
        } else if collectionView == formatsCollectionView {
            if vm.match.formats.count == 0 {
                return 1
            } else {
                return vm.match.formats.count
            }
        } else if collectionView == matchedAnimeCollectionView {
             return vm.match.matched.count
        } else {
            return vm.match.skipped.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView {
            let size: CGSize = vm.match.genres[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: UIFont.nunitoFont(size: 15, type: .regular)!])
            return CGSize(width: size.width + 20, height: size.height + 20)
        } else if collectionView == formatsCollectionView {
            let size: CGSize = vm.match.formats[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: UIFont.nunitoFont(size: 15, type: .regular)!])
            return CGSize(width: size.width + 20, height: size.height + 20)
        } else {
            let size = CGSize(width: view.frame.width * 0.44, height: 290)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView != matchedAnimeCollectionView, collectionView != skippedAnimeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TagCellView else {
                fatalError("Failed to dequeue with TagCellView")
            }
            
            if collectionView == genresCollectionView {
                if vm.match.genres.count == 0 {
                    cell.configure(with: "None")
                    return cell
                } else {
                    cell.configure(with: vm.match.genres[indexPath.row])
                    return cell
                }
            } else {
                if vm.match.formats.count == 0 {
                    cell.configure(with: "None")
                    return cell
                } else {
                    cell.configure(with: vm.match.formats[indexPath.row])
                    return cell
                }
            }
        } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimeCardWithLabelViewCell else {
                    fatalError("Failed to dequeue with AnimeCardWithLabelViewCell")
                }
                
            if collectionView == matchedAnimeCollectionView {
                cell.configure(with: vm.match.matched[indexPath.row])
                cell.delegate = self
                return cell
            } else {
                cell.configure(with: vm.match.skipped[indexPath.row])
                cell.delegate = self
                return cell
            }
        }
    }
}
