//
//  FBControllerNavigator.swift
//  FBNavigator
//
//  Created by Felipe Correia on 03/06/20.
//  Copyright © 2020 felip38rito. All rights reserved.
//

import UIKit

/**
 Define the type that can be used as a destination for our FBNavigator for controller navigation
 ~~~
 /// The best way to implement this destination is to go with enumerations:
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
 
protocol ControllerFabricProtocol {
    func createMainController(dependency: SomeDependency) -> UIViewController
    func createOnboardingController() -> UIViewController
}

class ControllerFabric: ControllerFactoryProtocol {
    ...your implementation...
}

 ~~~
 */
public protocol FBControllerDestination {
    func controller() -> UIViewController
}

/**
 The specific navigator for use with UIViewControllers as destinations
 
 ~~~
 /// Assuming you have an enum MainDestination that implements FBControllerDestination
 /// let's initialize with some navigation controller
 let navigator = FBControllerNavigator<MainDestination>(nc: SomeNavigationController())
 /// And then go anywhere you define in the enumeration
 navigator.navigate(to: .main)
 ~~~
 */
open class FBControllerNavigator<D: FBControllerDestination>: FBNavigator {
    /// The possible destinations for this navigator instance injected generically
    public typealias Destination = D
    
    /// The UIKit navigationController
    public weak var navigationController: UINavigationController?
    
    /// Initialize the navigator for UIViewControllers
    /// - Parameter nc: The navigation controller responsible for the controller basic navigation
    public init(nc: UINavigationController) {
        self.navigationController = nc
    }
    
    /**
    Navigate to some destination

    This method take the depedency of FBControllerDestination type as a destination and then navigate to it's controller

    - Parameter to: The destination to go
    - Precondition: `to` must implement FBControllerDestination
     
    ~~~
    let navigator = FBControllerNavigator<MainDestination>(nc: SomeNavigationController())
    /// And then go anywhere you define in the enumeration
    navigator.navigate(to: .main)
    ~~~
    */
    open func navigate(to: D, animated: Bool = true) {
        navigationController?.pushViewController(to.controller(), animated: animated)
    }
}
