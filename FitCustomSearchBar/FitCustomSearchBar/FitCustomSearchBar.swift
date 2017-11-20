//
//  FitCustomSearchBar.swift
//  FitCustomSearchBar
//
//  Created by Cyrill on 2017/11/17.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

import UIKit

public enum FitSearchBarIconAlignment: UInt {
    case left
    case center
}

@objc public protocol FitCustomSearchBarDelegate: UIBarPositioningDelegate {
    
    @objc optional func searchBarShouldBeginEditing(_ searchBar: FitCustomSearchBar) -> Bool // return NO to not become first responder
    
    @objc optional func searchBarTextDidBeginEditing(_ searchBar: FitCustomSearchBar) // called when text starts editing
    
    @objc optional func searchBarShouldEndEditing(_ searchBar: FitCustomSearchBar) -> Bool // return NO to not resign first responder
    
    @objc optional func searchBarTextDidEndEditing(_ searchBar: FitCustomSearchBar) // called when text ends editing
    
    @objc optional func searchBar(_ searchBar: FitCustomSearchBar, textDidChange searchText: String) // called when text changes (including clear)
    
    @objc optional func searchBar(_ searchBar: FitCustomSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool // called before text changes
    
    @objc optional func searchBarSearchButtonClicked(_ searchBar: FitCustomSearchBar) // called when keyboard search button pressed
    
  
    @objc optional func searchBarCancelButtonClicked(_ searchBar: FitCustomSearchBar) // called when cancel button pressed
    
    @objc optional func searchBarResultsListButtonClicked(_ searchBar: FitCustomSearchBar) // called when search results button pressed
    
    @objc optional func searchBar(_ searchBar: FitCustomSearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
}

open class FitCustomSearchBar: UIView, UITextInputTraits, UITextFieldDelegate {

    weak open var delegate: FitCustomSearchBarDelegate?
    
    public var text: String? {
        set {
            self.textField.text = newValue
        }
        get {
            return self.textField.text
        }
    }
    public var textColor: UIColor! {
        willSet {
            self.textField.textColor = newValue
        }
    }
    public var textFont: UIFont! {
        willSet {
            self.textField.font = newValue
        }
    }
    public var prompt: String!
    public var placeholder: String! {
        willSet {
            self.textField.placeholder = newValue
            self.textField.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
    public var iconAlignment: FitSearchBarIconAlignment! {
        willSet {
            self._iconAlignTemp = newValue
        }
        
        didSet {
            self.adjustIconWith(iconAlignment!)
        }
    }
    public var placeholderColor: UIColor! {
        willSet {
            if (self.placeholder == nil || self.placeholder == "") {
                
            } else {
                self.textField.attributedPlaceholder = NSAttributedString.init(string: self.placeholder, attributes: [NSAttributedStringKey.foregroundColor: newValue, NSAttributedStringKey.font: self.textField.font!])
            }
        }
    }
    public var textFieldColor: UIColor! {
        willSet {
            self.textField.backgroundColor = newValue
        }
    }
    
    public var _inputAccessoryView: UIView? {
        willSet {
            self.textField.inputAccessoryView = newValue
        }
    }
    
    public var _inputView: UIView? {
        willSet {
            self.textField.inputView = newValue
        }
    }
    
    public var iconImage: UIImage? {
        willSet {
            if (self.textField.leftView != nil) {
                (self.textField.leftView as! UIImageView).image = newValue
                self.textField.leftViewMode = UITextFieldViewMode.always
            }
        }
    }
    public var backgroundImage: UIImage? {
        willSet {
            self.textField.background = newValue
        }
    }
    
    public var hiddenCancelButton: Bool?
    public var textBorderStyle: UITextBorderStyle! {
        willSet {
            self.textField.borderStyle = newValue
        }
    }
    @nonobjc public var keyboardType: UIKeyboardType! {
        willSet {
            self.textField.keyboardType = newValue
        }
    }
    
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
    fileprivate var _iconAlignTemp: FitSearchBarIconAlignment?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
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
        if self.hiddenCancelButton == nil {
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
        self.delegate?.searchBar!(self, textDidChange: textField.text!)
    }
    
    func adjustIconWith(_ iconAlignment: FitSearchBarIconAlignment) {
        if (self.iconAlignment == FitSearchBarIconAlignment.center && ((self.text == nil) || self.text?.count == 0) && !self.textField.isFirstResponder) {
            _iconCenterImgV?.isHidden = false
            self.textField.frame = CGRect(x: 7, y: 7, width: self.frame.size.width-7*2, height: 30)
            self.textField.textAlignment = .center
            
            let pString: String = self.placeholder ?? ""
            let titleSize = pString.size(withAttributes: [NSAttributedStringKey.font: self.textField.font as Any])
            
            let x = self.textField.frame.size.width * 0.5 - titleSize.width*0.5 - 30
            if _iconCenterImgV == nil {
                _iconCenterImgV = UIImageView.init(image: UIImage(named: "123"))
                _iconCenterImgV?.contentMode = .scaleAspectFit
                self.textField.addSubview(_iconCenterImgV!)
            }
            
            let xx: CGFloat = x>0 ? x : 0
            
            _iconCenterImgV!.frame = CGRect(x: xx, y: 0, width: _iconCenterImgV!.frame.size.width, height: _iconCenterImgV!.frame.size.height)
            _iconCenterImgV!.isHidden = x>0 ? false : true
            self.textField.leftView = x>0 ? nil : _iconImgV
            self.textField.leftViewMode = x > 0 ? UITextFieldViewMode.never : UITextFieldViewMode.always
        } else {
            _iconCenterImgV?.isHidden = true
            UIView.animate(withDuration: 1, animations: {
                self.textField.textAlignment = NSTextAlignment.left
                self._iconImgV = UIImageView.init(image: UIImage(named: "123"))
                self._iconImgV?.contentMode = UIViewContentMode.scaleAspectFit;
                self.textField.leftView = self._iconImgV;
                self.textField.leftViewMode =  UITextFieldViewMode.always;
            })
        }
    }
    
    @objc func cancelButtonTouched() {
        self.textField.text = ""
        self.textField.resignFirstResponder()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if _iconAlignTemp == FitSearchBarIconAlignment.center {
            self.iconAlignment = .left
        }
        if self.hiddenCancelButton == nil {
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelButton.isHidden = false
                self.textField.frame = CGRect(x: 7, y: 7, width: self.cancelButton.frame.origin.x - 7, height: 30)
            })
        }
        
        _ = self.delegate?.searchBarShouldBeginEditing?(self)
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.searchBarTextDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        _ = self.delegate?.searchBarShouldEndEditing?(self)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if _iconAlignTemp == FitSearchBarIconAlignment.left {
            self.iconAlignment = .center
        }
        if self.hiddenCancelButton == nil {
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelButton.isHidden = true
                self.textField.frame = CGRect(x: 7, y: 7, width: self.frame.size.width - 7*2, height: 30)
            })
        }
        self.delegate?.searchBarTextDidEndEditing?(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _ = self.delegate?.searchBar?(self, shouldChangeTextIn: range, replacementText: string)
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.delegate?.searchBar?(self, textDidChange: "")
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.searchBarSearchButtonClicked?(self)
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
