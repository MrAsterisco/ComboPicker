//
//  File.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

import Foundation

public protocol ComboPickerModel: Identifiable, Hashable {
  associatedtype Value: Hashable, LosslessStringConvertible
  
  init(value: Value)
  
  init?(customValue: String)
  
  var label: String { get }
  
  var value: Value { get }
  
  var valueForManualInput: String? { get }
}
