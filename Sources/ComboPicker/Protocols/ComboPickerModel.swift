//
//  File.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

import Foundation

/// A generic value that can be displayed in a ``ComboPicker``.
///
/// # Overview
/// Anything that conforms to this protocol can be displayed in a ``ComboPicker``.
/// The picker will use the `label` as display label, the `value` as actual value to return
/// and `valueForManualInput` as value to prefill the custom input field (where available).
///
/// The value must be convertible to string, as the user will be able to input arbitrary characters.
public protocol ComboPickerModel: Identifiable, Hashable {
  associatedtype Value: Hashable, LosslessStringConvertible
  
  /// Initialize a new model with the passed value.
  ///
  /// - parameters:
  ///   - value: A value.
  init(value: Value)
  
  /// Try to initialize a new model using the passed custom value.
  ///
  ///- parameters:
  /// - customValue: A custom value the user input.
  init?(customValue: String)
  
  /// Get the label to use to display this value.
  var label: String { get }
  
  /// Get the actual value.
  var value: Value { get }
  
  /// Get the value to prefill the custom input field.
  ///
  /// - note: This property is not used on macOS and tvOS.
  var valueForManualInput: String? { get }
}
