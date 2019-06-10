<p align="center">
    <img src ="https://firebasestorage.googleapis.com/v0/b/outnow-backend.appspot.com/o/expensify-logo.png?alt=media&token=2fb0c6df-f9d1-4339-a8de-75bc0a673791" />
</p>

# Remote Mobile Challenge

## Summary 

The mobile challenge has been a very rewarding experience, I found the requirements for the challenge very clear, but with enough flexibility to enable me to express myself and showcase my skills. 

I wanted to get a true feel of what it meant to be an Expensify Mobile Engineer, and so I spent some time immersing myself in your product to try and understand the thought processes around it and how it aligned and resonated with what I want to be spending my time working on. In completing the challenge, my time was mostly spent on design, and achieving clean, maintainable and documented code. Taking me to a tital of 5 days, taking into account a few distractions from WWDC, especially SwiftUI :o.

The key challenge I encountered was in deciding and implementing the right architecture that will allow me to achieve a good level of code separation, scalability and testability. I have detailed the challenges and solutions below.

# Architecture

I think one of the most debated topics in iOS development is the choice of architecture e.g. MVC, MVVM(-C) or MVP. In order to pick an architecture that I believed was suitable for the task, I considered a few goals in mind;

- Separation of Concerns
- Scalability
- Testability

I eventually went with the MVVM-C architecture. It has three key players, ```Model``` ```View```, ```ViewModel``` and ```Coordinator```. I went with this architecture because it offered me the ability to separate core components like navigation, networking and presentation.
It can be argued that MVVM-C might have been overengineering and simply navigating in the traditional way and sticking with **MVC** will have been better for an app of this scale, that would be a credible arguement. 

However, as iOS developers we rarely write basic apps and from personal experience, business requirements often changes as the app scales, our ViewControllers become massive, testing is not as straightforward and it becomes harder to reason about the code or make changes.

The ```Coordinator``` abstracted away the navigation and dependency injection from the ViewControllers, it also injected the ViewController dependencies and has a one-to-one communication with its ViewController. Furthermore, it is also easier to spin up a completely different navigation flow based on a new feature and write unit tests to test the navigation logic without having to launch the app.

The ```ViewModel``` allowed me to handle business logic seperately and it made the code more easily testable. It was also responsible for interacting with the networking layer and passing data to/from the ViewController.

Together, I was able to achieve a good level of separation between different layers of the app.

## Challenge 1 - Communication between the ViewModel and ViewController 

## Solution

- I used closures to facilitate the communication between the ViewModel and ViewController. Usually I would use a reactive framework like RxSwift or ReactiveCocoa to bind the data directly to the UI and just observe the changes

## Challenge 2 - Enabling/Disabling buttons

- In the `SignInViewController` I needed to enable/disable the `SignInButton` based on whether the text in the textFields were empty and when the button was pressed to guard against multiple requests. 
- In the `CreateTransactionViewController` I needed to enable/disable the `Save` button based on whether the textFields had text and also when the user clicks `Save`

## Solution

In order to solve the problems, I used the ``` .editingChanged ``` event on the textFields and then validated the text inputs with a custom function using a `Target/Action`. When the buttons had been clicked on the ViewControllers, I used a closure callback to notify the ViewControllers to disable the buttons while the request was taking place

## Notes on MVVM-C

- There is still a chance for *Massive View Model* and it becoming a code dumping ground
- The major issue would be that what happens when someone unfamiliar with the subject of MVVM-C but understands another architecture looks at the code. It may be confusing and they may not know where to get started.
- There is no clear standard for Coordinators and so when reading about it, there are variants of how to actually implement it

# Authentication

Authentication was fairly straightforward to begin with. Hit the auth endpoint and get back an auth token. 

## Challenge 1 - Quitting and reopening the app

When a user quits the app, they would have had to reauthenticate, this hurts the user experience.

## Solution - Keychain persistence

I decided to persist the auth token to the user keychain for both security and to prevent the user from reauthentcating. Instead I save the token and use it until it expires, then prompt the user to reauthenticate. A possible improvement for security would have been to encrypt the token to prevent hackers from gaining access to confidential information of the user.

# Third-Party

I did not want to hit ``` pod install ``` too much in this project as I wanted to showcase my skills. However, I introduced;

- [CoordinatorLibrary](https://github.com/kaunamohammed/CoordinatorLibrary) by me. I used this library to handle navigation.
- [KeychainPasswordItem](https://developer.apple.com/library/content/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797-Intro-DontLinkElementID_2) by Apple. I used this lirary to handle interacting with the keychain.
- [AuthController & Settings](https://www.raywenderlich.com/129-basic-ios-security-keychain-and-hashing) by RayWenderlich. I used this library to interact with the user current session state.

# Finally

I would like to express my gratitude for the opportunity to work on this project. I look forward to hearing back from you.
