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
    
    var textField: TextFieldWithPadding
    
    var textBeginEditing: () -> Void
    var textDidChange:() -> Void
    var pressReturn:() -> Void
    
    func makeUIView(context: Context) -> some UITextField {
        
        textField.delegate = context.coordinator
        textField.placeholder = "search or enter url"
        textField.returnKeyType = .go

        let leftView = UIView(frame: CGRect(x:0, y: 0, width: 10, height: 10))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        // 右视图
        
        let rightButton = UIButton(type: .custom, primaryAction: UIAction(handler: { handler in
            textField.text = ""
            textField.rightView?.isHidden = true
        }))
        rightButton.setImage(UIImage(named: "clearIcon"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.frame = CGRect(x:0, y: 0, width: 16 , height: 16)
        textField.rightView = rightButton
        textField.rightViewMode = .whileEditing
        
        textField.layer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if text != uiView.text {
            uiView.text = text
        }
        
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

    func changeTextFieldStyle() {

        textField.attributedPlaceholder = NSAttributedString(string: "search or enter url", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.shared.getTheme().placeHolderColor,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
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
