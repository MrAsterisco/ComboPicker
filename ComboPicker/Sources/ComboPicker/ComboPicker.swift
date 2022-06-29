//
//  ComboPicker.swift
//  
//
//  Created by Alessio Moiso on 26.06.22.
//

import SwiftUI

public struct ComboPicker<Model: ComboPickerModel>: View {
  private let title: String
  private let manualTitle: String
  
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
          content: $content,
          value: $value,
          focus: _focus,
          action: { change(to: .manual) }
        )
      case .manual:
        ManualInput(
          title: manualTitle,
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
