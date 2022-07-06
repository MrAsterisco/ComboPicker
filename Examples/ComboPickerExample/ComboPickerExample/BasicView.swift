//
//  BasicView.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 03.07.22.
//

import SwiftUI
import ComboPicker

#if os(watchOS) || os(tvOS)
typealias Stack = VStack
#else
typealias Stack = HStack
#endif

struct BasicView: View {
  @State private var content = ExampleModel.data
  
  @State private var selection = ExampleModel.data.first!.value
  @State private var otherSelection = ExampleModel.data.last!.value
  
  var body: some View {
    Stack {
      ComboPicker(
        title: "Pick a number",
        manualTitle: "Custom...",
        valueFormatter: ExampleModelFormatter(),
        content: $content,
        value: $selection
      )
      .keyboardType(.numberPad)
      
      ComboPicker(
        title: "Pick another number",
        manualTitle: "Custom...",
        valueFormatter: ExampleModelFormatter(),
        content: $content,
        value: $otherSelection
      )
      .keyboardType(.numberPad)
#if os(iOS)
      .pickerFont(.caption2)
#endif
    }
    .padding()
  }
}

struct BasicView_Previews: PreviewProvider {
  static var previews: some View {
    BasicView()
  }
}
