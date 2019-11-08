//
//  Stack.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/11/2.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

struct Stack<T> {
    private var elements = [T]()
    
    mutating func push(_ element: T) {
        elements.append(element)
    }
    
    mutating func pop() -> T? {
        guard elements.count > 0 else {
            return nil
        }
        return elements.removeFirst()
    }
}
