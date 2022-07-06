# 🪓 Axt 

Axt is SwiftUI view testing library. It makes use of preferences to enable testing views. Axt can test views in-vitro, which means that views behave the same as in apps and are fully functional. SwiftUI property wrappers such as `@State` are usable and views can be interacted with.

## Examples

Take a simple view that displays a number of toggles. Notice the `toggle_1`, `show_more` and `toggle_2` identifiers.

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

We can check the value of a toggle.

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

We can programmatically tap the toggle in the test.

```swift
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))
moreToggle.performAction()
```

### Wait for a condition

We can wait for a toggle to appear.

```swift
try await test.waitForCondition(timeout: 1) {
    test.find(id: "toggle_2") != nil
}
```

Check out more examples in the AxtExamples project in the Examples folder.

## Documentation

### Getting started

Follow the steps below to add Axt to an existing project. Note that Axt should be used with unit test targets, and not with UI test targets.

1. Add the Axt Swift package as a dependency to your Xcode project.
2. Link both your app target and unit test target to the Axt library. If the project is built for release, it will only contain stubs for Axt and no inspection code.
3. Make sure your unit test target has a host application. We need some app to host the views to test, but the views do not need to be part of this host application.

### Exposing views

Axt never tries to read down the view hierarchy, it uses preferences that are transferred up the hierarchy. In order to use views in a test, you need to expose them by giving them an Axt identifier, and optionally add more information such as a value.

To expose a view, use the `axt` modifier. There are different ways to expose views, depending on whether they are built-in or custom views. You can also add attach Axt elements without explicit child views to a view.

#### Simple views

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

This will be exposed to the tests as below, as you can also check using the `watchHierarchy` function.

```
→ app
  → colors
    → blue
    → red
```

#### Values and functionality

You can also specify values or functionality manually to expose them to views.

```swift
Color.blue.frame(width: 50, height: 50)
    .axt("color_1", value: UIColor.blue)
Color.red.frame(width: 50, height: 50)
    .axt("color_2", value: UIColor.red)
```

These can now be accessed from tests.

```
→ app
  → blue value=UIColor.blue
  → red value=UIColor.red
```

You can also add closures to perform from tests or ways to set values.

#### Reusable controls

It is common to want to specify values or functionality for custom views, but allow clients to set the Axt identifier or override values or functionality. This would be the case for custom buttons or search bars. For this, use the `axt` modifier without an identifier.

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

An `axt` modifier that does not have an identifier is only exposed to tests if an identifier is provided somewhere hier up in the view hierarchy.

#### Native views

Because we cannot change native SwiftUI view implementations and add preferences to them, we need a different way to expose their information. To enable Axt on native SwiftUI views, you need to give Axt a hint as to what kind of view it needs to look for:

```swift
Button("Tap me") { tap() }
    .axt(.button, "tap_button")
```

```
→ tap_button label="Tap me" action
```

```swift
Toggle("Toggle me", isOn: $isOn)
    .axt(.toggle, "is_on_toggle")
```

```
→ is_on_toggle label="Toggle me" value=true action
```

```swift
NavigationLink("More", destination: Destination())
    .axt(.navigationLink, "more_link")
```

```
→ more_link label="More" action
```

```swift
TextField("Name", text: $name)
    .axt(.textField, "name_field")
```

```
→ name_field label="Name" value="" action
```

You can place the `axt` modifier below other modifiers as well:

```swift
Button("Tap me") { tap() }
    .buttonStyle(MyButtonStyle())
    .tint(.red)
    .axt(.button, "tap_button")
```

These modifiers try to extract data from the views, and are the only exception to the principle that Axt never tries to read down the view hierarchy. If you use your own controls instead of native SwiftUI controls, you should not use these modifiers, but instead add use `axt` modifiers in their bodies to expose what needs to be accessible from the tests.

#### Inserting extra elements

Sometimes it can be useful to insert Axt elements that do not correspond to a SwiftUI view. This can be useful to expose buttons that are handled in UIKit instead, interact with gestures or other objects that are not views, or provide an easy way to interact with view state when testing a view modifier.

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

### Testing

#### Axt tests

If you want to use Axt in a test, make the test `async` and create the test with the following line.

```swift
let test = await AxtTest.host(MyView())
```

This will display `MyView` in the simulator, with a red border around it, to indicite that it is presented by Axt. The `test` is also an Axt element. That means you can call all the functions on it introduced in Axt elements.

#### Axt elements

Axt elements point to a view that is exposed to Axt by the methods presented before, but it differs to a view in that it is a reference type. Even if a view is re-evaluated, an Axt element that points to that view will be the same. The Axt element will track changes in the view. That means you can store an Axt element, make changes to the SwiftUI state, and then check the Axt element again.

```swift
let test = await AxtTest.host(MyView())
let label = try XCTUnwrap(test.find(id: "my_label")
let toggle = try XCTUnwrap(test.find(id: "my_toggle"))

XCTAssertEqual(label.value as? String, "yes")

toggle.performAction()
await AXTest.yield()

XCTAssertEqual(label.value as? String, "no")
```

You can check if an Axt element (still) exists (`exists`), and it has an identifier given to it through the `axt` modifier (`id`), and optionally a label (`label`), value (`value`), way to perform an action (`performAction()`), and way to set the value (`setValue`).

For any Axt element, you can use `await element.watchHierarchy()` to see how the hierarchy changes while interacting with it in the simulator or on your iPhone.

#### Traversing the hierarchy

You can get the direct children of an element using the `children` method. To recursively get all elements underneath another element, use the `all` property instead.

You can also use `find(id: "my_button")` to recursively search for an element with id `my_button`, or `findAll(id: "my_button")` to get an array of all the elements with this id.

#### Waiting for view updates

If you change the state of a variable in a SwiftUI view, for example by performing an action on a control or changing a value, SwiftUI might invalidate your view. However, SwiftUI does not re-evaluate invalidated views immediately. This is done for efficiency reasons. Therefore, you cannot make an assertion immediately after changing state.

If you expect an update to happen after an action immediately after the current run loop cycle, you can use the `AxtTest.yield()` function.

```swift
let test = await AxtTest.host(TogglesView())
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

moreToggle.performAction()
await AxtTest.yield()

XCTAssertNotNil(test.find(id: "toggle_2"))
```

If you expect that it might take longer for the view hierarchy to update, for example because the changes are animated, you can use the `waitFor` functions on Axt elements. These functions are efficient, because they only check for changes when the view hierarchy was changed.

```swift
let test = await AxtTest.host(TogglesView())
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

moreToggle.performAction()

XCTAssertNotNil(try await test.waitForElement(id: "toggle_2", timeout: 1))
```

There is also `waitForCondition` to wait for any boolean condition, and `waitForUpdate` that returns as soon as anything in the view hierarchy is changed.

