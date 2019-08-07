//
//  SearchField.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/7/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import UIKit
import os.log

public protocol SearchFieldDelegate: class {
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidReturn(_ textField: UITextField)
    func selected(searchResult: SearchAble)
    func textfieldValueDidChangeWith(_ text: String?)
}

public class SearchField<Element: SearchAble>: UITextField, UITextFieldDelegate, SearchResultsControllerDelegate {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    private var _controller: SearchResultsController<GenericCell<Element>, Element>?
    private var _resultsView: UIView?
    private var isPresented = false
    
    var controller: SearchResultsController<GenericCell<Element>, Element> {
        get {
            guard let currentController = _controller else {
                let newController = SearchResultsController<GenericCell<Element>, Element>(delegate: self)
                _controller = newController
                return newController
            }
            return currentController
        }
        set {
            _controller = newValue
        }
    }
    
    public var resultsView: UIView {
        get {
            guard let results = _resultsView else {
                let view = controller.view!
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
            return results
        }
        
        set {
            _resultsView = newValue
        }
    }
    
    weak var searchFieldDelegate: SearchFieldDelegate?
    
    deinit {
        os_log("deinit SearchField")
    }
    
    public init(delegate: SearchFieldDelegate) {
        self.searchFieldDelegate = delegate
        super.init(frame: .zero)
        initSetup()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        setupShadowForLayout()
        backgroundColor = .white
        addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        self.delegate = self
    }
    
    @objc func handleTextDidChange() {
        guard _controller == nil else {
            filter()
            return
        }
        searchFieldDelegate?.textfieldValueDidChangeWith(text)
    }
    
    fileprivate func filter() {
        _controller?.filter(text: text)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presentContainerInSuperView()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        removeContainerFromSuperView()
        return true
    }
    
    func animate(alpha: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.resultsView.alpha = alpha
                        self?.containerView.alpha = alpha
            }, completion: completion)
    }
    
    public func filterInBase(searchResultsController searchItems: [SearchAble]) {
        controller.setItems(searchItems: searchItems)
    }
    
    public func selected(searchResult: SearchAble) {
        
        searchFieldDelegate?.selected(searchResult: searchResult)
    }
    
    public func dimissView() {
        removeContainerFromSuperView()
    }
}

extension SearchField {
    
    func removeContainerFromSuperView() {
        resignFirstResponder()
        animate(alpha: 0) { [weak self] _ in
            self?.resultsView.removeFromSuperview()
            self?.containerView.removeFromSuperview()
            self?.isPresented.toggle()
        }
    }
    
    func presentContainerInSuperView() {
        guard let superView = superview, !isPresented else {
            return
        }
        setupLayout(in: superView)
        resultsView.alpha = 0
        containerView.alpha = 0
        animate(alpha: 1) { [weak self] _ in
            self?._controller?.reloadData()
            self?.isPresented.toggle()
        }
    }
    
    func setupLayout(in view: UIView) {
         let padding = UIEdgeInsets(top: frame.midY + frame.height, left: frame.minX, bottom: 0, right: view.frame.width - frame.maxX)
        
        containerView.frame = view.frame
        view.insertSubview(containerView, belowSubview: self)
        containerView.addSubview(resultsView)
        
        containerView.fillSuperView()
        resultsView.fillSuperView(disregarding: .bottom, padding: padding)
        resultsView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
}
