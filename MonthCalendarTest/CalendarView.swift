//
//  CalendarView.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/16.
//

import UIKit

class CalendarView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        collectionView.collectionViewLayout.invalidateLayout()
        
        return collectionView
    }()
    
    var firstWeekDayOfMonth = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("startOfMonth -> ", Date().startOfMonth)        
        print("endOfMonth -> ", "2022-03-01".date?.endOfMonth.maxDate ?? -1)
        print("endOfMonth -> ", "2022-03-01".date?.endOfMonth.previousMaxDate ?? -1)
        
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("!!!!!!!!!!!!!!!!!!!!!!")
    }
    
    private func initializeView() {
        
        setUpViews()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setUpViews() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }   

}

extension CalendarView: UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else { return UICollectionViewCell() }
        
        let startWeekdayOfMonthIndex = firstWeekDayOfMonth - 1
        let previousMaxDate = "2022-02-01".date?.endOfMonth.previousMaxDate ?? -1
        
        if indexPath.item < startWeekdayOfMonthIndex {
            // previous month
            let date = previousMaxDate - (startWeekdayOfMonthIndex - 1) + indexPath.item
            cell.configure(to: date)
            cell.isNotCurrentDate()
        } else if indexPath.item >= ("2022-02-01".date?.endOfMonth.maxDate ?? -1) + 2 {
            let date = indexPath.item - (("2022-02-01".date?.endOfMonth.maxDate ?? -1) + 1)
            cell.configure(to: date)
            cell.isNotCurrentDate()
        } else {
            let date = indexPath.item - startWeekdayOfMonthIndex + 1
            
            cell.configure(to: date)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
}

class DateCell: UICollectionViewCell {
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    var date = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(datelabel)
        datelabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(to date: Int) {
        datelabel.text = String(date)
        self.date = date
    }
    
    func isNotCurrentDate() {
        datelabel.textColor = .gray
    }
    
}


extension Dictionary where Value: Equatable {
    func keys(of element: Value) -> [Key] {
        return filter { $0.1 == element }.map { $0.0 }
    }
}
