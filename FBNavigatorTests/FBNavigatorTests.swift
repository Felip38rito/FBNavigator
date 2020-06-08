//
//  FBNavigatorTests.swift
//  FBNavigatorTests
//
//  Created by Felipe Correia on 03/06/20.
//  Copyright © 2020 felip38rito. All rights reserved.
//

import XCTest
import UIKit
@testable import FBNavigator

class FBNavigatorTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testCanNavigateToSomeGenericController() {
        // To use the FBNavigation scheme, you'll need the navigationController
        let navigationController = TestNavigationController(rootViewController: TestRootController())
        
        let navigator = FBControllerNavigator<Destinations>(nc: navigationController)
        /// let's try to navigate to "another test"
        navigator.navigate(to: .anotherTest)
        /// let's check if it's the AnotherTestController since we have the animation...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssert(navigationController.topViewController is AnotherTestController)
        }
    }
    
    func testCanInjectDependenciesIntoADestinationController() {
        let navigationController = TestNavigationController(rootViewController: TestRootController())
        
        let navigator = FBControllerNavigator<Destinations>(nc: navigationController)
        
        let dependency = Dependency()
        
        navigator.navigate(to: .test(dependency: dependency))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            /// first let's check the type of the controller
            XCTAssert(navigationController.topViewController is TestController)
            /// last, but no least, let's check the dependency
            let controller = navigationController.topViewController as! TestController
            /// successifully injected
            XCTAssertEqual(dependency, controller.dependency)
            XCTAssertNotEqual(Dependency(), controller.dependency)
        }
        
    }
}

fileprivate class TestRootController: UIViewController {
    let str = "I am the root controller"
}

fileprivate class TestController: UIViewController {
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class AnotherTestController: UIViewController {

}

fileprivate class TestNavigationController: UINavigationController {
    
}

/// Since this is only a test, i'll not implement a factory, only instantiate the simplest way
fileprivate enum Destinations: FBControllerDestination {
    case test(dependency: Dependency)
    case anotherTest
    
    func controller() -> UIViewController {
        switch self {
            case .test(let dependency):
            return TestController(dependency: dependency)
            
            case .anotherTest:
            return AnotherTestController()
        }
    }
}

fileprivate struct Dependency: Equatable {
    let string = "I am a controller dependency..."
}
