import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';

/// The details this package is held to are the React stylesheets': the same
/// tokens resolved the same way. These assertions are the parts of a
/// screenshot that can be checked without a screen — the geometry a size
/// resolves to, and the recipe a variant paints with.
///
/// See packages/ui_react/src/components/*.css for the rules each group
/// mirrors.
void main() {
  Widget host(Widget child, {ThemeData? theme}) {
    return material.MaterialApp(
      home: Theme(
        data: theme ?? ThemeData.studioLight(),
        child: material.Material(
          type: material.MaterialType.transparency,
          child: Center(child: child),
        ),
      ),
    );
  }

  const vars = themeVariables;

  group('Button', () {
    testWidgets('sits at the size profile height, small by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(Button(onPressed: () {}, child: const Text('Save'))),
      );

      final Size size = tester.getSize(find.byType(Button));
      expect(size.height, vars.controlSmallSize);
    });

    testWidgets('every size lands on its profile height', (tester) async {
      for (final (WidgetSize step, double height) in [
        (WidgetSize.tiny, vars.controlTinySize),
        (WidgetSize.small, vars.controlSmallSize),
        (WidgetSize.medium, vars.controlMediumSize),
        (WidgetSize.large, vars.controlLargeSize),
      ]) {
        await tester.pumpWidget(
          host(Button(size: step, onPressed: () {}, child: const Text('A'))),
        );
        expect(
          tester.getSize(find.byType(Button)).height,
          height,
          reason: '${step.namedSize.name} button',
        );
      }
    });

    testWidgets('recessed is the default variant, and it fills the inset', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(Button(onPressed: () {}, child: const Text('Save'))),
      );

      final decoration =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration
              as BoxDecoration;
      expect(decoration.color, vars.colorSurfaceInset);
    });

    testWidgets('filled takes the accent fill and the hairline lift', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.filled,
            onPressed: () {},
            child: const Text('Save'),
          ),
        ),
      );

      final decoration =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration
              as BoxDecoration;
      expect(
        decoration.color,
        vars.colorPrimary[vars.controlColorFilledSurface.normalShade!],
      );
      expect(decoration.boxShadow, isNotEmpty);

      // The one action a view points at carries the extra weight.
      final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
        find.byType(DefaultTextStyle).last,
      );
      expect(style.style.fontWeight, vars.labelStrong.fontWeight);
    });

    testWidgets('disabled flattens: no lift, no extra weight', (tester) async {
      await tester.pumpWidget(
        host(
          const Button(
            variant: ButtonVariant.filled,
            onPressed: null,
            child: Text('Save'),
          ),
        ),
      );

      final decoration =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration
              as BoxDecoration;
      expect(decoration.color, vars.colorSurfaceSunken);
      expect(decoration.boxShadow, isEmpty);
    });
  });

  group('IconButton', () {
    testWidgets('is a square of the profile height, tiny by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(IconButton(icon: material.Icons.add, onPressed: () {})),
      );

      final Size size = tester.getSize(find.byType(IconButton));
      expect(size.width, vars.controlTinySize);
      expect(size.height, vars.controlTinySize);
    });

    testWidgets('the quiet default rests in the subtle ink', (tester) async {
      await tester.pumpWidget(
        host(IconButton(icon: material.Icons.add, onPressed: () {})),
      );

      // A toolbar row has to read as chrome until it is touched.
      expect(
        tester.widget<Icon>(find.byType(Icon)).color,
        vars.colorContentSubtle,
      );
    });

    testWidgets('the on-state turns the glyph accent', (tester) async {
      await tester.pumpWidget(
        host(
          IconButton(icon: material.Icons.add, active: true, onPressed: () {}),
        ),
      );

      // "This is on" is a colour statement, not a chip.
      expect(
        tester.widget<Icon>(find.byType(Icon)).color,
        vars.colorPrimary[700],
      );
    });
  });

  group('Badge', () {
    testWidgets('is an annotation: chip corner, display cut, never a control '
        'height', (tester) async {
      await tester.pumpWidget(host(const Badge(child: Text('Beta'))));

      final Container box = tester.widget<Container>(find.byType(Container));
      final decoration = box.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.circular(vars.radiusTiny),
      );
      expect(
        tester.getSize(find.byType(Badge)).height,
        lessThan(vars.controlSmallSize),
      );

      final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
        find.byType(DefaultTextStyle).last,
      );
      expect(style.style.fontFamily, vars.labelStrong.fontFamily);
      expect(style.style.fontWeight, vars.labelMedium.fontWeight);
    });

    testWidgets('raised is paper and quiet ink', (tester) async {
      await tester.pumpWidget(
        host(const Badge(variant: BadgeVariant.raised, child: Text('3'))),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;
      expect(decoration.color, vars.colorSurface);
    });
  });

  group('KeyCap', () {
    testWidgets('hint is bare faint text', (tester) async {
      await tester.pumpWidget(host(const KeyCap('⌘K')));

      expect(find.byType(Container), findsNothing);
      expect(
        tester.widget<Text>(find.byType(Text)).style?.color,
        vars.colorContentFaint,
      );
    });

    testWidgets('key alone draws the recessed cap', (tester) async {
      await tester.pumpWidget(
        host(const KeyCap('Esc', variant: KeyCapVariant.key)),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;
      expect(decoration.color, vars.colorSurfaceInset);
      expect(decoration.border, isNull, reason: 'a key is pressed in, not up');
    });
  });

  group('Card', () {
    testWidgets('raised is paper with the hairline', (tester) async {
      await tester.pumpWidget(host(const Card(child: Text('x'))));

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;
      expect(decoration.color, vars.colorSurface);
      // A separator is one *device* pixel: the 1px token halves on Retina,
      // the way base.css halves it under `min-resolution: 2dppx`. The test
      // binding runs at a device pixel ratio above 1.
      expect(
        tester.view.devicePixelRatio,
        greaterThanOrEqualTo(2),
        reason: 'the halving only shows above 1x',
      );
      expect(decoration.border!.top.width, vars.strokeHairline / 2);
    });

    testWidgets('tinted takes the surface wash, not the chip fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const Card(variant: CardVariant.tinted, child: Text('x'))),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;
      expect(decoration.color!.a, closeTo(vars.washSurface, 0.001));
      expect(decoration.border!.top.color.a, closeTo(vars.washEdge, 0.001));
    });
  });

  group('Callout', () {
    testWidgets('fill and edge are washes of the tint', (tester) async {
      await tester.pumpWidget(
        host(
          const Callout(
            tint: CalloutTint.danger,
            title: Text('The build failed'),
          ),
        ),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container).first).decoration
              as BoxDecoration;
      expect(decoration.color!.a, closeTo(vars.washSurface, 0.001));
      expect(decoration.border!.top.color.a, closeTo(vars.washEdge, 0.001));
    });
  });

  group('Checkbox', () {
    testWidgets('the box defines the row — no minimum height', (tester) async {
      await tester.pumpWidget(host(Checkbox(value: true, onChanged: (_) {})));

      // A stacked checklist sits at the density the boxes set, so the row is
      // the box rather than the (taller) control height.
      expect(
        tester.getSize(find.byType(Checkbox)).height,
        vars.checkboxMediumBox,
      );
      expect(vars.checkboxMediumBox, lessThan(vars.controlMediumSize));
    });

    testWidgets('the label carries the selection signal twice over', (
      tester,
    ) async {
      Future<TextStyle> labelStyle({required bool checked}) async {
        await tester.pumpWidget(
          host(
            Checkbox(
              value: checked,
              label: const Text('Send me the newsletter'),
              onChanged: (_) {},
            ),
          ),
        );
        return tester
            .widget<DefaultTextStyle>(find.byType(DefaultTextStyle).last)
            .style;
      }

      final TextStyle resting = await labelStyle(checked: false);
      final TextStyle selected = await labelStyle(checked: true);

      // It rests one ink step back at the quiet weight, and takes the full
      // ink and the label weight only when its box is checked.
      expect(resting.color, vars.colorContentMuted);
      expect(resting.fontWeight, vars.labelQuiet.fontWeight);
      expect(selected.color, vars.colorContent);
      expect(selected.fontWeight, vars.labelMedium.fontWeight);
    });
  });

  group('Radio', () {
    testWidgets('the ring keeps its outline when selected', (tester) async {
      await tester.pumpWidget(
        host(Radio<int>(value: 1, groupValue: 1, onChanged: (_) {})),
      );

      final decoration =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration
              as BoxDecoration;
      // A filled circle is a checkbox's signal, not a radio's.
      expect(decoration.color, isNull);
      expect(decoration.border, isNotNull);
      expect(decoration.shape, BoxShape.circle);
    });
  });

  group('Switch', () {
    testWidgets('track and thumb are the switch tokens', (tester) async {
      await tester.pumpWidget(host(Switch(value: false, onChanged: (_) {})));

      final Size size = tester.getSize(find.byType(Switch));
      expect(size.width, vars.switchMediumWidth);
      expect(size.height, vars.switchMediumHeight);
    });

    testWidgets('every size lands on its own track', (tester) async {
      for (final (WidgetSize step, double width, double height) in [
        (WidgetSize.small, vars.switchSmallWidth, vars.switchSmallHeight),
        (WidgetSize.medium, vars.switchMediumWidth, vars.switchMediumHeight),
        (WidgetSize.large, vars.switchLargeWidth, vars.switchLargeHeight),
      ]) {
        await tester.pumpWidget(
          host(Switch(size: step, value: false, onChanged: (_) {})),
        );
        expect(
          tester.getSize(find.byType(Switch)),
          Size(width, height),
          reason: '${step.namedSize.name} switch',
        );
      }
    });
  });

  group('Spinner', () {
    testWidgets('every size lands on its spacing step', (tester) async {
      for (final (WidgetSize step, double dimension) in [
        (WidgetSize.small, vars.spacing35),
        (WidgetSize.medium, vars.spacing4),
        (WidgetSize.large, vars.spacing5),
      ]) {
        await tester.pumpWidget(host(Spinner(size: step)));
        expect(
          tester.getSize(find.byType(Spinner)),
          Size.square(dimension),
          reason: '${step.namedSize.name} loader',
        );
      }
    });
  });

  group('SegmentedControl', () {
    testWidgets('the capsule is the track inset on both sides, and the two '
        'corners are concentric', (tester) async {
      await tester.pumpWidget(
        host(
          SegmentedControl<String>(
            value: 'a',
            onChanged: (_) {},
            items: const [
              SegmentedItem(value: 'a', label: 'A'),
              SegmentedItem(value: 'b', label: 'B'),
            ],
          ),
        ),
      );

      final double inset = vars.segmentedControlInset;
      // The segment's height is the control height minus the inset on both
      // sides, so a segmented control lines up with the buttons beside it.
      expect(
        tester.getSize(find.byType(SegmentedControl<String>)).height,
        vars.controlSmallSize,
      );

      final decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byType(AnimatedContainer).first,
                  )
                  .decoration
              as BoxDecoration;
      // The capsule's corner is the track's minus the inset — the only
      // relationship that keeps the two curves concentric.
      expect(
        decoration.borderRadius,
        BorderRadius.circular(vars.controlSmallRadius - inset),
      );
    });
  });

  group('PillTabs', () {
    testWidgets('an unselected pill has a fill of its own', (tester) async {
      await tester.pumpWidget(
        host(
          PillTabs<String>(
            value: 'a',
            onChanged: (_) {},
            items: const [
              PillTabItem(value: 'a', label: 'A'),
              PillTabItem(value: 'b', label: 'B'),
            ],
          ),
        ),
      );

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      final selected = containers.first.decoration as BoxDecoration;
      final resting = containers.last.decoration as BoxDecoration;

      expect(
        selected.color,
        vars.colorPrimary[vars.controlColorFilledSurface.normalShade!],
      );
      // There is no track, so an unselected pill needs its own fill to be a
      // target at all — the inset step.
      expect(resting.color, vars.colorSurfaceInset);
    });
  });

  group('Progress', () {
    testWidgets('every size lands on its own thickness', (tester) async {
      for (final (WidgetSize step, double thickness) in [
        (WidgetSize.small, vars.spacing1),
        (WidgetSize.medium, vars.spacing15),
        (WidgetSize.large, vars.spacing2),
      ]) {
        await tester.pumpWidget(host(Progress(value: 0.5, size: step)));
        expect(
          tester.getSize(find.byType(Progress)).height,
          thickness,
          reason: '${step.namedSize.name} progress',
        );
      }
    });
  });

  group('OptionCard', () {
    testWidgets('the chosen card thickens its border as well as colouring it', (
      tester,
    ) async {
      Future<BoxDecoration> decorationFor({required bool selected}) async {
        await tester.pumpWidget(
          host(
            OptionCard(
              title: 'Automatic',
              selected: selected,
              onPressed: () {},
            ),
          ),
        );
        return tester
                .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration
            as BoxDecoration;
      }

      final resting = await decorationFor(selected: false);
      final chosen = await decorationFor(selected: true);

      // A device-pixel hairline at rest; the control stroke when chosen.
      expect(resting.border!.top.width, vars.strokeHairline / 2);
      expect(chosen.border!.top.width, vars.strokeControl);
      expect(
        chosen.border!.top.color,
        vars.colorPrimary[vars.controlColorOutlinedBorder.normalShade!],
      );
    });
  });

  group('Menu', () {
    testWidgets('the panel is not in the tree until the trigger opens it, and '
        'an outside press closes it', (tester) async {
      await tester.pumpWidget(
        host(
          Menu(
            trigger: (context, state) => Button(
              onPressed: state.toggle,
              child: const Text('Actions'),
            ),
            items: [MenuItem(label: 'Rename', onSelect: () {})],
          ),
        ),
      );

      expect(find.text('Rename'), findsNothing);

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget);

      // The overlay fills the window, so a press away from the panel lands on
      // the dismiss barrier.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsNothing);
    });

    testWidgets('selecting a row closes the panel', (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        host(
          Menu(
            trigger: (context, state) => Button(
              onPressed: state.toggle,
              child: const Text('Actions'),
            ),
            items: [MenuItem(label: 'Rename', onSelect: () => selected++)],
          ),
        ),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      expect(selected, 1);
      expect(find.text('Rename'), findsNothing);
    });
  });

  group('Dialog', () {
    testWidgets('the scrim covers the window rather than the column that '
        'opened it', (tester) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => Button(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => const Dialog(
                  children: [DialogHeader(title: 'Discard these changes?')],
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      expect(find.text('Discard these changes?'), findsNothing);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Discard these changes?'), findsOneWidget);

      // `position: fixed` means the whole window: the scrim is as wide as the
      // app, not as wide as the button that opened it.
      expect(
        tester.getSize(find.byType(DialogScrim)),
        tester.getSize(find.byType(material.MaterialApp)),
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Discard these changes?'), findsNothing);
    });
  });

  group('themes', () {
    testWidgets('a filled button follows the theme it is scoped to', (
      tester,
    ) async {
      for (final (ThemeData theme, ThemeVariables themeVars) in [
        (ThemeData.studioLight(), themeVariables),
        (ThemeData.studioDark(), themeVariablesStudioDark),
        (ThemeData.brightLight(), themeVariablesBrightLight),
        (ThemeData.brightDark(), themeVariablesBrightDark),
      ]) {
        await tester.pumpWidget(
          host(
            Button(
              variant: ButtonVariant.filled,
              onPressed: () {},
              child: const Text('Save'),
            ),
            theme: theme,
          ),
        );

        final decoration =
            tester
                    .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                    .decoration
                as BoxDecoration;
        expect(
          decoration.color,
          themeVars.colorPrimary[themeVars
              .controlColorFilledSurface
              .normalShade!],
        );
      }
    });
  });
}
