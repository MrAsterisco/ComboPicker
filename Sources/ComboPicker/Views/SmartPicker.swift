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
  private let valueFormatter: Formatter
  
  private let keyboardType: KeyboardType
  
#if os(iOS)
  fileprivate var font: UIFont?
#endif
  
  @Binding private var content: [Model]
  @Binding private var value: Model.Value
  
  @Binding private var manualInput: String
  @FocusState private var focus: ComboPickerMode?
  
  let action: () -> ()
  
  public init(
    title: String = "",
    manualTitle: String = "",
    keyboardType: KeyboardType = .default,
    valueFormatter: Formatter,
    content: Binding<[Model]>,
    value: Binding<Model.Value>,
    manualInput: Binding<String>,
    focus: FocusState<ComboPickerMode?>,
    action: @escaping () -> ()
  ){
    self.title = title
    self.manualTitle = manualTitle
    self.keyboardType = keyboardType
    self.valueFormatter = valueFormatter
    self._content = content
    self._value = value
    self._manualInput = manualInput
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
        text: $manualInput
      )
    }
#elseif os(tvOS)
    VStack {
      Picker(title, selection: $value) {
        ForEach($content) { $model in
          Text(valueFormatter.string(from: model))
            .tag(model.value)
        }
      }
      
      TextField(manualTitle, text: $manualInput)
        .font(.headline)
        .keyboardType(keyboardType.systemType)
    }
    .onChange(of: value) { newValue in
      guard newValue != Model.Value(manualInput) else { return }
      manualInput = ""
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
      valueFormatter: valueFormatter,
      font: font
    )
    .frame(height: Constants.pickerHeight)
    .clipped()
    .onTapGesture { action() }
    .focused($focus, equals: .picker)
#endif
  }
}

extension SmartPicker {
#if os(iOS)
  func font(_ font: UIFont?) -> Self {
    var newSelf = self
    newSelf.font = font
    return newSelf
  }
#endif
}
