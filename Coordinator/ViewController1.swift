//
//  ViewController1.swift
//  Coordinator
//
//  Created by Александрк Бельковский on 20/11/2018.
//  Copyright © 2018 Александрк Бельковский. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, CoordinatorModule {
    
    var total: Int = 0
    
    // MARK: - CoordinatorModule
    
    enum SecondModuleEvents {
        case nextClicked
        case endClicked
    }
    
    typealias CoordinatorEventsType = SecondModuleEvents
    
    var handler: ((ViewController1.SecondModuleEvents) -> Void)?
    
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countLabel.text = "\(total)"
    }
    
    // MARK: - Handlers
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        handler?(.nextClicked)
    }
    
    @IBAction func endButtonClicked(_ sender: UIButton) {
        handler?(.endClicked)
    }
    
}
