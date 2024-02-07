//
//  AuthHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class AuthHeaderView: UIView {

    
    //MARK: UI Components
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Lifecycle
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        
        self.title.text = title
        self.subTitle.text = subTitle
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        
    }
}
