# FitCustomSearchBar
A CustomSearchBar use Swift 4



Use it just like UISearchBar

```swift
lazy var searchBar: FitCustomSearchBar = {
    var searchBar = FitCustomSearchBar.init(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: 44.0))
    searchBar.iconImage = UIImage(named: "123")
    searchBar.backgroundColor = UIColor.clear
    searchBar.iconAlignment = .center
    searchBar.placeholder = "请输入关键字"
    searchBar.placeholderColor = UIColor.gray
    searchBar.delegate = self
    searchBar.sizeToFit()
    return searchBar
}()
```

If you do not need the cancelButton, It's ok

just set `isHiddenCancelButton` to true

```swift
searchBar.isHiddenCancelButton = true
```

And the protocol

```swift
func searchBarShouldBeginEditing(_ searchBar: FitCustomSearchBar) -> Bool {
	return true
}

func searchBarTextDidBeginEditing(_ searchBar: FitCustomSearchBar) {
}

func searchBarShouldEndEditing(_ searchBar: FitCustomSearchBar) -> Bool {
    return true
}

func searchBarTextDidEndEditing(_ searchBar: FitCustomSearchBar) {
}

func searchBar(_ searchBar: FitCustomSearchBar, textDidChange searchText: String) {
}

func searchBar(_ searchBar: FitCustomSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return true
}

func searchBarSearchButtonClicked(_ searchBar: FitCustomSearchBar) {
}

func searchBarCancelButtonClicked(_ searchBar: FitCustomSearchBar) {
}
```

