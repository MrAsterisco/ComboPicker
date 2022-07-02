//
//  ComboBox.swift
//  
//
//  Created by Alessio Moiso on 27.06.22.
//

#if canImport(AppKit)
import SwiftUI
import AppKit

struct ComboBox: NSViewRepresentable {
  var items: [String]
  @Binding var text: String
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  func makeNSView(context: Context) -> NSComboBox {
    let comboBox = NSComboBox()
    comboBox.usesDataSource = false
    comboBox.completes = false
    comboBox.delegate = context.coordinator
    comboBox.intercellSpacing = NSSize(width: 0.0, height: 10.0)
    return comboBox
  }
  
  func updateNSView(_ nsView: NSComboBox, context: Context) {
    nsView.removeAllItems()
    nsView.addItems(withObjectValues: items)
    
    context.coordinator.ignoreSelectionChanges = true
    nsView.stringValue = text
    nsView.selectItem(withObjectValue: text)
    context.coordinator.ignoreSelectionChanges = false
  }
}

// MARK: - Coordinator
extension ComboBox {
  class Coordinator: NSObject, NSComboBoxDelegate {
    var parent: ComboBox
    var ignoreSelectionChanges: Bool = false
    
    init(_ parent: ComboBox) {
      self.parent = parent
    }
    
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
      if
        !ignoreSelectionChanges,
        let box: NSComboBox = notification.object as? NSComboBox,
        let newStringValue: String = box.objectValueOfSelectedItem as? String
      {
        parent.text = newStringValue
      }
    }
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
      if let textField = obj.object as? NSTextField
      {
        parent.text = textField.stringValue
      }
    }
  }
}
#endif
