//
//  FBNavigator.swift
//  FBNavigator
//
//  Created by Felipe Correia on 03/06/20.
//  Copyright © 2020 felip38rito. All rights reserved.
//

import UIKit

/// The basic abstraction of how a navigator should behave.
/// The principle here is that I need to go from anywhere to anywhere
public protocol FBNavigator {
    associatedtype Destination
    
    func navigate(to: Destination)
}
