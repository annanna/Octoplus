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
        let visual = SKSpriteNode(imageNamed: "toni")
        visual.name = "visual"
        visual.size = CGSize(width: 100, height: 100)
        addChild(visual)
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
