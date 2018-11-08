//
//  ViewController.swift
//  ConsumidorWS
//
//  Created by ExpresionBinaria on 10/24/18.
//  Copyright © 2018 ExpresionBinaria. All rights reserved.
//

import UIKit
import RijndaelSwift

class ViewController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var txtResultado: UITextField!
    @IBOutlet weak var txtEndpoint: UILabel!
    @IBOutlet weak var txtChain: UITextField!
    @IBOutlet weak var txtDecryptResult: UITextField!
    
    var currentParsingElement:String = ""
    var dateString:String = ""

    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    
    let key = "Expr3s10nB1n4r14"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEndpoint.text = "http://ebserver.com.mx/WSSincroniza/WSSincroniza.asmx"
    }


    @IBAction func btnGet(_ sender: UIButton) {
         //Create request
        let soapMessage =
        "<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://www.w3.org/2003/05/soap-envelope'><soap:Body><getDateTime xmlns='http://tempuri.org/' /></soap:Body></soap:Envelope>"
        let endpoint = "http://ebserver.com.mx/WSSincroniza/WSSincroniza.asmx"
        let url = URL(string: endpoint)
        let req = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        
       
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        req.httpMethod = "POST"
        req.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //Make the request
        dataTask?.cancel()
        dataTask = mySession.dataTask(with: req as URLRequest) { (data, response, error) in
            defer { self.dataTask = nil }
            guard let data = data else { return }
            //print("XML respuesta: " + String(data: data, encoding: .utf8)!)
            print("XML respuesta: " + String(data: data, encoding: .utf8)!)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        dataTask?.resume()
    }
    
    func displayOnUI() {
        txtResultado.text = dateString
    }
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "getDateTimeResponse" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "getDateTimeResult" {
                self.dateString += foundedChar
            }
            else {
                self.dateString += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "getDateTimeResponse" {
            print("Ended parsing...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.displayOnUI()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    @IBAction func decrypt(_ sender: UIButton) {
        //let IV = "keyBytes"
        //let r = Rijndael(key: key, mode: .cbc)!
        //let plainData = txtChain.text
        //let cipherData = r.e
    }
    
}

