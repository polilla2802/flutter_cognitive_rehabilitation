# Cognitive Rehabilitation — Mobile App

<p align="center">
  <img src="./assets/images/logos/brain.png" width="120"/>
</p>

A Flutter mobile app I built end-to-end as a contractor for **Farahi Law Firm** (a personal injury law firm in California). The idea was to give their clients — many of whom were accident victims dealing with traumatic brain injuries — a tool to practice and gradually improve cognitive skills like focus, memory, reaction time and logic, through short gamified exercises.

I designed and built the whole thing solo over the course of the contract: the game mechanics, the branding, the UI, the backend integration, and the assets pipeline.

---

## What it is

The app revolves around **four mini-games**, each targeting a different combination of cognitive skills, with three difficulty levels (easy / medium / hard). All games track progress over time so the user can see how their performance evolves.

<table>
  <tr>
    <td align="center" width="25%"><img src="./assets/images/logos/GoPop-logo.png" width="160"/></td>
    <td align="center" width="25%"><img src="./assets/images/logos/GoColor-logo.png" width="160"/></td>
    <td align="center" width="25%"><img src="./assets/images/logos/GoMatrix-logo.png" width="160"/></td>
    <td align="center" width="25%"><img src="./assets/images/logos/GoSpeed-logo.png" width="160"/></td>
  </tr>
  <tr>
    <td align="center"><b>GoPop</b><br/><sub>Reflex + Focus</sub></td>
    <td align="center"><b>GoColor</b><br/><sub>Response + Logic</sub></td>
    <td align="center"><b>GoMatrix</b><br/><sub>Memory + Logic</sub></td>
    <td align="center"><b>GoSpeed</b><br/><sub>Speed + Reflex</sub></td>
  </tr>
</table>

## Cognitive skills covered

Each game contributes to a subset of six core skills, and the user's progress is broken down per skill on the stats screen.

<table>
  <tr>
    <td align="center"><img src="./assets/images/icons/skills/focus.png" width="60"/></td>
    <td align="center"><img src="./assets/images/icons/skills/memory.png" width="60"/></td>
    <td align="center"><img src="./assets/images/icons/skills/logic.png" width="60"/></td>
    <td align="center"><img src="./assets/images/icons/skills/reflex.png" width="60"/></td>
    <td align="center"><img src="./assets/images/icons/skills/response.png" width="60"/></td>
    <td align="center"><img src="./assets/images/icons/skills/speed.png" width="60"/></td>
  </tr>
  <tr>
    <td align="center"><b>Focus</b></td>
    <td align="center"><b>Memory</b></td>
    <td align="center"><b>Logic</b></td>
    <td align="center"><b>Reflex</b></td>
    <td align="center"><b>Response</b></td>
    <td align="center"><b>Speed</b></td>
  </tr>
</table>

## The games

Each game has its own visual identity and a per-difficulty how-to-play flow so the user understands the mechanics before starting.

### GoPop — Reflex + Focus

<table>
  <tr>
    <td width="20%"><img src="./assets/images/games/go_pop/how_to_play/easy/htp_pop_1.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_pop/how_to_play/easy/htp_pop_2.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_pop/how_to_play/easy/htp_pop_3.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_pop/how_to_play/easy/htp_pop_4.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_pop/how_to_play/easy/htp_pop_5.jpg"/></td>
  </tr>
</table>

### GoColor — Response + Logic

<table>
  <tr>
    <td align="center"><img src="./assets/images/games/go_color/GoColor-icon.png" width="80"/></td>
  </tr>
</table>

<table>
  <tr>
    <td width="20%"><img src="./assets/images/games/go_color/how_to_play/easy/htp_color_1.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_color/how_to_play/easy/htp_color_2.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_color/how_to_play/easy/htp_color_3.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_color/how_to_play/easy/htp_color_4.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_color/how_to_play/easy/htp_color_5.jpg"/></td>
  </tr>
</table>

### GoSpeed — Speed + Reflex

<table>
  <tr>
    <td align="center"><img src="./assets/images/games/go_speed/GoSpeed-icon.png" width="80"/></td>
  </tr>
</table>

<table>
  <tr>
    <td width="20%"><img src="./assets/images/games/go_speed/how_to_play/easy/htp_speed_1.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_speed/how_to_play/easy/htp_speed_2.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_speed/how_to_play/easy/htp_speed_3.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_speed/how_to_play/easy/htp_speed_4.jpg"/></td>
    <td width="20%"><img src="./assets/images/games/go_speed/how_to_play/easy/htp_speed_5.jpg"/></td>
  </tr>
</table>

### GoMatrix — Memory + Logic

<table>
  <tr>
    <td align="center"><img src="./assets/images/games/go_matrix/how_to_play/easy/htp_matrix_1.jpg" width="280"/></td>
    <td align="center"><img src="./assets/images/games/go_matrix/how_to_play/medium/htp_matrix_1.jpg" width="280"/></td>
    <td align="center"><img src="./assets/images/games/go_matrix/how_to_play/hard/htp_matrix_1.jpg" width="280"/></td>
  </tr>
  <tr>
    <td align="center"><sub>Easy</sub></td>
    <td align="center"><sub>Medium</sub></td>
    <td align="center"><sub>Hard</sub></td>
  </tr>
</table>

## Tech stack

- **Flutter** (SDK 2.18, Dart) — multi-platform (Android + iOS)
- **Flame** game engine + **flame_bloc** + **flame_audio** for the game mechanics
- **Provider** for state management
- **Firebase** — Auth, Firestore for user data and progress tracking
- **Google Sign-In** for authentication
- **fl_chart** and **Syncfusion gauges** for the stats and progress dashboards
- **carousel_slider**, **animated_flip_counter**, **google_fonts** for UI polish
- **video_player** for in-game background videos
- Custom asset pipeline (11 background music tracks, sound effects per event, intro/outro audio, video backgrounds, per-difficulty tutorials)

The project shipped to version 2.2.3 (build 23) before the client paused the launch.

## What I did

This was a one-developer project from scratch, so I owned everything:

- **Designed the four games** from concept to mechanics. I researched cognitive training apps (Lumosity, Peak, Elevate) and adapted the patterns to what made sense for this specific user base. **No medical professionals were involved in the design** — the games are general-purpose cognitive training exercises, not a clinical intervention.

- **Built the game logic with Flame**, including collision detection, scoring, difficulty scaling, and the per-game how-to-play tutorial flow.

- **Branding and visual identity** — logos for all four games (GoPop, GoColor, GoMatrix, GoSpeed), the app icon (brain logo), color palette, typography, and the icons for each cognitive skill.

- **User flow** — sign up with Google, see your stats dashboard, pick a game, see the tutorial for the difficulty level, play, get feedback, see how the run affected your skill metrics.

- **Backend integration** — Firebase Auth for users, Firestore for persisting game results, computing per-skill progress, and showing trends with charts.

- **Audio/video pipeline** — multiple background tracks that rotate, success/fail sound effects with variations to avoid repetition, intro and game-over cinematics, looping video backgrounds during gameplay.

- **Multi-difficulty tutorials** — each game has separate "how to play" screens for easy, medium and hard, because the mechanics change at each level.

## Why it's not on the stores

The app reached a working v2.2.3 with all four games, auth, stats and the full asset set, but the client paused the launch due to a change in their internal priorities. I delivered everything functional — it just never went public. The code stayed under my care so I'm able to keep it here as part of my portfolio.

## What I focused on

- **Game feel.** Cognitive training apps live or die on whether playing them is satisfying. A lot of the work was on micro-feedback: the pop sound when you tap the right tile, the shine animation, the wrong-answer feedback, the smooth difficulty curve so you don't quit on level 1.

- **Skill metrics.** Each game outputs more than just a score — it computes a contribution to specific cognitive skills (focus, memory, etc.), which feed into a progress dashboard so the user can see what they're actually improving over time.

- **Designing for the actual users.** The target audience wasn't gamers — it was adults dealing with cognitive recovery. The UI had to be readable, the tutorials had to be visual (which is why every game has its own per-difficulty image-based tutorial), and the difficulty had to ramp slowly.

- **Solo full-stack ownership.** I was the only developer, so I had to make end-to-end decisions: data model, auth strategy, asset organization, naming conventions, branding. It was a great exercise in taking a vague brief ("a cognitive games app for our clients") and turning it into a shipped product.

## Notes

This was a contracted project for Farahi Law Firm and is here in my GitHub with their knowledge. The codebase is the working build I delivered — the brand assets, game logos and icons are mine (created during the project), and there's no real user data in the repo.
