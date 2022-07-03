//
//  File.swift
//  
//
//  Created by Alessio Moiso on 03.07.22.
//

import Foundation

/// A type that represents a generic formatter.
///
/// # Overview
/// You can provide an implementation of this protocol to format
/// the values you want to display in a `ComboPicker`.
public protocol ValueFormatterType {
  associatedtype Value
  
  func string(from value: Value) -> String
}
