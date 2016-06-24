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
		XCTAssert(readability.imageUrl() == "http://readcereal.com/wp-content/uploads/2015/11/jounral-post-three.jpg",
			"Wrong image url")
	}

	func testStarwarsPage() {

		let bundle = NSBundle(forClass: self.dynamicType)
		guard let path = bundle.pathForResource("starwars", ofType: "html") else {
			XCTFail("No resource path available")
			return
		}

		guard let htmlData = NSData(contentsOfFile: path) else {
			XCTFail("No resource file available")
			return
		}

		let readability = Readability(data: htmlData)

		XCTAssert(readability.title() == "From a Certain Point of View: What Is the Best Scene in Star Wars: The Force Awakens? | StarWars.com")
		XCTAssert(readability.description() == "Two StarWars.com writers argue for what they consider the best scene in Star Wars: The Force Awakens!",
			"Wrong description")
		XCTAssert(readability.imageUrl() == "http://a.dilcdn.com/bl/wp-content/uploads/sites/6/2015/10/star-wars-force-awakens-official-poster.jpg",
			"Wrong image url")
	}
}
