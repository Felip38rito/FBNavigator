# FBNavigator
A SOLID (at least wanna be) and simple implementation of navigation

The objective of this simple lib is to help me with navigation when coding iOS native apps. 
With this project, I have 3 principles to follow:

- You can navigate from ANY ViewController to ANY ViewController, without requiring that they know each other (they shouldn't... SOLID, remember?)
- You can implement your own schema of navigation just by implementing the protocols. You don't have to be bounded by UIKit navigation... you can implement your own on the same pattern
- Allow you to write your navigation with controllers the way you like it. Be it with controllers instantiated from storyboards, xibs, or by pure swift code. That's for you to choose, not me. ;)

## How to install?
For now, you can use CocoaPods: 

## How to use it?
First things first, you'll create the destinations for the navigator to go. I recommend you to use enumerations, like this:
```swift
enum Destinations: FBControllerDestination {
   /// Define the destinations for the navigator
   case destiny1
   case destiny2(dep: Dependency)
  
   /// This is the default implementation: By the destination, you'll choose what controller to instantiate
   func controller() -> UIViewController {
     switch self {
      case .destiny1:
       return SomeViewController(....)
      case .destiny2(let dep):
       return AnotherViewController(dependency: dep, ...)
     }
   }
}
```

And then, you'll be able to navigate with that. The only thing you'll need (for navigating between controllers, of course) is the UINavigationController, so:

```swift
/// let's say you have a navigationController of type UINavigationController already.
/// the destinations are informed by a generic: this way you can divide the routes as you please
let navigator = FBControllerNavigator<Destinations>(nc: navigationController)
navigator.navigate(to: .destiny1)
```
And that's all :)

## Yeah! But is that SOLID?

You may be thinking 
> "Well, if I am to create ViewControllers and describe navigation in the same place, it breaks the rule of SOLID single responsibility principle, right?"

That's RIGHT! 

I've just show the simplest way to do it. Now, I'll show the way I like the most: _**With factories**_.

First of all, lets create an abstract factory on swift, you'll see why this is good in minutes:
```swift
protocol ControllerFabricProtocol {
    func createMainController(dependency: SomeDependency) -> UIViewController
    func createOnboardingController() -> UIViewController
}
```

```swift
class ControllerFabric: ControllerFactoryProtocol {
   // ...your implementation for each controller...
}
```
Now, you can just delegate the creation of the controllers to the fabric, and let the navigation class do one and only one thing: Navigate! (Or better, describe where to go)

```swift
enum MainDestination: FBControllerDestination {
     case main
     case onboarding
     
     /// This is the default implementation: I don't require you to implement any pattern here.
     /// I leave to you the choice on how to instantiate your UIViewControllers
     func controller() -> UIViewController {
         /// But, I recommend you to use the Factory design pattern
         /// to keep SOLID
         return self.controller(factory: ControllerFabric())
     }
     
     /// And here I'm using the fabric just to ilustrate.
     /// This way you can go from ANY UIViewController to ANY UIViewController
     /// as the enumerations support arguments so you can inject dependencies.
     private func controller(factory: ControllerFactoryProtocol) -> UIViewController {
         switch self {
             case .main(let dependency):
                 return factory.createMainController(dependency: dependency)
             default:
                 return factory.createOnboardingController()
         }
     }
 }
```

### Last! But no least...
As you can see, you can implement an enum to describe some routes to your navigation. But there's no reason for you to implement only one... you can split all your navigation in the way that best suits your need. 

As you can pass a generic FBControllerDestination here, you can change the possible routes for each instance of FBControllerNavigator. No subclassing needed.  
```swift
let navigator1 = FBControllerNavigator<SomeDestination>(nc: navigationController)
let navigator2 = FBControllerNavigator<AnotherDestination>(nc: navigationController)
```

Now that's cool, isn't it?

### Yeah! I like it. But if I need to navigate between another endpoints rather than ViewControllers?

The FBControllerNavigator is based on a protocol named FBNavigator (the most important part), so it means that you can implement it with another objects to construct your own navigation to fit your needs. I've implemented FBControllerNavigator as an example of the most common navigation, that is, between viewControllers. :) 


Let me know your thoughts! :) 
