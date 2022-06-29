//
//  ContentView.swift
//  ComboPickeriOS
//
//  Created by Alessio Moiso on 27.06.22.
//

import SwiftUI
import ComboPicker
import ComboPickerExampleKit

struct ContentView: View {
  @State private var content = ExampleModel.data
  @State private var selectedValue = ExampleModel.data.first!.value
  
  var body: some View {
    VStack {
      ComboPicker(content: $content, value: $selectedValue)
      Text("Current value: \(selectedValue)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
