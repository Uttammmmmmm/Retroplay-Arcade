# RetroPlay Arcade — Figma design spec

## Product
An offline pocket arcade with nostalgic mini-games. Android and iOS, portrait-first, no account or network required for core play.

## Visual direction
Retro-modern pixel arcade: deep indigo background, violet surfaces, electric cyan and warm yellow highlights. Keep gameplay boards high-contrast and controls large.

## Frames
- Main mobile frame: 393 × 852 px
- Validation frames: 360 × 800 and 430 × 932 px
- 8 px spacing system, 20 px page padding, 18 px card radius, 14 px button radius
- Minimum touch target 44 × 44 px
- Use Auto Layout for game cards, chips, score panels, dialogs and bottom navigation

## Color variables
- Background: `#100F24`
- Surface: `#1D1B3A`
- Raised surface: `#29264B`
- Cyan: `#35E0D0`
- Yellow: `#FFD166`
- Purple: `#8B72FF`
- Main text: `#F8F7FF`
- Secondary text: `#B9B6D6`
- Danger: `#FF6B7A`
- Success: `#70E1A1`

## Typography
- Display: Space Grotesk Bold or equivalent
- Body: Inter / platform sans
- Score numbers: bold tabular numerals
- Pixel font only for decorative labels

## Screens
1. Home: header, tagline, search, category filters, game grid, favorites, settings.
2. Game intro: title, rules, difficulty selector, best score, Play button.
3. Game screen: score/status, board, controls, pause/restart.
4. Result overlay: win/loss/draw, score, replay, home.
5. Settings: sound, haptics, theme, reset local data.
6. Favorites: locally saved games.
7. How-to-play sheet: concise rules and gesture hints.

## Game-specific notes
- Snake: dark green 18×18 grid, cyan body, yellow head, coral food; directional D-pad.
- Tic-Tac-Toe: 3×3 board; cyan X, yellow O; animated mark placement and winning line.
- Dots & Boxes: 5×5 dots; 4×4 boxes; animated line reveal and ownership fill.
- Number Merge: 4×4 grid, distinct tile color per value, swipe controls, merge pop animation.
- Memory Match: cards flip with a 3D-like rotation, matched cards glow and fade.
- Minesweeper: covered/revealed/flagged/mine states, reveal animation, safe first move.
- Pong: two paddles and ball, score display, optional one-player CPU.
- Whack-a-Mole: animated mole pop-up, timed round and combo feedback.
- Sliding Puzzle: numbered tiles slide into empty space, move counter and win animation.
- Hangman: letter keyboard, incorrect guess progression, win/loss state.
- Reaction Tap: random wait, color change, reaction time and false-start state.

## Components
GameCard, CategoryChip, ScoreCard, PrimaryButton, IconButton, GameBoardCell, PauseDialog, ResultDialog, GameRulesSheet, BottomNavigation.

## Prototype links
Home → game intro → play → pause/result → replay/home. Search and categories filter the grid. Favorites are saved locally. All gameplay is playable in airplane mode.

## Accessibility
High contrast, 44px minimum controls, no color-only feedback, scalable text, semantics labels, reduce unnecessary motion when platform accessibility settings request it.
