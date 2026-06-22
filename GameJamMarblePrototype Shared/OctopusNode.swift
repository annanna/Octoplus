//
//  OctopusNode.swift
//  GameJamMarblePrototype Shared
//
//  Created by Anna Münster  on 09.06.26.
//

import SpriteKit

final class OctopusNode: SKNode {
    let radius: CGFloat = 22

    override init() {
        super.init()
        buildAppearance()
        startIdleAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func buildAppearance() {
        // Visual container keeps animations separate from the physics-driven parent transform
        let visual = SKNode()
        visual.name = "visual"
        addChild(visual)

        // Body
        let body = SKShapeNode(circleOfRadius: radius)
        body.fillColor = SKColor(red: 0.52, green: 0.10, blue: 0.82, alpha: 1)
        body.strokeColor = SKColor(red: 0.30, green: 0.04, blue: 0.55, alpha: 1)
        body.lineWidth = 2
        visual.addChild(body)

        // Eyes
        for xOffset: CGFloat in [-8, 8] {
            let eye = SKShapeNode(circleOfRadius: 5)
            eye.position = CGPoint(x: xOffset, y: 6)
            eye.fillColor = .white
            eye.strokeColor = .clear
            visual.addChild(eye)

            let pupil = SKShapeNode(circleOfRadius: 2.5)
            pupil.position = CGPoint(x: xOffset + 1, y: 5)
            pupil.fillColor = .black
            pupil.strokeColor = .clear
            visual.addChild(pupil)
        }

        // Six tentacles spread across the bottom half (210° – 330°)
        for i in 0 ..< 6 {
            let angle = CGFloat(210 + i * 24) * .pi / 180
            visual.addChild(makeTentacle(angle: angle))
        }
    }

    private func makeTentacle(angle: CGFloat) -> SKShapeNode {
        let start = CGPoint(x: cos(angle) * (radius - 2),  y: sin(angle) * (radius - 2))
        let end   = CGPoint(x: cos(angle) * (radius + 14), y: sin(angle) * (radius + 14) - 5)
        let ctrl  = CGPoint(
            x: (start.x + end.x) / 2 + cos(angle + .pi / 2) * 7,
            y: (start.y + end.y) / 2 + sin(angle + .pi / 2) * 7
        )

        let path = CGMutablePath()
        path.move(to: start)
        path.addQuadCurve(to: end, control: ctrl)

        let shape = SKShapeNode(path: path)
        shape.strokeColor = SKColor(red: 0.40, green: 0.05, blue: 0.65, alpha: 1)
        shape.lineWidth = 3
        shape.lineCap = .round
        return shape
    }

    private func startIdleAnimation() {
        guard let visual = childNode(withName: "visual") else { return }

        let bob = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 3, duration: 0.7),
            SKAction.moveBy(x: 0, y: -3, duration: 0.7)
        ])
        visual.run(SKAction.repeatForever(bob), withKey: "bob")

        let squash = SKAction.sequence([
            SKAction.scaleX(to: 1.08, y: 0.93, duration: 0.5),
            SKAction.scaleX(to: 0.93, y: 1.08, duration: 0.5),
            SKAction.scaleX(to: 1.00, y: 1.00, duration: 0.25)
        ])
        visual.run(SKAction.repeatForever(squash), withKey: "squash")
    }
}
