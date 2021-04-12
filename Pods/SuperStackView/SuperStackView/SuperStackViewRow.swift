//
//  SuperStackViewRow.swift
//  SuperStackView
//
//  Created by Himanshu Arora on 08/11/20.
//

import UIKit

/**
 * A row view that wraps every row in a super stack view.
 */
open class SuperStackViewRow: UIView {
    
    private var positionalTypes: [PositionalType]? = nil
    
    public init(contentView: UIView, positionalTypes: [PositionalType]?) {
        self.contentView = contentView
        self.positionalTypes = positionalTypes
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            insetsLayoutMarginsFromSafeArea = false
        }
        
        setUpViews()
        setUpConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Open
    
    open override var isHidden: Bool {
        didSet {
            guard isHidden != oldValue else { return }
            separatorView.alpha = isHidden ? 0 : 1
        }
    }
    
    open var rowBackgroundColor = UIColor.clear {
        didSet { backgroundColor = rowBackgroundColor }
    }
    
    open var rowInset: UIEdgeInsets {
        get { return layoutMargins }
        set { layoutMargins = newValue }
    }
    
    open var separatorAxis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            updateSeparatorAxisConstraints()
            updateSeparatorInset()
        }
    }
    
    open var separatorColor: UIColor {
        get { return separatorView.color }
        set { separatorView.color = newValue }
    }
    
    open var separatorWidth: CGFloat {
        get { return separatorView.width }
        set { separatorView.width = newValue }
    }
    
    /// Alias for `separatorWidth`. Maintained for backwards compatibility.
    open var separatorHeight: CGFloat {
        get { return separatorWidth }
        set { separatorWidth = newValue }
    }
    
    open var separatorInset: UIEdgeInsets = .zero {
        didSet { updateSeparatorInset() }
    }
    
    open var isSeparatorHidden: Bool {
        get { return separatorView.isHidden }
        set { separatorView.isHidden = newValue }
    }
    
    // MARK: Public
    
    public let contentView: UIView
    
    
    // Whether the separator should be hidden or not for this cell. Note that this doesn't always
    // reflect whether the separator is hidden or not, since, for example, the separator could be
    // hidden because it's the last row in the stack view and
    // `automaticallyHidesLastSeparator` is `true`.
    open var shouldHideSeparator = false
    
    // MARK: Private
    
    private let separatorView = SeparatorView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private var separatorTopConstraint: NSLayoutConstraint?
    private var separatorBottomConstraint: NSLayoutConstraint?
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var separatorTrailingConstraint: NSLayoutConstraint?
    
    private func setUpViews() {
        setUpSelf()
        setUpContentView()
        setUpSeparatorView()
    }
    
    private func setUpSelf() {
        clipsToBounds = true
    }
    
    private func setUpContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
    }
    
    private func setUpSeparatorView() {
        addSubview(separatorView)
    }
    
    private func setUpConstraints() {
        setUpContentViewConstraints()
        setUpSeparatorViewConstraints()
        updateSeparatorAxisConstraints()
    }
    
    private func setUpContentViewConstraints() {
        let leadingConstraint = contentView.leadingAnchor.constraint(equalTo:
                                                                        layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = contentView.trailingAnchor.constraint(equalTo:
                                                                        layoutMarginsGuide.trailingAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo:
                                                                    layoutMarginsGuide.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
        let topConstraint = contentView.topAnchor.constraint(equalTo:
                                                                layoutMarginsGuide.topAnchor)
        
        var constraints = [NSLayoutConstraint]()
        // general contraints
        constraints.append(contentsOf: [leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])

        if let positionalTypes = self.positionalTypes {
            var newConstraint: NSLayoutConstraint?
            
            for positionalType in positionalTypes {
                
                switch positionalType {
                case .top:
                    constraints = constraints.filter { $0 != bottomConstraint }
                    // this is now new bottom sheet constraint
                    newConstraint = contentView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor)
                case .bottom:
                    constraints = constraints.filter { $0 != topConstraint }
                    newConstraint = contentView.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor)
                case .centerY:
                    constraints = constraints.filter { $0 != topConstraint &&  $0 != bottomConstraint }
                    newConstraint = contentView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
                case .start:
                    constraints = constraints.filter { $0 != trailingConstraint }
                    newConstraint = contentView.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor)
                case .end:
                    constraints = constraints.filter { $0 != leadingConstraint }
                    newConstraint = contentView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor)
                case .centerX:
                    constraints = constraints.filter { $0 != leadingConstraint && $0 != trailingConstraint }
                    newConstraint = contentView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                }
                
            }
            
            if let contraint = newConstraint {
                constraints.append(contraint)
            }
            
            
        }

        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUpSeparatorViewConstraints() {
        separatorTopConstraint = separatorView.topAnchor.constraint(equalTo: topAnchor)
        separatorBottomConstraint = separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        separatorLeadingConstraint = separatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        separatorTrailingConstraint = separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
    }
    
    private func updateSeparatorAxisConstraints() {
        separatorTopConstraint?.isActive = separatorAxis == .vertical
        separatorBottomConstraint?.isActive = true
        separatorLeadingConstraint?.isActive = separatorAxis == .horizontal
        separatorTrailingConstraint?.isActive = true
    }
    
    private func updateSeparatorInset() {
        separatorTopConstraint?.constant = separatorInset.top
        separatorBottomConstraint?.constant = separatorAxis == .horizontal ? 0 : -separatorInset.bottom
        separatorLeadingConstraint?.constant = separatorInset.left
        separatorTrailingConstraint?.constant = separatorAxis == .vertical ? 0 : -separatorInset.right
    }
    
}
