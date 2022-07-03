//
//  ComboPicker.swift
//  
//
//  Created by Alessio Moiso on 26.06.22.
//

import SwiftUI

/// A control that displays a picker with the ability to also input custom values.
///
/// # Overview
/// This component is ideal when you want to provide the user with some predefined
/// options, while still giving them the ability to input new ones.
/// You can create a combo picker with any value that conforms to `ComboPickerModel`.
///
/// The following code shows an example implementation of a `ComboPickerModel` that wraps an `Int`:
///
/// ```swift
/// public struct Model: ComboPickerModel {
///   public static func ==(lhs: Model, rhs: Model) -> Bool {
///     lhs.value == rhs.value
///   }
///
///   public let id = UUID()
///   public let value: Int
///
///   public init(value: Int) {
///     self.value = value
///   }
///
///   public init?(customValue: String) {
///     guard let doubleValue = NumberFormatter().number(from: customValue)?.intValue else { return nil }
///     self.init(value: doubleValue)
///   }
///
///   public var valueForManualInput: String? {
///     NumberFormatter().string(from: .init(value: value))
///   }
/// }
/// ```
///
/// # Predefined Values
/// The predefined values are displayed in a `Picker` on all platforms, except for macOS, where
/// AppKit's `NSComboBox` is used.
///
/// - warning: On iOS and iPadOS, putting a picker below another one will cause the second picker
/// to take over all gestures and tap events of the first one. You can, however, fit two pickers on the same line.
/// - note: Please note that on tvOS, the amount of visible options in the Picker might be
/// limited, as all options are displayed inline.
///
/// # Formatting Values
/// The predefined values that will be displayed in the `ComboPicker` can be formatted by means of an
/// implementation of `ValueFormatterType`. You are required to provide one.
///
/// Here's an example implementation that uses a `NumberFormatter` to display an `Int` value.
///
/// ```swift
/// final class ModelFormatter: ValueFormatterType {
///   func string(from value: Model) -> String {
///     NumberFormatter().string(from: .init(value: value.value)) ?? ""
///   }
/// }
/// ```
///
/// - note: Because of the `NSComboBox` works on macOS, predefined values will not be formatted using
/// this formatter. Their implementation of `LosslessStringConvertible` will be used instead.
///
/// # Manual Input
/// When the user taps on the Picker, the component switches automatically to the manual input mode.
/// In this mode, the user is allowed to enter any value.
///
/// The component will attempt to convert the value to your implementation of `ComboPickerModel`.
/// You are responsible of deciding whether the value is valid or not. Invalid values will not be added to the
/// picker nor will be reported as selected.
///
/// - note: On tvOS, there is no tap-interaction. The user can swipe down to access the text field directly.
/// - note: On macOS, the `NSComboBox` allows users to type directly inside the menu.
public struct ComboPicker<Model: ComboPickerModel, Formatter: ValueFormatterType>: View where Formatter.Value == Model {
  private let title: String
  private let manualTitle: String
  
  fileprivate var keyboardType = KeyboardType.default
  fileprivate var valueFormatter: Formatter
  
  @Binding private var content: [Model]
  @Binding private var value: Model.Value
  
  @State private var mode = ComboPickerMode.picker
  @State private var manualInput = ""
  
  @FocusState private var focus: ComboPickerMode?
  
  /// Initialize a new `ComboPicker` using the passed values.
  ///
  /// - parameters:
  ///   - title: A title that will be displayed when choosing from a predefined set of values.
  ///   - manualTitle: A title that will be displayed when using manual input.
  ///   - valueFormatter: A formatter implementation to represent values in the predefined set.
  ///   - content: The predefined set of values.
  ///   - value: The currently selected value.
  public init(
    title: String = "",
    manualTitle: String = "",
    valueFormatter: Formatter,
    content: Binding<[Model]>,
    value: Binding<Model.Value>
  ) {
    self.title = title
    self.manualTitle = manualTitle
    self.valueFormatter = valueFormatter
    self._content = content
    self._value = value
  }
  
  public var body: some View {
    Group {
      switch mode {
      case .picker:
        SmartPicker(
          title: title,
          manualTitle: manualTitle,
          keyboardType: keyboardType,
          valueFormatter: valueFormatter,
          content: $content,
          value: $value,
          focus: _focus,
          action: { change(to: .manual) }
        )
      case .manual:
        ManualInput(
          title: manualTitle,
          keyboardType: keyboardType,
          value: $manualInput,
          focus: _focus,
          action: { change(to: .picker) }
        )
      }
    }
    .animation(.easeInOut, value: mode)
    .onAppear {
      manualInput = Model(value: value).valueForManualInput ?? ""
    }
    .onChange(of: manualInput) { newValue in
      guard
        let modelValue = Model(customValue: newValue),
        modelValue.value != value
      else { return }
      
      if !content.contains(modelValue) {
        content += [modelValue]
      }
      
      value = modelValue.value
    }
    .onChange(of: value) { newValue in
      manualInput = Model(value: newValue).valueForManualInput ?? ""
    }
  }
}

public extension ComboPicker {
  func keyboardType(_ type: KeyboardType) -> Self {
    var newSelf = self
    newSelf.keyboardType = type
    return newSelf
  }
}

private extension ComboPicker {
  func change(to mode: ComboPickerMode) {
    withAnimation {
      self.mode = mode
      focus = mode
    }
  }
}
