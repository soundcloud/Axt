import SwiftUI

struct GestureView: View {
    @State private var dragY: CGFloat = 0

    var body: some View {
        knob
            .axt("knob")
            .frame(width: 50, height: 50)
            .offset(x: 0, y: dragY)
            .gesture(gesture)
            .axt(insert: "drag", value: dragY, setValue: { dragY = $0 as? CGFloat ?? 0 })
    }

    @ViewBuilder private var knob: some View {
        if abs(dragY) > 300 {
            Circle()
                .axt(value: "circle")
        }
        else {
            Rectangle()
                .axt(value: "rectangle")
        }
    }

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragY = value.translation.height
            }
            .onEnded { value in
                withAnimation(.spring()) {
                    dragY = 0
                }
            }
    }
}
