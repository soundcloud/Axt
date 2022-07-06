# 🪓 Axt 

Axt is SwiftUI view testing library. It makes use of preferences to enable testing views in-vitro. That means views behave the same as in apps and are fully functional, all SwiftUI property wrappers are in a usable state and views can be interacted with.

## Examples

Take a simple views that displays a number of toggles. Notice the use of the `axt` modifier.

```swift
List {
    Toggle("1", isOn: $value1)
        .axt(.toggle, "toggle_1")
    Toggle("Show more", isOn: $showMore)
        .axt(.toggle, "show_more")
    if showMore {
        Toggle("2", isOn: $value2)
            .axt(.toggle, "toggle_2")
    }
}
```

### Watching the hierarchy

As a first step, we can watch view updates in the console.

```swift
func testWatch() async {
    let test = await AxtTest.host(TogglesView())
    await test.watchHierarchy()
}
```

Running this test should open the simulator, and print the view hierarchy in the console.

```
→ app
  → toggle_1 label="1" value=false action
  → show_more label="Show more" value=false action
```

If you interact with the view in the simulator, a new view hierarchy will be printed in the console any time it changes.

### Check for a value

We can check the value of a toggle:

```swift
func testValue() async {
    let test = await AxtTest.host(TogglesView())
    let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

    moreToggle.performAction()
    await AxtTest.yield()

    XCTAssertNotNil(test.find(id: "more_content"))
}
```

### Perform an action 

We can programmatically tap the toggle in the test:

```swift
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))
moreToggle.performAction()
```

### Wait for a condition

We can wait for a toggle to appear:

```swift
try await test.waitForCondition(timeout: 1) {
    test.find(id: "toggle_2") != nil
}
```

Check out more examples in the AxtExamples project in the Examples folder.

## Getting started

1. Add the Axt Swift package as a dependency to your Xcode project.
2. Link both your app target and unit test target to the Axt library. If the project is built for release, it will only contain stubs for Axt and no inspection code.
3. Make sure your unit test target has a host application. We need some app to host the views to test, but the views do not need to be part of this host application.

## Documentation

Axt never tries to read down the view hierarchy, it always reads up. In order to use views in a test, you need to expose them by giving them an Axt identifier and possibly add more information.

### Exposing views

To enable testing views, we first need to expose them using the `axt` modifier. There are different ways to expose views, depending on whether they are built-in or custom views. You can also add attach Axt elements without explicit child views to a view.

#### Simple views and container views

You can expose any view or stack by specifying an identifier.

```swift
HStack {
    Color.blue.frame(width: 50, height: 50)
        .axt("blue")
    Color.red.frame(width: 50, height: 50)
        .axt("red")
}
.axt("colors")
```

#### Views with values or functionality

You can also specify values or functionality manually to expose them to views.

```swift
Color.blue.frame(width: 50, height: 50)
    .axt("color_1", value: UIColor.blue)
Color.red.frame(width: 50, height: 50)
    .axt("color_2", value: UIColor.red)
```

You can also add closures to perform from tests or ways to set values. This information is transferred up the view hierarchy using preferences. This can then be used from the test to interact with the view hierarchy.

#### Native views

Because we cannot change native SwiftUI view implementations and add preferences to them, we need a different way to expose their information. To enable Axt on native SwiftUI views, you need to give Axt a hint as to what kind of view it needs to look for:

```swift
Button("Tap me") { tap() }
    .axt(.button, "tap_button")

Toggle("Tap me", isOn: $isOn)
    .axt(.toggle, "is_on_toggle")

NavigationLink("More", destination: Destination())
    .axt(.navigationLink, "more_link")

TextField("Name", text: $name)
    .axt(.textField, "name_field")
```

You can place the `axt` modifier below other modifiers as well:

```swift
Button("Tap me") { tap() }
    .buttonStyle(MyButtonStyle())
    .tint(.red)
    .axt(.button, "tap_button")
```

#### Custom views

If you use custom controls instead of native SwiftUI controls, you should not use the modifiers like above. Those modifiers try to extract data from the views. For custom controls, that is not necessary, because we can include preferences internally. To specify values or functionality for custom views, but allow clients to set the Axt identifier or override values or functionality, use the `axt` modifier without an identifier.

```swift
struct MyButton: View {
    let action: () -> Void

    var body: some View {
        Button("Tap me!") { action() }
            .axt(action: action)
    }
}

MyButton() { /* ... */ }
    .axt("my_button")
```

#### Inserting extra elements

Sometimes it can be useful to insert Axt elements to a views that do not correspond to a view itself. This can be useful to expose buttons that are handled in UIKit instead, interact with gestures or other objects that are not views, or provide an easy way to interact with view state when testing a view modifier.

For example, here is how we can expose the contents of an alert:

```swift
content.alert(isPresented: $isPresented) {
    Alert(
        title: Text(message),
        primaryButton: .default(Text("1"), action: action1),
        secondaryButton: .default(Text("2"), action: action2))
}
.axt(insert: "button_1", when: isPresented, label: "1", action: action1)
.axt(insert: "button_2", when: isPresented, label: "2", action: action2)
```

And here we expose a drag gesture to be testable.

```swift
@State private var dragY: CGFloat = 0

var body: some View {
    knob
        .frame(width: 50, height: 50)
        .offset(x: 0, y: dragY)
        .gesture(gesture)
        .axt(insert: "drag", value: dragY, setValue: { dragY = $0 as? CGFloat ?? 0 })
}
```

#### Sheets

Preferences that are set on the contents of a SwiftUI sheet are never transferred to the view presenting the sheet. You can still expose contens of a sheet, but this should be a last resort. Use the following code to add a new `AxtTest` to the `AxtTest.sheets` variable.

```swift
Button("...") { isPresented = true }
    .sheet(isPresented: $isPresented) {
        MoreMenu()
            .hostAxSheet()
    }
```

