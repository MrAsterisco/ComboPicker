//
//  SmartPicker.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

import SwiftUI

struct SmartPicker<Model: ComboPickerModel, Formatter: ValueFormatterType>: View where Formatter.Value == Model {
  private let title: String
  private let manualTitle: String
  
  private let keyboardType: KeyboardType
  private let valueFormatter: Formatter
  
  @Binding private var content: [Model]
  @Binding private var value: Model.Value
  
#if os(macOS) || os(tvOS)
  @State private var comboBoxInput = ""
#endif
  @FocusState private var focus: ComboPickerMode?
  
  let action: () -> ()
  
  public init(
    title: String = "",
    manualTitle: String = "",
    keyboardType: KeyboardType = .default,
    valueFormatter: Formatter,
    content: Binding<[Model]>,
    value: Binding<Model.Value>,
    focus: FocusState<ComboPickerMode?>,
    action: @escaping () -> ()
  ){
    self.title = title
    self.manualTitle = manualTitle
    self.keyboardType = keyboardType
    self.valueFormatter = valueFormatter
    self._content = content
    self._value = value
    self._focus = focus
    self.action = action
  }
  
  var body: some View {
#if os(macOS)
    VStack {
      if !title.isEmpty {
        Text(title)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      ComboBox(
        items: content.map { $0.value.description },
        text: $comboBoxInput
      )
    }
    .onChange(of: comboBoxInput) { newValue in
      guard let modelValue = Model.Value(newValue) else { return }
      value = modelValue
    }
    .onChange(of: value) { newValue in
      comboBoxInput = newValue.description
    }
    .onAppear {
      comboBoxInput = value.description
    }
#elseif os(tvOS)
    VStack {
      Picker(title, selection: $value) {
        ForEach($content) { $model in
          Text(valueFormatter.string(from: model))
            .tag(model.value)
        }
      }
      
      TextField(manualTitle, text: $comboBoxInput)
        .keyboardType(keyboardType.systemType)
    }
    .onChange(of: comboBoxInput) { newValue in
      guard let modelValue = Model.Value(newValue) else { return }
      value = modelValue
    }
    .onChange(of: value) { newValue in
      guard newValue != Model.Value(comboBoxInput) else { return }
      comboBoxInput = ""
    }
#elseif os(watchOS)
    Picker(title, selection: $value) {
      ForEach($content) { $model in
        Text(valueFormatter.string(from: model))
          .tag(model.value)
      }
    }
    .pickerStyle(.wheel)
    .frame(height: 50)
    .clipped()
    .onTapGesture { action() }
    .focused($focus, equals: .picker)
#elseif os(iOS)
    NativePicker(
      content: $content,
      selection: $value,
      valueFormatter: valueFormatter
    )
    .compositingGroup()
    .contentShape(Rectangle())
    .frame(height: Constants.pickerHeight)
    .clipped()
    .onTapGesture { action() }
    .focused($focus, equals: .picker)
#endif
  }
}
