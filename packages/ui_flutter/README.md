# beyondtranslate_ui

The BeyondTranslate design system for Flutter — a port of the React
`@beyondtranslate/ui` atoms in `packages/ui`. Same tokens, same four themes,
under plain generic widget names.

Primitives only, which is where React draws the line too: no translation,
provider, glossary or language-pair concept reaches this package, and it ships
no sample data. The product's own widgets and tokens live in the app, under
`apps/desktop/flutter/lib/src/`, the way React's live in `apps/storybook/src/`.
The [widget map](#widget-map) below names both halves.

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

Some widget names (`Badge`, `Button`, `Checkbox`, `Dialog`, `Divider`, `Radio`,
`Step`, `Switch`) are also Material's. This package never imports Material, so
nothing clashes internally — but an app that uses both should import one of them
with a prefix, as above.

## Tokens

`lib/src/theme/` mirrors `packages/ui/src/styles/` field for field, and inherits
its split:

| React | Flutter |
| --- | --- |
| `styles/constants.css` — what no theme may touch | the `DesignTokens` defaults for `metrics` and the type scale |
| `styles/themes/*.css` — one file per theme | `DesignThemes.studioLight` and friends in `themes.dart` |

**A theme may change exactly three families: colour, radii and shadows.** The
structural constants — sidebar and titlebar sizes, the 11/12/13/15/17 type
scale, the hairline unit — are the same in all four. Every field defaults to the
**Studio Light** value, which is how the CSS is written too: `studio-light.css`
doubles as the `:root` baseline and each `[data-theme=…]` block overrides only
what it changes. A theme is therefore "the baseline, plus these overrides":

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
context.themeName;     // which palette is active — React's useTheme()
context.hairlineWidth; // one device pixel
```

Type recipes come off `DesignTypography` and match the CSS classes:
`sansStyle`, `displayStyle`, `cjkStyle`, `monoStyle`, `labelStyle`
(`.type-label`), `numericStyle` (`.type-numeric`).

Two unrelated things are called hairline: `context.hairlineWidth` is the
separator's *width*, while its colour comes from `colors.hairline` /
`hairlineStrong` / `hairlineSoft` (plus `accentHairline`, `warnHairline`,
`dangerHairline`).

The CSS calls a few families something else — `--corner-*`, `--elevation-*` and
`--type-*` — only because `--radius-*`, `--shadow-*` and `--text-*` are
Tailwind's own namespaces there. Both names exist on that side; Dart has no such
clash and keeps `radii`, `shadows` and `typography`.

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
| `Surface` / `Divider` | `Surface` / `Divider` |
| `Dialog*` | `Dialog`, `DialogHeader`, `DialogBody`, `DialogFooter` |
| `EmptyState` | `EmptyState` |
| `Field` / `Input` / `Textarea` / `Select` / `FieldValue` | `Field` / `Input` / `TextArea` / `Select` / `FieldValue` |
| `SearchField` | `SearchField` |
| `ProgressBar` / `Meter` / `Spinner` | `ProgressBar` / `Meter` / `Spinner` |
| `Step` / `StepList` | `Step` / `StepList` |
| `Table*` | `DataTable`, `DataTableHead`, `DataTableRow`, `DataTableCell` |
| `MiniWindow` / `MiniPanel` | `PopoverWindow` / `PopoverPanel` |
| `BrowserFrame` | `BrowserFrame` |
| — | `FloatingToolbar` / `ToolbarSeparator` (in-page overlay bar; no React twin) |
| `WindowFrame` and friends | `WindowFrame`, `WindowTitlebar`, `WindowBody`, `WindowMain`, `WindowContent`, `WindowFooter`, `TrafficLights` |
| `Sidebar` and friends | `Sidebar`, `SidebarGroup`, `SidebarCard`, `NavItem`, `Rail`, `RailItem`, `Aside` |
| `Stage` / `ActionBar` | `Stage` / `ActionBar` |
| — | `Pressable`, `HoverRegion`, `FocusRing` (interaction primitives) |

### In the app, not here

The product's own widgets, for when you are looking one up and land here first.
They live in `apps/desktop/flutter/lib/src/widgets/`, and take generic slots the
same way the atoms do — the product words go in at the call site.

| React (`apps/storybook/src/components`) | Flutter (`apps/desktop/flutter/lib/src/widgets`) |
| --- | --- |
| `ProviderAvatar` | `Avatar` (colour + glyph; no provider table) |
| `ProviderListItem` | `ListTile` |
| `HistoryItem` | `ListCard` |
| `TermMark` | `Mark` |
| `SourceBlock` | `TextBlock` |
| `PreferredTranslation` | `HighlightBlock` |
| `ServiceCard` | `TitledCard` |
| `TermCard` | `InfoCard` |
| `DictionaryEntry` | `DetailBlock` |
| `ShortcutRow` | `SettingRow` |
| `StatBlock` / `SegmentGauge` | `Stat` / `SegmentGauge` |
| `SelectionBubble` | `PopoverCard` |
| `PageThumb` | `Thumbnail` |
| `LanguagePair` | `SwapPair` |
| `FloatingBall` | `FloatingBall` |
| `BilingualParagraph` | `AnnotatedParagraph` |

Their tokens moved with them, into
`apps/desktop/flutter/lib/src/theme/product_tokens.dart` — the twin of React's
`apps/storybook/src/styles/product.css`. Provider brand colours, the marker on a
preferred translation, and the source / translation type recipes are all product
concepts. They layer on top of the tokens here and are reached the same way,
`context.product` beside `context.tokens`.

## Gallery

`example/` is every atom under a theme switcher.

```bash
cd example && flutter run -d macos
```

The product's widgets have their own gallery in the app, at `/debug/widgets`.

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

Both have twins on the app's side of the boundary, covering the widgets that
live there: `test/business_widget_golden_test.dart` and
`test/design_widget_alignment_test.dart`.

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
- **Selection.** `--selection` resolves to the accent while the window is
  key; `WindowFrame(unfocused: true)` swaps in the unemphasized pair by
  re-scoping the tokens, so every row inside picks it up without threading
  state down.
