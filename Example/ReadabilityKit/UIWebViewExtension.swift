//
//  UIWebViewExtension.swift
//  ReadabilityKit_Example
//
//  Created by Dmitry Shipinev on 19/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIWebView {
    
    var htmlContent: String? {
        return self.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
    }
    
}
