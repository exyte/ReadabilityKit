import Fuzi

public class Readability {

	// Queries in order of priority

	let descQueries: [(String, String?)] = [
		("//head/meta[@name='description']", "content"),
		("//head/meta[@property='og:description']", "content"),
		("//head/meta[@name='twitter:description']", "content")
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
		+ "sidebar|sponsor|tags|tool|widget|player|disclaimer|toc|infobox|vcard"

	let nodesTags = "p|div|td|h1|h2|article|section"

	var unlikelyRegExp: NSRegularExpression?
	var posetiveRegExp: NSRegularExpression?
	var negativeRegExp: NSRegularExpression?
	var nodesRegExp: NSRegularExpression?

	private var document: XMLDocument?
	private var maxWeight = 0
	private var maxWeightNode: XMLElement?

	var maxWeightImgUrl: String?
	var maxWeightText: String?

	private func weightNode(node: XMLElement) -> Int {
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

		if let style = node.attributes["style"] { // node.attributeForName("style")?.stringValue() {
			if let negativeRegExp = negativeRegExp {
				if negativeRegExp.matchesInString(style, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, style.characters.count)).count > 0 {
					weight -= 50
				}
			}
		}

		return weight
	}

	private func calcWeightForChild(node: XMLElement, ownText: String) -> Int {
		return 0
	}

	private func weightChildNodes(node: XMLElement) -> Int {
		var weight = 0
		var pEls = [XMLElement]()
		var caption: XMLElement?

		node.children.forEach { child in

			let text = child.stringValue

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

			if caption != nil {
				weight += 30
			}
		}

		return weight
	}

	private func importantNodes() -> [XMLElement]? {

		if let bodyNodes = document?.xpath("//body") { // try(document?.nodesForXPath("//body") as? [GDataXMLElement]) {
			if bodyNodes.count > 0 {
				if let innerNodes = bodyNodes.first?.xpath("//*") {
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
			importantNodes.forEach { node in
				var weight = weightNode(node)
				let stringValue = node.stringValue
				weight += stringValue.characters.count / 10

				weight += weightChildNodes(node)
				if (weight > maxWeight)
				{
					maxWeight = weight
					maxWeightNode = node
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

	private func sizeWeight(imgNode: XMLElement) -> Int {
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

	private func altWeight(imgNode: XMLElement) -> Int {
		var weight = 0
		if let altStr = imgNode.attributes["alt"] {
			if (altStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	private func titleWeight(imgNode: XMLElement) -> Int {
		var weight = 0
		if let titleStr = imgNode.attributes["title"] {
			if (titleStr.characters.count > 35) {
				weight += 20
			}
		}

		return weight
	}

	private func determineImageSource(node: XMLElement) -> XMLElement? {

		var maxImgWeight = 20
		var maxImgNode: XMLElement?

		let imageNodes = node.xpath("//img")
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

	private func extractText(node: XMLElement) -> String?
	{
		let strValue = node.stringValue

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

	public init(data htmlData: NSData)
	{
		do {
			try document = XMLDocument(data: htmlData)
		}
		catch {
			NSLog("Error parsing html data")
			return
		}

		findMaxWeightNode()
		if let maxWeightNode = maxWeightNode {

			// Images
			if let imageNode = determineImageSource(maxWeightNode) {
				maxWeightImgUrl = imageNode.attributes["src"]
			}

			// Text
			maxWeightText = extractText(maxWeightNode)
		}
	}

	private func extractValueUsing(document: XMLDocument, path: String, attribute: String?) -> String? {

		let nodes = document.xpath(path)
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
				return node.stringValue
			}
		}

		return .None
	}

	private func extractValuesUsing(document: XMLDocument, path: String, attribute: String?) -> [String]? {
		var values: [String]?

		let nodes = document.xpath(path)
		values = [String]()
		nodes.forEach { node in

			if let attribute = attribute {
				if let value = node.attributes[attribute] {
					values?.append(value)
				}
			}
			else {
				values?.append(node.stringValue)
			}
		}

		return values
	}

	private func extractValueUsing(document: XMLDocument, queries: [(String, String?)]) -> String? {
		for query in queries {
			if let value = extractValueUsing(document, path: query.0, attribute: query.1) {
				return value
			}
		}

		return nil
	}

	private func extractValuesUsing(document: XMLDocument, queries: [(String, String?)]) -> [String]? {
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

	public func imageUrl() -> String?
	{
		if let document = document {
			if let imageUrl = extractValueUsing(document, queries: imageQueries) {
				return imageUrl
			}
		}

		return maxWeightImgUrl
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
