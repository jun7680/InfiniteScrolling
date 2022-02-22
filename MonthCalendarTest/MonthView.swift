//
//  MonthView.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/16.
//

import UIKit

class MonthView: UIView {
    
    var yearAndMonth: String = "0000.00" {
        didSet {
            let year = yearAndMonth.split(separator: ".")[0]
            var month = yearAndMonth.split(separator: ".")[1]
            if Int(month) ?? 1 < 10 {
                month = "0" + month
            }
            yearAndMonth = String(year + "." + month)
            
            monthLabel.text = yearAndMonth
        }
    }
    
    var presentedMonth = 0
    var presentedYear = 0
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAll()
        
        presentedYear = Calendar.current.component(.year, from: Date())
        presentedMonth = Calendar.current.component(.month, from: Date())
    }
    
    private func configureAll() {
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        monthLabel.text = "2022.02"
    }
    
    func updateYearAndMonth(to date: Date) {
        // TODO
    }
    
    required init?(coder: NSCoder) {
        fatalError("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
}
