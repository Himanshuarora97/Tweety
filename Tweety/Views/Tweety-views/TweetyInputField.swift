//
//  TweetyInputField.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

protocol TweetyInputFieldDelegate: class {
    func textFieldShouldReturn(_ inputView: TweetyInputField) -> Bool
}

class TweetyInputField: UIView {
    
    public lazy var inputField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.font = UIFont.semibold(size: 16)
        field.autocorrectionType = .no
        field.delegate = self
        field.autocapitalizationType = .none
        return field
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        return view
    }()
    
    weak var delegate: TweetyInputFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(inputField)
        addSubview(bottomLine)
    }
    
    private func setUpConstraints() {
        inputField.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        inputField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        inputField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomLine.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 6).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        bottomAnchor.constraint(equalTo: bottomLine.bottomAnchor).isActive = true
    }
    
    public func setPlaceholder(text: String, color: UIColor = UIColor.black.withAlphaComponent(0.6),
                               font: UIFont = .regular(size: 16)) {
        let textAttr: [NSMutableAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let textAttrString = NSMutableAttributedString(string: text , attributes: textAttr)
        inputField.attributedPlaceholder = textAttrString
    }
    
}

extension TweetyInputField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? false
    }
    
}
