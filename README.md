# 🪓 Axt 

Axt is SwiftUI view testing library. It makes use of preferences to enable testing views.

### Documentation

#### Native views

Because we cannot change native SwiftUI view implementations and add preferences to them, we need a different way to expose their information. To enable Axt on native SwiftUI views, you need to give Axt a hint as to what kind of view it needs to look for.

```swift
// Button
Button("Tap me") { tap() }
    .buttonStyle(MyButtonStyle())
    .axt(.button, "tap_button")

// Button
Toggle("Tap me", isOn: $isOn)
    .tint(.red)
    .axt(.toggle, "is_on_toggle")

// Button
Button("Tap me") { tap() }
    .buttonStyle(MyButtonStyle())
    .axt(.button, "tap_button")
```
