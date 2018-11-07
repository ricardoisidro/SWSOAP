import Foundation

final class XMLElementExtractor: NSObject, XMLParserDelegate {
    private var isTarget = false
    private var value: String?
    private let elementName: String
    
    private init(elementName: String) {
        self.elementName = elementName
    }
    
    static func extractElement(_ elementName: String, fromXML data: Data) -> String? {
        let extractor = XMLElementExtractor(elementName: elementName)
        let parser = XMLParser(data: data)
        parser.delegate = extractor
        parser.parse()
        return extractor.value
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        isTarget = elementName == self.elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isTarget {
            value = value?.appending(string) ?? string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == self.elementName {
            parser.abortParsing()
        }
    }
}
