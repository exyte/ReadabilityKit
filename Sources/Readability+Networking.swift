//
//  Readability+Networking.swift
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

#if os(OSX)
	import AppKit
#else
	import UIKit
#endif

let readabilityUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/601.7.7 (KHTML, like Gecko) Version/9.1.2 Safari/601.7.7"

public extension Readability {

	public class func parse(url: URL, completion: @escaping (ReadabilityData?) -> ()) {

		let isMainThread = Thread.isMainThread

		var request = URLRequest(url: url)
		request.setValue(readabilityUserAgent, forHTTPHeaderField: "User-Agent")
        

		URLSession.shared.dataTask(with: request,
			completionHandler: { (responseData, _, _) in
				guard let htmlData = responseData else {

					if isMainThread {
						DispatchQueue.main.async(execute: {
							completion(.none)
						})
					} else {
						completion(.none)
					}

					return
				}

				if Readability.checkForImage(htmlData) {
					let parsedData = ReadabilityData(title: url.absoluteString,
						description: .none,
						topImage: url.absoluteString,
						text: .none,
						topVideo: .none,
						keywords: .none)

					if isMainThread {
						DispatchQueue.main.async(execute: {
							completion(parsedData)
						})
					} else {
						completion(parsedData)
					}

					return
				}

				if isMainThread {
					DispatchQueue.main.async(execute: {
						Readability.parse(data: htmlData, completion: completion)
					})
				} else {
					Readability.parse(data: htmlData, completion: completion)
				}

		}).resume()
	}

	class func checkForImage(_ data: Data) -> Bool {
		#if os(OSX)
			let image = NSImage(data: data)
		#else
			let image = UIImage(data: data)
		#endif

		if let _ = image {
			return true
		}

		return false
	}

}
