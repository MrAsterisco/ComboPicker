//
//  SmartPicker.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

import SwiftUI

struct SmartPicker<Model: ComboPickerModel>: View {
  private let title: String
  private let manualTitle: String
  
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
    content: Binding<[Model]>,
    value: Binding<Model.Value>,
    focus: FocusState<ComboPickerMode?>,
    action: @escaping () -> ()
  ){
    self.title = title
    self.manualTitle = manualTitle
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
          Text(model.label)
            .tag(model.value)
        }
      }
      
      TextField(manualTitle, text: $comboBoxInput)
    }
    .onChange(of: comboBoxInput) { newValue in
      guard let modelValue = Model.Value(newValue) else { return }
      value = modelValue
    }
    .onChange(of: value) { newValue in
      guard newValue != Model.Value(comboBoxInput) else { return }
      comboBoxInput = ""
    }
#else
    Picker(title, selection: $value) {
      ForEach($content) { $model in
        Text(model.label)
          .tag(model.value)
      }
    }
    .pickerStyle(.wheel)
#if !os(watchOS)
    .frame(height: 30)
#else
    .frame(height: 50)
#endif
    .clipped()
    .onTapGesture { action() }
    .focused($focus, equals: .picker)
#endif
  }
}
