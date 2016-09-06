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

let readabilityUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/601.7.7 (KHTML, like Gecko) Version/9.1.2 Safari/601.7.7"

public extension Readability {

	public class func parse(url url: NSURL, completion: (ReadabilityData?) -> ()) {

		let isMainThread = NSThread.isMainThread()

		let request = NSMutableURLRequest(URL: url)
		request.setValue(readabilityUserAgent, forHTTPHeaderField: "User-Agent")

		NSURLSession.sharedSession().dataTaskWithRequest(request,
			completionHandler: { (responseData, _, _) in
				guard let htmlData = responseData else {

					if isMainThread {
						dispatch_async(dispatch_get_main_queue(), {
							completion(.None)
						})
					} else {
						completion(.None)
					}

					return
				}

				if Readability.checkForImage(htmlData) {
					let parsedData = ReadabilityData(title: url.absoluteString,
						description: .None,
						topImage: url.absoluteString,
						text: .None,
						topVideo: .None,
						keywords: .None)

					if isMainThread {
						dispatch_async(dispatch_get_main_queue(), {
							completion(parsedData)
						})
					} else {
						completion(parsedData)
					}

					return
				}

				if isMainThread {
					dispatch_async(dispatch_get_main_queue(), {
						Readability.parse(data: htmlData, completion: completion)
					})
				} else {
					Readability.parse(data: htmlData, completion: completion)
				}

		}).resume()
	}

	class func checkForImage(data: NSData) -> Bool {
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
