//
//  CalendarMonthView.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/18.
//

import UIKit

class CalendarMonthView: UICollectionView {
 
    var lineView = LineView()
    var monthDelegate: MonthDelegate?
    @IBInspectable public var isHiddenOtherMonth: Bool = false
    
    // Layout properties
    @IBInspectable public var sectionSpace: CGFloat = 1.5 {
        didSet {
            sectionSeparator.frame.size.height = sectionSpace
        }
    }
    @IBInspectable public var cellSpace: CGFloat = 0.5 {
        didSet {
            if let layout = collectionViewLayout as? MonthLayout, layout.cellSpace != cellSpace {
                setCollectionViewLayout(self.layout, animated: false)
            }
        }
    }
    @IBInspectable public var weekCellHeight: CGFloat = 25 {
        didSet {
            sectionSeparator.frame.origin.y = inset.top + weekCellHeight
            if let layout = collectionViewLayout as? MonthLayout, layout.weekCellHeight != weekCellHeight {
                setCollectionViewLayout(self.layout, animated: false)
            }
        }
    }
    @IBInspectable public var circularViewDiameter: CGFloat = 0.75 {
        didSet {
            reloadData()
        }
    }
    
    public var inset: UIEdgeInsets = .zero {
        didSet {
            if let layout = collectionViewLayout as? MonthLayout, layout.inset != inset {
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: frame.width, height: 100)
                setCollectionViewLayout(self.layout, animated: false)
            }
        }
    }
//    fileprivate lazy var model = DateModel()
    fileprivate let sectionSeparator = UIView()
    fileprivate var layout: UICollectionViewLayout {
        return MonthLayout(inset: inset, cellSpace: cellSpace, sectionSpace: sectionSpace, weekCellHeight: weekCellHeight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewLayout = layout
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    init(frame: CGRect, sectionSpace: CGFloat = 1.5, cellSpace: CGFloat = 0.5, inset: UIEdgeInsets = .zero, weekCellHeight: CGFloat = 25) {
        super.init(frame: frame, collectionViewLayout: MonthLayout(inset: inset, cellSpace: cellSpace, sectionSpace: sectionSpace, weekCellHeight: weekCellHeight))
        self.sectionSpace = sectionSpace
        self.cellSpace = cellSpace
        self.inset = inset
        self.weekCellHeight = weekCellHeight
    }
    
}


enum SelectionMode {
    
}

struct LineView {
    enum Postion { case top, center, bottom }
    var height: CGFloat = 1
    var widthRate: CGFloat = 1
    var position = Postion.center
}

enum ContentPosition {
    case topLeft, topCenter, topRight
    case left, center, right
    case bottomLeft, bottomCenter, bottomRight
    case custom(x: CGFloat, y: CGFloat)
}
