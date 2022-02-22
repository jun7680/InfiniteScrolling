//
//  MainCollectionView.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    var calendar = CalendarMonthView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300), sectionSpace: 1.5, cellSpace: 1, inset: .zero, weekCellHeight: 25)
    var monthFlag = -1
    fileprivate lazy var model = DateModel()
    override func layoutSubviews() {
        super.layoutSubviews()         
        addSubview(calendar)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}

extension MainCollectionViewCell {
    func configure() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.isPagingEnabled = true
        calendar.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.identifier)
        print(model.makeDateModel())
    }
    
    func configure(_ cell: MonthCell, at indexPath: IndexPath) {
        let style = MonthCell.CellStyle.standard
        let content: String
        let date = model.date(at: indexPath)
        if indexPath.section == 0 {
            content = model.week(at: indexPath.row)
        } else {
            switch monthFlag {
            case 0:
                if let beginning = model.indexAtBeginning(in: .previous), indexPath.row < beginning {
                    cell.textColor = .lightGray
                } else if let end = model.indexAtEnd(in: .previous), indexPath.row > end {
                    cell.textColor = .lightGray
                } else {
                    cell.textColor = .black
                }
                content = model.previousDayString(at: indexPath)
                break;
            case 1:
                if let beginning = model.indexAtBeginning(in: .current), indexPath.row < beginning {
                    cell.textColor = .lightGray
                } else if let end = model.indexAtEnd(in: .current), indexPath.row > end {
                    cell.textColor = .lightGray
                } else {
                    cell.textColor = .black
                }
                content = model.currentDayString(at: indexPath)
                break;
            case 2:
                if let beginning = model.indexAtBeginning(in: .next), indexPath.row < beginning {
                    cell.textColor = .lightGray
                } else if let end = model.indexAtEnd(in: .next), indexPath.row > end {
                    cell.textColor = .lightGray
                } else {
                    cell.textColor = .black
                }
                content = model.nextDayString(at: indexPath)
                break;
            default:
                content = model.nextDayString(at: indexPath)
                break;
            }
        }        
        cell.content = content
        cell.configureAppearance(of: style, withColor: .brown, backgroundColor: .white, isSelected: false)
    }
    
    func display(in month: MonthType, row: Int) {        
        monthFlag = row        
    }
    
    func updateCurrentDates(_ direction: Int) {
        if direction < 0 {
            model.display(in: .previous)
        } else {
            model.display(in: .next)
        }
    }
    
}

extension MainCollectionViewCell: UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UIScrollViewDelegate,
                             UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(model.select(with: indexPath))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? DateModel.dayCountPerRow : DateModel.maxCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.identifier, for: indexPath) as? MonthCell else { return .init() }
        configure(cell, at: indexPath)
        return cell
    }
}
