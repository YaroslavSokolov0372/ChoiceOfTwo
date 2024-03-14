//
//  CustomTagsView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class CustomTagsView: UIView {

    //MARK: Variables
    var tagViews: [CustomTagView] = []
    var numberOfRows = 2
    var tags: [String] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            tagViews = []
            var totalWidth: CGFloat = 0
            tags.forEach { str in
                let tagV = CustomTagView()
                tagV.text = str
//                let size = tagV.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let size = str.size(withAttributes: [NSAttributedString.Key.font: UIFont.nunitoFont(size: 15, type: .regular)!])
                tagV.setupUI(textSize: size)
                totalWidth += size.width
                tagViews.append(tagV)
            }
            let rowWidth: CGFloat = totalWidth / CGFloat(numberOfRows)
            
            var iTag: Int = 0
            while iTag < tagViews.count {
                // create a new "row" horizontal stack view
                let vSV = UIStackView()
                vSV.spacing = 8
                stackView.addArrangedSubview(vSV)
                var cw: CGFloat = 0
                // add tag views
                while cw < rowWidth, iTag < tagViews.count {
                    let t = tagViews[iTag]
                    let sz = t.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    vSV.addArrangedSubview(t)
                    cw += sz.width
                    iTag += 1
                }
            }
        }
    }

    //MARK: - UI Components
    let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 8
        v.alignment = .leading
        return v
    }()
    let scrollView = UIScrollView()

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
//        self.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        scrollView.addSubview(stackView)
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
}
