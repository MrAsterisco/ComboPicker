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
  
  let font: UIFont?
  let valueFormatter: Formatter
  
  init(content: Binding<[Content]>, selection: Binding<Content.Value>, valueFormatter: Formatter, font: UIFont? = nil) {
    self.content = content
    self.selection = selection
    self.valueFormatter = valueFormatter
    self.font = font
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return parent.content.wrappedValue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      let value = parent.valueFormatter.string(from: parent.content.wrappedValue[row])
      
      if
        let view = view as? UILabel,
        (view.font == parent.font || parent.font == nil)
      {
        view.text = value
        return view
      }
      
      let label = UILabel()
      // Use the default text size for pickers, unless a different font is specified.
      // This is necessary to mimic the standard behavior, when the delegate only returns strings.
      label.font = parent.font ?? .systemFont(ofSize: 21)
      label.text = value
      label.textAlignment = .center
      label.adjustsFontForContentSizeCategory = true
      
      return label
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
