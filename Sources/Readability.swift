//
//  Readability.swift
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

import Ji

public struct ReadabilityData {
	public let title: String
	public let description: String?
	public let topImage: String?
	public let text: String?
	public let topVideo: String?
	public let keywords: [String]?
}

open class Readability {

	// Queries in order of priority

	let descQueries: [(String, String?)] = [
		("//head/meta[@name='description']", "content"),
		("//head/meta[@property='og:description']", "content"),
		("//head/meta[@name='twitter:description']", "content"),
		("//head/meta[@property='twitter:description']", "content")
	]

	let titleQueries: [(String, String?)] = [
		("//head/title", nil),
		("//head/meta[@name='title']", "content"),
		("//head/meta[@property='og:title']", "content"),
		("//head/meta[@name='twitter:title']", "content")
	]

	let imageQueries: [(String, String?)] = [
		("//head/meta[@property='og:image']", "content"),
		("//head/meta[@name='twitter:image']", "content"),
		("//link[@rel='image_src']", "href"),
		("//head/meta[@name='thumbnail']", "content"),
		("//img[contains(@src,':small')]", "src")
	]

	let videoQueries: [(String, String?)] = [
		("//head/meta[@property='og:video:url']", "content")
	]

	let keywordsQueries: [(String, String?)] = [
		("//head/meta[@name='keywords']", "content"),
	]

	let unlikely = "com(bx|ment|munity)|dis(qus|cuss)|e(xtra|[-]?mail)|foot|"
		+ "header|menu|re(mark|ply)|rss|sh(are|outbox)|sponsor"
		+ "a(d|ll|gegate|rchive|ttachment)|(pag(er|ination))|popup|print|"
		+ "login|si(debar|gn|ngle)"

	let positive = "(^(body|content|h?entry|main|page|post|text|blog|story|haupt))"
		+ "|arti(cle|kel)|instapaper_body"

	let negative = "nav($|igation)|user|com(ment|bx)|(^com-)|contact|"
		+ "foot|masthead|(me(dia|ta))|outbrain|promo|related|scroll|(sho(utbox|pping))|"
		+ "sidebar|sponsor|tags|tool|widget|player|disclaimer|toc|infobox|vcard|post-ratings"

	let nodesTags = "p|div|td|h1|h2|article|section"

	var unlikelyRegExp: NSRegularExpression?
	var positiveRegExp: NSRegularExpression?
	var negativeRegExp: NSRegularExpression?
	var nodesRegExp: NSRegularExpression?

	fileprivate var document: Ji?
	fileprivate var maxWeight = 0
	fileprivate var maxWeightNode: JiNode?

	var maxWeightImgUrl: String?
	var maxWeightText: String?

	var directImageUrl: String?

	fileprivate func weightNode(_ node: JiNode) -> Int {
		var weight = 0

		if let className = node.attributes["class"] {
			let classNameRange = NSMakeRange(0, className.characters.count)
			if let positiveRegExp = positiveRegExp {
				if positiveRegExp.matches(in: className, options: NSRegularExpression.MatchingOptions.reportProgress, range: classNameRange).count > 0 {
					weight += 35
				}
			}

			if let unlikelyRegExp = unlikelyRegExp {
				if unlikelyRegExp.matches(in: className, options: NSRegularExpression.MatchingOptions.reportProgress, range: classNameRange).count > 0 {
					weight -= 20
				}
			}

			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matches(in: className, options: NSRegularExpression.MatchingOptions.reportProgress, range: classNameRange).count > 0 {
					weight -= 50
				}
			}
		}

		if let id = node.attributes["id"] {
			let idRange = NSMakeRange(0, id.characters.count)
			if let positiveRegExp = positiveRegExp {
				if positiveRegExp.matches(in: id, options: NSRegularExpression.MatchingOptions.reportProgress, range: idRange).count > 0 {
					weight += 40
				}
			}

			if let unlikelyRegExp = unlikelyRegExp {
				if unlikelyRegExp.matches(in: id, options: NSRegularExpression.MatchingOptions.reportProgress, range: idRange).count > 0 {
					weight -= 20
				}
			}

			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matches(in: id, options: NSRegularExpression.MatchingOptions.reportProgress, range: idRange).count > 0 {
					weight -= 50
				}
			}
		}

		if let style = node.attributes["style"] {
			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matches(in: style, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, style.characters.count)).count > 0 {
					weight -= 50
				}
			}
		}

		return weight
	}

	fileprivate func calcWeightForChild(_ node: JiNode, ownText: String) -> Int {

		var c = calculateNumberOfAppearance(ownText, substring: "&quot;")
		c += calculateNumberOfAppearance(ownText, substring: "&lt;")
		c += calculateNumberOfAppearance(ownText, substring: "&gt;")
		c += calculateNumberOfAppearance(ownText, substring: "px")

		var val = 0
		if c > 5 {
			val = -30
		} else {
			val = Int(Double(ownText.characters.count) / 25.0)
		}

		return val
	}

	fileprivate func weightChildNodes(_ node: JiNode) -> Int {
		var weight = 0
		var pEls = [JiNode]()
		var caption: JiNode?

		node.children.forEach { child in

			guard let text = child.content else {
				return
			}

			let length = text.characters.count
			if length < 20 {
				return
			}

			if length > 200 {
				weight += max(50, length / 10)
			}

			let tagName = node.tag
			if tagName == "h1" || tagName == "h2" {
				weight += 30
			}
			else if tagName == "div" || tagName == "p" {
				weight += calcWeightForChild(child, ownText: text)

				if tagName == "p" && length > 50 {
					pEls.append(child)
				}

				if let className = node.attributes["class"] {
					if className.lowercased() == "caption" {
						caption = node
					}
				}
			}

			if caption != .none {
				weight += 30
			}
		}

		return weight
	}

	fileprivate func calculateNumberOfAppearance(_ str: String, substring: String) -> Int {
		var c = 0
		guard let firstElement = str.range(of: substring)?.lowerBound else {
			return 0
		}

		let index = str.characters.distance(from: str.startIndex, to: firstElement)
		if index >= 0 {
			c += 1
            
            let sourceStr = String(str[str.index(firstElement, offsetBy: substring.characters.count)...])
            c += calculateNumberOfAppearance(sourceStr,
                                             substring: substring)
            
            //c += calculateNumberOfAppearance(str.substring(from: str.index(firstElement, offsetBy: substring.characters.count)), substring: substring)

		}

		return c
	}

	fileprivate func importantNodes() -> [JiNode]? {

		if let bodyNodes = document?.xPath("//body") {
			if bodyNodes.count > 0 {
				if let innerNodes = bodyNodes.first?.xPath("//*") {
					return Array(innerNodes)
				}
			}
		}

		return .none
	}

	fileprivate func findMaxWeightNode() {
		maxWeight = 0
		do {
			try unlikelyRegExp = NSRegularExpression(pattern: unlikely, options: NSRegularExpression.Options.caseInsensitive)
			try positiveRegExp = NSRegularExpression(pattern: positive, options: NSRegularExpression.Options.caseInsensitive)
			try negativeRegExp = NSRegularExpression(pattern: negative, options: NSRegularExpression.Options.caseInsensitive)
			try nodesRegExp = NSRegularExpression(pattern: nodesTags, options: NSRegularExpression.Options.caseInsensitive)
		}
		catch _ {
			NSLog("Error creating regular expressions")
			return
		}

		if let importantNodes = importantNodes() {

			for node in importantNodes {
				var weight = weightNode(node)
				guard let stringValue = node.content else {
					continue
				}
				weight += stringValue.characters.count / 10

				weight += weightChildNodes(node)
				if (weight > maxWeight)
				{
					maxWeight = weight
					maxWeightNode = node
				}

				if weight > 200 {
					break
				}
			}
		}

		// Uncomment to debug
		/*
		 if let maxWeightNOdeDesc = maxWeightNode?.stringValue {
		 print("Max weight \(self.maxWeight) for \(maxWeightNOdeDesc)")
		 }
		 */
	}

	fileprivate func sizeWeight(_ imgNode: JiNode) -> Int {
		var weight = 0
		if let widthStr = imgNode.attributes["width"] {
            if let width = Int(widthStr) {
                if width >= 50 {
                    weight += 20
                }
                else {
                    weight -= 20
                }
            }
		}

		if let heightStr = imgNode.attributes["height"] {
            if let height = Int(heightStr) {
                if height >= 50 {
                    weight += 20
                }
                else {
                    weight -= 20
                }
            }
		}

		return weight
	}

	fileprivate func altWeight(_ imgNode: JiNode) -> Int {
		var weight = 0
		if let altStr = imgNode.attributes["alt"] {
			if (altStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	fileprivate func titleWeight(_ imgNode: JiNode) -> Int {
		var weight = 0
		if let titleStr = imgNode.attributes["title"] {
			if (titleStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	fileprivate func determineImageSource(_ node: JiNode) -> JiNode? {
		var maxImgWeight = 20.0
		var maxImgNode: JiNode?

		var imageNodes = node.xPath("//img")
		if imageNodes.count == 0 {
			if let parent = node.parent {
				imageNodes = parent.xPath("//img")
			}
		}

		var score = 1.0
		imageNodes.forEach { imageNode in

			guard let url = imageNode.attributes["src"] else {
				return
			}

			if isAdImage(url) {
				return
			}

			var weight = Double(sizeWeight(imageNode) +
					altWeight(imageNode) +
					titleWeight(imageNode))

			if let parent = imageNode.parent {
				if let _ = parent.attributes["rel"] {
					weight -= 40.0
				}
			}

			weight = weight * score

			if weight > maxImgWeight {
				maxImgWeight = weight
				maxImgNode = imageNode
				score = score / 2.0
			}

		}

		return maxImgNode
	}

	fileprivate func isAdImage(_ url: String) -> Bool {
		return calculateNumberOfAppearance(url, substring: "ad") > 2
	}

	fileprivate func clearNodeContent(_ node: JiNode) -> String? {
		guard var strValue = node.content else {
			return .none
		}

		let nodesToRemove = [
			node.xPath("//script"),
			node.xPath("//noscript"),
			node.xPath("//style")].flatMap { $0 }
		nodesToRemove.forEach { nodeToRemove in
			guard let contentToRemove = nodeToRemove.content else {
				return
			}

			strValue = strValue.replacingOccurrences(of: contentToRemove, with: "")
		}

		return strValue
	}

	fileprivate func extractText(_ node: JiNode) -> String?
	{
		guard let strValue = clearNodeContent(node) else {
			return .none
		}

		let texts = strValue.replacingOccurrences(of: "\t", with: "").components(separatedBy: CharacterSet.newlines)
		var importantTexts = [String]()
		let extractedTitle = title()
		texts.forEach({ (text: String) in
			let length = text.characters.count

			if let titleLength = extractedTitle?.characters.count {
				if length > titleLength {
					importantTexts.append(text)
				}

			} else if length > 100 {
				importantTexts.append(text)
			}
		})
		return importantTexts.first?.trim()
	}

	fileprivate func extractFullText(_ node: JiNode) -> String?
	{
		guard let strValue = clearNodeContent(node) else {
			return .none
		}

		let texts = strValue.replacingOccurrences(of: "\t", with: "").components(separatedBy: CharacterSet.newlines)
		var importantTexts = [String]()
		texts.forEach({ (text: String) in
			let length = text.characters.count
			if length > 175 {
				importantTexts.append(text)
			}
		})

		var fullText = importantTexts.reduce("", { $0 + "\n" + $1 })
		lowContentChildren(node).forEach { lowContent in
			fullText = fullText.replacingOccurrences(of: lowContent, with: "")
		}

		return fullText
	}

	fileprivate func lowContentChildren(_ node: JiNode) -> [String] {

		var contents = [String]()

		if node.children.count == 0 {
			if let content = node.content {
				let length = content.characters.count
				if length > 3 && length < 175 {
					contents.append(content)
				}
			}
		}

		node.children.forEach { childNode in
			contents.append(contentsOf: lowContentChildren(childNode))
		}

		return contents
	}

	open class func parse(_ htmlData: Data) -> ReadabilityData? {
		let readability = Readability()
		return readability.parseData(htmlData)
	}

	func parseData(_ htmlData: Data) -> ReadabilityData? {
		self.document = Ji(htmlData: htmlData)

		self.findMaxWeightNode()

		if let maxWeightNode = self.maxWeightNode {
			if let imageNode = self.determineImageSource(maxWeightNode) {
				self.maxWeightImgUrl = imageNode.attributes["src"]
			}

			// Text
			self.maxWeightText = self.extractText(maxWeightNode)
		}

		guard let title = self.title() else {
			return .none
		}

		let parsedData = ReadabilityData(
			title: title,
			description: self.description(),
			topImage: self.topImage(),
			text: self.text(),
			topVideo: self.topVideo(),
			keywords: self.keywords()
		)

		return parsedData
	}

	fileprivate func extractValueUsing(_ document: Ji, path: String, attribute: String?) -> String? {

		guard let nodes = document.xPath(path) else {
			return .none
		}

		if nodes.count == 0 {
			return .none
		}

		if let node = nodes.first {

			// Valid attribute
			if let attribute = attribute {
				if let attrNode = node.attributes[attribute] {
					return attrNode
				}
			}
			// Not using attribute
			else {
				return node.content
			}
		}

		return .none
	}

	fileprivate func extractValuesUsing(_ document: Ji, path: String, attribute: String?) -> [String]? {
		var values: [String]?

		let nodes = document.xPath(path)
		values = [String]()
		nodes?.forEach { node in

			if let attribute = attribute {
				if let value = node.attributes[attribute] {
					values?.append(value)
				}
			}
			else {
				if let content = node.content {
					values?.append(content)
				}
			}
		}

		return values
	}

	fileprivate func extractValueUsing(_ document: Ji, queries: [(String, String?)]) -> String? {
		for query in queries {
			if let value = extractValueUsing(document, path: query.0, attribute: query.1) {
				return value
			}
		}

		return nil
	}

	fileprivate func extractValuesUsing(_ document: Ji, queries: [(String, String?)]) -> [String]? {
		for query in queries {
			if let values = extractValuesUsing(document, path: query.0, attribute: query.1) {
				return values
			}
		}

		return nil
	}

	open func title() -> String?
	{
		if let document = document {
			guard let title = extractValueUsing(document, queries: titleQueries) else {
				return .none
			}

			if title.characters.count == 0 {
				return .none
			}

			return title
		}

		return .none
	}

	func description() -> String?
	{
		if let document = document {
			if let description = extractValueUsing(document, queries: descQueries) {
				return description
			}
		}

		return maxWeightText
	}

	func text() -> String? {
		guard let maxWeightNode = maxWeightNode else {
			return .none
		}

		return extractFullText(maxWeightNode)?.trim()
	}

	func topImage() -> String?
	{
		if let document = document {
			if let imageUrl = extractValueUsing(document, queries: imageQueries) {
				return imageUrl
			}
		}

		return maxWeightImgUrl
	}

	func topVideo() -> String? {
		if let document = document {
			if let imageUrl = extractValueUsing(document, queries: videoQueries) {
				return imageUrl
			}
		}

		return .none
	}

	func keywords() -> [String]?
	{
		if let document = document {
			if let values = extractValuesUsing(document, queries: keywordsQueries) {
				var keywords = [String]()
				values.forEach { (value: String) in
					var separatorsCharacterSet = CharacterSet.whitespacesAndNewlines
					separatorsCharacterSet.formUnion(NSCharacterSet.punctuationCharacters)
					keywords.append(contentsOf: value.components(separatedBy: separatorsCharacterSet))
				}

				keywords = keywords.filter({ $0.characters.count > 1 })

				return keywords
			}
		}

		return .none
	}
}
