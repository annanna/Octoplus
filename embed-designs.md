# Embedding Design Assets

## Step 1 — Import into Xcode

1. In the Project navigator, open **GameJamMarblePrototype iOS → Assets.xcassets**
2. Drag all PNG files from the designer delivery into the asset catalog
3. Xcode will auto-group `@2x` / `@3x` variants if the filenames match exactly  
   (`background@2x.png` → Image Set "background")
4. Verify each Image Set shows slots filled at 2× and 3× (1× can stay empty)

---

## Step 2 — Background

**File:** `GameJamMarblePrototype Shared/GameScene.swift:32`

Replace:
```swift
backgroundColor = SKColor(red: 0.05, green: 0.08, blue: 0.18, alpha: 1)
```

With:
```swift
let bg = SKSpriteNode(imageNamed: "background")
bg.size = size
bg.position = CGPoint(x: 0, y: 0)
bg.zPosition = -1
addChild(bg)
```

---

## Step 3 — Maze walls

**File:** `GameJamMarblePrototype Shared/MazeBuilder.swift:36`

Replace:
```swift
let wall = SKSpriteNode(color: SKColor(white: 0.55, alpha: 1), size: def.size)
```

With:
```swift
let wall = SKSpriteNode(texture: SKTexture(imageNamed: "wall"), size: def.size)
```

> If the designer delivered a 9-slice texture (with defined end caps), add this line directly after:
> ```swift
> wall.centerRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
> ```
> Adjust the inset fractions to match where the non-stretchable end caps end.

---

## Step 4 — Octopus

**File:** `GameJamMarblePrototype Shared/OctopusNode.swift:23`

Replace the entire `buildAppearance()` method:

```swift
private func buildAppearance() {
    let visual = SKNode()
    visual.name = "visual"
    addChild(visual)

    let sprite = SKSpriteNode(imageNamed: "octopus")
    sprite.size = CGSize(width: 80, height: 80)
    visual.addChild(sprite)
}
```

The `visual` node is kept so the **bob and squash idle animations** in `startIdleAnimation()` continue to work without any changes. The physics body uses `radius = 22` set in `GameScene.swift:62` — that is unchanged.

---

## Step 5 — Goal portal

**File:** `GameJamMarblePrototype Shared/GoalPortalNode.swift:20`

Replace the entire `buildAppearance(radius:)` method:

```swift
private func buildAppearance(radius: CGFloat) {
    let sprite = SKSpriteNode(imageNamed: "bubble")
    sprite.size = CGSize(width: radius * 2, height: radius * 2)
    addChild(sprite)

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
}
```

The existing pulse animation is preserved. The "EXIT" label and rotation are removed — add them back if the designer didn't include them in the bubble art.

---

## Checklist

- [ ] All 4 Image Sets visible in Assets.xcassets with 2× and 3× filled
- [ ] Build succeeds (no missing asset warnings in the console)
- [ ] Background fills scene edge-to-edge on device
- [ ] Walls render without visible seams or stretching artifacts
- [ ] Octopus bob/squash animation plays correctly
- [ ] Goal portal pulse animation plays correctly
- [ ] Physics still works (octopus collides with walls, win condition triggers)
