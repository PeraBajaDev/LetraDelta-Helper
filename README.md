# LetraDelta Helper

> A desktop tool for translating Deltarune dialogue files.

<!-- Add a screenshot here -->

---

## Features

- **Tag validation** — detects missing, extra, or out-of-order Deltarune script tags (`\E`, `\F`, `\c`, `~`, `%`, `/`, and more)
- **Live preview** — renders the translated text as it would appear in-game, with control codes stripped
- **Spell checker** — Hunspell-powered spell checking with right-click suggestions
- **Reference table** — load a CSV with per-dialogue notes and EN/JP reference translations
- **Progress tracking** — each entry and dialogue shows its translation state at a glance
- **Replace similar entries** — a checkbox that, when enabled, propagates your translation automatically to all entries sharing the same original text
- **Author tracking** — records who last edited each dialogue
- **Crash recovery** — auto-saves a temporary file and automatically detects abruptly closed sessions on next launch
- **Deltarune export** — produces a flat `key → translation` JSON file ready to be used by the game
- **Unsaved changes protection** — prompts before discarding unsaved work

---

## Installation

1. Go to the [Releases](../../releases) page and download the zip for your platform (Windows or Linux).
2. Extract the zip anywhere you like.
3. Run the executable inside — no installation required.

---

## Usage

1. **Open a file** — `File > Open` (`Ctrl+O`) to load a LetraDelta Helper JSON file.
2. **Select an entry** — pick a dialogue entry from the left panel.
3. **Select a dialogue** — pick an individual line within that entry.
4. **Translate** — the original text is shown for reference; type your translation in the edit field.
5. **Save** — `File > Save` (`Ctrl+S`) or `File > Save As` (`Ctrl+Shift+S`).
6. **Export** — `File > Export` (`Ctrl+E`) produces a flat JSON file ready to be used by the game.

> **Reference table:** load a CSV with translation notes via `File > Open Reference` or directly from the reference table panel. The CSV must have four columns in this order: `Key`, `Notes`, `EN to target`, `JP to target`.

---

## File Format

LetraDelta Helper works with a specific JSON structure:

```json
{
  "Style": "Deltarune",
  "Dialogues": {
    "ENTRY_ID": [
      {
        "Key": "unique_dialogue_key",
        "Content": "Translated text",
        "OriginalContent": "Original text",
        "LastEdited": "username",
        "NeedsReview": false
      }
    ]
  }
}
```

| Field | Description |
|---|---|
| `Style` | Parser style to use (currently `"Deltarune"`) |
| `Dialogues` | Map of entry IDs to arrays of dialogue objects |
| `Key` | Unique identifier for this dialogue line |
| `Content` | The translated text (empty until translated) |
| `OriginalContent` | The original source text, used as reference |
| `LastEdited` | Username of the last editor (auto-filled) |
| `NeedsReview` | Flags the line for review without blocking progress |

### Export format

`File > Export` produces a flat JSON with only the keys and their translations, ready to be loaded by the game:

```json
{
  "unique_dialogue_key": "Translated text"
}
```

If a line has no translation yet, the export falls back to the original content.

---

## Contributing

Contributions are welcome! The main areas where help is most useful:

- **UI improvements** — layout, usability, new features
- **Interface translations** — add a new language column to `Localization.csv`

### Adding a UI language

> Requires **Godot 4.7**.

1. Open `Localization.csv` and add a new column for your locale code (e.g. `fr`).
2. Fill in the translations for each key.
3. In the Godot editor, reimport `Localization.csv` to regenerate the `.translation` files.
4. Register the new `.translation` file in `Project > Project Settings > Localization`.

### Submitting a PR

> Requires **Godot 4.7** to run the project from the editor.

1. Fork the repository and create a branch for your change.
2. Format all GDScript files with [GDScript-formatter](https://github.com/GDQuest/GDScript-formatter) with the `--reorder-code` option enabled. PRs that skip this step will not be accepted.
3. Open a pull request against `main` with a clear description of what it does.
4. Keep PRs focused — one feature or fix per PR.
5. For larger changes, open an Issue first to align before implementing.

### Bug reports

Open a [GitHub Issue](../../issues) and include:
- Steps to reproduce
- Your OS (Windows / Linux)
- The JSON file if relevant (you can anonymize it)

---

## License

MIT — see [LICENSE](LICENSE) for details.
