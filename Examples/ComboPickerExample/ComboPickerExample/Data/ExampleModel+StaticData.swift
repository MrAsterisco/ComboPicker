public extension ExampleModel {
#if os(tvOS)
  static var data: [ExampleModel] = (1...10).map {
    .init(value: $0)
  }
#else
  static var data: [ExampleModel] = (1...100).map {
    .init(value: $0)
  }
#endif
}
