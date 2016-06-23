//
//  ViewController.swift
//  ReadabilityKit
//
//  Created by Victor Sukochev on 06/22/2016.
//  Copyright (c) 2016 Victor Sukochev. All rights reserved.
//

import UIKit

class MainController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var addressField: UITextField?
	@IBOutlet weak var webView: UIWebView?

	var url: NSURL?

	override func viewDidLoad() {
		super.viewDidLoad()

		loadDefaultPage()
	}

	@IBAction func onGo() {
		guard let addressStr = addressField?.text else {
			return
		}

		var urlStr = addressStr
		if !urlStr.containsString("https://") &&
		!urlStr.containsString("http://") {
			urlStr = "https://\(urlStr)"
		}

		url = NSURL(string: urlStr)
		guard let url = url else {
			return
		}

		let request = NSURLRequest(URL: url)
		webView?.loadRequest(request)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == "details_segue" {
			let detailsController = segue.destinationViewController as! DetailsController
			detailsController.url = url
		}
	}

	func loadDefaultPage() {
		guard let url = NSURL(string: "https://google.com") else {
			return
		}

		let request = NSURLRequest(URL: url)
		webView?.loadRequest(request)
	}

	// MARK: UIWebView delegate
	func webViewDidFinishLoad(webView: UIWebView) {
		url = webView.request?.URL
		guard let urlStr = url?.absoluteString else {
			return
		}

		addressField?.text = urlStr
	}
}
