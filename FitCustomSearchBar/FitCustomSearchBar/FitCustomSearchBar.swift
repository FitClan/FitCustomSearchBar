//
//  FitCustomSearchBar.swift
//  FitCustomSearchBar
//
//  Created by Cyrill on 2017/11/17.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

import UIKit

public enum SearchBarIconAlignment: UInt {
    case left
    case center
}

public protocol FitCustomSearchBarDelegate: UIBarPositioningDelegate {
    
}

open class FitCustomSearchBar: UIView, UITextInputTraits, UITextFieldDelegate {

    weak open var delegate: FitCustomSearchBarDelegate?
    
    public var text: String?
    public var textColor: UIColor!
    public var textFont: UIFont!
    public var prompt: String!
    public var placeholder: String!
    
    public var iconAlignment: SearchBarIconAlignment! {
        willSet {
            self._iconAlignTemp = newValue
            self.adjustIconWith(self._iconAlignTemp!)
        }
    }
    public var placeholderColor: UIColor!
    public var textFieldColor: UIColor!
    
//    var inputAccessoryView: UIView?
//    open var inputView: UIView?
    public var iconImage: UIImage?
    public var backgroundImage: UIImage?
    
    public var hiddenCancelButton: Bool?
    public var textBorderStyle: UITextBorderStyle?
    @nonobjc public var keyboardType: UIKeyboardType?
    
    func isFirstResponder() -> Bool {
        return self.textField.isFirstResponder;
    }
    
    open override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder();
    }
    
    open override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder();
    }
    
    func setAutoCapitalizationMode(type: UITextAutocapitalizationType) {
        self.textField.autocapitalizationType = type
    }
    
    fileprivate var _iconImgV: UIImageView?
    fileprivate var _iconCenterImgV: UIImageView?
    fileprivate var _iconAlignTemp: SearchBarIconAlignment?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
        self.sizeToFit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.sizeToFit()
    }
    
    open override var intrinsicContentSize: CGSize {
        get {
            return UILayoutFittingExpandedSize
        }
    }
    

    private func initView() {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 44);
        if !self.hiddenCancelButton! {
            self.addSubview(self.cancelButton)
            self.cancelButton.isHidden = true
        }
        
        self.addSubview(self.textField)
        
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.RawValue(UInt8(NSKeyValueObservingOptions.new.rawValue) | UInt8(NSKeyValueObservingOptions.old.rawValue))), context: nil)
        
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "frame"){
            self.adjustIconWith(_iconAlignTemp!)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField!) {
        
    }
    
    func adjustIconWith(_ iconAlignment: SearchBarIconAlignment) {
        if (self.iconAlignment == .center && (self.textField.text == nil || (self.text == nil) || self.text?.count == 0) && !self.textField.isFirstResponder) {
            _iconCenterImgV?.isHidden = false
            self.textField.frame = CGRect(x: 7, y: 7, width: self.frame.size.width-7*2, height: 30)
            self.textField.textAlignment = .center
            
            var pp: NSString = NSString(string: (self.placeholder ?? ""))
            
            // FIXME: 这里要继续
            
        }
    }
    
    @objc func cancelButtonTouched() {
        self.textField.text = ""
        self.textField.resignFirstResponder()
        
    }
    
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    lazy var cancelButton: UIButton = {
        var _cancelButton = UIButton(type: .custom)
        _cancelButton.frame = CGRect(x: self.frame.size.width-60, y: 7, width: 60, height: 30)
        _cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        _cancelButton.setTitle("取消", for: .normal)
        _cancelButton.setTitleColor(UIColor.black, for: .normal)
        _cancelButton.autoresizingMask = .flexibleLeftMargin
        _cancelButton.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        return _cancelButton
    }()
    
    private lazy var textField: UITextField = {
        var _textField = UITextField.init(frame: CGRect(x: 7, y: 7, width: self.frame.size.width-7*2, height: 30))
        
        _textField.delegate = self
        _textField.borderStyle = .none
        _textField.contentVerticalAlignment = .center
        _textField.returnKeyType = .search
        _textField.enablesReturnKeyAutomatically = true
        _textField.font = UIFont.systemFont(ofSize: 14.0)
        _textField.clearButtonMode = .whileEditing
        
        _textField.autoresizingMask = .flexibleWidth
        _textField.borderStyle = .none;
        _textField.layer.cornerRadius = 3.0;
        _textField.layer.masksToBounds = true;
        _textField.backgroundColor = UIColor(red: 240.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        _textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return _textField
    }()
    
}
