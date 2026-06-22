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
    // MARK: - Multiplayer handoff: broadcast score / game-over via match session here
    var onScoreChanged: ((Int) -> Void)?

    private var octopus: OctopusNode!
    private var goalNode: GoalPortalNode!

    private var score    = 0
    private var goalBusy = false  // blocks re-trigger during respawn animation

    private let maxSpeed:     CGFloat = 300
    private let gravityScale: CGFloat = 15

    private var hh: CGFloat { size.height / 2 }
    private var hw: CGFloat { size.width  / 2 }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        anchorPoint     = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = SKColor(red: 0.05, green: 0.08, blue: 0.18, alpha: 1)
        physicsWorld.gravity         = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        MazeBuilder.build(in: self, wallCategory: Physics.wall, octopusCategory: Physics.octopus)
        spawnGoal()
        spawnOctopus()
    }

    // MARK: - Spawn helpers

    private func spawnGoal() {
        goalNode          = GoalPortalNode()
        goalNode.position = CGPoint(x: 0, y: -(hh * 0.806))
        goalNode.name     = "goal"

        let body = SKPhysicsBody(circleOfRadius: 30)
        body.isDynamic           = false
        body.categoryBitMask     = Physics.goal
        body.contactTestBitMask  = Physics.octopus
        body.collisionBitMask    = 0  // sensor
        goalNode.physicsBody     = body
        addChild(goalNode)
    }

    private func spawnOctopus() {
        octopus          = OctopusNode()
        octopus.position = CGPoint(x: 0, y: hh * 0.806)

        let body = SKPhysicsBody(circleOfRadius: octopus.radius)
        body.linearDamping       = 0.4
        body.angularDamping      = 0.8
        body.restitution         = 0.1
        body.allowsRotation      = false
        body.categoryBitMask     = Physics.octopus
        body.contactTestBitMask  = Physics.goal
        body.collisionBitMask    = Physics.wall
        octopus.physicsBody      = body
        addChild(octopus)
    }

    // MARK: - Score & goal respawn

    private func collectGoal() {
        score += 1
        // MARK: - Multiplayer handoff: broadcast updated score to all players here
        onScoreChanged?(score)
    }

    private func respawnGoal() {
        let oldPos = goalNode.position
        let newPos = randomSafePosition()

        goalNode.physicsBody?.categoryBitMask = 0   // disable sensor during animation

        spawnPickupRipple(at: oldPos)

        goalNode.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 0.01, duration: 0.15),
                SKAction.fadeOut(withDuration: 0.15)
            ]),
            SKAction.run { [weak self] in self?.goalNode.position = newPos },
            SKAction.group([
                SKAction.scale(to: 1.0, duration: 0.22),
                SKAction.fadeIn(withDuration: 0.22)
            ]),
            SKAction.run { [weak self] in
                self?.goalNode.physicsBody?.categoryBitMask = Physics.goal
                self?.goalBusy = false
            }
        ]))
    }

    private func spawnPickupRipple(at pos: CGPoint) {
        let ring = SKShapeNode(circleOfRadius: 28)
        ring.position    = pos
        ring.strokeColor = SKColor(red: 0.0, green: 0.78, blue: 0.74, alpha: 0.9)
        ring.lineWidth   = 3
        ring.fillColor   = .clear
        ring.zPosition   = 5
        addChild(ring)
        ring.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 3.5, duration: 0.4),
                SKAction.fadeOut(withDuration: 0.4)
            ]),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: - Random safe position

    private func randomSafePosition() -> CGPoint {
        let bt:    CGFloat = 14
        let margin: CGFloat = 40
        let wHalf:  CGFloat = 10 + 40   // inner-wall half-height + margin

        let left  = -hw + bt + margin
        let right =  hw - bt - margin

        let ya =  hh * 0.569
        let yb =  hh * 0.190
        let yc = -hh * 0.190
        let yd = -hh * 0.569

        let bands: [(lo: CGFloat, hi: CGFloat)] = [
            (ya + wHalf,        hh - bt - margin),   // above Wall E
            (yb + wHalf,        ya - wHalf),          // between E and F
            (yc + wHalf,        yb - wHalf),          // between F and G
            (yd + wHalf,        yc - wHalf),          // between G and H
            (-hh + bt + margin, yd - wHalf),          // below Wall H
        ]

        let valid = bands.filter { $0.hi - $0.lo > 20 }
        guard !valid.isEmpty, left < right else { return .zero }

        let band = valid.randomElement()!
        return CGPoint(
            x: CGFloat.random(in: left...right),
            y: CGFloat.random(in: band.lo...band.hi)
        )
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
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
        guard mask == Physics.octopus | Physics.goal, !goalBusy else { return }
        goalBusy = true
        collectGoal()
        respawnGoal()
    }
}
