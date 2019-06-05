# CoordinatorLibrary

[![Build Status](https://travis-ci.com/kaunamohammed/CoordinatorLibrary.svg?branch=master)](https://travis-ci.com/kaunamohammed/CoordinatorLibrary)
![Cocoapods](https://img.shields.io/cocoapods/v/CoordinatorLibrary.svg)
[![License](https://img.shields.io/cocoapods/l/CoordinatorLibrary.svg?style=flat)](https://cocoapods.org/pods/CoordinatorLibrary)
[![Platform](https://img.shields.io/cocoapods/p/CoordinatorLibrary.svg?style=flat)](https://cocoapods.org/pods/CoordinatorLibrary)
![GitHub Release Date](https://img.shields.io/github/release-date/kaunamohammed/CoordinatorLibrary.svg)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

CoordinatorLibrary is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoordinatorLibrary'
```

## Coordinator

Coordinators are actually just as the name suggest, Coordinators. They are designed to abstract away the navigation logic from view controllers and help with better seperation of concerns. Overall, the Coordinator consists of Three protocols, to clearly define responsibilities of each type conforming to them and allow for some protocol composition.

### Coordinatable
This protocol has one requirement ```start()```. This is the method where you should set up the Coordinators ViewController.

### NavigationCoordinatable
This protocol has only one requirement. Types conforming to it should have a ```presenter``` which can be any subclass of ```UINavigationController```. It also has some extensions to abstract away implementation details of presenting another screen in your app. 

```swift
public func navigate(to viewController: UIViewController, with presentationStyle: PresentationStyle, animated: Bool)
```

### ChildCoordinatable
This protocol has four requirements.

```swift
    /// The array containing any child coordinatable
    var childCoordinators: [Coordinatable] { get set } 
    
    /**
     
     Add a child coordinatable to the parent
     
     - parameter coordinator: The coordinator to add as a child
     
     */
    func add(child coordinator: Coordinatable)
    
    /**
     
     Removes a child coordinatable from the parent
     
     - parameter coordinator: The coordinator to remove from the parent
     
     */
    func remove(child coordinator: Coordinatable)
    
    /// Removes all child coordinatables from the parent
    func removeAll()
 ```
**Note:** They have been implemented as protocol extensions so you do not have to when you're adopting the protocol.

**Note on adopting Coordinator protocols:** While you're within your right to use these protocols on your own and compose them how you see fit, I would advice checking out the convinience classes that have abstracted some of the ways in which you might want to use Coordinators protocols. Continue reading below to have a look.

### App Coordinator

```swift
open class AppCoordinator: Coordinatable, ChildCoordinatable
```

App Coordinator is a base class that is in charge of starting the application navigation. It would typically reside in the ```AppDelegate``` where it kicks-off coordinating to it's children based on some custom logic. 

**Note:** ```AppCoordinator``` is meant to be subclassed. This is because based on your app or business requirements you may want to handle coordinating to children differently. It is also a convinience class designed to abstract away dealing with setting up the application window. This allows you to focus on exactly what matters, configuring your application navigation logic. 

For example, here's how you might subclass the ```AppCoordinator``` and customize navigation. In a real world use-case this would probably be based on if the current user is signed in or not.

```swift
class CoordinatorExampleAppCoordinator: AppCoordinator {
    
    override func start() {
        Bool.random() ? startChildA() : startChildB()
    }
    
}
```

### Navigation Coordinators

```swift
open class NavigationCoordinator<T: UIViewController>: NSObject, UINavigationControllerDelegate, NavigationFlowCoordinator
```
Navigation Coordinators are a specialized generic base class for dealing with removing a child coordinator from memory when the back button in a ```UINavigationController``` is tapped. Navigation Coordinators inherit from ```NSObject``` in order to implement the ```UINavigationControllerDelegate```. It conforms to ```NavigationFlowCoordinator```. Finally, it stores a generic type T 

**Note:** The actual adoption of the ```UINavigationControllerDelegate``` protocol is done in the class and not in the extension. This is because ```Conformance of generic class 'NavigationCoordinator<T>' to @objc protocol 'UINavigationControllerDelegate' cannot be in an extension```

```swift

// MARK: - UINavigationControllerDelegate
extension NavigationCoordinator {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let viewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(viewController) else { return }
        
        if viewController is T  {
            removeCoordinator(self)
        }
    }
}

```

The relevant part is where ```NavigationCoordinator``` conforms to ```UINavigationControllerDelegate```. Everytime this delegate method is called, the class checks to see if the viewController is the same as the one that was presented and if it was then it gets removed by ```NavigationCoordinator```

### Child Coordinators

```swift
open class ChildCoordinator<T: UIViewController>: NavigationCoordinator<T>, ChildCoordinatable
```
Child Coordinators are a specialized generic base class for dealing with adding/removing a child coordinator from it's parent. 
Child Coordinators inherit from ```NavigationFlowCoordinator```.

When we subclass ```ChildCoordinator``` we are then able to handle adding and removing a child coordinator from it's parent as illustrated in here.

```swift
        let child = ViewControllerBCoordinator(presenter: presenter, removeCoordinator: remove)
        add(child: child)
        child.start()
```
**Note:** For the most part, you do not really need to call ```remove()``` directly, you can just add the remove method into the child as shown above. 

### Communication
Communication between Coordinators is a 1:1 Parent -> Child relationship. There are two ways to handle this communication namely; Delegation and Closures. Personally, I prefer to handle communication with Closures because they tend to be simpler to introduce and reduce tight coupling between Parent -> Child.

In this example, the ViewControllerACoordinator holds a reference to ViewControllerA which has a closure being called everytime the button in ViewControllerA was tapped. ``` didTapButton: (() -> Void)? ``` In response to receiving the event, the Coordinator will spin-up ViewControllerBCoordinator and call ``` start() ``` to make the transition to ViewControllerB

```swift

class ViewControllerACoordinator: ChildCoordinator<ViewControllerA> {
    
    override func start() {
        viewController = ViewControllerA()
        navigate(to: viewController, with: .push, animated: true)
        
        viewController.didTapButton = { [startViewCoordinatorB] in
            startViewCoordinatorB()
        }
    }
    
    private func startViewCoordinatorB() {
        let child = ViewControllerBCoordinator(presenter: presenter, removeCoordinator: remove)
        add(child: child)
        child.start()
    } 
    
}

```

## StoryboardSupportable

```swift
public protocol StoryBoardSupportable: class
```

StoryboardSupportable is a protocol that allows for storyboard-based instantiation support for view controllers. When using Storyboards, this is how you instantiate your view controller -

```swift
 // when using storyboards
 viewController = ViewControllerA.instantiate(from: "Main")
```
**Note:** if you use a view model/presenter etc, you will need to use property initialization after instantiating the viewcontroller.

When you want a view controller to be able to instantiate it's self like above, you make it conform to StoryBoardSupportable.

```swift
class ViewControllerA: UIViewController, StoryBoardSupportable
```

## Author

kaunamohammed, kaunamohammed@gmail.com

## License

CoordinatorLibrary is available under the MIT license. See the LICENSE file for more info.
=======
# CoordinatorLibrary

## Where to go from here

Coordinators, can be hard to grasp initially, but it is a surprisingly simple and extensible architecture when you cross that initial step of starting. There's some great articles on the web that I recommend reading to flesh out your understanding of how coordinators work.
- [The Coordinator](http://khanlou.com/2015/01/the-coordinator/)
- [Coordinator Redux](http://khanlou.com/2015/10/coordinators-redux/)
- [An iOS Coordinator Pattern](https://will.townsend.io/2016/an-ios-coordinator-pattern)

Additionally there's a [fantastic video from NSSpain](https://vimeo.com/144116310) where the guy behind the recent push for coordinators, Soroush Khanlou, talks about how he uses them in his application.

## Contributing

Have an issue? Open an issue! Have an idea? Open a pull request!

If you like the library, please :star: it!

Cheers mate :beers:
