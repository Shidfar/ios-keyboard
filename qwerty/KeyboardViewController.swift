//
//  KeyboardViewController.swift
//  qwerty
//
//  Created by Shidfar Hodizoda on 17/03/2018.
//  Copyright © 2018 Shidfar Hodizoda. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let buttonTitlesNormal = [
            ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", " ⌫ "],
            [" ⇥", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "[", "]", "\\" ],
            ["  ⇪", "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "\'", "⏎  "],
            ["  ⇧  ", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/", "  ⇧  "]
        ]
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        _ = screenSize.height
        
        let HEIGHT = 45
        let WIDTH = Int(screenWidth)
        
        var row = 0
        for buttonTitles in buttonTitlesNormal {
            let buttons = createButtons(titles: buttonTitles)
            let topRow = UIView(frame: CGRect(origin: CGPoint.init(x: 0, y: (HEIGHT * row)), size: CGSize(width: WIDTH, height: HEIGHT)))
            for button in buttons {
                topRow.addSubview(button)
            }
            self.view.addSubview(topRow)
            addConstraints(buttons: buttons, containingView: topRow)
            row += 1
        }
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func createButtons(titles: [String]) -> [UIButton] {
        var buttons = [UIButton]()
        
        for title in titles {
            let button = UIButton(type: .system) as UIButton
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            button.addTarget(self, action: #selector(self.keyPressed(sender:)), for: UIControlEvents.touchUpInside)
            buttons.append(button)
        }
        
        return buttons
    }
    
    @objc func keyPressed(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.title(for: .normal)
        if title == " ⌫ " {
            (textDocumentProxy as UIKeyInput).deleteBackward()
        } else if title == " ⇥" {
            (textDocumentProxy as UIKeyInput).insertText("    ")
        } else {
            (textDocumentProxy as UIKeyInput).insertText(title!)
        }
    }
    
    func addConstraints(buttons: [UIButton], containingView: UIView){
        
        for (index, button) in buttons.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: -1)
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: 1)
                
            } else{
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: 1)
                
                let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                containingView.addConstraint(widthConstraint)
            }
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: -1)
                
            } else{
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: -1)
            }
            
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
