//
//  BaseTextField.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/14/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

public class BaseTextField: UITextField {
    
    // MARK: - UI variables
    private lazy var leftViewPadding = UIView()
    var leftImageContainer: UIImageView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        backgroundColor = .white
        addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        setupLayerWithShadow()
        setupLeftView()
    }
    
    func setupLeftView() {
        let img = UIImageView(image: SearchFieldIcons.search?.withRenderingMode(.alwaysTemplate))
        img.isUserInteractionEnabled = true
        leftImageContainer = img
        leftViewPadding.addSubview(img)
        leftView = leftViewPadding
        leftViewMode = .always
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        leftViewPadding.frame = CGRect(x: 0,
                                       y: 0,
                                       width: frame.height,
                                       height: frame.height)
        
        leftImageContainer?.center = leftViewPadding.center
    }
    
    @objc func handleTextDidChange() {}
    
    /// setupLeftContainer setups up the image on the left part of the BaseTextField in case the devs want to change it
    ///
    /// - Parameter image: UIimage that will be presented
    public func setupLeftContainer(image: UIImage) {
        leftImageContainer?.image = image
    }
}
