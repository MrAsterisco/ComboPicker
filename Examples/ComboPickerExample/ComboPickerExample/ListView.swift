//
//  ListView.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 03.07.22.
//

import SwiftUI
import ComboPicker

struct ListView: View {
  @State private var content = ExampleModel.data
  
  @State private var selection = ExampleModel.data.first!.value
  @State private var otherSelection = ExampleModel.data.last!.value
  
  var body: some View {
    List {
      ComboPicker(
        title: "Pick a number",
        manualTitle: "Custom...",
        valueFormatter: ExampleModelFormatter(),
        content: $content,
        value: $selection
      )
#if os(iOS)
      .pickerFont(.headline)
#endif
      .keyboardType(.numberPad)
      .padding()
      
      ComboPicker(
        title: "Pick another number",
        manualTitle: "Custom...",
        valueFormatter: ExampleModelFormatter(),
        content: $content,
        value: $otherSelection
      )
      .keyboardType(.numberPad)
      .padding()
    }
#if os(iOS)
    .listStyle(.insetGrouped)
#endif
  }
}

struct ListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView()
  }
}
