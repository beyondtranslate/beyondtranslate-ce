/// The brand mark.
library;

import 'package:flutter/widgets.dart';

/// The 文/A dual-panel mark from the brand page (490×490 master). 「文」 is the
/// word for writing and the head of the alphabet at once; the two panels hold
/// source and translation.
///
/// Copied verbatim from the React kit's `brand-logo.tsx`; absolute
/// M/L/C/Q/Z commands only, which is all [_parseBrandPath] understands.
const String _kBrandMarkPath =
    'M48 0C21.49 0 0 21.49 0 48L0 291.23C0 317.74 21.49 339.23 48 339.23L120.77 339.23Q150.77 339.23 150.77 369.23L150.77 442C150.77 468.51 172.26 490 198.77 490L442 490C468.51 490 490 468.51 490 442L490 198.77C490 172.26 468.51 150.77 442 150.77L369.23 150.77Q339.23 150.77 339.23 120.77L339.23 48C339.23 21.49 317.74 0 291.23 0L48 0ZM428.96 16.67C436.36 33.52 448.48 45.64 465.33 53.04Q480 58 465.33 62.96C448.48 70.36 436.36 82.48 428.96 99.33Q424 114 419.04 99.33C411.64 82.48 399.52 70.36 382.67 62.96Q368 58 382.67 53.04C399.52 45.64 411.64 33.52 419.04 16.67Q424 2 428.96 16.67ZM67.69 37.69L271.54 37.69Q301.54 37.69 301.54 67.69L301.54 139.62Q301.54 169.62 280.32 190.83L190.83 280.32Q169.62 301.54 139.62 301.54L67.69 301.54Q37.69 301.54 37.69 271.54L37.69 67.69Q37.69 37.69 67.69 37.69ZM150.77 84.8Q150.77 94.23 141.36 94.23L94.22 94.23Q75.38 94.23 75.38 113.07Q75.38 131.92 94.22 131.92L172.01 131.92Q202.01 131.92 186.57 157.57C179.38 166.95 171.09 175.53 162.52 183.3Q161.37 184.34 160.05 183.54C159.5 183.23 158.95 182.94 158.43 182.57C151.12 177.54 145.16 172.12 140.75 167.06Q131.92 150.77 113.09 150.77Q94.23 150.77 97.42 169.24C100.89 178.92 106.9 187.28 114.07 194.62Q130.16 208.49 112.03 219.59C109.8 220.85 107.69 222.02 105.7 223.09Q88.93 231.45 95.99 248.82Q103.06 266.2 120.23 258.69C129.71 254.12 142.29 247.4 155.84 238.41Q166.67 230.87 178.69 236.32C184.27 238.68 189.48 240.63 193.76 242.06L196.61 242.99Q208.97 247.04 213.02 234.69L216.69 223.47Q220.74 211.11 208.39 207.06L205.54 206.13C204.65 205.83 203.17 205.19 201.65 204.53Q198.47 203.19 200.85 200.69C216.05 184.51 229.74 165 238.51 142.21Q242.06 131.92 252.94 131.92Q263.85 131.92 263.85 121.04L263.85 113.07Q263.85 94.23 245.01 94.23L197.88 94.23Q188.46 94.23 188.46 84.82Q188.46 75.38 179.05 75.38L160.18 75.38Q150.77 75.38 150.77 84.8ZM329.8 237.34Q352.19 237.34 359.62 258.44L407.77 395.18Q414.62 414.62 394.01 414.62Q373.39 414.62 366.96 395.04L366.61 393.99Q359.84 373.39 338.16 373.39L317 373.39Q295.65 373.39 290.06 393.99L289.62 395.58Q284.46 414.62 264.74 414.62Q245 414.62 251.55 396.02L300 258.44Q307.43 237.34 329.8 237.34ZM324.34 286.92C321.72 296.25 318.22 308.11 313.81 322.39Q307.43 342.76 329.8 342.76Q352.19 342.76 345.97 322.34C340.96 306.12 337.09 294.18 334.55 286.9Q329.81 265.61 324.34 286.92ZM70.96 392.17C78.36 409.02 90.48 421.14 107.33 428.54Q122 433.5 107.33 438.46C90.48 445.86 78.36 457.98 70.96 474.83Q66 489.5 61.04 474.83C53.64 457.98 41.52 445.86 24.67 438.46Q10 433.5 24.67 428.54C41.52 421.14 53.64 409.02 61.04 392.17Q66 377.5 70.96 392.17Z';

/// The master's coordinate space.
const double _kBrandMarkExtent = 490;

/// Parsed once and reused by every glyph on screen.
final Path _brandMarkPath = _parseBrandPath(_kBrandMarkPath);

/// A parser for exactly the subset of SVG path data the brand mark uses:
/// absolute M, L, C, Q and Z. Kept private so it never has to grow into a
/// general SVG library — the mark is the only path this package draws.
Path _parseBrandPath(String data) {
  final path = Path();
  var i = 0;
  var command = '';

  bool isSeparator(String c) => c == ' ' || c == ',';
  bool startsNumber(String c) =>
      c == '-' || c == '.' || (c.compareTo('0') >= 0 && c.compareTo('9') <= 0);

  double readNumber() {
    while (i < data.length && isSeparator(data[i])) {
      i++;
    }
    final start = i;
    if (i < data.length && data[i] == '-') i++;
    while (i < data.length &&
        (data[i] == '.' ||
            (data[i].compareTo('0') >= 0 && data[i].compareTo('9') <= 0))) {
      i++;
    }
    return double.parse(data.substring(start, i));
  }

  while (i < data.length) {
    final c = data[i];
    if (isSeparator(c)) {
      i++;
      continue;
    }
    if (!startsNumber(c)) {
      command = c;
      i++;
      if (command == 'Z') path.close();
      continue;
    }
    switch (command) {
      case 'M':
        path.moveTo(readNumber(), readNumber());
        // Further pairs after an M are implicit absolute line-tos.
        command = 'L';
      case 'L':
        path.lineTo(readNumber(), readNumber());
      case 'C':
        path.cubicTo(readNumber(), readNumber(), readNumber(), readNumber(),
            readNumber(), readNumber());
      case 'Q':
        path.quadraticBezierTo(
            readNumber(), readNumber(), readNumber(), readNumber());
      default:
        throw FormatException('Unsupported path command: $command');
    }
  }
  // SVG's default fill rule; the mark's counters are wound to read as holes
  // under it.
  return path;
}

/// The bare 文/A glyph — for surfaces that bring their own brand ground (the
/// acid-green avatar, a green button). The React component fills with
/// `currentColor`; here the colour is passed in.
class BrandGlyph extends StatelessWidget {
  const BrandGlyph({super.key, required this.size, required this.color});

  /// Rendered edge in px; the glyph is square.
  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _BrandGlyphPainter(color),
      ),
    );
  }
}

class _BrandGlyphPainter extends CustomPainter {
  const _BrandGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / _kBrandMarkExtent;
    canvas.scale(scale);
    canvas.drawPath(_brandMarkPath, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BrandGlyphPainter oldDelegate) =>
      color != oldDelegate.color;
}

/// The app-icon treatment of the mark: acid-green glyph on the ink-blue tile.
/// Literal brand colours on purpose — the brand page's rule is that the icon
/// never flips with the theme, and acid green only ever sits on ink. Solid
/// green rather than the gradient, matching the brand page's own favicon-size
/// cut.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 20});

  /// Tile edge in px.
  final double size;

  @override
  Widget build(BuildContext context) {
    // CSS linear-gradient(160deg, …): the axis 160° clockwise from "to top".
    const begin = Alignment(-0.342, -0.940);
    const end = Alignment(0.342, 0.940);

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: begin,
            end: end,
            colors: [Color(0xFF182541), Color(0xFF111C2E), Color(0xFF0B1322)],
            stops: [0, 0.6, 1],
          ),
          // rounded-[24%] — the squircle read scales with the tile.
          borderRadius: BorderRadius.circular(size * 0.24),
          border: Border.all(color: const Color(0x17F2F4EF)),
        ),
        child: BrandGlyph(size: size * 0.68, color: const Color(0xFFD6FF3F)),
      ),
    );
  }
}
