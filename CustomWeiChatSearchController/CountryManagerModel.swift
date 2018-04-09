//
//  CountryManagerModel.swift
//  ProductDetailViewController
//
//  Created by 范国徽 on 2018/3/1.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit

class CountryManagerModel: NSObject {

    static let share: CountryManagerModel = CountryManagerModel()
    private override init() {
        
    }
    
    lazy var countryList: [String] = {
        let pathUrl = Bundle.main.path(forResource: "country", ofType: "txt")!
        let countryStr = try! String.init(contentsOfFile: pathUrl)
        let countryList = countryStr.components(separatedBy: CharacterSet.newlines)
        return countryList
    }()
    
    
}
