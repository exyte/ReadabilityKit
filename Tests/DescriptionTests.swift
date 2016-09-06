//
//  DescriptionTests.swift
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

class DescriptionTests: XCTestCase {

	func testDescriptionCase1() {

		let content = "<html><head><title>test</title><meta name = \"description\" content = \"Test\"><head><html>"
		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test description case 1 failed")

		let parser = Readability()
		parser.parse(contentData) { data in
			guard let description = data?.description else {
				XCTFail("Description parsing failed.")
				return
			}

			XCTAssert(description == "Test", "Description parsing failed.")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}

	func testDescriptionCase2() {

		let content = "<html><head><title>test</title><meta property = \"og:description\" content = \"Test\"><head><html>"
		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test description case 2 failed")

		let parser = Readability()
		parser.parse(contentData) { data in
			guard let description = data?.description else {
				XCTFail("Description parsing failed.")
				return
			}

			XCTAssert(description == "Test", "Description parsing failed.")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}

	func testDescriptionCase3() {

		let content = "<html><head><title>test</title><meta name = \"twitter:description\" content = \"Test\"><head><html>"
		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test description case 3 failed")
		let parser = Readability()
		parser.parse(contentData) { data in
			guard let description = data?.description else {
				XCTFail("Description parsing failed.")
				return
			}

			XCTAssert(description == "Test", "Description parsing failed.")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}
}
