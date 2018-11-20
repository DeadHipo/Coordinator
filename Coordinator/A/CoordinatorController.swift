//
//  Module.swift
//  Coordinator
//
//  Created by Александрк Бельковский on 20/11/2018.
//  Copyright © 2018 Александрк Бельковский. All rights reserved.
//

import UIKit

protocol CoordinatorController {
    
    associatedtype ModuleEventsType
    
    typealias Handler = (ModuleEventsType) -> Void
    
    var handler: Handler? { get }
    
    var toViewController: UIViewController { get }
    
}

extension CoordinatorController where Self: UIViewController {
    
    var toViewController: UIViewController {
        return self
    }
    
}
