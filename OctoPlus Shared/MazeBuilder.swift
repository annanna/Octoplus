//
//  MazeBuilder.swift
//  GameJamMarblePrototype Shared
//
//  Created by Anna Münster  on 09.06.26.
//

import SpriteKit

enum MazeBuilder {
    // MARK: - Multiplayer handoff: replace static layout with server-provided maze data here
    // MARK: - Asset swap: replace SKSpriteNode(color:size:) with SKSpriteNode(imageNamed:) here

    static func build(in scene: SKScene, wallCategory: UInt32, octopusCategory: UInt32) {
        let w  = scene.size.width
        let h  = scene.size.height
        let hw = w / 2
        let hh = h / 2
        let bt: CGFloat = 14   // border thickness
        let wh: CGFloat = 20   // inner wall height

        // Gap the octopus (diameter ~44 pt) can pass through with comfortable margin.
        // 0.276 preserves the original ~100 pt gap on a 362 pt inner width.
        let innerW = w - 2 * bt
        let gap    = max(90, innerW * 0.276)
        let wallW  = innerW - gap

        // X centre of a wall whose gap is on the LEFT (wall hugs the right border)
        let cxGapLeft  =  hw - bt - wallW / 2
        // X centre of a wall whose gap is on the RIGHT (wall hugs the left border)
        let cxGapRight = -hw + bt + wallW / 2

        // Y positions as fractions of half-height (derived from original 390×844 design)
        let ya =  hh * 0.569   // ≈ y =  240 on 844 h
        let yb =  hh * 0.190   // ≈ y =   80 on 844 h
        let yc = -hh * 0.190
        let yd = -hh * 0.569

        let defs: [(pos: CGPoint, sz: CGSize)] = [
            // Outer borders — edges snap exactly to scene bounds
            (CGPoint(x:  0,            y:  hh - bt / 2), CGSize(width: w,  height: bt)),
            (CGPoint(x:  0,            y: -(hh - bt / 2)), CGSize(width: w, height: bt)),
            (CGPoint(x: -(hw - bt/2),  y:  0),            CGSize(width: bt, height: h)),
            (CGPoint(x:  (hw - bt/2),  y:  0),            CGSize(width: bt, height: h)),
            // S-path inner walls (alternating gap side forces a winding path)
            (CGPoint(x: cxGapLeft,  y: ya), CGSize(width: wallW, height: wh)), // gap left
            (CGPoint(x: cxGapRight, y: yb), CGSize(width: wallW, height: wh)), // gap right
            (CGPoint(x: cxGapLeft,  y: yc), CGSize(width: wallW, height: wh)), // gap left
            (CGPoint(x: cxGapRight, y: yd), CGSize(width: wallW, height: wh)), // gap right
        ]

        for (idx, def) in defs.enumerated() {
            let isOuterBorder = idx < 4
            let wall = SKSpriteNode(color: isOuterBorder ? .clear : SKColor(white: 1, alpha: 1), size: def.sz)
            wall.position = def.pos
            let body = SKPhysicsBody(rectangleOf: def.sz)
            body.isDynamic = false
            body.friction = 0.3
            body.restitution = 0.05
            body.categoryBitMask = wallCategory
            body.collisionBitMask = octopusCategory
            body.contactTestBitMask = 0
            wall.physicsBody = body
            scene.addChild(wall)
        }
    }
}
