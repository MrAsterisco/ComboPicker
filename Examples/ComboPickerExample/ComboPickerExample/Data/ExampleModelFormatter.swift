//
//  ExampleModelFormatter.swift
//  ComboPickerExample
//
//  Created by Alessio Moiso on 03.07.22.
//

import Foundation
import ComboPicker

final class ExampleModelFormatter: ValueFormatterType {
  func string(from value: ExampleModel) -> String {
    "# \(NumberFormatter().string(from: .init(value: value.value)) ?? "")"
  }
}
