//
//  ViewController.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/16.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    lazy var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 284)
    lazy var calendar = CalendarMonthView(frame: frame, sectionSpace: 1.5, cellSpace: 1, inset: .zero, weekCellHeight: 25)
    let itemColors = [UIColor.red, UIColor.yellow, UIColor.green]
    var currentIndex: CGFloat = 0
    var isOneStepPaging = true
    var cellWidth: CGFloat = 0
    var scrollDirection = ScrollDirection.none
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        
        let lineSpacing: CGFloat = 20
        
        let cellRatio: CGFloat = 0.7
        
        
        let cellWidth = floor(view.frame.width * cellRatio)
        let cellHeight = floor(view.frame.height * cellRatio)
        
        // 상하, 좌우 inset value 설정
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        layout.itemSize = CGSize(width: view.frame.width, height: cellHeight)
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        return cv
    }()
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setViews()
        
    }
    
    private func setViews() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 스크롤 시 빠르게 감속 되도록 설정
        collectionView.decelerationRate = .fast
//        view.addSubview(calendar)

//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.height.equalTo(300)
//            $0.width.equalToSuperview()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
    }
}

extension ViewController: UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemColors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "collectionViewCell",
            for: indexPath) as? MainCollectionViewCell
        else { return .init() }
        
        cell.display(in: .current, row: indexPath.row)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint),
              let cell = collectionView.cellForItem(at: visibleIndexPath) as? MainCollectionViewCell
        else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        cellWidth = cellWidthIncludingSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            cell.updateCurrentDates(1)
        } else {
            roundedIndex = ceil(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let numberOfCell = itemColors.count
        let page = Int(scrollView.contentOffset.x) / Int(cellWidth)
        
        if page == 0 {
            
        }
    }
}
class CollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension Date {
    static var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    var maxDate: Int {
        return Int(Date.dayFormatter.string(from: self)) ?? -1
    }
    var previousMaxDate: Int {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)?.maxDate ?? -1
    }
    var weekday: Int {
        get {
            Calendar.current.component(.weekday, from: self)
        }
    }
    
    var firstDayOfTheMonth: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? Date()
        }
    }
    
    var currentMonth: Int {
        get {
            Calendar.current.component(.month, from: self)
        }
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
}



enum ScrollDirection {
    case left, none, right
}
