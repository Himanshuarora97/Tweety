//
//  SuperStackView.swift
//  SuperStackView
//
//  Created by Himanshu Arora on 08/11/20.
//

import UIKit

public enum PositionalType: Int {
    case top
    case bottom
    case centerX
    case centerY
    case start
    case end
}

open class SuperStackView: UIView {
    
    open var stack = UIStackView()
    
    open var rowInset: UIEdgeInsets = .zero
    
    open var rowsCount: Int {
        get {
            stack.arrangedSubviews.count
        }
    }
    
    open var rowBackgroundColor = UIColor.clear
    
    
    public init() {
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.addSubview(stack)
    }
    
    private func setUpConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    // MARK: Styling Separators
    
    /// The color of separators in the stack view.
    ///
    /// The default color matches the default color of separators in `UITableView`.
    open var separatorColor = UITableView().separatorColor ?? .clear {
        didSet {
            for case let cell as SuperStackViewRow in stack.arrangedSubviews {
                cell.separatorColor = separatorColor
            }
        }
    }
    
    /// The width (or thickness) of separators in the stack view.
    ///
    /// The default width is 1px.
    open var separatorWidth: CGFloat = 1 / UIScreen.main.scale {
        didSet {
            for case let cell as SuperStackView in stack.arrangedSubviews {
                cell.separatorWidth = separatorWidth
            }
        }
    }
    
    /// The height of separators in the stack view.
    ///
    /// This property is the same as `separatorWidth` and is maintained for backwards compatibility.
    ///
    /// The default height is 1px.
    open var separatorHeight: CGFloat {
        get { return separatorWidth }
        set { separatorWidth = newValue }
    }
    
    /// Specifies the default inset of row separators.
    ///
    /// Only left and right insets are honored when `axis` is `.vertical`, and only top and bottom
    /// insets are honored when `axis` is `.horizontal`. This inset will be used for any new row that
    /// is added to the stack view. The default left and right insets match the default inset of cell
    /// separators in `UITableView`, which are 15pt on the left and 0pt on the right. The default top
    /// and bottom insets are 0pt.
    open var separatorInset: UIEdgeInsets = UITableView().separatorInset
    
    /// Sets the separator inset for the given row to the `UIEdgeInsets` provided.
    ///
    /// Only left and right insets are honored.
    open func setSeparatorInset(forRow row: UIView, inset: UIEdgeInsets) {
        (row.superview as? SuperStackViewRow)?.separatorInset = inset
    }
    
    /// Sets the separator inset for the given rows to the `UIEdgeInsets` provided.
    ///
    /// Only left and right insets are honored.
    open func setSeparatorInset(forRows rows: [UIView], inset: UIEdgeInsets) {
        rows.forEach { setSeparatorInset(forRow: $0, inset: inset) }
    }
    
    // MARK: Hiding and Showing Separators
    
    /// Specifies the default visibility of row separators.
    ///
    /// When `true`, separators will be hidden for any new rows added to the stack view.
    /// When `false, separators will be visible for any new rows added. Default is `false`, meaning
    /// separators are visible for any new rows that are added.
    open var hidesSeparatorsByDefault = false
    
    /// Hides the separator for the given row.
    open func hideSeparator(forRow row: UIView) {
        if let cell = row.superview as? SuperStackViewRow {
            cell.shouldHideSeparator = true
            updateSeparatorVisibility(forCell: cell)
        }
    }
    
    /// Hides separators for the given rows.
    open func hideSeparators(forRows rows: [UIView]) {
        rows.forEach { hideSeparator(forRow: $0) }
    }
    
    /// Shows the separator for the given row.
    open func showSeparator(forRow row: UIView) {
        if let cell = row.superview as? SuperStackViewRow {
            cell.shouldHideSeparator = false
            updateSeparatorVisibility(forCell: cell)
        }
    }
    
    /// Shows separators for the given rows.
    open func showSeparators(forRows rows: [UIView]) {
        rows.forEach { showSeparator(forRow: $0) }
    }
    
    /// Automatically hides the separator of the last cell in the stack view.
    ///
    /// Default is `false`.
    open var automaticallyHidesLastSeparator = false {
        didSet {
            if let cell = stack.arrangedSubviews.last as? SuperStackViewRow {
                updateSeparatorVisibility(forCell: cell)
            }
        }
    }
    
    
    
    // MARK: Add and remove Row Functions
    open func addRow(_ row: UIView, animated: Bool = false, positionalTypes: [PositionalType]? = nil) {
        insertRow(withContentView: row, atIndex: stack.arrangedSubviews.count, animated: animated, positionalTypes: positionalTypes)
    }
    
    open func addRow(_ row: UIView, animated: Bool = false, inset: UIEdgeInsets, positionalTypes: [PositionalType]? = nil) {
        insertRow(withContentView: row, atIndex: stack.arrangedSubviews.count, animated: animated, positionalTypes: positionalTypes)
        setInset(forRow: row, inset: inset)
    }
    
    open func addRows(_ rows: [UIView], animated: Bool = false) {
        rows.forEach { addRow($0, animated: animated) }
    }
    
    open func addRows(_ rows: [UIView], animated: Bool = false, inset: UIEdgeInsets) {
        rows.forEach { addRow($0, animated: animated, inset: inset) }
    }
    
    /// Returns `true` if the given row is present in the stack view, `false` otherwise
    open func containsRow(_ row: UIView) -> Bool {
        guard let cell = row.superview as? SuperStackViewRow else { return false }
        return stack.arrangedSubviews.contains(cell)
    }
    
    // MARK: Hiding and Showing Rows
    
    open func hideRow(_ row: UIView, animated: Bool = false) {
        setRowHidden(row, isHidden: true, animated: animated)
    }
    
    open func hideRows(_ rows: [UIView], animated: Bool = false) {
        rows.forEach { hideRow($0, animated: animated) }
    }
    
    open func showRow(_ row: UIView, animated: Bool = false) {
        setRowHidden(row, isHidden: false, animated: animated)
    }
    
    open func showRows(_ rows: [UIView], animated: Bool = false) {
        rows.forEach { showRow($0, animated: animated) }
    }
    
    /// Hides the given row if `isHidden` is `true`, or shows the given row if `isHidden` is `false`.
    ///
    /// If `animated` is `true`, the change is animated.
    open func setRowHidden(_ row: UIView, isHidden: Bool, animated: Bool = false) {
        guard let cell = row.superview as? SuperStackViewRow else { return }
        // if property doesn't change don't do anything
        if cell.isHidden == isHidden {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 1,
                           options: [],
                           animations: {
                            cell.isHidden = isHidden
                            self.layoutIfNeeded()
                           },
                           completion: nil)
        } else {
            cell.isHidden = isHidden
        }
    }
    
    /// Hides the given rows if `isHidden` is `true`, or shows the given rows if `isHidden` is
    /// `false`.
    ///
    /// If `animated` is `true`, the change are animated.
    open func setRowsHidden(_ rows: [UIView], isHidden: Bool, animated: Bool = false) {
        rows.forEach { setRowHidden($0, isHidden: isHidden, animated: animated) }
    }
    
    /// Returns `true` if the given row is hidden, `false` otherwise.
    open func isRowHidden(_ row: UIView) -> Bool {
        return (row.superview as? SuperStackViewRow)?.isHidden ?? false
    }
    
    private func insertRow(withContentView contentView: UIView, atIndex index: Int,
                           animated: Bool, positionalTypes: [PositionalType]?) {
        
        let cell = createRow(withContentView: contentView, positionalTypes: positionalTypes)
        stack.insertArrangedSubview(cell, at: index)
        
        updateSeparatorVisibility(forCell: cell)
        
        if let prevCell = cellAbove(cell: cell) {
            updateSeparatorVisibility(forCell: prevCell)
        }
        
        if animated {
            cell.alpha = 0
            layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                cell.alpha = 1
            }
        }
    }
    
    private func createRow(withContentView contentView: UIView, positionalTypes: [PositionalType]?) -> SuperStackViewRow {
        let cell = cellForRow(contentView, positionalTypes: positionalTypes)
        cell.rowBackgroundColor = rowBackgroundColor
        cell.rowInset = rowInset
        cell.separatorAxis = stack.axis == .horizontal ? .vertical : .horizontal
        cell.separatorColor = separatorColor
        cell.separatorHeight = separatorHeight
        cell.separatorInset = separatorInset
        cell.shouldHideSeparator = hidesSeparatorsByDefault
        return cell
    }
    
    open func cellForRow(_ row: UIView, positionalTypes: [PositionalType]?) -> SuperStackViewRow {
        let view = SuperStackViewRow(contentView: row, positionalTypes: positionalTypes)
        return view
    }
    
    /// Sets the inset for the given row to the `UIEdgeInsets` provided.
    open func setInset(forRow row: UIView, inset: UIEdgeInsets) {
        (row.superview as? SuperStackViewRow)?.rowInset = inset
    }
    
    open func setBackgroundColor(forRow row: UIView, color: UIColor) {
        (row.superview as? SuperStackViewRow)?.rowBackgroundColor = color
    }
    
    private func updateSeparatorVisibility(forCell cell: SuperStackViewRow) {
        let isLastCellAndHidingIsEnabled = automaticallyHidesLastSeparator &&
            cell === stack.arrangedSubviews.last
        cell.isSeparatorHidden =
            isLastCellAndHidingIsEnabled || cell.shouldHideSeparator
    }
    
    open func getRowAtIndex(_ index: Int) -> UIView? {
        if let row = stack.arrangedSubviews[index] as? SuperStackViewRow {
            return row.contentView
        }
        return nil
    }
    
    open func getView(for row: UIView) -> UIView? {
        return row.superview as? SuperStackViewRow
    }
    
    private func cellAbove(cell: SuperStackViewRow) -> SuperStackViewRow? {
        #if swift(>=5.0)
        guard let index = stack.arrangedSubviews.firstIndex(of: cell), index > 0 else { return nil }
        #else
        guard let index = stack.arrangedSubviews.index(of: cell), index > 0 else { return nil }
        #endif
        return stack.arrangedSubviews[index - 1] as? SuperStackViewRow
    }
    
}
