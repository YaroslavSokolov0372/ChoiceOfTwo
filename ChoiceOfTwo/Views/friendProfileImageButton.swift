//
//  AddFriendsPlusButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class friendProfileImageButton: UIButton {

    
    //MARK: -Lifecycle
    init(imageSize: CGSize? = nil, image: String) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.plain()
        let im = UIImage(named: image)!.withRenderingMode(.alwaysTemplate)
        configuration.background.strokeColor = .mainPurple
        configuration.baseForegroundColor = .mainPurple
        configuration.background.cornerRadius = 30
        configuration.image = im
        self.configuration = configuration
        self.clipsToBounds = true
        self.tintColor = .mainPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
