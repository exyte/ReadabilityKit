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

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testReadcerealPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("readcereal", ofType: "html") else {
			XCTFail("No resource path available")
			return
		}

		guard let htmlData = NSData(contentsOfFile: path) else {
			XCTFail("No resource file available")
			return
		}

		let readability = Readability(data: htmlData)

		XCTAssert(readability.title() == "Amsterdam Fog - Cereal", "Wrong title")
		XCTAssert(readability.description() == "        The name Amsterdam arises from the city’s beginnings as a dam on the river Amstel. During the 17th century, a series of canals were built in four main bands, forming concentric circles inside the city, flowing south towards the river. Amsterdam’s historic canals, which total over 100km, are dotted with 1500 bridges, forming a sweeping network of aqua and stone.",
			"Wrong description")
		XCTAssert(readability.topImage() == "http://readcereal.com/wp-content/uploads/2015/11/jounral-post-three.jpg",
			"Wrong image url")
	}

	func testStarwarsPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("starwars", ofType: "html") else {
			XCTFail("No resource path available")
			return
		}

		let url = NSURL(fileURLWithPath: path)
		let readability = Readability(url: url)

		XCTAssert(readability.title() == "From a Certain Point of View: What Is the Best Scene in Star Wars: The Force Awakens? | StarWars.com")
		XCTAssert(readability.description() == "Two StarWars.com writers argue for what they consider the best scene in Star Wars: The Force Awakens!",
			"Wrong description")
		XCTAssert(readability.topImage() == "http://a.dilcdn.com/bl/wp-content/uploads/sites/6/2015/10/star-wars-force-awakens-official-poster.jpg",
			"Wrong image url")
	}

	func testMmochampionPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("mmochampion", ofType: "html") else {
			XCTFail("No resource path available")
			return
		}

		let url = NSURL(fileURLWithPath: path)
		guard let htmlStr = try? String(contentsOfURL: url) else {
			XCTFail("No resource path available")
			return
		}

		let readability = Readability(string: htmlStr)

		XCTAssert(readability.title() == "MMO-Champion - World of Warcraft News and Raiding Strategies")
		XCTAssert(readability.description() == "Articles and forums with game news and raiding strategies.")

		let keywords = ["mmo", "news", "world", "of", "warcraft", "raids", "mmo", "wow"]

		guard let readabilityKeywords = readability.keywords() else {
			return
		}

		XCTAssert(readabilityKeywords == keywords, "Wrong image url")
	}
}
