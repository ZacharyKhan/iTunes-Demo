//
//  Protocols.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/2/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import Foundation

protocol SideMenuDelegate {
    func didSelectItem(at index : Int, withTitle: String)
}
