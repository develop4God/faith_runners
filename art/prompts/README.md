# Art Generation Prompts

Every asset in the game is a JSON file conforming to `schema.json`, split by
`asset_type`:

| Folder | asset_type | What lives here |
| --- | --- | --- |
| `characters/` | `character` | Each hero's static poses: idle, run cycle, ability pose, portrait |
| `scenarios/` | `scenario` | Each map's tilesets (ground/hazard-zone/safe-zone) + parallax background |
| `sprites/` | `sprite` | Standalone looped animations not tied to a character pose: ability VFX (dash trail, stealth shimmer, etc.) and map hazard animations (search party, closing walls, rising water) |
| `ui/` | `ui` | HUD icons, menu background, card frames |

`style_guide.json` holds the shared art direction (style, negative prompt,
consistency rules) referenced by every asset's `style_guide_ref` field —
validated on the first generated batch (David + Flight to Egypt's ground
tile), see the FaithRunners Vision & Game Design doc.

## Generating an asset

Prepend `style_guide.json`'s `art_style` and `negative_prompt` to each
`variants[].prompt` before sending it to your image tool. One file's
variants can be generated independently — no need to batch a whole
category at once.

## Adding a new asset

Copy the closest existing file, keep `asset_type` correct, and validate
against `schema.json` before generating (any JSON Schema validator works,
e.g. `python -c "import json,jsonschema; jsonschema.validate(json.load(open('characters/new_hero.json')), json.load(open('schema.json')))"`).
