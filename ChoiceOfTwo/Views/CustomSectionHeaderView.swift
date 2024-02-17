//
//  CustomSectionHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 16/02/2024.
//

import UIKit

class CustomSectionHeaderView: UILabel {


    
    //MARK: - Lifecycle
    init(headerName: String) {
        super.init(frame: .zero)
        self.text = headerName
        self.textColor = .mainPurple
        self.font = .nunitoFont(size: 25, type: .light)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
