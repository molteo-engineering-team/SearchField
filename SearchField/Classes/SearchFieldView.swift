//
//  SearchFieldView.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/14/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import Foundation
import os.log

/// SearchViewDelegate notifies the user when the SearchFieldView has been pressed to animate into the main SearchViewController
public protocol SearchViewDelegate: NSObjectProtocol {
    /// called when the user invokes the following method (textFieldShouldBeginEditing) from UITextFieldDelegate
    func presentSearchViewController()
}


/// This view will be used to only open and display the result which was selected from the SearchResults
final public class SearchFieldView: BaseTextField, UITextFieldDelegate {
    
    // MARK: - Delegate
    weak public var searchViewDelegate: SearchViewDelegate?
    
    // MARK: - init
    deinit {
        os_log("deinit SearchFieldView", type: .debug)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchViewDelegate?.presentSearchViewController()
        return false
    }
    
}
