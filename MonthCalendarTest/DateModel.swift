//
//  DateModel.swift
//  MonthCalendarTest
//
//  Created by injun on 2022/02/17.
//

import UIKit

enum MonthType { case previous, current, next }

class DateModel: NSObject {

    static let dayCountPerRow = 7
    static let maxCellCount = 42
    
    var weeks: (String, String, String, String, String, String, String) = ("일", "월", "화", "수", "목", "금", "토")
    
    enum WeekType: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        
        init?(_ indexPath: IndexPath) {
            let firstWeekday = Calendar.current.firstWeekday
            switch indexPath.row % 7 {
            case (8 -  firstWeekday) % 7:  self = .sunday
            case (9 -  firstWeekday) % 7:  self = .monday
            case (10 - firstWeekday) % 7:  self = .tuesday
            case (11 - firstWeekday) % 7:  self = .wednesday
            case (12 - firstWeekday) % 7:  self = .thursday
            case (13 - firstWeekday) % 7:  self = .friday
            case (14 - firstWeekday) % 7:  self = .saturday
            default: return nil
            }
        }
    }
    struct SequenceDates { var start, end: Date? }
    lazy var sequenDates: SequenceDates = .init(start: nil, end: nil)
    
    fileprivate var currentDates: [Date] = []
    fileprivate var previousDates: [Date] = []
    fileprivate var nextDates: [Date] = []
    fileprivate var dateZip: [[Date]] = [[]]
    fileprivate var selectedDates: [Date: Bool] = [:]
    fileprivate var currentDate: Date = .init()
    
    override init() {
        super.init()
        setup()
    }
    
    func makeDateModel() -> Int {
        dateZip = [previousDates, currentDates, nextDates]
        
        return dateZip.count
    }
    
    func indexAtBeginning(in month: MonthType) -> Int? {
        if let index = calendar.ordinality(of: .day, in: .weekOfMonth, for: atBeginning(of: month)) {
            return index - 1
        }
        
        return nil
    }
    
    func indexAtEnd(in month: MonthType) -> Int? {
        if let rangeDays = calendar.range(of: .day, in: .month, for: atBeginning(of: month)), let beginning = indexAtBeginning(in: month) {
            let count = rangeDays.upperBound - rangeDays.lowerBound
            return count + beginning - 1
        }
        
        return nil
    }
    
    func previousDayString(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool = false) -> String {
        if isHidden && isOtherMonth(at: indexPath) {
            return String()
        }
        
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "d"        
        print("🥲", previousDates)
        return formatter.string(from: previousDates[indexPath.row])
    }
    
    func currentDayString(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool = false) -> String {
        if isHidden && isOtherMonth(at: indexPath) {
            return String()
        }
        
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "d"
        
        return formatter.string(from: currentDates[indexPath.row])
    }
    
    func nextDayString(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool = false) -> String {
        if isHidden && isOtherMonth(at: indexPath) {
            return String()
        }
        
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "d"
        
        return formatter.string(from: nextDates[indexPath.row])
    }    
    
    func isOtherMonth(at indexPath: IndexPath) -> Bool {
        if let beginning = indexAtBeginning(in: .current), let end = indexAtEnd(in: .current),
           indexPath.row < beginning || indexPath.row > end {
            return true
        }
        
        return false
    }
    
    func display(in month: MonthType) {
        currentDates = []
        currentDate = month == .current ? Date() : date(of: month)
        setup()
    }

    func dateString(in month: MonthType, withFormat format: String) -> String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = format
        return formatter.string(from: date(of: month))
    }
    
    func date(at indexPath: IndexPath) -> Date {
        return currentDates[indexPath.row]
    }
    
    func willSelectDate(at indexPath: IndexPath) -> Date? {
        let date = currentDates[indexPath.row]
        return selectedDates[date] == true ? nil : date
    }
        
    // Select date in programmatically
    func select(from fromDate: Date, to toDate: Date?) {
        if let toDate = toDate?.formated() {
            set(true, withFrom: fromDate, to: toDate)
        } else if let fromDate = fromDate.formated() {
            selectedDates[fromDate] = true
        }
    }
    
    func select(with indexPath: IndexPath) -> Date {
        return date(at: indexPath)
    }
    
    func week(at index: Int) -> String {
        switch index {
        case 0: return weeks.0
        case 1: return weeks.1
        case 2: return weeks.2
        case 3: return weeks.3
        case 4: return weeks.4
        case 5: return weeks.5
        case 6: return weeks.6
        default: return String()
        }
    }
}

private extension DateModel {
    var calendar: Calendar { return Calendar.current }
    
    func setup() {
        selectedDates = [:]
        
        guard let indexAtBeginning = self.indexAtBeginning(in: .current) else { return }
        guard let previousIndexAtBeginnig = self.indexAtBeginning(in: .previous) else { return }
        guard let nextIndexAtBeginnig = self.indexAtBeginning(in: .next) else { return }
        
        var components: DateComponents = .init()
        currentDates = (0..<DateModel.maxCellCount).compactMap { index in
            components.day = index - indexAtBeginning
            return calendar.date(byAdding: components, to: atBeginning(of: .current))
        }
        
        previousDates = (0..<DateModel.maxCellCount).compactMap { index in
            components.day = index - previousIndexAtBeginnig
            return calendar.date(byAdding: components, to: atBeginning(of: .previous))
        }
        
        nextDates = (0..<DateModel.maxCellCount).compactMap { index in
            components.day = index - nextIndexAtBeginnig
            return calendar.date(byAdding: components, to: atBeginning(of: .next))
        }
        
        let selectedDateKeys = selectedDates.keys(of: true)
        selectedDateKeys.forEach { selectedDates[$0] = true }
    }
    
    func set(_ isSelected: Bool, withFrom fromDate: Date, to toDate: Date) {
        currentDates
            .filter { fromDate <= $0 && toDate >= $0 }
            .forEach { selectedDates[$0] = isSelected }
    }
    
    func atBeginning(of month: MonthType) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date(of: month))
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    func date(of month: MonthType) -> Date {
        var components = DateComponents()
        components.month = {
            switch month {
            case .previous:
                return -1
            case .current:
                return 0
            case .next:
                return 1
            }
        }()
        return calendar.date(byAdding: components, to: currentDate) ?? Date()
    }
}
