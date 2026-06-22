# Design Handoff — Marble Game Assets

## Canvas

The game scene is **390 × 844 pt** (iPhone 16 / SE3 safe area), origin at center.  
Deliver all assets as **PNG with transparency** unless noted. Include **@2x and @3x** scale variants.

---

## Assets required

### 1. Background

| Property | Value |
|---|---|
| File name | `background` |
| Format | PNG (or JPEG if no transparency needed) |
| Size @1x | 390 × 844 px |
| Size @2x | 780 × 1688 px |
| Size @3x | 1170 × 2532 px |

Full-bleed scene background. No transparency required.

---

### 2. Maze walls

| Property | Value |
|---|---|
| File name | `wall` |
| Format | PNG with transparency |
| Size @1x | 20 × 20 px (tileable square) |
| Size @2x | 40 × 40 px |
| Size @3x | 60 × 60 px |

The engine tiles and stretches this texture to fit walls of different sizes:

| Wall | Size (pt) |
|---|---|
| Top / bottom border | 390 × 14 |
| Left / right border | 14 × 830 |
| Internal horizontal walls | 262 × 20 |

Design a seamless tileable texture — it will be stretched along the long axis.  
If you want distinct end caps, let me know and I'll implement 9-slice.

---

### 3. Octopus (player character)

| Property | Value |
|---|---|
| File name | `octopus` |
| Format | PNG with transparency |
| Canvas size @1x | 80 × 80 px |
| Canvas size @2x | 160 × 160 px |
| Canvas size @3x | 240 × 240 px |

The character is a **circle of radius 22 pt** with **6 tentacles** drooping from the bottom half, extending ~14 pt beyond the body edge. Center the art in the canvas with ~4 pt padding on all sides.

The physics collision shape is a fixed circle (radius 22 pt) regardless of art — tentacles can visually extend beyond it.

---

### 4. Goal portal (bubble)

| Property | Value |
|---|---|
| File name | `bubble` |
| Format | PNG with transparency |
| Canvas size @1x | 72 × 72 px |
| Canvas size @2x | 144 × 144 px |
| Canvas size @3x | 216 × 216 px |

A circular portal / bubble the octopus falls into to win. Radius 30 pt, so 60 × 60 pt visible art with 6 pt padding.  
The engine applies a **looping scale pulse** (scale 1.0 → 1.12 → 1.0 over ~1.8 s) on top of the sprite, so avoid designing a tight border that would look clipped at max scale.

---

## File naming summary

| Asset | File name | Notes |
|---|---|---|
| Background | `background@2x.png`, `background@3x.png` | No `@1x` needed |
| Wall tile | `wall@2x.png`, `wall@3x.png` | Tileable/stretchable |
| Octopus | `octopus@2x.png`, `octopus@3x.png` | Transparent, centered |
| Goal bubble | `bubble@2x.png`, `bubble@3x.png` | Transparent, centered |

Deliver files loose (not inside an `.xcassets` bundle) — I'll import them into Xcode.

---

## Color reference (current placeholder palette)

| Element | Color |
|---|---|
| Background | `#0D1530` (dark navy) |
| Walls | `#8C8C8C` (mid grey) |
| Octopus body | `#8519D1` (purple) |
| Goal portal | `#00C7BD` (teal) |
