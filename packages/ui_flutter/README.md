# beyondtranslate_ui

The BeyondTranslate design system for Flutter — a port of the React
`@beyondtranslate/ui` atoms in `packages/ui`. Same tokens, same four themes,
same components, under plain generic widget names.

The existing `apps/desktop/flutter/lib/src/widgets/ui` set is untouched; this
package sits beside it.

## Using it

```dart
import 'package:beyondtranslate_ui/beyondtranslate_ui.dart' as ui;

ui.DesignThemeProvider(
  theme: ui.DesignThemeName.studioLight,
  child: ui.Button(
    variant: ui.ButtonVariant.primary,
    onPressed: () {},
    child: const Text('翻译'),
  ),
);
```

Some widget names (`Badge`, `Button`, `Checkbox`, `Dialog`, `Divider`,
`ListTile`, `Radio`, `Step`, `Switch`) are also Material's. This package never
imports Material, so nothing clashes internally — but an app that uses both
should import one of them with a prefix, as above.

## Tokens

`lib/src/theme/tokens.dart` mirrors `packages/ui/src/styles/tokens.css`
field for field. Every field defaults to the **Studio Light** value, which is
how the CSS is written too: `:root` declares the baseline and each
`[data-theme=…]` block overrides only what it changes. A theme is therefore
"the baseline, plus these overrides":

```dart
DesignThemes.studioDark; // brightness, gradients, colours, shadows
DesignThemes.brightLight; // + pill radii
```

Reach for tokens through the context extension:

```dart
context.tokens;   // the whole set
context.colors;   // colours
context.radii;    // corner radii
context.metrics;  // sidebar / titlebar / window sizes
context.typography;
context.shadows;
context.hairlineWidth; // one device pixel
```

Type recipes come off `DesignTypography` and match the CSS classes:
`sansStyle`, `displayStyle`, `cjkStyle`, `monoStyle`, `labelStyle` (`.bt-label`),
`numericStyle` (`.bt-numeric`), `translationStyle` (`.bt-translation`),
`sourceStyle` (`.bt-source`).

## Widget map

| React (`packages/ui`) | Flutter |
| --- | --- |
| `Badge` | `Badge` |
| `Button` | `Button` |
| `Callout` | `Callout` |
| `CheckboxOption` | `Checkbox` |
| `RadioOption` / `RadioGroup` | `Radio` / `RadioList` |
| `Toggle` | `Switch` |
| `SegmentedControl` | `SegmentedControl` |
| `PillTabs` | `Tabs` (+ `TabItem`) |
| `OptionCard` | `OptionCard` |
| `Kbd` | `Kbd` |
| `SectionLabel` | `Label` |
| `EngineAvatar` | `Avatar` (colour + glyph; no engine table) |
| `Surface` / `Divider` | `Surface` / `Divider` |
| `Dialog*` | `Dialog`, `DialogHeader`, `DialogBody`, `DialogFooter` |
| `EmptyState` | `EmptyState` |
| `Field` / `Input` / `Textarea` / `Select` / `FieldValue` | `Field` / `Input` / `TextArea` / `Select` / `FieldValue` |
| `SearchField` | `SearchField` |
| `ProgressBar` / `Meter` / `Spinner` | `ProgressBar` / `Meter` / `Spinner` |
| `Step` / `StepList` | `Step` / `StepList` |
| `Table*` | `DataTable`, `DataTableHead`, `DataTableRow`, `DataTableCell` |
| `EngineListItem` | `ListTile` |
| `HistoryItem` | `ListCard` |
| `TermMark` | `Mark` / `markSpan` |
| `SourceBlock` | `TextBlock` |
| `PreferredTranslation` | `HighlightBlock` |
| `EngineCard` | `TitledCard` |
| `TermCard` | `InfoCard` |
| `DictionaryEntry` | `DetailBlock` |
| `ShortcutRow` | `SettingRow` |
| `StatBlock` / `SegmentGauge` | `Stat` / `SegmentGauge` |
| `SelectionBubble` | `PopoverCard` |
| `MiniWindow` / `MiniPanel` / `PageThumb` | `PopoverWindow` / `PopoverPanel` / `Thumbnail` |
| `LanguagePair` | `SwapPair` |
| `FloatingBall` | `FloatingBall` |
| `BrowserFrame` / `BilingualParagraph` / `FloatingToolbar` / `ToolbarSeparator` | `BrowserFrame` / `AnnotatedParagraph` / `FloatingToolbar` / `ToolbarSeparator` |
| `WindowFrame` and friends | `WindowFrame`, `WindowTitlebar`, `WindowBody`, `WindowMain`, `WindowContent`, `WindowFooter`, `TrafficLights` |
| `Sidebar` and friends | `Sidebar`, `SidebarGroup`, `SidebarCard`, `NavItem`, `Rail`, `RailItem`, `Aside` |
| `Stage` / `ActionBar` | `Stage` / `ActionBar` |
| — | `Pressable`, `HoverRegion`, `FocusRing` (interaction primitives) |

Every widget that carried product vocabulary in React (provider ids, "translation",
"term") takes generic slots here: the product words live at the call site.

## Gallery

`example/` is the Flutter equivalent of the Storybook workspace — every atom
under a theme switcher.

```bash
cd example && flutter run -d macos
```

## Tests

`test/widget_metrics_test.dart` asserts the fixed geometry the deck pins with
Tailwind height utilities — the numbers a font's own line box would otherwise
drift off (control heights, the switch box, the sidebar group's gaps).

`test/golden_test.dart` renders each block on its own at DPR 1 into
`test/goldens/<block>.png`, ~10 KB each, so a regression names the block it
broke and the image is small enough to read. It loads the real faces — SF,
PingFang SC, Apple Symbols and the Fluent icon font — so the images show the
typography, not a wall of placeholder boxes. A host without those faces skips
the suite rather than reporting false diffs, which makes this a macOS-local
guard; the metrics test above is the part that holds everywhere. Refresh after
a deliberate visual change:

```bash
flutter test --update-goldens
```

## Notes on the port

- **Hairlines.** The CSS halves borders to 0.5px on Retina so a separator is
  one device pixel. `context.hairlineWidth` does the same.
- **Line height.** Every recipe sets
  `leadingDistribution: TextLeadingDistribution.even`, which is how CSS
  distributes leading — without it a `leading-none` chip sits taller here than
  on the web.
- **Focus.** `:focus-visible { outline: 3px solid … }` becomes `FocusRing`,
  a 3px stroke just outside the box following its corner radius, shown for
  keyboard focus only.
- **Selection.** `--bt-selection` resolves to the accent while the window is
  key; `WindowFrame(unfocused: true)` swaps in the unemphasized pair by
  re-scoping the tokens, so every row inside picks it up without threading
  state down.
