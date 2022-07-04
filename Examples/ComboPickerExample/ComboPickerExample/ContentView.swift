//
//  ContentView.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 29.06.22.
//

import SwiftUI
import ComboPicker

struct ContentView: View {
  var body: some View {
    TabView {
      BasicView()
        .tabItem {
          Text("Basic")
        }
      
      ListView()
        .tabItem {
          Text("List")
        }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
