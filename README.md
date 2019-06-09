<p align="center">
    <img src ="https://firebasestorage.googleapis.com/v0/b/outnow-backend.appspot.com/o/expensify-logo.png?alt=media&token=2fb0c6df-f9d1-4339-a8de-75bc0a673791" />
</p>

# Remote Mobile Challenge

## Summary 

The mobile challenge has been a very rewarding experience, I found the requirements for the challenge very clear, but with enough flexibility to enable me to express myself and showcase my skills. 

I have worked on the challenge part-time for 5 days, primarily due to the distractions from WWDC and SwiftUI. I also wanted to get a true feel of what it meant to be an Expensify Engineer, I immersed myself in your product to try and understand the thought processes around them and how it aligned and resonated with mine. In completing the challenge, my time was mostly spent on design, and achieving clean, maintainable and documented code.

The key challenge I encountered was in deciding and implementing the right architecture that will allow me to achieve a good level of code separation, scalability and testability. I have detailed the challenges and solutions below.

# Architecture

I think one of the most debated topics in iOS development is the choice of architecture e.g. MVC, MVVM(-C) or MVP. In order to pick an architecture that I believed was suitable for the task, I considered a few goals in mind;

- Separation of Concerns
- Scalability
- Testability

I eventually went with the MVVM-C architecture. It has three key players, **Model** **ViewController**, **ViewModel** and **Coordinator**. I went with this architecture because it offered me the ability to separate core components like navigation, networking and presentation.
It can be argued that MVVM-C might have been overengineering and simply navigating in the traditional way and sticking with **MVC** will have been better for an app of this scale, that would be a credible arguement. 

However, as iOS developers we rarely write basic apps and from personal experience, business requirements often changes as the app scales, our ViewControllers become massive, testing is not as straightforward and it becomes harder to reason about the code or make changes.

The **Coordinator** abstracted away the navigation and dependency injection from the ViewControllers, it also injected the ViewController dependencies and has a one-to-one communication with its ViewController. Furthermore, it is also easier to spin up a completely different navigation flow based on a new feature and write unit tests to test the navigation logic without having to launch the app.

The **ViewModel** allowed me to handle business logic seperately and it made the code more easily testable. It was also responsible for interacting with the networking layer and passing data to/from the ViewController.

Together, I was able to achieve a good level of separation between different layers of the app.

## Challenge 1 - Communication between the ViewModel and ViewController 

## Solution

- I used closures to facilitate the communication between the ViewModel and ViewController. Usually I qould use a reactive framework like RxSwift or ReactiveCocoa to bind the data directly to the UI

## Challenge 2 - 455

## Caveat

- There is still a chance for *Massive View Model* and it becoming a code dumping ground
- The major issue would be that what happens when someone unfamiliar with the subject of MVVM-C but understands another architecture looks at the code. It may be confusing and they may not know where to get started.
- There is no clear standard for Coordinators and so when reading about it, there are variants of how to actually implement it

# Authentication

Authentication was fairly straightforward to begin with. Hit the auth endpoint and get back an auth token. 

## Challenge 1 - Quiting the app

When a user quits the app, they would have had to reauthenticate, this hurts the user experience.

## Solution - Keychain persistence

I decided to persist the auth token to the user keychain for both security and to prevent the user from reauthentcating. Instead I save the token and use it until it expires, then prompt the user to reauthenticate. A possible improvement for security would have been to encrypt the token to prevent hackers from gaining access to confidential information of the user.
