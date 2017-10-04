//
//  JiNode.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang (张宏昊)
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
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import libxml2

public typealias 戟节点 = JiNode

/**
JiNode types, these match element types in tree.h

*/
public enum JiNodeType: Int {
	case element = 1
	case attribute = 2
	case text = 3
	case cDataSection = 4
	case entityRef = 5
	case entity = 6
	case pi = 7
	case comment = 8
	case document = 9
	case documentType = 10
	case documentFrag = 11
	case notation = 12
	case htmlDocument = 13
	case dtd = 14
	case elementDecl = 15
	case attributeDecl = 16
	case entityDecl = 17
	case namespaceDecl = 18
	case xIncludeStart = 19
	case xIncludeEnd = 20
	case docbDocument = 21
}

/// Ji node
open class JiNode {
	/// The xmlNodePtr for this node.
	open let xmlNode: xmlNodePtr
	/// The Ji document contians this node.
	open unowned let document: Ji
	/// Node type.
	open let type: JiNodeType
	
	/// A helper flag to get whether keepTextNode has been changed.
	fileprivate var _keepTextNodePrevious = false
	/// Whether should remove text node. By default, keepTextNode is false.
	open var keepTextNode = false
	
	/**
	Initializes a JiNode object with the supplied xmlNodePtr, Ji document and keepTextNode boolean flag.
	
	- parameter xmlNode:      The xmlNodePtr for a node.
	- parameter jiDocument:   The Ji document contains this node.
	- parameter keepTextNode: Whether it should keep text node, by default, it's false.
	
	- returns: The initialized JiNode object.
	*/
	init(xmlNode: xmlNodePtr, jiDocument: Ji, keepTextNode: Bool = false) {
		self.xmlNode = xmlNode
		document = jiDocument
		type = JiNodeType(rawValue: Int(xmlNode.pointee.type.rawValue))!
		self.keepTextNode = keepTextNode
	}
	
	/// The tag name of this node.
	open var tag: String? { return name }
	
	/// The tag name of this node.
	open var tagName: String? { return name }
	
	/// The tag name of this node.
	open lazy var name: String? = {
		return String.fromXmlChar(self.xmlNode.pointee.name)
	}()
	
	/// Helper property for avoiding unneeded calculations.
	fileprivate var _children: [JiNode] = []
	/// A helper flag for avoiding unneeded calculations.
	fileprivate var _childrenHasBeenCalculated = false
	/// The children of this node. keepTextNode property affects the results
	open var children: [JiNode] {
		if _childrenHasBeenCalculated && keepTextNode == _keepTextNodePrevious {
			return _children
		} else {
			_children = [JiNode]()
			var childNodePointer = xmlNode.pointee.children
			while childNodePointer != nil {
				if keepTextNode || xmlNodeIsText(childNodePointer) == 0 {
					let childNode = JiNode(xmlNode: childNodePointer!, jiDocument: document, keepTextNode: keepTextNode)
					_children.append(childNode)
				}
				childNodePointer = childNodePointer?.pointee.next
			}
			_childrenHasBeenCalculated = true
			_keepTextNodePrevious = keepTextNode
			return _children
		}
	}
	
	/// The first child of this node, nil if the node has no child.
	open var firstChild: JiNode? {
		var first = xmlNode.pointee.children
		if first == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: first!, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(first) != 0 {
				first = first?.pointee.next
				if first == nil { return nil }
			}
			return JiNode(xmlNode: first!, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	/// The last child of this node, nil if the node has no child.
	open var lastChild: JiNode? {
		var last = xmlNode.pointee.last
		if last == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: last!, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(last) != 0 {
				last = last?.pointee.prev
				if last == nil { return nil }
			}
			return JiNode(xmlNode: last!, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	/// Whether this node has children.
	open var hasChildren: Bool {
		return firstChild != nil
	}
	
	/// The parent of this node.
	open lazy var parent: JiNode? = {
		if self.xmlNode.pointee.parent == nil { return nil }
		return JiNode(xmlNode: (self.xmlNode.pointee.parent)!, jiDocument: self.document)
	}()
	
	/// The next sibling of this node.
	open var nextSibling: JiNode? {
		var next = xmlNode.pointee.next
		if next == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: next!, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(next) != 0 {
				next = next?.pointee.next
				if next == nil { return nil }
			}
			return JiNode(xmlNode: next!, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	/// The previous sibling of this node.
	open var previousSibling: JiNode? {
		var prev = xmlNode.pointee.prev
		if prev == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: prev!, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(prev) != 0 {
				prev = prev?.pointee.prev
				if prev == nil { return nil }
			}
			return JiNode(xmlNode: prev!, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	/// Raw content of this node. Children, tags are also included.
	open lazy var rawContent: String? = {
		let buffer = xmlBufferCreate()
		if self.document.isXML {
			xmlNodeDump(buffer, self.document.xmlDoc, self.xmlNode, 0, 0)
		} else {
			htmlNodeDump(buffer, self.document.htmlDoc, self.xmlNode)
		}
		
		let result = String.fromXmlChar(buffer?.pointee.content)
		xmlBufferFree(buffer)
		return result
	}()
	
	/// Content of this node. Tags are removed, leading/trailing white spaces, new lines are kept.
	open lazy var content: String? = {
		let contentChars = xmlNodeGetContent(self.xmlNode)
		if contentChars == nil { return nil }
		let contentString = String.fromXmlChar(contentChars)
		free(contentChars)
		return contentString
	}()
	
	/// Raw value of this node. Leading/trailing white spaces, new lines are kept.
	open lazy var value: String? = {
		let valueChars = xmlNodeListGetString(self.document.xmlDoc, self.xmlNode.pointee.children, 1)
		if valueChars == nil { return nil }
		let valueString = String.fromXmlChar(valueChars)
		free(valueChars)
		return valueString
	}()
	
	/**
	Get attribute value with key.
	
	- parameter key: An attribute key string.
	
	- returns: The attribute value for the key.
	*/
	open subscript(key: String) -> String? {
		get {
			var attribute: xmlAttrPtr? = self.xmlNode.pointee.properties
			while attribute != nil {
				if key == String.fromXmlChar(attribute!.pointee.name) {
					let contentChars = xmlNodeGetContent(attribute?.pointee.children)
					if contentChars == nil { return nil }
					let contentString = String.fromXmlChar(contentChars)
					free(contentChars)
					return contentString
				}
				attribute = attribute?.pointee.next
			}
			return nil
		}
	}
	
	/// The attributes dictionary of this node.
	open lazy var attributes: [String: String] = {
		var result = [String: String]()
		var attribute: xmlAttrPtr? = self.xmlNode.pointee.properties
		while attribute != nil {
			let key = String.fromXmlChar(attribute!.pointee.name)
			assert(key != nil, "key doesn't exist")
			let valueChars = xmlNodeGetContent(attribute?.pointee.children)
			var value: String? = ""
			if valueChars != nil {
				value = String.fromXmlChar(valueChars)
				assert(value != nil, "value doesn't exist")
			}
			free(valueChars)
			
			result[key!] = value!
			attribute = attribute?.pointee.next
		}
		return result
	}()
	
	
	
	// MARK: - XPath query
	
	/**
	Perform XPath query on this node.
	
	- parameter xPath: XPath query string.
	
	- returns: An array of JiNode, an empty array will be returned if XPath matches no nodes.
	*/
	open func xPath(_ xPath: String) -> [JiNode] {
		let xPathContext = xmlXPathNewContext(self.document.xmlDoc)
		if xPathContext == nil {
			// Unable to create XPath context.
			return []
		}
		
		xPathContext?.pointee.node = self.xmlNode
		
		let xPathObject = xmlXPathEvalExpression(UnsafeRawPointer(xPath.cString(using: String.Encoding.utf8)!).assumingMemoryBound(to: xmlChar.self), xPathContext)
		xmlXPathFreeContext(xPathContext)
		if xPathObject == nil {
			// Unable to evaluate XPath.
			return []
		}
		
		let nodeSet = xPathObject?.pointee.nodesetval
		if nodeSet == nil || nodeSet?.pointee.nodeNr == 0 || nodeSet?.pointee.nodeTab == nil {
			// NodeSet is nil.
            xmlXPathFreeObject(xPathObject)
			return []
		}
		
		var resultNodes = [JiNode]()
		for i in 0 ..< Int((nodeSet?.pointee.nodeNr)!) {
			let jiNode = JiNode(xmlNode: (nodeSet?.pointee.nodeTab[i]!)!, jiDocument: self.document, keepTextNode: keepTextNode)
			resultNodes.append(jiNode)
		}
		
		xmlXPathFreeObject(xPathObject)
		
		return resultNodes
	}
	
	
	
	// MARK: - Handy search methods: Children
	
	/**
	Find the first child with the tag name of this node.
	
	- parameter name: A tag name string.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	open func firstChildWithName(_ name: String) -> JiNode? {
		var node = firstChild
		while (node != nil) {
			if node!.name == name {
				return node
			}
			node = node?.nextSibling
		}
		return nil
	}
	
	/**
	Find the children with the tag name of this node.
	
	- parameter name: A tag name string.
	
	- returns: An array of JiNode.
	*/
	open func childrenWithName(_ name: String) -> [JiNode] {
		return children.filter { $0.name == name }
	}
	
	/**
	Find the first child with the attribute name and value of this node.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	open func firstChildWithAttributeName(_ attributeName: String, attributeValue: String) -> JiNode? {
		var node = firstChild
		while (node != nil) {
			if let value = node![attributeName] , value == attributeValue {
				return node
			}
			node = node?.nextSibling
		}
		return nil
	}
	
	/**
	Find the children with the attribute name and value of this node.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	
	- returns: An array of JiNode.
	*/
	open func childrenWithAttributeName(_ attributeName: String, attributeValue: String) -> [JiNode] {
		return children.filter { $0.attributes[attributeName] == attributeValue }
	}
	
	
	
	// MARK: - Handy search methods: Descendants
	
	/**
	Find the first descendant with the tag name of this node.
	
	- parameter name: A tag name string.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	open func firstDescendantWithName(_ name: String) -> JiNode? {
		return firstDescendantWithName(name, node: self)
	}
	
	
	/**
	Helper method: Find the first descendant with the tag name of the node provided.
	
	- parameter name: A tag name string.
	- parameter node: The node from which to find.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	fileprivate func firstDescendantWithName(_ name: String, node: JiNode) -> JiNode? {
		if !node.hasChildren {
			return nil
		}
		
		for child in node {
			if child.name == name {
				return child
			}
			if let nodeFound = firstDescendantWithName(name, node: child) {
				return nodeFound
			}
		}
		return nil
	}
	
	/**
	Find the descendant with the tag name of this node.
	
	- parameter name: A tag name string.
	
	- returns: An array of JiNode.
	*/
	open func descendantsWithName(_ name: String) -> [JiNode] {
		return descendantsWithName(name, node: self)
	}
	
	/**
	Helper method: Find the descendant with the tag name of the node provided.
	
	- parameter name: A tag name string.
	- parameter node: The node from which to find.
	
	- returns: An array of JiNode.
	*/
	fileprivate func descendantsWithName(_ name: String, node: JiNode) -> [JiNode] {
		if !node.hasChildren {
			return []
		}
		
		var results = [JiNode]()
		for child in node {
			if child.name == name {
				results.append(child)
			}
			results.append(contentsOf: descendantsWithName(name, node: child))
		}
		return results
	}
	
	/**
	Find the first descendant with the attribute name and value of this node.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	open func firstDescendantWithAttributeName(_ attributeName: String, attributeValue: String) -> JiNode? {
		return firstDescendantWithAttributeName(attributeName, attributeValue: attributeValue, node: self)
	}
	
	/**
	Helper method: Find the first descendant with the attribute name and value of the node provided.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	- parameter node:           The node from which to find.
	
	- returns: The JiNode object found or nil if it doesn't exist.
	*/
	fileprivate func firstDescendantWithAttributeName(_ attributeName: String, attributeValue: String, node: JiNode) -> JiNode? {
		if !node.hasChildren {
			return nil
		}
		
		for child in node {
			if child[attributeName] == attributeValue {
				return child
			}
			if let nodeFound = firstDescendantWithAttributeName(attributeName, attributeValue: attributeValue, node: child) {
				return nodeFound
			}
		}
		return nil
	}
	
	/**
	Find the descendants with the attribute name and value of this node.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	
	- returns: An array of JiNode.
	*/
	open func descendantsWithAttributeName(_ attributeName: String, attributeValue: String) -> [JiNode] {
		return descendantsWithAttributeName(attributeName, attributeValue: attributeValue, node: self)
	}
	
	/**
	Helper method: Find the descendants with the attribute name and value of the node provided.
	
	- parameter attributeName:  An attribute name.
	- parameter attributeValue: The attribute value for the attribute name.
	- parameter node:           The node from which to find.
	
	- returns: An array of JiNode.
	*/
	fileprivate func descendantsWithAttributeName(_ attributeName: String, attributeValue: String, node: JiNode) -> [JiNode] {
		if !node.hasChildren {
			return []
		}
		
		var results = [JiNode]()
		for child in node {
			if child[attributeName] == attributeValue {
				results.append(child)
			}
			results.append(contentsOf: descendantsWithAttributeName(attributeName, attributeValue: attributeValue, node: child))
		}
		return results
	}
}

// MARK: - Equatable
extension JiNode: Equatable { }
public func ==(lhs: JiNode, rhs: JiNode) -> Bool {
	if lhs.document == rhs.document {
		return xmlXPathCmpNodes(lhs.xmlNode, rhs.xmlNode) == 0
	}
	return false
}

// MARK: - SequenceType
extension JiNode: Sequence {
	public func makeIterator() -> JiNodeGenerator {
		return JiNodeGenerator(node: self)
	}
}

/// JiNodeGenerator
open class JiNodeGenerator: IteratorProtocol {
	fileprivate var node: JiNode?
	fileprivate var started = false
	public init(node: JiNode) {
		self.node = node
	}
	
	open func next() -> JiNode? {
		if !started {
			node = node?.firstChild
			started = true
		} else {
			node = node?.nextSibling
		}
		return node
	}
}

// MARK: - CustomStringConvertible
extension JiNode: CustomStringConvertible {
	public var description: String {
		return rawContent ?? "nil"
	}
}

// MARK: - CustomDebugStringConvertible
extension JiNode: CustomDebugStringConvertible {
	public var debugDescription: String {
		return description
	}
}
