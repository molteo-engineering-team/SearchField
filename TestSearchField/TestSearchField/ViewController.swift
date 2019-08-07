//
//  ViewController.swift
//  TestSearchField
//
//  Created by Mustafa Khalil on 8/8/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import UIKit
import SearchField

class ViewController: UIViewController, SearchFieldControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentView = SearchFieldController(delegate: self)
        view.addSubview(currentView.view)
        currentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        currentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func selected(searchResult: SearchAble) {
        
    }
}
