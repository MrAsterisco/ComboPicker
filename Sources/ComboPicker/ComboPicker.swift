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
/// # Predefined Values
/// The predefined values are displayed in a `Picker` on all platforms, except for macOS, where
/// the AppKit's `NSComboBox` is used.
///
/// - warning: Please note that on tvOS, the amount of visible options in the Picker might be
/// limited, as all options are displayed inline.
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
public struct ComboPicker<Model: ComboPickerModel>: View {
  private let title: String
  private let manualTitle: String
  
  fileprivate var keyboardType = KeyboardType.default
  
  @Binding private var content: [Model]
  @Binding private var value: Model.Value
  
  @State private var mode = ComboPickerMode.picker
  @State private var manualInput = ""
  
  @FocusState private var focus: ComboPickerMode?
  
  public init(
    title: String = "",
    manualTitle: String = "",
    content: Binding<[Model]>,
    value: Binding<Model.Value>
  ) {
    self.title = title
    self.manualTitle = manualTitle
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

// MARK: - Preview
struct SwiftUIView_Previews: PreviewProvider {
  @State static private var selection = "1"
  
  struct TestModel: ComboPickerModel {
    let id = UUID()
    let value: String
    
    init(value: String) {
      self.value = value
    }
    
    init?(customValue: String) {
      self.init(value: customValue)
    }
    
    var valueForManualInput: String? {
      value
    }
    
    var label: String {
      "\(value) kg"
    }
  }
  
  static var previews: some View {
    ComboPicker(
      content: .constant(
        (1..<100).map {
          TestModel(value: "\($0)")
        }
      ),
      value: $selection
    )
  }
}
