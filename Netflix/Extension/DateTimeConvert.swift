//
//  DateTimeConvert.swift
//  Netflix
//
//  Created by HuyNguyen on 19/05/2024.
//

import Foundation
final class DateTimeConvert {
    
    static let shared: DateTimeConvert = DateTimeConvert()
    
    func convertDateFormat(inputDate: String, toFormat: String) -> String {
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = toFormat

         return convertDateFormatter.string(from: oldDate ?? Date())
    }
}
