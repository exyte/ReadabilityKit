//
//  MainController.swift
//  ReadabilityKit
//
//  Copyright (c) 2016 Exyte http://www.exyte.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import ReadabilityKit

class MainController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var addressField: UITextField?
	@IBOutlet weak var webView: UIWebView?

	var url: URL?
	var parser: Readability?
	var image: UIImage?
	var parsedData: ReadabilityData?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		loadDefaultPage()
	}

	@IBAction func onGo() {
		addressField?.resignFirstResponder()

		guard let addressStr = addressField?.text else {
			return
		}

		var urlStr = addressStr
		if !urlStr.contains("https://") &&
		!urlStr.contains("http://") {
			urlStr = "https://\(urlStr)"
		}

		url = URL(string: urlStr)
		guard let url = url else {
			return
		}

		let request = URLRequest(url: url)
		webView?.loadRequest(request)
	}

	@IBAction func onParse() {
        parseHTMLContent()
	}

	func moveToDetails() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Details View Controller") as? DetailsController else {
            return
        }
        viewController.titleText = parsedData?.title
        viewController.desc = parsedData?.description
        viewController.keywords = parsedData?.keywords
        viewController.image = image
        viewController.videoURL = parsedData?.topVideo
		self.navigationController?.pushViewController(viewController, animated: true)
	}

	func loadDefaultPage() {
		guard let url = URL(string: "https://google.com") else {
			return
		}

		let request = URLRequest(url: url)
		webView?.loadRequest(request)
	}

	// MARK: UIWebView delegate
	func webViewDidFinishLoad(_ webView: UIWebView) {
		url = webView.request?.url
		guard let urlStr = url?.absoluteString else {
			return
		}

		addressField?.text = urlStr
	}

	// MARK: UITextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		onGo()

		return true
	}

	// MARK: Parsing

	func parseHTMLContent() {
        guard let htmlContent = webView?.htmlContent else {
			return
		}
        
		Readability.parse(htmlString: htmlContent) { data in
			self.parsedData = data

			guard let imageUrlStr = data?.topImage else {
				return
			}

			guard let imageUrl = URL(string: imageUrlStr) else {
				return
			}

            guard let imageData = try? Data(contentsOf: imageUrl) else {
                return
            }
            
			self.image = UIImage(data: imageData)

			self.moveToDetails()
        }
    }
    
}
