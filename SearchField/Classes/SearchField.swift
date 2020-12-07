//
//  SearchField.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/7/19.
//  Copyright © 2019 Molteo. All rights reserved.
//
import os.log

protocol SearchFieldDelegate: NSObjectProtocol {
    
    /// dismiss is called when the user pressed the back button in the search view to dimiss the search controller
    func dismissView()
    
    /// textfieldValueDidChangeWith text that's being typed by the user
    ///
    /// - Parameter text:
    func textDidChangeWith(_ text: String?)
}

/// extension to functions that we might not want to actually implement which just notifies the higher view that the UITextFieldDelegate functions are being called
extension SearchFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {}
    func textFieldShouldClear(_ textField: UITextField) {}
    func textFieldDidBeginEditing(_ textField: UITextField) {}
}

public final class SearchField: BaseTextField {
    
    // MARK: - Delegate
    weak var searchFieldDelegate: SearchFieldDelegate?
    
    // MARK: - Init
    deinit {
        os_log("deinit SearchField", type: .debug)
    }
    
    init(delegate: SearchFieldDelegate) {
        self.searchFieldDelegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        setupView()
    }
    
    /// Setup for the view since it's a subclass of BaseTextField
    func setupView() {
        // set the delegate to self so we can call the methods for UITextField without any interference
        delegate = self
        clearButtonMode = .whileEditing
        // changes the clear button
        if let clearButton = value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(SearchFieldIcons.cancelImage, for: .normal)
        }
        // sets the image from Framework assets
        guard let img = SearchFieldIcons.back else { return }
        setupLeftContainer(image: img)
        leftImageContainer?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimissView)))
    }
    
    ///  returns the text while the user is typing to the SearchFieldDelegate to start the filtering process
    @objc override func handleTextDidChange() {
        searchFieldDelegate?.textDidChangeWith(text)
    }
}

// MARK: - UITextFieldDelegate

extension SearchField: UITextFieldDelegate {
    
    /// Implementation of the textfield should begin editing method that would call the respective method from the  SearchFieldDelegate delegate
    ///
    /// - Parameter textField: The text field containing the text.
    /// - Returns: always true
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchFieldDelegate?.textFieldDidBeginEditing(textField)
        return true
    }
    
    /// Implementation of the textfield should return method that would call the respective method from the  SearchFieldDelegate delegate
    ///
    /// - Parameter textField: The text field containing the text.
    /// - Returns: always true
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFieldDelegate?.textFieldShouldReturn(textField)
        return true
    }
    
    /// Implementation of the textfield should clear delegate that would call the respective method from the SearchFieldDelegate delegate
    ///
    /// - Parameter textField: The text field containing the text.
    /// - Returns: Will always return true
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchFieldDelegate?.textFieldShouldClear(textField)
        return true
    }
}

// MARK: - View change

extension SearchField {
    
    /// dismissView is the method that would be called from the delegate SearchFieldDelegate to dismiss the SearchViewController
    @objc fileprivate func dimissView() {
        searchFieldDelegate?.dismissView()
    }
    
}
