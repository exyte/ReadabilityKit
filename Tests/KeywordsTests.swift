//
//  KeywordsTests.swift
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

import XCTest
import ReadabilityKit

class KeywordsTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testKeywords() {

		let content = "<html><head><title>test</title><meta name = \"keywords\" content = \"Test1, Test2\"><head><html>"
		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test keywords failed")
		let parser = Readability()
		parser.parse(contentData) { data in
			guard let keywords = data?.keywords else {
				XCTFail("Keywords parsing failed.")
				return
			}

			XCTAssert(keywords == ["Test1", "Test2"], "Keywords parsing failed.")
			expectation.fulfill()
		}

        waitForExpectationsWithTimeout(30.0) { error in
            if let err = error {
                XCTFail("Failed with error: \(err)")
            }
        }
	}
}
