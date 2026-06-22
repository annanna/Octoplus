//
//  GoalPortalNode.swift
//  GameJamMarblePrototype Shared
//
//  Created by Anna Münster  on 09.06.26.
//

import SpriteKit

final class GoalPortalNode: SKNode {
    init(radius: CGFloat = 30) {
        super.init()
        buildAppearance(radius: radius)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func buildAppearance(radius: CGFloat) {
        let teal = SKColor(red: 0.0, green: 0.78, blue: 0.74, alpha: 1)

        let outer = SKShapeNode(circleOfRadius: radius)
        outer.strokeColor = teal
        outer.lineWidth = 4
        outer.fillColor = SKColor(red: 0.0, green: 0.78, blue: 0.74, alpha: 0.15)
        outer.glowWidth = 10
        addChild(outer)

        let inner = SKShapeNode(circleOfRadius: radius * 0.55)
        inner.strokeColor = .white
        inner.lineWidth = 2
        inner.fillColor = SKColor(white: 1, alpha: 0.06)
        addChild(inner)

        let pulse = SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 1.12, duration: 0.9),
                SKAction.fadeAlpha(to: 0.7, duration: 0.9)
            ]),
            SKAction.group([
                SKAction.scale(to: 1.0, duration: 0.9),
                SKAction.fadeAlpha(to: 1.0, duration: 0.9)
            ])
        ])
        run(SKAction.repeatForever(pulse))

        outer.run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 5)
        ))
    }
}
