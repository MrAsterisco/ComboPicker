import ComboPicker
import Foundation

public struct ExampleModel: ComboPickerModel {
  public static func ==(lhs: ExampleModel, rhs: ExampleModel) -> Bool {
    lhs.value == rhs.value
  }
  
  public let id = UUID()
  public let value: Int
  
  public init(value: Int) {
    self.value = value
  }
  
  public init?(customValue: String) {
    guard let doubleValue = NumberFormatter().number(from: customValue)?.intValue else { return nil }
    self.init(value: doubleValue)
  }
  
  public var valueForManualInput: String? {
    NumberFormatter().string(from: .init(value: value))
  }
}
