# 🪓 Axt 

![](https://user-images.githubusercontent.com/13484323/185608030-21c45ddc-f90b-42e9-a8ac-e855bb090aea.svg)
![platform-iOS 15-green](https://user-images.githubusercontent.com/13484323/185608132-f90bd70e-4518-404d-9ba7-c24739f7c2b2.svg)

Axt is a testing library for SwiftUI.

Unit tests using Axt can interact with SwiftUI views, which are running live in the simulator and are in a fully functional state.

```swift
struct MyView: View {
    @State var showMore = false

    var body: some View {
        VStack {
            Toggle("Show more", isOn: $showMore)
                .testId("show_more_toggle", type: .toggle)
            if showMore {
                Text("More")
                    .testId("more_text", type: .text)
            }
        }
    }
}
```

```swift
@MainActor
class MyViewTests: XCTestCase {
    func testShowMore() async throws {
        let test = await AxtTest.host(MyView())
        let showMoreToggle = test.find(id: "show_more_toggle")

        await showMoreToggle?.performAction()

        XCTAssertEqual(showMoreToggle?.value as? Bool, true)
        XCTAssertEqual(test.find(id: "more_text")?.label, "More")
    }
}
```

## Getting started

Follow the steps below to add Axt to an existing project. Note that Axt should be used with unit test targets, and not with UI test targets.

1. Add the Axt Swift package as a dependency to your Xcode project.
2. Link both your app target and unit test target to the Axt library. If the project is built for release, it will only contain stubs for Axt and no inspection code.
3. Make sure your unit test target has a host application. We need some app to host the views to test, but the views do not need to be part of this host application.

## Documentation 

### Exposing views

To expose a view, you give it an identifier with the `testId` modifier.

Take this list of toggles, and notice the `toggle_1`, `show_more` and `toggle_2` identifiers.

```swift
List {
    Toggle("1", isOn: $value1)
        .testId("toggle_1", type: .toggle)
    Toggle("Show more", isOn: $showMore)
        .testId("show_more", type: .toggle)
    if showMore {
        Toggle("2", isOn: $value2)
            .testId("toggle_2", type: .toggle)
    }
}
.testId("toggle_list")
```

This will be exposed to the tests as below.

```
→ app
  → toggle_list
    → toggle_1 label="1" value=false action
    → show_more label="Show more" value=false action
```

There are different ways to expose views to unit tests, depending on whether they are built-in or custom views. You can also attach Axt elements without explicit child views to a view.

#### Native views

To enable Axt on native SwiftUI views, you need to tell Axt what kind of view it needs to look for. The following built-in views are supported.

##### Button

```swift
Button("Tap me") { tap() }
    .testId("tap_button", type: .button)
```

```
→ tap_button label="Tap me" action
```

##### Toggle

```swift
Toggle("Toggle me", isOn: $isOn)
    .testId("is_on_toggle", type: .toggle)
```

```
→ is_on_toggle label="Toggle me" value=true action
```

##### NavigationLink

```swift
NavigationLink("More", destination: Destination())
    .testId("more_link", type: .navigationLink)
```

```
→ more_link label="More" action
```

##### TextField

```swift
TextField("Name", text: $name)
    .testId("name_field", type: .textField)
```

```
→ name_field label="Name" value="" action
```

#### Custom views

For custom views, you can specify values or functionality manually to expose them to views.

```swift
Color.blue.frame(width: 50, height: 50)
    .testId("color_1", value: "blue")
Color.red.frame(width: 50, height: 50)
    .testId("color_2", value: "red")
```

These can now be accessed from tests.

```
→ app
  → color_1 value=blue
  → color_2 value=red
```

You can also add closures to perform from tests (using the `action` parameter) or a way to set a value (using the `setValue` parameter).

#### Re-usable controls

It is common to want to specify values or functionality for re-usable controls, but allow clients to set the test identifier or override values or functionality. This would be the case for custom buttons or search bars. For this, use the `testData` modifier.

```swift
struct MyButton: View {
    let action: () -> Void

    var body: some View {
        Button("Tap me!") { action() }
            .testData(action: action)
    }
}

MyButton(action: action)
    .testId("my_button")
```

There will only be a single element for this button exposed to the tests.

```
→ app
  → my_button action
```

Using the `testData` modifier only results in an element exposed to tests, if an identifier is provided somewhere higher up in the view hierarchy.

Do not use the `testId(:type:)` modifiers for native views on custom controls. For custom controls, extracting data from views is not necessary.

#### Inserting extra elements

Sometimes it can be useful to insert Axt elements that do not correspond to a SwiftUI view. This can be useful to expose buttons that are handled in UIKit, or to interact with gestures or other objects that are not views, or provide an easy way to interact with view state when testing a view modifier.

For example, here is how we can expose the contents of an alert.

```swift
content.alert(isPresented: $isPresented) {
    Alert(
        title: Text(message),
        primaryButton: .default(Text("1"), action: action1),
        secondaryButton: .default(Text("2"), action: action2))
}
.testId(insert: "button_1", when: isPresented, label: "1", action: action1)
.testId(insert: "button_2", when: isPresented, label: "2", action: action2)
```

The elements will be exposed as siblings.

```
→ app
  → button_1 label="1" action
  → button_2 label="2" action
```

And here we expose a drag gesture to be testable.

```swift
@State private var dragY: CGFloat = 0

var body: some View {
    knob
        .frame(width: 50, height: 50)
        .offset(x: 0, y: dragY)
        .gesture(gesture)
        .testId(insert: "drag", value: dragY, setValue: { dragY = $0 as? CGFloat ?? 0 })
}
```

```
→ app
  → drag value=0.0
```

#### Sheets

Preferences that are set on the contents of a SwiftUI sheet are never transferred to the view presenting the sheet. You can still expose contents of a sheet, but this should be a last resort. Use the following code to add a new `AxtTest` to the `AxtTest.sheets` variable.

```swift
Button("...") { isPresented = true }
    .sheet(isPresented: $isPresented) {
        MoreMenu()
            .hostAxtSheet()
    }
```

### Writing tests

The first step to writing an Axt test is to create an asynchronous test method, and to host an Axt test with the view.

```swift
func test_myView() async {
  let test = await AxtTest.host(MyView())
  // ...
```

In addition to creating the test, this will also display `MyView` in the simulator or iPhone. It will be displayed with a red border around it, to indicite that it is presented by Axt and distinguish it from the rest of the app contents.

#### Watch the hierarchy

As a first step, we can watch view updates in the console.

```swift
await test.watchHierarchy()
```

Running this test prints the current view hierarchy in the console. The view is also interactive. If you interact with the view, a new view hierarchy will be printed in the console any time it changes.

#### Finding views

The `test` we created before is also an Axt element, namely the root element. If you have an element, you can use it to search for other elements.

You can use the `find(id: "my_button")` method to recursively search for an element with id `my_button`, or `findAll(id: "my_button")` to get an array of all the elements with this id.

```swift
let myButton = try XCTUnwrap(test.find(id: "my_button"))
```

You can also get the direct children of an element using the `children` method. To recursively get all elements underneath another element, use the `all` property instead.

#### Assert on elements

You can check if an Axt element (still) exists (`exists`). It has an identifier given to it through the `testId` modifier (`id`), and optionally a label (`label`), value (`value`), way to perform an action (`performAction()`), and way to set the value (`setValue`).

For any Axt element, you can use `await element.watchHierarchy()` to see how the hierarchy changes while interacting with it in the simulator or on your iPhone.

#### The lifetime of Axt elements

An Axt element points to a view that is exposed to Axt by the methods presented before, but it differs to a view in that it is a reference type. If a view is re-evaluated, an Axt element that points to that view will be updated, but the same object. The Axt element will track changes in the view. That means you can store an Axt element, make changes to the SwiftUI state, and then check the Axt element again.

```swift
let test = await AxtTest.host(MyView())
let label = try XCTUnwrap(test.find(id: "my_label")
let toggle = try XCTUnwrap(test.find(id: "my_toggle"))

XCTAssertEqual(label.value as? String, "yes")

await toggle.performAction()

XCTAssertEqual(label.value as? String, "no")
```

#### Waiting for view updates

If you change the state of a variable in a SwiftUI view, for example by performing an action on a control or changing a value, SwiftUI will trigger a re-evaluation of your view. However, SwiftUI does not re-evaluate the view immediately. This is done for efficiency reasons. Therefore, you cannot make an assertion immediately after changing state.

If you expect an update to happen after an action immediately after the current run loop cycle, use `performAction()`. If you don't want to give SwiftUI the time to update the views, use `performActionWithoutYielding()` instead. You can then give SwiftUI the time to update the views by calling `AxtTest.yield()`.

```swift
let test = await AxtTest.host(TogglesView())
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

moreToggle.performActionWithoutYielding()
await AxtTest.yield()

XCTAssertNotNil(test.find(id: "toggle_2"))
```

If you expect that it might take longer for the view hierarchy to update, for example because the changes are animated, you can use the `waitFor` functions on Axt elements. These functions are efficient, because they only check for changes when the view hierarchy was changed.

```swift
let test = await AxtTest.host(TogglesView())
let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

await moreToggle.performAction()

XCTAssertNotNil(try await test.waitForElement(id: "toggle_2", timeout: 1))
```

There is also `waitForCondition` to wait for any boolean condition, and `waitForUpdate` that returns as soon as anything in the view hierarchy is changed.

