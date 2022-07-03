//
//  ContentView.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 29.06.22.
//

import SwiftUI
import ComboPicker

#if os(watchOS) || os(tvOS)
typealias Stack = VStack
#else
typealias Stack = HStack
#endif

struct ContentView: View {
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
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
