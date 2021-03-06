//
//  File.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

import SwiftUI

struct ManualInput: View {
  private let title: String
  private let keyboardType: KeyboardType
  private let action: () -> ()
  
  @Binding private var value: String
  @FocusState private var focus: ComboPickerMode?
  
  init(
    title: String = "",
    keyboardType: KeyboardType = .default,
    value: Binding<String>,
    focus: FocusState<ComboPickerMode?>,
    action: @escaping () -> ()
  ) {
    self.title = title
    self.keyboardType = keyboardType
    self._value = value
    self._focus = focus
    self.action = action
  }
  
  var body: some View {
#if os(iOS) || os(macOS)
    HStack {
      TextField(title, text: $value)
#if !os(macOS)
        .keyboardType(keyboardType.systemType)
#endif
        .font(.system(size: 21))
        .multilineTextAlignment(.center)
        .frame(height: 30)
        .focused($focus, equals: .manual)
        .overlay(alignment: .trailing) {
          Button(action: performAction) {
            Image(systemName: "checkmark.circle.fill")
          }
          .padding(.trailing, 4)
        }
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .padding([.leading, .trailing], 8)
        .onSubmit(performAction)
    }
#elseif os(watchOS)
    HStack {
      TextField("", text: $value)
        .multilineTextAlignment(.center)
        .focused($focus, equals: .manual)
      
      Image(systemName: "checkmark.circle.fill")
        .onTapGesture { action() }
        .font(.title)
        .padding()
    }
#endif
  }
}

private extension ManualInput {
  func performAction() {
    // This avoids crashing because the text field doesn't want to resign
    // from first responder when the ComboPicker is displayed
    // in a List.
    focus = nil
    action()
  }
}
