//
//  ViewController.swift
//  js_test
//
//  Created by Derrick  Ho on 3/6/16.
//  Copyright © 2016 Derrick  Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var webViewHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let fp = NSBundle.mainBundle().pathForResource("stuff", ofType: "html")!
		let s = try! String(contentsOfFile: fp)
		webView.delegate = self
		
		webView.layer.borderColor = UIColor.blackColor().CGColor
		webView.layer.borderWidth = 1
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
			self.webView.loadHTMLString(s, baseURL: nil)
		}
	}

	func doSomething(num: Int? = nil, name: String? = nil) {
		var msg_arr = [String]()
		if num != nil {
			msg_arr.append("\(num!)")
		}
		if name != nil {
			msg_arr.append(name!)
		}
		
		let msg = msg_arr.joinWithSeparator(", ")
		
		UIAlertView(title: "clicked it", message: msg, delegate: nil, cancelButtonTitle: "OK").show()
	}

	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		if let requestURL = request.URL,
			 let component = NSURLComponents(URL: requestURL, resolvingAgainstBaseURL: false)
		where component.scheme == "ios" && component.path == "doSomething"
		{
			switch component.queryItems?.count {
			case 2?:
				doSomething(
					Int(component.queryItems![0].value ?? "")
					, name: component.queryItems![1].value
				)
			case 1?:
				doSomething(Int(component.queryItems![0].value ?? ""))
			default:
				doSomething()
			}
			return false
		}
		return true
	}

	func webViewDidFinishLoad(webView: UIWebView) {
		let size = webView.sizeThatFits(CGSize(width: webView.frame.width, height: 0))
		webViewHeight.constant = size.height
	}
	
}

