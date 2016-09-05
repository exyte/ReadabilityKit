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

	public convenience init(url: NSURL) {

		self.init()
		let request = NSMutableURLRequest(URL: url)
		request.setValue(readabilityUserAgent, forHTTPHeaderField: "User-Agent")

		let semaphore = dispatch_semaphore_create(0)

		var data: NSData?

		// Avoiding deadlock in shared session thread
		let sessionQueue = dispatch_queue_create("readability_url_session_queue", DISPATCH_QUEUE_SERIAL)
		dispatch_async(sessionQueue) {
			NSURLSession.sharedSession().dataTaskWithRequest(request,
				completionHandler: { (responseData, _, _) in
					data = responseData
					dispatch_semaphore_signal(semaphore)

			}).resume()
		}

		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

		guard let htmlData = data else {
			return
		}

		if self.checkForImage(htmlData) {
			self.directImageUrl = url.absoluteString
			return
		}

		parse(htmlData)
	}

	public convenience init(url: NSURL, completion: (() -> ())?) {

		self.init()

		let request = NSMutableURLRequest(URL: url)
		request.setValue(readabilityUserAgent, forHTTPHeaderField: "User-Agent")

		NSURLSession.sharedSession().dataTaskWithRequest(request,
			completionHandler: { (responseData, _, _) in
				guard let htmlData = responseData else {
					return
				}

				if self.checkForImage(htmlData) {
					self.directImageUrl = url.absoluteString
					completion?()
					return
				}

				self.parse(htmlData)
				completion?()

		}).resume()
	}

	private func checkForImage(data: NSData) -> Bool {
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
