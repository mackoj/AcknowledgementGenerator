import Foundation
import Mustache

struct PackageInfo: MustacheBoxable {
  let name: String
  let license: String
  
  var mustacheBox: MustacheBox {
    return Box([
      "name": self.name,
      "license": self.license
    ])
  }
}
