//
//  ViewController.swift
//  Example-iOS-Swift
//
//  Created by Harrison Hough on 31/5/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WebViewDelegate {
    
    let webViewControllerTag = 100
    let webViewIdentifier = "WebViewController"
    var webViewController = WebViewController()
    
    @IBOutlet weak var editAvatarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createWebView()
        editAvatarButton.isHidden = true
        webViewController.view.isHidden = true
        editAvatarButton.isHidden = !webViewController.hasCookies()
    }

    @IBAction func onCreateNewAvatarAction(_ sender: Any) {
        destroyWebView()
        createWebView()
        webViewController.reloadPage(clearHistory: true)
        webViewController.view.isHidden = false
    }
    
    @IBAction func onEditAvatarAction(_ sender: Any) {
        webViewController.view.isHidden = false
        webViewController.reloadPage(clearHistory: false)
    }
    
    @IBAction func onUseInARAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FaceAnimojiViewController") as! FaceAnimojiViewController
        let navigation = UINavigationController(rootViewController: controller)
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)

    }
    
    func createWebView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: webViewIdentifier) as UIViewController

        guard let viewController = controller as? WebViewController else {
            return
        }
        webViewController = viewController
        webViewController.avatarUrlDelegate = self
        
        addChild(controller)

        self.view.addSubview(controller.view)
        controller.view.frame = view.safeAreaLayoutGuide.layoutFrame
        controller.view.tag = webViewControllerTag
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
    
    func avatarUrlCallback(url: String){
        //showAlert(message: url)
        print(url)
        webViewController.view.isHidden = true
        editAvatarButton?.isHidden = false
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Avatar URL Generated", message: message, preferredStyle: .alert)

             let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
             })
             alert.addAction(okButton)
             DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
    }
    
    func destroyWebView(){
        if let viewWithTag = self.view.viewWithTag(webViewControllerTag) {
            
            webViewController.dismiss(animated: true, completion: nil)
            viewWithTag.removeFromSuperview()
        }else{
            print("No WebView to destroy!")
        }
    }
}
