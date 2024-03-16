//
//  CustomTagsView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

protocol CustomTagsViewDelegate {
    func customTagsView(_ customTagsView: CustomTagsView, enumType: StringRepresentable, didSelectItemAt index: Int)
    func customTagsView(_ customTagsView: CustomTagsView, enumType: StringRepresentable, didDeSelectItemAt index: Int)
}

class CustomTagsView: UIView {

    //MARK: Variables
    public var delegate: CustomTagsViewDelegate?
    var tagViews: [CustomTagView] = []
    var numberOfRows = 2
    var tags: [StringRepresentable] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            tagViews = []
            var totalWidth: CGFloat = 0
            tags.forEach { str in
                let tagV = CustomTagView()
                tagV.text = str.rawValue
                tagV.enumType = str
                let size = str.rawValue.size(withAttributes: [NSAttributedString.Key.font: UIFont.nunitoFont(size: 15, type: .regular)!])
                tagV.setupUI(textSize: size)
                totalWidth += size.width
                tagViews.append(tagV)
            }
            
            let rowWidth: CGFloat = totalWidth / CGFloat(numberOfRows)
            var iTag: Int = 0
            while iTag < tagViews.count {
                let vSV = UIStackView()
                vSV.spacing = 8
                stackView.addArrangedSubview(vSV)
                var cw: CGFloat = 0
                while cw < rowWidth, iTag < tagViews.count {
                    let t = tagViews[iTag]
                    let sz = t.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    vSV.addArrangedSubview(t)
                    cw += sz.width
                    iTag += 1
                }
            }
            
            tagViews.forEach { tv in
                tv.selectChanged = { [weak self] theTagView in
                    guard let self = self,
                          let idx = self.tagViews.firstIndex(of: theTagView)
                    else { return }
                    self.delegate?.customTagsView(self, enumType: tv.enumType, didSelectItemAt: idx)
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
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
}
