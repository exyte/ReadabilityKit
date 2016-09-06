//
//  NodeWeightTests.swift
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

class NodeWeightTests: XCTestCase {

	func testNodeWeightCase1() {

		let content = "<html><head><title>test</title></head><body><tag1 class = \"main\"  id = \"blog\" style = \"text\"><img src = \"imageUrl1\"></tag1><tag2><img src = \"imageUrl2\" title = \"Really long long title. To outweight first image. Abit more symbols.\" height =\"150\"></tag2><body><html>"

		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test node weight case 1")
		Readability.parse(data: contentData) { data in
			guard let imageUrl = data?.topImage else {
				XCTFail("Image parsing failed.")
				return
			}

			XCTAssert(imageUrl == "imageUrl2", "Node weight calculation failed.")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}

	func testNodeWeightCase2() {

		let content = "<html><head><title>Test.</title></head><body><tag1 class = \"widget\" id = \"widget\" style = \"text\">From a private hospital for the insane near Providence, Rhode Island, there recently disappeared an exceedingly singular person. He bore the name of Charles Dexter Ward, and was placed under restraint most reluctantly by the grieving father who had watched his aberration grow from a mere eccentricity to a dark mania involving both a possibility of murderous tendencies and a profound and peculiar change in the apparent contents of his mind. Doctors confess themselves quite baffled by his case, since it presented oddities of a general physiological as well as psychological character.</tag1><tag2 class = \"main\" id = \"blog\" style = \"text\">In the first place, the patient seemed oddly older than his twenty-six years would warrant. Mental disturbance, it is true, will age one rapidly; but the face of this young man had taken on a subtle cast which only the very aged normally acquire. In the second place, his organic processes shewed a certain queerness of proportion which nothing in medical experience can parallel. Respiration and heart action had a baffling lack of symmetry; the voice was lost, so that no sounds above a whisper were possible; digestion was incredibly prolonged and minimised, and neural reactions to standard stimuli bore no relation at all to anything heretofore recorded, either normal or pathological. The skin had a morbid chill and dryness, and the cellular structure of the tissue seemed exaggeratedly coarse and loosely knit. Even a large olive birthmark on the right hip had disappeared, whilst there had formed on the chest a very peculiar mole or blackish spot of which no trace existed before. In general, all physicians agree that in Ward the processes of metabolism had become retarded to a degree beyond precedent.</tag2><body><html>"

		guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
			return
		}

		let expectation = expectationWithDescription("Test node weight case 1")
		Readability.parse(data: contentData) { data in
			guard let description = data?.description else {
				XCTFail("Description parsing failed.")
				return
			}

			XCTAssert(description == "Test.From a private hospital for the insane near Providence, Rhode Island, there recently disappeared an exceedingly singular person. He bore the name of Charles Dexter Ward, and was placed under restraint most reluctantly by the grieving father who had watched his aberration grow from a mere eccentricity to a dark mania involving both a possibility of murderous tendencies and a profound and peculiar change in the apparent contents of his mind. Doctors confess themselves quite baffled by his case, since it presented oddities of a general physiological as well as psychological character.In the first place, the patient seemed oddly older than his twenty-six years would warrant. Mental disturbance, it is true, will age one rapidly; but the face of this young man had taken on a subtle cast which only the very aged normally acquire. In the second place, his organic processes shewed a certain queerness of proportion which nothing in medical experience can parallel. Respiration and heart action had a baffling lack of symmetry; the voice was lost, so that no sounds above a whisper were possible; digestion was incredibly prolonged and minimised, and neural reactions to standard stimuli bore no relation at all to anything heretofore recorded, either normal or pathological. The skin had a morbid chill and dryness, and the cellular structure of the tissue seemed exaggeratedly coarse and loosely knit. Even a large olive birthmark on the right hip had disappeared, whilst there had formed on the chest a very peculiar mole or blackish spot of which no trace existed before. In general, all physicians agree that in Ward the processes of metabolism had become retarded to a degree beyond precedent.")
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(30.0) { error in
			if let err = error {
				XCTFail("Failed with error: \(err)")
			}
		}
	}
}
