//
//  File.swift
//  
//
//  Created by Alessio Moiso on 30.06.22.
//
#if canImport(UIKit)
import UIKit
#endif

public enum KeyboardType {
  case  `default`,
        asciiCapable,
        numbersAndPunctuation,
        URL,
        numberPad,
        phonePad,
        namePhonePad,
        emailAddress,
        decimalPad,
        twitter,
        webSearch,
        asciiCapableNumberPad,
        alphabet
  
#if !os(macOS) && !os(watchOS)
  var systemType: UIKeyboardType {
    switch self {
    case .`default`:
      return .`default`
    case .asciiCapable:
      return .asciiCapable
    case .numbersAndPunctuation:
      return .numbersAndPunctuation
    case .URL:
      return .URL
    case .numberPad:
      return .numberPad
    case .phonePad:
      return .phonePad
    case .namePhonePad:
      return .namePhonePad
    case .emailAddress:
      return .emailAddress
    case .decimalPad:
      return .decimalPad
    case .twitter:
      return .twitter
    case .webSearch:
      return .webSearch
    case .asciiCapableNumberPad:
      return .asciiCapableNumberPad
    case .alphabet:
      return .alphabet
    }
  }
#endif
}
