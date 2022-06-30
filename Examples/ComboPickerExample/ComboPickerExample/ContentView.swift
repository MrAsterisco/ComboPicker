//
//  ContentView.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 29.06.22.
//

import SwiftUI
import ComboPicker

struct ContentView: View {
  @State private var content = ExampleModel.data
  @State private var selection = ExampleModel.data.first!.value
  
  var body: some View {
    VStack {
      ComboPicker(
        title: "Pick a number",
        manualTitle: "Custom...",
        content: $content,
        value: $selection
      )
      .keyboardType(.numberPad)
      
//      Text("Selected value: \(selection)")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
