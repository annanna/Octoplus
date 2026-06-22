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
        let sprite = SKSpriteNode(imageNamed: "schnecke")
        sprite.size = CGSize(width: radius * 4, height: radius * 4)
        addChild(sprite)

        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.12, duration: 0.9),
            SKAction.scale(to: 1.0,  duration: 0.9)
        ])
        run(SKAction.repeatForever(pulse))
    }
}
