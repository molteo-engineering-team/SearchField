# Welcome to SearchField

Starting with the SearchField framework is pretty simple, however it also provides a powerful way to customize your UI at the same time.

## Simple Implementation

1- create a struct that confirms to the `SearchResults` protocol that should always have a title

```swift
struct SomeImportantElement: SearchResult {
    var title: String = UUID().uuidString
}
```

2- Conforming to the `protocols` that will enforce you to create the following methods, which are the minimum requirement for using the `SearchField` framework

```swift
class OurMainViewController: UIViewController, SearchViewControllerDelegate, SearchViewDelegate {}
```

```swift
protocol SearchViewDelegate {
    func presentSearchViewController()
}
```
```swift
protocol SearchViewDelegate {
    func removeControllerFromView(_ controller: UIViewController)
    func selected(searchResult: SearchResult)
}
```

3- The framework comes with a `SearchFieldView` that can be used to display the `SearchResult` and open the `SearchViewController`, you can anchor it any where you want in the view. and implement the method that's required by `SearchViewDelegate`. `OurMainViewController` should also implement the methods required by the `SearchViewController` to select Elements and dismiss the view. 

The animation is handled by FadingAnimation class that should present and dismiss the `SearchViewController` by the fading effect that's implemented (Custom animations can also be created and send to the `transitioningDelegate` instead)

```swift

private var animation = FadingAnimation()

var someArray = [        
    SomeImportantElement(),
    SomeImportantElement(),
    SomeImportantElement(),
]

func presentSearchViewController() {
    // Using the Generic Cell for our SomeImportantElement struct and also conforming the SearchView to it too
    let controller = SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>()
    // adding the padding that we want to the results Controller
    controller.resultsControllerPadding = .init(top: 10, left: 20, bottom: 10, right: 20)
    controller.delegate = self
    controller.transitioningDelegate = animation        
    controller.searchableElements = someArray
    present(controller, animated: true)
}

```
Note that the filtering is done in the SearchViewController since we didn't implement the following protocol `SearchViewControllerDataSource`

4- Implement the method selected, and The remove controller from view should also be implemented to dismiss the view

```swift
    func selected(searchResult: SearchResult) {
        // Do something important
        print(searchResult)
    }

    func removeControllerFromView(_ controller: UIViewController)  {
        controller.dismiss(animated: true)
    }
```


 and You are done 🥳🥳!

5- In case you want to implement your own DataSource such as A network call or, Some Magical call you dont want the controller to handle you can setting the data source delegate `SearchViewControllerDataSource` in the `OurMainViewController` 

```swift
private var searchController: SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>

func presentSearchViewController() {
    /// Code from above
    controller.delegate = self
    controller.dataSource = self
    searchController = controller
    /// Code from above
}
```

now since you can implement the method filter

```swift
func filter(text: String?) {
    guard let txt = text, !txt.isEmpty else {
        // Implement your own way to handle empty Text or might be cool to also implement this with a custom SearchResultsController more on how to do that in Section 2 part 2 of this readme
        searchController?.searchableElements = someArray
        return
    }
    // Filtering from someArray or a networking call and setting it to searchableElements
    let filtered = someArray.filter { (id) -> Bool in
        return id.title.contains(txt)
    }
    searchController?.searchableElements = filtered
}

```

## A bit of a custom Implementation

want to implement your own cell with some custom elemtns text, description and maybe images? 

1- For instance now, Our Bosses want a purple cell, and we can't really provide that with the current implementation. That's why we created this framework to start with...

Create a custom struct for the data that you want

```swift
class ClassifiedStruct: SearchResult {
    var title: String = UUID().uuidString
    var image: UIImage?
    var betterTitle: String = "Hello 🐩!"
}
```
Create a custom GenericCell for the data that you want to present

```swift
class SomeReallyClassifiedImplementation: GenericCell<ClassifiedStruct> {

    // <<<HERE COMES YOUR CUSTOM UI IMPLEMENTATION>>>

    override var item: Element? {
        didSet {
            guard let item = item else { return }
            superAwesomeTitle.text = betterTitle
            poodleImageView.setImage(item.image)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .purple
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

2- You aren't happy with our implementation for the UITableView, You can implement your own by subclassing `SearchResultsController`. However there are some limitations such as you wont be able to implement Section. You would be able to implement headers and footer views.


```swift
class SomeController: SearchResultsController<TestCell, Test> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // YOU CAN return a custom header
        let view = UIView()
        view.backgroundColor = .red
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // we return a header in this case when there are zero filtered items
        return count == 0 ? 250 : 0
    }
}
```