//
//  LBTextField.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/11.
//

import Foundation
import SwiftUI
import UIKit


struct LBTextField: UIViewRepresentable {
    
    @Binding var text: String
    @EnvironmentObject var appSettings: AppSetting
    
    var textField: TextFieldWithPadding
    
    var textBeginEditing: () -> Void
    var textDidChange:() -> Void
    var pressReturn:() -> Void
    
    func makeUIView(context: Context) -> some UITextField {
        
        textField.delegate = context.coordinator
        textField.attributedPlaceholder = NSAttributedString(string: "search or enter url", attributes: [NSAttributedString.Key.foregroundColor:(appSettings.darkModeSettings ? UIColor(Color.lb_gray) : UIColor.white),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        textField.returnKeyType = .go
        textField.textColor = appSettings.darkModeSettings ? UIColor(Color.lb_black) : UIColor.white

        let leftView = UIView(frame: CGRect(x:0, y: 0, width: 10, height: 10))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        // 右视图
        
        let rightButton = UIButton(type: .custom, primaryAction: UIAction(handler: { handler in
            textField.text = ""
            textField.rightView?.isHidden = true
        }))
        let image = appSettings.darkModeSettings ? UIImage(named: "clearIcon_black") : UIImage(named: "clearIcon_white")
        rightButton.setImage(image, for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.frame = CGRect(x:0, y: 0, width: 20 , height: 16)
        textField.rightView = rightButton
        textField.rightViewMode = .whileEditing
    
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if text != uiView.text {
            uiView.text = text
        }
        
        let image = appSettings.darkModeSettings ? UIImage(named: "clearIcon_black") : UIImage(named: "clearIcon_white")
        let button = uiView.rightView as! UIButton
        button.setImage(image, for: .normal)
        
        uiView.attributedPlaceholder = NSAttributedString(string: "search or enter url", attributes: [NSAttributedString.Key.foregroundColor:(appSettings.darkModeSettings ? UIColor(Color.lb_gray) : UIColor.white),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        uiView.textColor = appSettings.darkModeSettings ? UIColor(Color.lb_black) : UIColor.white
    }
    
    func makeCoordinator() -> TextFieldCoordinator {
        
        TextFieldCoordinator(self) {
            
            textBeginEditing()
            
        } textDidChange: {
            
            textDidChange()
            
        } pressReturn: {
            
            pressReturn()
        }
    }
    
    class TextFieldCoordinator: NSObject, UITextFieldDelegate {
        
        var parent: LBTextField
        var textBeginEditing: () -> Void
        var textDidChange: () -> Void
        var pressReturn:() -> Void
        
        init(_ textField: LBTextField,textBeginEditing: @escaping () ->Void = {},textDidChange: @escaping () ->Void = {},pressReturn: @escaping () ->Void = {}) {
            
            self.parent = textField
            self.textBeginEditing = textBeginEditing
            self.textDidChange = textDidChange
            self.pressReturn = pressReturn
        }
        

        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            textField.rightView?.isHidden = textField.text == "" ? true : false
            textBeginEditing()
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard textField.markedTextRange == nil, parent.text != textField.text else {
                return
            }
            parent.text = textField.text ?? ""
            textField.rightView?.isHidden = textField.text == "" ? true : false
            
            textDidChange()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            pressReturn()
            textField.rightView?.isHidden = true
            textField.resignFirstResponder()
            
            return true
        }
        
    }
    
}

class TextFieldManger: ObservableObject {

    let textField: TextFieldWithPadding

    init(){

        textField = TextFieldWithPadding()
    }

}


class TextFieldWithPadding: UITextField {
    
    var rightViewPadding = UIEdgeInsets(
        top: 0,
        left: -10,
        bottom: 0,
        right: 10
    )
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: rightViewPadding)
    }
    
}
