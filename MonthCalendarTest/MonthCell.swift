//
//  CollectionViewCell.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/18.
//

import UIKit

class MonthCell: UICollectionViewCell {
    fileprivate let contentLabel = UILabel()
    fileprivate let circularView = UIView()
    fileprivate let lineView = UIView()
 
    static let identifier = "MonthCell"
    
    enum CellStyle {
        case standard, circle, semicircleEdge(position: SequencePosition), line(position: SequencePosition?)
        
        enum SequencePosition { case left, middle, right}
    }
    var content = String() {
        didSet {
            contentLabel.text = content
            adjustSubViewsFrame()
        }
    }
    
    var textColor = UIColor.black {
        didSet {
            contentLabel.textColor = textColor
        }
    }
    
    var dayBackGroundColor = UIColor.white {
        didSet {
            backgroundColor = dayBackGroundColor
        }
    }
    
    var contentPostion = ContentPosition.center
    
    var lineViewApperance: LineView? {
        didSet {
            configureLineView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSubViewsFrame()
    }
    
    // Todo : 수정
    func configureAppearance(of style: CellStyle, withColor color: UIColor, backgroundColor: UIColor, isSelected: Bool) {        
        switch style {
        case .standard:
            self.backgroundColor = isSelected ? color : backgroundColor
        case .circle:
            self.backgroundColor = isSelected ? color : backgroundColor
        case .semicircleEdge(let position):
            self.backgroundColor = isSelected ? color : backgroundColor
        case .line(let position):
            lineView.isHidden = false
            
            guard let position = position else {
                lineView.frame.origin.y = (bounds.width - lineView.frame.width) / 2
                return
            }
            
            switch position {
            case .left: lineView.frame.origin.x = bounds.width - lineView.frame.width
            case .middle:
                lineView.frame.size.width = bounds.width
                lineView.frame.origin.x = (bounds.width - lineView.frame.width) / 2
            case .right:
                lineView.frame.origin.x = 0
            }
        }
    }
}

private extension MonthCell {
    var position: CGPoint {
        let dayWidth = contentLabel.frame.width
        let dayHeight = contentLabel.frame.height
        let width = frame.width
        let height = frame.height
        let padding: CGFloat = 2
        
        switch contentPostion {
            // Top
        case .topLeft: return .init(x: padding, y: padding)
        case .topCenter: return .init(x: (width - dayWidth) / 2, y: padding)
        case .topRight: return .init(x: width - dayWidth - padding, y: padding)
            // Center
        case .left: return .init(x: padding, y: (height - dayHeight) / 2)
        case .center: return .init(x: (width - dayWidth) / 2, y: (height - dayHeight) / 2)
        case .right: return .init(x: width - dayWidth - padding, y: (height - dayHeight) / 2)
            // Bottom
        case .bottomLeft: return .init(x: padding, y: height - dayHeight - padding)
        case .bottomCenter: return .init(x: (width - dayWidth) / 2, y: height - dayHeight - padding)
        case .bottomRight: return .init(x: width - dayWidth - padding, y: height - dayHeight - padding)
            
        case .custom(let x, let y): return .init(x: x, y: y)
        }
    }
    
    func setup() {
        addSubview(contentLabel)
        let lineViewSize = CGSize.init(width: bounds.width, height: 1)
        lineView.frame = CGRect(origin: .init(x: 0, y: (bounds.height - lineViewSize.height) / 2), size: lineViewSize)
        lineView.isHidden = true
        addSubview(lineView)
    }
    
    func adjustSubViewsFrame() {
        contentLabel.sizeToFit()
        contentLabel.frame.origin = position
    }
    
    func configureLineView() {
        guard let appearance = lineViewApperance else { return }
        lineView.frame.size = CGSize(width: bounds.width * appearance.widthRate, height: appearance.height)
        lineView.frame.origin.y = {
            switch appearance.position {
            case .top: return (bounds.height / 2 - lineView.frame.height) / 2
            case .center: return (bounds.height - lineView.frame.height) / 2
            case .bottom: return (bounds.height / 2 - lineView.frame.height) / 2 + bounds.height / 2
            }
        }()
    }
}

