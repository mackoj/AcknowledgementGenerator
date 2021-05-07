import Foundation
import Mustache

struct GroupPackageInfo: MustacheBoxable {
  var pkg: [PackageInfo]
  
  var mustacheBox: MustacheBox {
    return Box([
      "pkg": self.pkg,
    ])
  }
}

struct PackageInfo: MustacheBoxable, Comparable {
  static func < (lhs: PackageInfo, rhs: PackageInfo) -> Bool {
    if lhs.author !=  rhs.author {
      return lhs.author <  rhs.author
    }
    return lhs.name <  rhs.name
  }
  
  let name: String
  let author: String
  let license: String
  
  var mustacheBox: MustacheBox {
    return Box([
      "name": self.name,
      "author": self.author,
      "license": self.license
    ])
  }
}
