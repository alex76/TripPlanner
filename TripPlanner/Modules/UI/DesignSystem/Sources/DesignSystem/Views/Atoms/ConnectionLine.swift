import SwiftUI

public struct ConnectionLine<Background: ShapeStyle>: View {
    public enum Position {
        case start
        case middleGap
        case middle
        case end
    }

    private let position: Position
    private let lineWidth: Double
    private let background: Background

    public init(
        position: ConnectionLine<Background>.Position,
        lineWidth: Double,
        background: Background
    ) {
        self.position = position
        self.lineWidth = lineWidth
        self.background = background
    }

    public var body: some View {
        switch position {
        case .start:
            StartShape(lineWidth: lineWidth)
                .fill(background)
        case .end:
            EndShape(lineWidth: lineWidth)
                .fill(background)
        case .middle:
            MiddleShape(lineWidth: lineWidth, gap: false)
                .fill(background)
        case .middleGap:
            MiddleShape(lineWidth: lineWidth, gap: true)
                .fill(background)
        }
    }

}

// MARK: - Shapes
extension ConnectionLine {
    private struct StartShape: Shape {
        let lineWidth: Double

        func path(in rect: CGRect) -> Path {
            var dot = Path()
            let radius = rect.height / 6

            dot.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(360),
                clockwise: true
            )

            var line = Path()
            line.move(to: CGPoint(x: rect.midX, y: rect.midY + radius))
            line.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

            var shape = dot.strokedPath(.init(lineWidth: lineWidth, dash: [3, 1], dashPhase: 1))
            shape.addPath(line.strokedPath(.init(lineWidth: lineWidth - 1)))
            return shape
        }
    }

    private struct EndShape: Shape {
        let lineWidth: Double

        func path(in rect: CGRect) -> Path {
            var dot = Path()
            let radius = rect.height / 6

            dot.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(360),
                clockwise: true
            )

            var line = Path()
            line.move(to: CGPoint(x: rect.midX, y: rect.minY))
            line.addLine(to: CGPoint(x: rect.midX, y: rect.midY - radius))

            var shape = dot.strokedPath(.init(lineWidth: lineWidth, dash: [3, 1], dashPhase: 3))
            shape.addPath(line.strokedPath(.init(lineWidth: lineWidth - 1)))
            return shape
        }
    }

    private struct MiddleShape: Shape {
        let lineWidth: Double
        let gap: Bool

        func path(in rect: CGRect) -> Path {
            let part = rect.height / 5
            var line = Path()
            line.move(to: CGPoint(x: rect.midX, y: rect.minY))

            if gap {
                line.addLine(to: CGPoint(x: rect.midX, y: 2 * part))

                line.move(to: CGPoint(x: rect.minX + part, y: 2 * part))
                line.addLine(to: CGPoint(x: rect.maxX - part, y: 2 * part))

                line.move(to: CGPoint(x: rect.minX + part, y: 3 * part))
                line.addLine(to: CGPoint(x: rect.maxX - part, y: 3 * part))

                line.move(to: CGPoint(x: rect.midX, y: 3 * part))
            }

            line.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

            return line.strokedPath(.init(lineWidth: lineWidth - 1))
        }
    }
}

#if DEBUG
    struct ConnectionLine_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ConnectionLine(position: .start, lineWidth: 3, background: Color.gray)
                ConnectionLine(position: .end, lineWidth: 3, background: Color.gray)
                ConnectionLine(position: .middle, lineWidth: 3, background: Color.gray)
                ConnectionLine(position: .middleGap, lineWidth: 3, background: Color.gray)
            }
            .frame(maxWidth: 40, maxHeight: 40)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
