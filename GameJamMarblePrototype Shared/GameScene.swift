//
//  GameScene.swift
//  GameJamMarblePrototype Shared
//
//  Created by Anna Münster  on 09.06.26.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Physics bit masks
    private enum Physics {
        static let octopus: UInt32 = 1 << 0
        static let wall:    UInt32 = 1 << 1
        static let goal:    UInt32 = 1 << 2
    }

    // Injected by ContentView before presentation
    var motionManager: MotionManager?
    // MARK: - Multiplayer handoff: replace onWin with a match session broadcast
    var onWin: (() -> Void)?

    private var octopus: OctopusNode!
    private var hasWon = false
    private let maxSpeed: CGFloat = 300
    private let gravityScale: CGFloat = 15

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // origin at center — explicit override for safety
        backgroundColor = SKColor(red: 0.05, green: 0.08, blue: 0.18, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        MazeBuilder.build(in: self, wallCategory: Physics.wall, octopusCategory: Physics.octopus)
        spawnGoal()
        spawnOctopus()
        addSmallLabel("START", at: CGPoint(x: 0, y:  hh * 0.806 + 28))
    }

    // Half-height shorthand — valid after size is set by resizeFill
    private var hh: CGFloat { size.height / 2 }

    // MARK: - Spawn helpers

    private func spawnGoal() {
        let goal = GoalPortalNode()
        goal.position = CGPoint(x: 0, y: -(hh * 0.806))

        let body = SKPhysicsBody(circleOfRadius: 30)
        body.isDynamic = false
        body.categoryBitMask = Physics.goal
        body.contactTestBitMask = Physics.octopus
        body.collisionBitMask = 0  // sensor
        goal.physicsBody = body
        addChild(goal)
    }

    private func spawnOctopus() {
        octopus = OctopusNode()
        octopus.position = CGPoint(x: 0, y: hh * 0.806)

        let body = SKPhysicsBody(circleOfRadius: octopus.radius)
        body.linearDamping = 0.4
        body.angularDamping = 0.8
        body.restitution = 0.1
        body.allowsRotation = false
        body.categoryBitMask = Physics.octopus
        body.contactTestBitMask = Physics.goal
        body.collisionBitMask = Physics.wall
        octopus.physicsBody = body
        addChild(octopus)
    }

    private func addSmallLabel(_ text: String, at point: CGPoint) {
        let label = SKLabelNode(text: text)
        label.fontName = "Helvetica-Bold"
        label.fontSize = 11
        label.fontColor = SKColor(white: 1, alpha: 0.45)
        label.position = point
        addChild(label)
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
        guard !hasWon else { return }

        let tilt = motionManager?.tiltForFrame() ?? CGVector(dx: 0, dy: 0)
        physicsWorld.gravity = CGVector(dx: tilt.dx * gravityScale, dy: tilt.dy * gravityScale)

        guard let vel = octopus?.physicsBody?.velocity else { return }
        let speed = hypot(vel.dx, vel.dy)
        if speed > maxSpeed {
            let factor = maxSpeed / speed
            octopus.physicsBody?.velocity = CGVector(dx: vel.dx * factor, dy: vel.dy * factor)
        }
    }

    // MARK: - Physics contact

    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        guard mask == Physics.octopus | Physics.goal, !hasWon else { return }
        hasWon = true
        octopus.physicsBody?.isDynamic = false
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        // MARK: - Multiplayer handoff: broadcast win event to match participants here
        onWin?()
    }
}
