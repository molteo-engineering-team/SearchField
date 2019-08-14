//
//  Icons.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/14/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import Foundation

public class SearchFieldIcons {
    
    private static var internalBundle: Bundle?
    
    public static var bundle: Bundle {
        if nil == SearchFieldIcons.internalBundle {
            SearchFieldIcons.internalBundle = Bundle(for: BaseTextField.self)
            let url = SearchFieldIcons.internalBundle!.resourceURL!
            let currentBundle = Bundle(url: url.appendingPathComponent("eu.molteo.icons"))
            if let v = currentBundle {
                SearchFieldIcons.internalBundle = v
            }
        }
        return SearchFieldIcons.internalBundle!
    }
    
    public static func getImage(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }
    
    public static var search = getImage("magnify")
    public static var back = getImage("back")
    public static var cancelImage = getImage("cancel")
}
