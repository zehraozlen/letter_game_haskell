# 🎮 Letter Strategy Game (Haskell)

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=26&pause=1000&color=4CAF50&center=true&vCenter=true&width=600&lines=Welcome+to+Letter+Strategy+Game!;Built+with+pure+Haskell+🌀" />
</p>

---

## 🧩 Overview
**Letter Strategy Game** is a turn-based board game written entirely in **Haskell**.  
Players take turns moving characters (`A`, `B`, `C`, `Z`) on a 3x5 grid.  
Each character follows specific rules — players must think strategically to **block**, **advance**, and **win**.

---

## 🕹️ How to Play

- The player chooses:
- The maximum number of total moves
- Who starts first: `"firsts"` (A/B/C) or `"last"` (Z)

### ▶️ Moves
- `A`, `B`, `C` can move **one step** in any direction **forward or sideways** (but not backward).
- `Z` can move **one step** in any direction.
- You input moves as:  
A 6

where `A` is the character and `6` is the cell index (0–14).

---

## 🏆 Winning Conditions
- **A/B/C win** if `Z` has no valid moves left.  
- **Z wins** if it moves past all A/B/C letters (to their right).  
- If all moves are used: the game ends in a **draw**.

---

## ⚙️ How to Run

### Using GHC:

ghc LetterGame.hs -o lettergame
./lettergame
