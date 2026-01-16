# Shimmer Effects

A modern, highly customizable shimmer effect widget for Flutter. Create beautiful skeleton loading states with ease.

[![pub package](https://img.shields.io/pub/v/flutter_shimmer_effects.svg)](https://pub.dev/packages/flutter_shimmer_effects)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Demo Gallery

<table>
  <tr>
    <td><img src="https://github.com/omar-hanafy/flutter_shimmer_effects/blob/main/screenshots/basic.gif?raw=true" alt="Basic shimmer demo" width="240" /></td>
    <td><img src="https://github.com/omar-hanafy/flutter_shimmer_effects/blob/main/screenshots/built-in.gif?raw=true" alt="Built-in skeletons demo" width="240" /></td>
    <td><img src="https://github.com/omar-hanafy/flutter_shimmer_effects/blob/main/screenshots/directions.gif?raw=true" alt="Direction variants demo" width="240" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/omar-hanafy/flutter_shimmer_effects/blob/main/screenshots/gradient.gif?raw=true" alt="Custom gradient demo" width="240" /></td>
    <td><img src="https://github.com/omar-hanafy/flutter_shimmer_effects/blob/main/screenshots/list.gif?raw=true" alt="List loading demo" width="240" /></td>
    <td></td>
  </tr>
</table>

## Features

- **Multiple directions** - Left-to-right, right-to-left, top-to-bottom, bottom-to-top
- **Smooth bounce mode** - Optional ping-pong loop for seamless shimmer
- **External control** - Synchronize multiple shimmers with `ShimmerController`
- **Accessibility** - Respects system "Reduce Motion" settings
- **Performance optimized** - Built-in `RepaintBoundary` for efficient rendering in lists
- **Finite loops** - Run animation a specific number of times with completion callback
- **Custom gradients** - Full control over colors, stops, and blend modes
- **Dark mode support** - `ShimmerLoading` automatically adapts to theme brightness
- **Pre-built skeletons** - Ready-to-use skeleton widgets for common UI patterns

## Installation

Add shimmer effects to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_shimmer_effects: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter_shimmer_effects/flutter_shimmer_effects.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: 200,
    height: 100,
    color: Colors.white,
  ),
)
```

### Loading State Management

Use `ShimmerLoading` for automatic transitions between loading and content:

```dart
ShimmerLoading(
  isLoading: _isLoading,
  placeholder: SkeletonListTile(),
  child: ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
    title: Text(user.name),
    subtitle: Text(user.email),
  ),
)
```

## API Reference

### Shimmer

The core widget that applies an animated gradient mask over its child.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | required | The widget to apply shimmer effect to |
| `gradient` | `Gradient` | required | The gradient for the shimmer effect |
| `direction` | `ShimmerDirection` | `ltr` | Direction of gradient movement |
| `period` | `Duration` | `1500ms` | Duration of one animation cycle |
| `loop` | `int` | `0` | Number of loops (0 = infinite) |
| `bounce` | `bool` | `false` | Reverse direction each cycle (infinite loop only) |
| `enabled` | `bool` | `true` | Whether animation is enabled |
| `controller` | `ShimmerController?` | `null` | External controller for sync |
| `curve` | `Curve` | `linear` | Animation curve |
| `blendMode` | `BlendMode` | `srcIn` | How gradient composites onto child |
| `respectReducedMotion` | `bool` | `true` | Honor system accessibility settings |
| `staticPercent` | `double` | `0.5` | Gradient position when motion disabled |
| `repaintBoundary` | `bool` | `true` | Wrap in RepaintBoundary for performance |
| `onAnimationComplete` | `VoidCallback?` | `null` | Called when finite loops complete |

#### Shimmer.fromColors

Convenience constructor using two colors:

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: YourWidget(),
)
```

### ShimmerDirection

Defines the direction of the shimmer gradient movement:

| Value | Description |
|-------|-------------|
| `ltr` | Left to right (default) |
| `rtl` | Right to left |
| `ttb` | Top to bottom |
| `btt` | Bottom to top |

### ShimmerController

Manages animation state for one or more `Shimmer` widgets.

```dart
final controller = ShimmerController();

// Control animation
controller.start();
controller.stop();
controller.toggle();

// Check state
controller.isAnimating;
controller.isDisposed;

// Don't forget to dispose
controller.dispose();
```

**Use cases:**
- Synchronize multiple shimmer widgets
- Pause animation when content is off-screen
- Programmatically control animation based on app logic

### ShimmerLoading

A convenience widget that manages loading state transitions:

```dart
ShimmerLoading(
  isLoading: true,
  placeholder: SkeletonParagraph(lines: 3),
  child: Text('Loaded content'),
  fadeTransition: true,
  fadeDuration: Duration(milliseconds: 250),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `isLoading` | `bool` | required | Whether to show placeholder |
| `child` | `Widget` | required | Content when loaded |
| `placeholder` | `Widget` | required | Skeleton widget when loading |
| `baseColor` | `Color?` | `null` | Override base color |
| `highlightColor` | `Color?` | `null` | Override highlight color |
| `direction` | `ShimmerDirection` | `ltr` | Direction of gradient movement |
| `period` | `Duration` | `1500ms` | Duration of one animation cycle |
| `bounce` | `bool` | `false` | Reverse direction each cycle (infinite loop only) |
| `curve` | `Curve` | `linear` | Animation curve |
| `fadeTransition` | `bool` | `true` | Animate between states |
| `fadeDuration` | `Duration` | `250ms` | Transition duration |
| `respectReducedMotion` | `bool` | `true` | Honor system accessibility settings |

## Skeleton Widgets

Pre-built skeleton widgets for common UI patterns:

### SkeletonLine

A rectangular skeleton for text lines:

```dart
SkeletonLine(
  width: double.infinity,
  height: 14.0,
  borderRadius: BorderRadius.circular(4),
)
```

### SkeletonAvatar

A circular skeleton for avatars:

```dart
SkeletonAvatar(size: 40.0)
```

### SkeletonBox

A rectangular skeleton for images or cards:

```dart
SkeletonBox(
  width: 100,
  height: 100,
  borderRadius: BorderRadius.circular(8),
)
```

### SkeletonListTile

A composite skeleton mimicking `ListTile`:

```dart
SkeletonListTile(
  hasLeading: true,
  hasSubtitle: true,
  leadingSize: 40.0,
  titleWidthFactor: 0.72,
  subtitleWidthFactor: 0.52,
)
```

### SkeletonParagraph

Multiple lines simulating a paragraph:

```dart
SkeletonParagraph(
  lines: 3,
  lineHeight: 14.0,
  spacing: 8.0,
  lastLineWidthFactor: 0.65,
)
```

## Examples

### List Loading

```dart
ListView.builder(
  itemCount: 10,
  itemBuilder: (context, index) {
    return ShimmerLoading(
      isLoading: _items == null,
      placeholder: SkeletonListTile(),
      child: _items != null ? ItemTile(item: _items[index]) : SizedBox(),
    );
  },
)
```

### Card Skeleton

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonBox(width: double.infinity, height: 200),
      SizedBox(height: 16),
      SkeletonParagraph(lines: 2),
    ],
  ),
)
```

### Synchronized Shimmers

```dart
class _MyWidgetState extends State<MyWidget> {
  final _controller = ShimmerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          controller: _controller,
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SkeletonLine(),
        ),
        Shimmer.fromColors(
          controller: _controller,
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SkeletonLine(),
        ),
        ElevatedButton(
          onPressed: _controller.toggle,
          child: Text('Toggle'),
        ),
      ],
    );
  }
}
```

### Finite Animation with Callback

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  loop: 3,
  onAnimationComplete: () {
    print('Animation completed!');
  },
  child: Text('Highlight me'),
)
```

### Custom Gradient

```dart
Shimmer(
  gradient: LinearGradient(
    colors: [Colors.red, Colors.orange, Colors.yellow],
    stops: [0.0, 0.5, 1.0],
  ),
  child: Icon(Icons.star, size: 48),
)
```

### Vertical Shimmer

```dart
Shimmer.fromColors(
  direction: ShimmerDirection.ttb,
  baseColor: Colors.blue[300]!,
  highlightColor: Colors.blue[100]!,
  child: Container(width: 100, height: 200, color: Colors.white),
)
```

## Performance Tips

1. **RepaintBoundary** - Enabled by default. Keep it on when using shimmer in lists.

2. **Controller for off-screen content** - Stop animation when widgets scroll out of view:
   ```dart
   controller.stop(); // When off-screen
   controller.start(); // When visible again
   ```

3. **Avoid deep nesting** - Keep shimmer children relatively simple for best performance.

## Accessibility

By default, `Shimmer` respects the user's "Reduce Motion" system setting. When reduced motion is enabled:
- Animation stops
- Gradient freezes at `staticPercent` position (default: 0.5)

To override this behavior, set `respectReducedMotion: false`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
