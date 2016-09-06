//
//  PagesTests.swift
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
import XCTest
import ReadabilityKit

class Tests: XCTestCase {

	func testReadcerealPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("readcereal", ofType: .None) else {
			XCTFail("No resource path available")
			return
		}

		guard let htmlData = NSData(contentsOfFile: path) else {
			XCTFail("No resource file available")
			return
		}

		let expectation = expectationWithDescription("Test readcereal page")
		let readability = Readability()
		readability.parse(htmlData) { data in
			guard let parsedData = data else {
				XCTFail("Parsing failed")
				return
			}

			guard let description = parsedData.description else {
				XCTFail("Parsing failed")
				return
			}

			guard let topImage = parsedData.topImage else {
				XCTFail("Parsing failed")
				return
			}

			XCTAssert(parsedData.title == "Amsterdam Fog - Cereal", "Wrong title")
			XCTAssert(description == "Travel & Style Magazine",
				"Wrong description")
			XCTAssert(topImage == "http://readcereal.com/wp-content/uploads/2015/11/jounral-post-three.jpg",
				"Wrong image url")

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}

	func testStarwarsPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("starwars", ofType: .None) else {
			XCTFail("No resource path available")
			return
		}

		let expectation = expectationWithDescription("Test starwars page")
		let readability = Readability()

		let url = NSURL(fileURLWithPath: path)
		readability.parse(url) { data in

			guard let parsedData = data else {
				XCTFail("Parsing failed")
				return
			}

			guard let description = parsedData.description else {
				XCTFail("Parsing failed")
				return
			}

			guard let topImage = parsedData.topImage else {
				XCTFail("Parsing failed")
				return
			}

			XCTAssert(parsedData.title == "From a Certain Point of View: What Is the Best Scene in Star Wars: The Force Awakens? | StarWars.com")
			XCTAssert(description == "Two StarWars.com writers argue for what they consider the best scene in Star Wars: The Force Awakens!",
				"Wrong description")
			XCTAssert(topImage == "http://a.dilcdn.com/bl/wp-content/uploads/sites/6/2015/10/star-wars-force-awakens-official-poster.jpg",
				"Wrong image url")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}

	func testMmochampionPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("mmochampion", ofType: .None) else {
			XCTFail("No resource path available")
			return
		}

		let url = NSURL(fileURLWithPath: path)
		guard let htmlStr = try? String(contentsOfURL: url) else {
			XCTFail("No resource path available")
			return
		}

		let expectation = expectationWithDescription("Test starwars page")
		let readability = Readability()
		readability.parse(htmlStr) { data in
			guard let parsedData = data else {
				XCTFail("Parsing failed")
				return
			}

			guard let description = parsedData.description else {
				XCTFail("Parsing failed")
				return
			}

			guard let keywords = parsedData.keywords else {
				XCTFail("Parsing failed")
				return
			}

			XCTAssert(parsedData.title == "MMO-Champion - World of Warcraft News and Raiding Strategies")
			XCTAssert(description == "Articles and forums with game news and raiding strategies.")

			let words = ["mmo", "news", "world", "of", "warcraft", "raids", "mmo", "wow"]
			XCTAssert(keywords == words, "Wrong image url")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}
}
