//
//  DetailsController.swift
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

class DetailsController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var videoURLTextView: UITextView?
    @IBOutlet weak var contentTextView: UITextView?
    
	var image: UIImage?
	var titleText: String?
	var desc: String?
	var keywords: [String]?
	var videoURL: String?
    
    @IBAction func onDone() {
        self.navigationController?.popViewController(animated: true)
    }

	override func viewDidLoad() {
		super.viewDidLoad()

        imageView?.image = image
        
        if let videoURL = self.videoURL {
            videoURLTextView?.text = videoURL
            videoURLTextView?.isHidden = false
            
            let videoURLRecongnizer = UITapGestureRecognizer(target: self, action: #selector(openVideo))
            videoURLTextView?.addGestureRecognizer(videoURLRecongnizer)
        } else {
            videoURLTextView?.isHidden = true
        }
        
        let boldFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        let regularFont = UIFont.systemFont(ofSize: 17)
        let stringFormat = "%@\n"
        
        let contentAttributedString = NSMutableAttributedString()
        contentAttributedString.append(
            NSAttributedString(
                string: String(format: stringFormat, titleText ?? ""),
                attributes: [NSAttributedString.Key.font: boldFont]
            )
        )
        contentAttributedString.append(
            NSAttributedString(
                string: String(format: stringFormat, keywords?.joined(separator: ", ") ?? ""),
                attributes: [NSAttributedString.Key.font: regularFont]
            )
        )
        contentAttributedString.append(
            NSAttributedString(
                string: String(format: stringFormat, desc ?? ""),
                attributes: [NSAttributedString.Key.font: regularFont]
            )
        )
        contentTextView?.attributedText = contentAttributedString
	}

    @objc func openVideo() {
		if let url = URL(string: videoURLTextView?.text ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: .none)
		}
	}
}
