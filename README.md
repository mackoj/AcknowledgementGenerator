# AcknowledgementGenerator

This tool will generate a SwiftUI view with the acknowledgement of license of all SPM dependencies.

It is configurable and easy to change with a template mechanism for the generated code.

```
swift run AcknowledgementGenerator ../Project/Project.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved acknowledgement.mustache --output-directory-path ../Project/Shared/Views --urls "https://github.com/adobe-fonts/source-code-pro"
```

## Todo

- add support using swift-format after generating the file(`swift-format --ignore-unparsable-files --in-place Acknowledgements.swift`)
- improve the Acknowledgements.swift file
- improve the template
- more docs
- tests
- README.md
- Handle other provider Gitlab
- Improve UI of Acknowledgements.swift
- Get contributors name to thanks them

![Simulator Screen Recording - iPhone 12 Pro Max - 2021-05-07 at 14 48 49](https://user-images.githubusercontent.com/661647/117451947-783f0e00-af43-11eb-88f2-b9808cf81d59.gif)
