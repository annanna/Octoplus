# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Open `GameJamMarblePrototype.xcodeproj` in Xcode 26.3+ and run the **GameJamMarblePrototype iOS** scheme on a simulator or device.

There is no CLI build command — use `xcodebuild` only if needed:
```
xcodebuild -project GameJamMarblePrototype.xcodeproj -scheme "GameJamMarblePrototype iOS" -destination "generic/platform=iOS Simulator" build
```

No external dependencies; no package manager.

## Architecture

**Entry point:** `GameJamMarblePrototype iOS/MarbleApp.swift` (`@main` SwiftUI app) → injects `AppState` env → `RootView` → switches on `AppState.appPhase`.

**Two source folders:**
- `GameJamMarblePrototype iOS/` — SwiftUI shell and all app-navigation logic. Compiled automatically via folder reference.
- `GameJamMarblePrototype Shared/` — All game logic: `GameScene`, `OctopusNode`, `GoalPortalNode`, `MazeBuilder`, `MotionManager`. These must be explicitly listed in the iOS target's `membershipExceptions` in `project.pbxproj`.

**Known Xcode issue:** Xcode may regenerate `project.pbxproj` and silently drop `GoalPortalNode.swift` and `MazeBuilder.swift` from the iOS target. If the build fails with "cannot find type in scope" for those types, fix it in Xcode: select each file → File Inspector → enable **GameJamMarblePrototype iOS** target membership.

**Global actor:** `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` is set project-wide. All types are implicitly `@MainActor`. SpriteKit runs on the main thread so this is intentional.

## App Navigation

The app is a mini-game collection. Navigation is driven by a two-level state machine, both `@Observable`:

**`AppState` (top level) — `AppPhase` enum:**
- `.onboarding` → `OnboardingView` (3-slide pager, shown on every launch for now)
- `.gameList` → `GameListView` (scrollable game cards)
- `.gameFlow(GameDefinition)` → `GameFlowView` (per-game 5-phase flow)

**`AppState.gameFlowPhase` — `GameFlowPhase` enum:**
- `.instructions` → `GameInstructionsView` (slides from `GameDefinition.instructionSlides`)
- `.playing` → the game view (built by `GameDefinition.makeView`)
- `.results(GameResult)` → `GameResultsView`
- `.rating(GameResult)` → `DifficultyRatingView` ("Wie schwer war das?")
- `.tips(GameResult)` → `GameTipsView`

## Adding a New Game

1. Create `YourGameView.swift` with `struct YourGameView: View` — accept `onComplete: (GameResult) -> Void` and call it when the game ends.
2. Create `YourGameDefinition.swift` — a top-level `let yourGame = GameDefinition(...)` with `id`, `title`, `subtitle`, `accentColor`, `instructionSlides`, `tips`, and `makeView`.
3. Add `yourGame` to the `allGames` array in `GameListView.swift`.

## Maze Game Flow

`MazeGameView` is the only real game currently. It runs a 30-second timer; when it expires, `onComplete(GameResult(...))` is called and the flow advances to results. The reset button (↺) respawns the scene but keeps the timer running.

`MazeGameDefinition.swift` contains the `GameDefinition` for the maze game, including German instruction slides and tips.

## Game Loop

Each frame in `GameScene.update(_:)`:
1. Read device tilt from `MotionManager.tiltForFrame()` (CoreMotion on device; `simulatedTilt` on simulator).
2. Apply tilt as `physicsWorld.gravity` (scaled ±15).
3. Clamp octopus velocity to 300 pt/s.

**Physics bit masks:** octopus `1 << 0`, wall `1 << 1`, goal `1 << 2`. Octopus collides with walls; goal is a sensor (contact only, no collision response).

**Score:** `GameScene.onScoreChanged` callback fires each time the octopus reaches the goal portal. `MazeGameView` writes this into its `MazeGameModel`.

## Maze

`MazeBuilder` generates a static S-shaped path: 4 outer border walls + 4 interior horizontal walls with alternating left/right gaps. Wall Y positions are fractional (e.g. `0.569 * size.height`) so they scale to any device height. Scene nominal size: 390×844 pt. Octopus starts at `(0, 340)`, goal at `(0, -340)`.

## Simulator Input

`SimulatorDPadView` (compiled only under `#if targetEnvironment(simulator)`) renders an arrow-key D-pad that writes into `MotionManager.simulatedTilt`. This is how tilt is tested without a physical device.

## Multiplayer Handoff Points

All four integration seams are marked `// MARK: - Multiplayer handoff:` in:
- `MotionManager.tiltForFrame()` — swap local accelerometer for network-received orientation
- `GameScene.didBegin(_:)` — broadcast score changes
- `MazeBuilder.defs` — replace static layout with server-provided maze data
- `MazeGameView.buildScene()` — inject shared game state

## Asset Placeholders

All visuals are procedurally drawn in code (no image assets required). Designer asset slots are documented in `design-handoff.md`; integration instructions are in `embed-designs.md`. The five swap points are:
- Background sprite: `GameScene.swift` around line 32
- Wall texture: `MazeBuilder.swift` around line 36
- Octopus sprite: `OctopusNode.swift` around line 23
- Goal portal sprite: `GoalPortalNode.swift` around line 20
- Onboarding octopus: `OnboardingView.swift` — replace `Image(systemName:)` with asset image; character is named "Toni Tinte"
