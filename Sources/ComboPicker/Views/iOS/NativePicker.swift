//
//  NativePicker.swift
//  
//
//  Created by Alessio Moiso on 03.07.22.
//

#if os(iOS)
import UIKit
import SwiftUI

/// An implementation of a `UIPickerView` compatible with SwiftUI.
///
/// Based on this [StackOverflow answer](https://stackoverflow.com/a/69842277/925537).
struct NativePicker<Content: ComboPickerModel, Formatter: ValueFormatterType>: UIViewRepresentable where Formatter.Value == Content {
  let content: Binding<[Content]>
  var selection: Binding<Content.Value>
  
  let valueFormatter: Formatter
  
  init(content: Binding<[Content]>, selection: Binding<Content.Value>, valueFormatter: Formatter) {
    self.content = content
    self.selection = selection
    self.valueFormatter = valueFormatter
  }
  
  func makeCoordinator() -> Self.Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIPickerView {
    let picker = OneLinePickerView()
    picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    picker.dataSource = context.coordinator
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<Self>) {
    guard let row = content.wrappedValue.firstIndex(where: { $0.value == selection.wrappedValue }) else { return }
    view.selectRow(row, inComponent: 0, animated: false)
  }
  
  class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: NativePicker
    
    init(_ pickerView: NativePicker) {
      parent = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//      return 90
//    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return parent.content.wrappedValue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return parent.valueFormatter.string(from: parent.content.wrappedValue[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      parent.selection.wrappedValue = parent.content.wrappedValue[row].value
    }
  }
  
  class OneLinePickerView: UIPickerView {
    override var intrinsicContentSize: CGSize {
      .init(width: UIView.noIntrinsicMetric, height: Constants.pickerHeight + Constants.pickerPadding)
    }
  }
}
#endif
