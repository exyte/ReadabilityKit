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

#if os(OSX)
	import AppKit
#else
	import UIKit
#endif

public class Readability {

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
		("//head/meta[@name='thumbnail']", "content")
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

	let posetive = "(^(body|content|h?entry|main|page|post|text|blog|story|haupt))"
		+ "|arti(cle|kel)|instapaper_body"

	let negative = "nav($|igation)|user|com(ment|bx)|(^com-)|contact|"
		+ "foot|masthead|(me(dia|ta))|outbrain|promo|related|scroll|(sho(utbox|pping))|"
		+ "sidebar|sponsor|tags|tool|widget|player|disclaimer|toc|infobox|vcard|post-ratings"

	let nodesTags = "p|div|td|h1|h2|article|section"

	var unlikelyRegExp: NSRegularExpression?
	var posetiveRegExp: NSRegularExpression?
	var negativeRegExp: NSRegularExpression?
	var nodesRegExp: NSRegularExpression?

	private var document: Ji?
	private var maxWeight = 0
	private var maxWeightNode: JiNode?

	var maxWeightImgUrl: String?
	var maxWeightText: String?

	var directImageUrl: String?

	private func weightNode(node: JiNode) -> Int {
		var weight = 0

		if let className = node.attributes["class"] {
			let classNameRange = NSMakeRange(0, className.characters.count)
			if let posetiveRegExp = posetiveRegExp {
				if posetiveRegExp.matchesInString(className, options: NSMatchingOptions.ReportProgress, range: classNameRange).count > 0 {
					weight += 35
				}
			}

			if let unlikelyRegExp = unlikelyRegExp {
				if unlikelyRegExp.matchesInString(className, options: NSMatchingOptions.ReportProgress, range: classNameRange).count > 0 {
					weight -= 20
				}
			}

			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matchesInString(className, options: NSMatchingOptions.ReportProgress, range: classNameRange).count > 0 {
					weight -= 50
				}
			}
		}

		if let id = node.attributes["id"] {
			let idRange = NSMakeRange(0, id.characters.count)
			if let posetiveRegExp = posetiveRegExp {
				if posetiveRegExp.matchesInString(id, options: NSMatchingOptions.ReportProgress, range: idRange).count > 0 {
					weight += 40
				}
			}

			if let unlikelyRegExp = unlikelyRegExp {
				if unlikelyRegExp.matchesInString(id, options: NSMatchingOptions.ReportProgress, range: idRange).count > 0 {
					weight -= 20
				}
			}

			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matchesInString(id, options: NSMatchingOptions.ReportProgress, range: idRange).count > 0 {
					weight -= 50
				}
			}
		}

		if let style = node.attributes["style"] {
			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matchesInString(style, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, style.characters.count)).count > 0 {
					weight -= 50
				}
			}
		}

		return weight
	}

	private func calcWeightForChild(node: JiNode, ownText: String) -> Int {

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

	private func weightChildNodes(node: JiNode) -> Int {
		var weight = 0
		var pEls = [JiNode]()
		var caption: JiNode?

		node.children.forEach { child in

			guard var text = child.content else {
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
					if className.lowercaseString == "caption" {
						caption = node
					}
				}
			}

			if caption != .None {
				weight += 30
			}
		}

		return weight
	}

	private func calculateNumberOfAppearance(str: String, substring: String) -> Int {
		var c = 0
		guard let firstElement = str.rangeOfString(substring)?.startIndex else {
			return 0
		}

		let index = str.startIndex.distanceTo(firstElement)
		if index >= 0 {
			c += 1
			c += calculateNumberOfAppearance(str.substringFromIndex(firstElement.advancedBy(substring.characters.count)), substring: substring)

		}

		return c
	}

	private func importantNodes() -> [JiNode]? {

		if let bodyNodes = document?.xPath("//body") {
			if bodyNodes.count > 0 {
				if let innerNodes = bodyNodes.first?.xPath("//*") {
					return Array(innerNodes)
				}
			}
		}

		return .None
	}

	private func findMaxWeightNode() {
		maxWeight = 0
		do {
			try unlikelyRegExp = NSRegularExpression(pattern: unlikely, options: NSRegularExpressionOptions.CaseInsensitive)
			try posetiveRegExp = NSRegularExpression(pattern: posetive, options: NSRegularExpressionOptions.CaseInsensitive)
			try negativeRegExp = NSRegularExpression(pattern: negative, options: NSRegularExpressionOptions.CaseInsensitive)
			try nodesRegExp = NSRegularExpression(pattern: nodesTags, options: NSRegularExpressionOptions.CaseInsensitive)
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

	private func sizeWeight(imgNode: JiNode) -> Int {
		var weight = 0
		if let widthStr = imgNode.attributes["width"] {
			let width = Int(widthStr)
			if width >= 50 {
				weight += 20
			}
			else {
				weight -= 20
			}
		}

		if let heightStr = imgNode.attributes["height"] {
			let height = Int(heightStr)
			if height >= 50 {
				weight += 20
			}
			else {
				weight -= 20
			}
		}

		return weight
	}

	private func altWeight(imgNode: JiNode) -> Int {
		var weight = 0
		if let altStr = imgNode.attributes["alt"] {
			if (altStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	private func titleWeight(imgNode: JiNode) -> Int {
		var weight = 0
		if let titleStr = imgNode.attributes["title"] {
			if (titleStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	private func determineImageSource(node: JiNode) -> JiNode? {
		var maxImgWeight = 20
		var maxImgNode: JiNode?

		let imageNodes = node.xPath("//img")
		imageNodes.forEach { imageNode in
			let weight = sizeWeight(imageNode) +
				altWeight(imageNode) +
				titleWeight(imageNode)

			if weight > maxImgWeight {
				maxImgWeight = weight
				maxImgNode = imageNode
			}
		}

		return maxImgNode
	}

	private func clearNodeContent(node: JiNode) -> String? {
		guard var strValue = node.content else {
			return .None
		}

		let nodesToRemove = [
			node.xPath("//script"),
			node.xPath("//noscript"),
			node.xPath("//style")].flatMap { $0 }
		nodesToRemove.forEach { nodeToRemove in
			guard let contentToRemove = nodeToRemove.content else {
				return
			}

			strValue = strValue.stringByReplacingOccurrencesOfString(contentToRemove, withString: "")
		}

		return strValue
	}

	private func extractText(node: JiNode) -> String?
	{
		guard let strValue = clearNodeContent(node) else {
			return .None
		}

		let texts = strValue.stringByReplacingOccurrencesOfString("\t", withString: "").componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		var importantTexts = [String]()
		texts.forEach({ (text: String) in
			let length = text.characters.count
			if length > 140 {
				importantTexts.append(text)
			}
		})
		return importantTexts.first
	}

	private func extractFullText(node: JiNode) -> String?
	{
		guard let strValue = clearNodeContent(node) else {
			return .None
		}

		let texts = strValue.stringByReplacingOccurrencesOfString("\t", withString: "").componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		var importantTexts = [String]()
		texts.forEach({ (text: String) in
			let length = text.characters.count
			if length > 175 {
				importantTexts.append(text)
			}
		})

		var fullText = importantTexts.reduce("", combine: { $0 + "\n" + $1 })
		lowContentChildren(node).forEach { lowContent in
			fullText = fullText.stringByReplacingOccurrencesOfString(lowContent, withString: "")
		}

		return fullText
	}

	private func lowContentChildren(node: JiNode) -> [String] {

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
			contents.appendContentsOf(lowContentChildren(childNode))
		}

		return contents
	}

	public convenience init(string: String) {
		guard let htmlData = string.dataUsingEncoding(NSUTF8StringEncoding) else {
			self.init(data: NSData())
			return
		}

		self.init(data: htmlData)
	}

	public convenience init(url: NSURL) {

		let request = NSURLRequest(URL: url)
		let semaphore = dispatch_semaphore_create(0)

		var data: NSData?
		NSURLSession.sharedSession().dataTaskWithRequest(request,
			completionHandler: { (responseData, _, _) in
				data = responseData
				dispatch_semaphore_signal(semaphore)

		}).resume()

		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

		guard let htmlData = data else {
			self.init(data: NSData())
			return
		}

		#if os(OSX)
			let image = NSImage(data: htmlData)
		#else
			let image = UIImage(data: htmlData)
		#endif

		if let _ = image {
			self.init(data: NSData())
			self.directImageUrl = url.absoluteString
			return
		}

		self.init(data: htmlData)
	}

	public required init(data htmlData: NSData)
	{
		document = Ji(htmlData: htmlData)

		findMaxWeightNode()

		if let maxWeightNode = maxWeightNode {
			if let imageNode = determineImageSource(maxWeightNode) {
				maxWeightImgUrl = imageNode.attributes["src"]
			}

			// Text
			maxWeightText = extractText(maxWeightNode)
		}
	}

	private func extractValueUsing(document: Ji, path: String, attribute: String?) -> String? {

		guard let nodes = document.xPath(path) else {
			return .None
		}

		if nodes.count == 0 {
			return .None
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

		return .None
	}

	private func extractValuesUsing(document: Ji, path: String, attribute: String?) -> [String]? {
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

	private func extractValueUsing(document: Ji, queries: [(String, String?)]) -> String? {
		for query in queries {
			if let value = extractValueUsing(document, path: query.0, attribute: query.1) {
				return value
			}
		}

		return nil
	}

	private func extractValuesUsing(document: Ji, queries: [(String, String?)]) -> [String]? {
		for query in queries {
			if let values = extractValuesUsing(document, path: query.0, attribute: query.1) {
				return values
			}
		}

		return nil
	}

	public func title() -> String?
	{
		if let document = document {
			guard let title = extractValueUsing(document, queries: titleQueries) else {
				return .None
			}

			if title.characters.count == 0 {
				return .None
			}

			return title
		}

		return nil
	}

	public func description() -> String?
	{
		if let document = document {
			if let description = extractValueUsing(document, queries: descQueries) {
				return description
			}
		}

		return maxWeightText
	}

	public func text() -> String? {
		guard let maxWeightNode = maxWeightNode else {
			return .None
		}

		return extractFullText(maxWeightNode)
	}

	public func topImage() -> String?
	{
		if let _ = directImageUrl {
			return directImageUrl
		}

		if let document = document {
			if let imageUrl = extractValueUsing(document, queries: imageQueries) {
				return imageUrl
			}
		}

		return maxWeightImgUrl
	}

	public func topVideo() -> String? {
		if let document = document {
			if let imageUrl = extractValueUsing(document, queries: videoQueries) {
				return imageUrl
			}
		}

		return .None
	}

	public func keywords() -> [String]?
	{
		if let document = document {
			if let values = extractValuesUsing(document, queries: keywordsQueries) {
				var keywords = [String]()
				values.forEach { (value: String) in
					let separatorsCharacterSet = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()
					separatorsCharacterSet.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
					keywords.appendContentsOf(value.componentsSeparatedByCharactersInSet(separatorsCharacterSet))
				}

				keywords = keywords.filter({ $0.characters.count > 1 })

				return keywords
			}
		}

		return .None
	}
}
