//
//  TextField.swift
//  Pantarevir
//
//  Created by Anton Källbom on 30/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}