//
//  Item.swift
//  ToDoApp
//
//  Created by Александр Христиченко on 01.06.2022.
//

import UIKit

//for future work
class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
