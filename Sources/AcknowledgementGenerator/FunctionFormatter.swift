import Foundation

class FunctionFormatter : Formatter {
  override func string(for obj: Any?) -> String? {
    if var pkgName = obj as? String {
      pkgName.removeAll { $0.isLetter == false }
      return pkgName.lowercased()
    }
    return nil
  }
}
