/// A modern, highly customizable shimmer effect widget for Flutter.
///
/// [Shimmer] applies an animated gradient mask over its [child] to create
/// a "skeleton loading" or "highlight" effect.
///
/// ### Core Behavior
/// The [child] widget defines the *shape* of the shimmer. The [gradient] defines
/// the *colors* that move across that shape. The alpha channel of the [child]
/// is preserved, but its original colors are overridden by the gradient.
///
/// ### Usage
/// Use this widget to indicate that content is loading or to draw attention to
/// a specific UI element.
///
/// ```dart
/// Shimmer.fromColors(
///   baseColor: Colors.grey[300]!,
///   highlightColor: Colors.grey[100]!,
///   child: Text('Loading...'),
/// )
/// ```
///
/// See also:
///  * [ShimmerController], for synchronizing or controlling the animation externally.
///  * [ShimmerLoading], a convenience wrapper for switching between content and shimmer.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Defines the direction of the shimmer gradient movement.
///
/// The gradient moves from "start" to "end" based on these directions.
enum ShimmerDirection {
  /// Left to Right. Standard for LTR languages.
  ltr,

  /// Right to Left. Standard for RTL languages.
  rtl,

  /// Top to Bottom. Often used for scanning or vertical loading effects.
  ttb,

  /// Bottom to Top.
  btt;

  /// Returns `true` if the direction is horizontal ([ltr] or [rtl]).
  bool get isHorizontal => this == ltr || this == rtl;

  /// Returns `true` if the direction is vertical ([ttb] or [btt]).
  bool get isVertical => !isHorizontal;

  /// Returns `true` if the direction is reversed ([rtl] or [btt]).
  bool get isReversed => this == rtl || this == btt;

  /// The alignment where the gradient begins its transition.
  Alignment get beginAlignment => switch (this) {
    ltr => Alignment.centerLeft,
    rtl => Alignment.centerRight,
    ttb => Alignment.topCenter,
    btt => Alignment.bottomCenter,
  };

  /// The alignment where the gradient ends its transition.
  Alignment get endAlignment => switch (this) {
    ltr => Alignment.centerRight,
    rtl => Alignment.centerLeft,
    ttb => Alignment.bottomCenter,
    btt => Alignment.topCenter,
  };
}

/// Manages the active state of one or more [Shimmer] widgets.
///
/// [ShimmerController] allows you to start, stop, or toggle animations programmatically.
///
/// ### Usage
/// *   **Synchronizing:** Pass the same controller to multiple [Shimmer] widgets to start/stop them together.
/// *   **Performance:** Call [stop] when the shimmering content is off-screen or covered to save resources.
/// *   **Logic:** Pause the shimmer when data is partially loaded but not yet ready for display.
class ShimmerController extends ChangeNotifier {
  /// Creates a controller with an initial animation state.
  ShimmerController({bool isAnimating = true}) : _isAnimating = isAnimating;

  bool _isAnimating;
  bool _isDisposed = false;

  /// Whether the controlled [Shimmer] widgets should currently be animating.
  bool get isAnimating => _isAnimating;

  /// Whether this controller has been permanently disposed.
  ///
  /// Once disposed, method calls like [start] or [stop] will be ignored to prevent memory leaks.
  bool get isDisposed => _isDisposed;

  /// Resumes the shimmer animation.
  ///
  /// If already animating or disposed, this method does nothing.
  /// Triggers a rebuild of attached [Shimmer] widgets.
  void start() {
    if (_isDisposed || _isAnimating) return;
    _isAnimating = true;
    notifyListeners();
  }

  /// Pauses the shimmer animation.
  ///
  /// The shimmer will freeze at its current or reset position depending on implementation.
  /// If already stopped or disposed, this method does nothing.
  void stop() {
    if (_isDisposed || !_isAnimating) return;
    _isAnimating = false;
    notifyListeners();
  }

  /// Toggles the animation state between running and paused.
  void toggle() => _isAnimating ? stop() : start();

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

/// A widget that renders an animated gradient mask over its [child].
///
/// [Shimmer] creates a visual effect often used for "skeleton" loading states.
/// It renders the [child] into a layer and applies a [gradient] shader that moves
/// across it over the specified [period].
///
/// ### Constraints & Behavior
/// *   **Alpha Masking:** The [child]'s opacity is used as a mask. Fully transparent
///     pixels in the child remain transparent. Opaque pixels take on the color of the gradient.
/// *   **Layout:** The widget takes the exact size of its [child].
/// *   **Performance:** By default, it wraps the animation in a [RepaintBoundary].
///
/// ### Accessibility
/// If [respectReducedMotion] is true (default), this widget listens to
/// [MediaQueryData.disableAnimations]. If the user has requested reduced motion,
/// the animation freezes at [staticPercent].
@immutable
class Shimmer extends StatefulWidget {
  /// Creates a custom shimmer effect with a specific [gradient].
  ///
  /// Use this constructor if you need full control over the gradient colors,
  /// stops, or type (though linear is standard).
  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.bounce = false,
    this.enabled = true,
    this.controller,
    this.curve = Curves.linear,
    this.blendMode = BlendMode.srcIn,
    this.respectReducedMotion = true,
    this.staticPercent = 0.5,
    this.repaintBoundary = true,
    this.onAnimationComplete,
  }) : assert(
         staticPercent >= 0.0 && staticPercent <= 1.0,
         'staticPercent must be between 0.0 and 1.0 inclusive.',
       );

  /// Creates a standard shimmer effect using two colors.
  ///
  /// This is a convenience constructor that generates a [LinearGradient]
  /// oscillating between [baseColor] and [highlightColor].
  ///
  /// ### Example
  /// ```dart
  /// Shimmer.fromColors(
  ///   baseColor: Colors.grey[300]!,
  ///   highlightColor: Colors.grey[100]!,
  ///   child: MySkeletonWidget(),
  /// )
  /// ```
  Shimmer.fromColors({
    super.key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.bounce = false,
    this.enabled = true,
    this.controller,
    this.curve = Curves.linear,
    this.blendMode = BlendMode.srcIn,
    this.respectReducedMotion = true,
    this.staticPercent = 0.5,
    this.repaintBoundary = true,
    this.onAnimationComplete,
  }) : assert(
         staticPercent >= 0.0 && staticPercent <= 1.0,
         'staticPercent must be between 0.0 and 1.0 inclusive.',
       ),
       gradient = LinearGradient(
         begin: direction.beginAlignment,
         end: direction.endAlignment,
         colors: <Color>[
           baseColor,
           baseColor,
           highlightColor,
           baseColor,
           baseColor,
         ],
         stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
       );

  /// The widget over which the shimmer effect is applied.
  ///
  /// This widget determines the *shape* of the shimmer. Usually a structure of
  /// [Container]s, [Text] widgets, or specific skeleton widgets.
  final Widget child;

  /// The gradient to use for the shimmer effect.
  ///
  /// The gradient is painted over the [child] using [blendMode].
  final Gradient gradient;

  /// The direction in which the gradient moves.
  ///
  /// Defaults to [ShimmerDirection.ltr].
  final ShimmerDirection direction;

  /// The duration of one complete animation cycle.
  ///
  /// Defaults to 1500ms. Shorter periods create a "busier" effect; longer periods
  /// are more subtle.
  final Duration period;

  /// The number of times the animation should loop.
  ///
  /// *   `0`: Infinite looping (default).
  /// *   `> 0`: Runs this many times and then stops.
  ///
  /// Triggers [onAnimationComplete] when finished (if finite).
  final int loop;

  /// Whether to reverse direction on each cycle.
  ///
  /// This only applies when [loop] is 0 (infinite). For finite loops, this is
  /// ignored.
  final bool bounce;

  /// Whether the shimmer is locally enabled.
  ///
  /// If `false`, the animation stops.
  /// Note: The animation effectively runs only if `enabled` is true AND
  /// ([controller] is null OR [controller.isAnimating] is true).
  final bool enabled;

  /// An optional external controller to synchronize or manage the animation state.
  ///
  /// If provided, this [Shimmer] will listen to the controller's notifications.
  final ShimmerController? controller;

  /// The animation curve applied to the gradient movement.
  ///
  /// Defaults to [Curves.linear] for a constant speed, but [Curves.easeInOut]
  /// can provide a more natural "breathing" feel.
  final Curve curve;

  /// The blend mode used to composite the gradient onto the child.
  ///
  /// Defaults to [BlendMode.srcIn], which keeps the child's alpha but replaces
  /// its color with the gradient's color.
  final BlendMode blendMode;

  /// Whether to respect the user's system "Reduce Motion" setting.
  ///
  /// If `true` (default), and the user has reduced motion enabled (e.g., via
  /// OS accessibility settings), the animation will be disabled and the gradient
  /// will be frozen at [staticPercent].
  final bool respectReducedMotion;

  /// The position of the gradient (0.0 to 1.0) when animation is disabled via reduced motion.
  ///
  /// Only used if [respectReducedMotion] is true and reduced motion is active.
  /// Defaults to 0.5 (center).
  final double staticPercent;

  /// Whether to wrap the shimmer in a [RepaintBoundary].
  ///
  /// Defaults to `true`.
  ///
  /// ### Why?
  /// Shimmer animations require repainting every frame. Without a boundary,
  /// this repaint request propagates up the tree, potentially causing the entire
  /// screen or list to repaint. This boundary isolates the repaint scope to just
  /// this widget, significantly improving performance in [ListView]s.
  final bool repaintBoundary;

  /// Callback triggered when the animation completes its specified [loop] count.
  ///
  /// Ignored if [loop] is 0 (infinite).
  final VoidCallback? onAnimationComplete;

  @override
  State<Shimmer> createState() => ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Gradient>('gradient', gradient))
      ..add(EnumProperty<ShimmerDirection>('direction', direction))
      ..add(DiagnosticsProperty<Duration>('period', period))
      ..add(IntProperty('loop', loop, defaultValue: 0))
      ..add(FlagProperty('bounce', value: bounce, ifTrue: 'bounce'))
      ..add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'))
      ..add(DiagnosticsProperty<ShimmerController?>('controller', controller))
      ..add(DiagnosticsProperty<Curve>('curve', curve))
      ..add(EnumProperty<BlendMode>('blendMode', blendMode))
      ..add(
        DiagnosticsProperty<bool>(
          'respectReducedMotion',
          respectReducedMotion,
          defaultValue: true,
        ),
      )
      ..add(DoubleProperty('staticPercent', staticPercent))
      ..add(DiagnosticsProperty<bool>('repaintBoundary', repaintBoundary));
  }
}

/// The state for [Shimmer], managing the animation controller and lifecycle.
///
/// Can be accessed via [GlobalKey] to manually control the animation (start/stop/reset),
/// although using [ShimmerController] is generally preferred for external control.
class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  CurvedAnimation? _curvedAnimation;

  int _completedLoops = 0;
  bool _reducedMotion = false;

  /// The animation with curve applied. Exposed for [AnimatedBuilder].
  Animation<double> get _animation => _curvedAnimation ?? _controller;

  /// The current value of the animation (0.0 to 1.0).
  double get value => _animation.value;

  /// Whether the internal animation controller is currently running.
  bool get isAnimating => _controller.isAnimating;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener(_handleStatus);

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    widget.controller?.addListener(_handleExternalControllerChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateReducedMotion();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.period != oldWidget.period) {
      _controller.duration = widget.period;
    }

    if (widget.curve != oldWidget.curve) {
      _curvedAnimation?.dispose();
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      );
    }

    if (widget.loop != oldWidget.loop) {
      _completedLoops = 0;
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleExternalControllerChange);
      widget.controller?.addListener(_handleExternalControllerChange);
    }

    _updateReducedMotion();
    _syncAnimation();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalControllerChange);
    _curvedAnimation?.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------
  // Reduced motion / controller
  // ---------------------------

  void _updateReducedMotion() {
    if (!widget.respectReducedMotion) {
      _reducedMotion = false;
      return;
    }

    // Efficiently checks the media query.
    // If context is not available (rare in didChangeDependencies), defaults to false.
    final bool reduce = (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

    _reducedMotion = reduce;
  }

  bool get _shouldAnimate {
    if (_reducedMotion) return false;
    if (!widget.enabled) return false;

    final ShimmerController? external = widget.controller;
    if (external != null) {
      // Safety: controller could be disposed between listener callback and here.
      if (external.isDisposed) return false;
      return external.isAnimating;
    }

    return true;
  }

  void _handleExternalControllerChange() {
    if (!mounted) return;
    if (widget.controller?.isDisposed ?? false) return;
    _syncAnimation();
  }

  // ---------------------------
  // Animation control
  // ---------------------------

  /// Syncs the internal controller with the desired state (_shouldAnimate).
  void _syncAnimation() {
    if (!_shouldAnimate) {
      _controller.stop(canceled: false);
      return;
    }

    if (widget.loop > 0 && _completedLoops >= widget.loop) {
      return;
    }

    if (_controller.isAnimating) return;

    if (widget.loop <= 0 && widget.bounce) {
      _resumeBounce();
      return;
    }

    // For infinite non-bounce loops, use repeat() for seamless looping.
    // This avoids the visible jump that occurs when forward() completes
    // and we call repeat() (which resets to 0.0).
    if (widget.loop <= 0) {
      _controller.repeat();
      return;
    }

    // Finite loops: restart from 0 if at the end.
    if (_controller.value >= 1.0) {
      _controller.forward(from: 0.0);
      return;
    }

    // Otherwise, resume from current position.
    _controller.forward();
  }

  void _resumeBounce() {
    final status = _controller.status;
    if (status == AnimationStatus.reverse ||
        status == AnimationStatus.completed) {
      _controller.reverse();
      return;
    }

    _controller.forward();
  }

  void _handleStatus(AnimationStatus status) {
    // Infinite looping with bounce: reverse at each end.
    if (widget.loop <= 0) {
      if (widget.bounce) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      }
      // Non-bounce infinite loops use repeat() in _syncAnimation,
      // which handles looping internally without firing completed status.
      return;
    }

    if (status != AnimationStatus.completed) return;

    // Finite looping.
    _completedLoops++;
    if (_completedLoops < widget.loop) {
      _controller.forward(from: 0.0);
    } else {
      // Completed requested loops.
      widget.onAnimationComplete?.call();
    }
  }

  /// Manually starts the animation from the beginning.
  void start() {
    _completedLoops = 0;
    _controller.forward(from: 0.0);
  }

  /// Manually stops the animation at the current frame.
  void stop() => _controller.stop(canceled: false);

  /// Resets the animation to the beginning and clears the loop count.
  void reset() {
    _completedLoops = 0;
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context);

    // We use AnimatedBuilder to drive the repaint of the render object.
    final content = AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double percent = _reducedMotion
            ? widget.staticPercent
            : _animation.value;
        return _ShimmerRenderWidget(
          percent: percent,
          direction: widget.direction,
          gradient: widget.gradient,
          blendMode: widget.blendMode,
          textDirection: textDirection,
          child: child,
        );
      },
    );

    // Wraps in RepaintBoundary if requested to isolate layout/paint cycles.
    if (!widget.repaintBoundary) return content;
    return RepaintBoundary(child: content);
  }
}

/// A strictly internal widget that bridges the Widget layer to the RenderObject layer.
///
/// It passes the animation value ([percent]) and configuration down to the
/// [_ShimmerRenderBox] which handles the actual painting.
@immutable
class _ShimmerRenderWidget extends SingleChildRenderObjectWidget {
  const _ShimmerRenderWidget({
    required this.percent,
    required this.direction,
    required this.gradient,
    required this.blendMode,
    required this.textDirection,
    super.child,
  });

  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;
  final BlendMode blendMode;
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ShimmerRenderBox(
      percent: percent,
      direction: direction,
      gradient: gradient,
      blendMode: blendMode,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _ShimmerRenderBox renderObject,
  ) {
    renderObject
      ..percent = percent
      ..direction = direction
      ..gradient = gradient
      ..blendMode = blendMode
      ..textDirection = textDirection;
  }
}

/// The render object responsible for painting the shimmer effect.
///
/// It uses a [ShaderMaskLayer] to apply the gradient.
class _ShimmerRenderBox extends RenderProxyBox {
  _ShimmerRenderBox({
    required double percent,
    required ShimmerDirection direction,
    required Gradient gradient,
    required BlendMode blendMode,
    required TextDirection? textDirection,
  }) : _percent = percent,
       _direction = direction,
       _gradient = gradient,
       _blendMode = blendMode,
       _textDirection = textDirection;

  double _percent;
  ShimmerDirection _direction;
  Gradient _gradient;
  BlendMode _blendMode;
  TextDirection? _textDirection;

  // Cache to avoid recreating the shader every frame if not needed.
  Shader? _cachedShader;
  Rect? _cachedRect;
  Gradient? _cachedGradient;
  Gradient? _cachedRepeatedGradient;
  TextDirection? _cachedTextDirection;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double value) {
    if (value == _percent) return;
    _percent = value;
    _invalidateShaderCache();
    markNeedsPaint();
  }

  set direction(ShimmerDirection value) {
    if (value == _direction) return;
    _direction = value;
    _invalidateShaderCache();
    markNeedsPaint();
  }

  set gradient(Gradient value) {
    if (value == _gradient) return;
    _gradient = value;
    _cachedRepeatedGradient = null;
    _invalidateShaderCache();
    markNeedsPaint();
  }

  set blendMode(BlendMode value) {
    if (value == _blendMode) return;
    _blendMode = value;
    markNeedsPaint();
  }

  set textDirection(TextDirection? value) {
    if (value == _textDirection) return;
    _textDirection = value;
    _invalidateShaderCache();
    markNeedsPaint();
  }

  void _invalidateShaderCache() {
    _cachedShader = null;
    _cachedRect = null;
    _cachedGradient = null;
    _cachedTextDirection = null;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childRenderBox = child;
    if (childRenderBox == null) {
      layer = null;
      return;
    }

    final Size childSize = childRenderBox.size;
    if (childSize.isEmpty) {
      layer = null;
      return;
    }

    assert(needsCompositing);

    final Rect shaderRect = _calculateShaderRect(childSize);
    final Shader shader = _getOrCreateShader(shaderRect);

    // We use a dedicated ShaderMaskLayer for efficiency.
    final ShaderMaskLayer activeLayer = layer ?? ShaderMaskLayer();
    activeLayer
      ..shader = shader
      ..maskRect = offset & size
      ..blendMode = _blendMode;

    context.pushLayer(activeLayer, super.paint, offset);
    layer = activeLayer;
  }

  Shader _getOrCreateShader(Rect rect) {
    // If rect/gradient/textDirection are unchanged, reuse shader.
    if (_cachedShader != null &&
        _cachedRect == rect &&
        identical(_cachedGradient, _gradient) &&
        _cachedTextDirection == _textDirection) {
      return _cachedShader!;
    }

    final td = _textDirection ?? TextDirection.ltr;

    // Use cached repeated gradient to avoid allocation every frame.
    _cachedRepeatedGradient ??= _toRepeatedGradient(_gradient);

    // Use repeated tile mode for seamless looping. When the gradient
    // travels one full period, TileMode.repeated ensures the pattern
    // continues smoothly across the loop boundary.
    _cachedShader = _cachedRepeatedGradient!.createShader(
      rect,
      textDirection: td,
    );
    _cachedRect = rect;
    _cachedGradient = _gradient;
    _cachedTextDirection = _textDirection;

    return _cachedShader!;
  }

  /// Converts a gradient to use [TileMode.repeated] for seamless looping.
  Gradient _toRepeatedGradient(Gradient gradient) {
    if (gradient is LinearGradient) {
      if (gradient.tileMode == TileMode.repeated) return gradient;
      return LinearGradient(
        colors: gradient.colors,
        stops: gradient.stops,
        begin: gradient.begin,
        end: gradient.end,
        tileMode: TileMode.repeated,
        transform: gradient.transform,
      );
    }
    if (gradient is RadialGradient) {
      if (gradient.tileMode == TileMode.repeated) return gradient;
      return RadialGradient(
        colors: gradient.colors,
        stops: gradient.stops,
        center: gradient.center,
        radius: gradient.radius,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        tileMode: TileMode.repeated,
        transform: gradient.transform,
      );
    }
    if (gradient is SweepGradient) {
      if (gradient.tileMode == TileMode.repeated) return gradient;
      return SweepGradient(
        colors: gradient.colors,
        stops: gradient.stops,
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        tileMode: TileMode.repeated,
        transform: gradient.transform,
      );
    }
    return gradient;
  }

  /// Calculates the geometry of the sliding gradient based on direction and percent.
  ///
  /// The gradient rect is 3x the size of the child. Combined with [TileMode.repeated],
  /// the gradient travels exactly one full period (3x size) for seamless looping.
  Rect _calculateShaderRect(Size size) {
    final double width = size.width;
    final double height = size.height;

    // Travel distance equals gradient rect size (3x) for seamless tiling.
    // At percent=0: rect positioned so visible area sees one part of the pattern.
    // At percent=1: rect has moved exactly one full gradient width, so with
    // TileMode.repeated, the visible area shows the same pattern as percent=0.
    return switch (_direction) {
      ShimmerDirection.ltr => Rect.fromLTWH(
        _lerp(-width * 2, width, _percent),
        0.0,
        width * 3,
        height,
      ),
      ShimmerDirection.rtl => Rect.fromLTWH(
        _lerp(width, -width * 2, _percent),
        0.0,
        width * 3,
        height,
      ),
      ShimmerDirection.ttb => Rect.fromLTWH(
        0.0,
        _lerp(-height * 2, height, _percent),
        width,
        height * 3,
      ),
      ShimmerDirection.btt => Rect.fromLTWH(
        0.0,
        _lerp(height, -height * 2, _percent),
        width,
        height * 3,
      ),
    };
  }

  static double _lerp(double start, double end, double t) =>
      start + (end - start) * t;

  @override
  void dispose() {
    _invalidateShaderCache();
    super.dispose();
  }
}

/// A convenience widget that swaps between a skeleton loader and the actual content.
///
/// [ShimmerLoading] manages the cross-fade transition between the `isLoading` state
/// (showing [placeholder] with shimmer) and the loaded state (showing [child]).
///
/// ### Usage
/// ```dart
/// ShimmerLoading(
///   isLoading: _users == null,
///   placeholder: UserSkeleton(),
///   child: UserList(users: _users),
/// );
/// ```
@immutable
class ShimmerLoading extends StatelessWidget {
  /// Creates a widget that manages the loading state and transitions.
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
    required this.placeholder,
    this.baseColor,
    this.highlightColor,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.bounce = false,
    this.curve = Curves.linear,
    this.fadeTransition = true,
    this.fadeDuration = const Duration(milliseconds: 250),
    this.respectReducedMotion = true,
  });

  /// Whether the data is currently being fetched.
  ///
  /// *   `true`: Shows the [placeholder] wrapped in a [Shimmer].
  /// *   `false`: Shows the [child].
  final bool isLoading;

  /// The widget to display when data is ready.
  final Widget child;

  /// The "skeleton" widget to display while loading.
  final Widget placeholder;

  /// Optional override for the shimmer base color. Defaults to [Colors.grey[300]].
  final Color? baseColor;

  /// Optional override for the shimmer highlight color. Defaults to [Colors.grey[100]].
  final Color? highlightColor;

  /// Direction of the shimmer animation.
  final ShimmerDirection direction;

  /// Duration of the shimmer animation cycle.
  final Duration period;

  /// Whether to reverse direction on each cycle (only for infinite loops).
  final bool bounce;

  /// Curve of the shimmer animation.
  final Curve curve;

  /// Whether to cross-fade between placeholder and child.
  ///
  /// Defaults to `true`.
  final bool fadeTransition;

  /// The duration of the cross-fade if [fadeTransition] is true.
  final Duration fadeDuration;

  /// Whether to disable animation if the user has requested reduced motion.
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dark mode defaults: darker base, slightly lighter highlight.
    final defaultBase = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final defaultHighlight = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    final effectiveBase = baseColor ?? defaultBase;
    final effectiveHighlight = highlightColor ?? defaultHighlight;

    final Widget current = isLoading
        ? Shimmer.fromColors(
            baseColor: effectiveBase,
            highlightColor: effectiveHighlight,
            direction: direction,
            period: period,
            bounce: bounce,
            curve: curve,
            respectReducedMotion: respectReducedMotion,
            child: placeholder,
          )
        : child;

    if (!fadeTransition) return current;

    // Uses a ValueKey to ensure the AnimatedSwitcher detects the change.
    return AnimatedSwitcher(
      duration: fadeDuration,
      child: KeyedSubtree(key: ValueKey<bool>(isLoading), child: current),
    );
  }
}

// -----------------------------------------------------------------------------
// Skeleton widgets
// -----------------------------------------------------------------------------

/// A simple rectangular skeleton, commonly used to represent lines of text.
@immutable
class SkeletonLine extends StatelessWidget {
  /// Creates a rounded rectangle skeleton.
  const SkeletonLine({
    super.key,
    this.width = double.infinity,
    this.height = 14.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  /// The width of the line. Defaults to infinity (fills available space).
  final double width;

  /// The height of the line. Defaults to 14.0.
  final double height;

  /// The border radius of the line. Defaults to 4.0 circular.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // The actual color is irrelevant - the shimmer gradient masks over it.
        // White is used for visibility in DevTools widget inspector.
        color: Colors.white,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// A circular skeleton, commonly used to represent avatars or icons.
@immutable
class SkeletonAvatar extends StatelessWidget {
  /// Creates a circular skeleton.
  const SkeletonAvatar({super.key, this.size = 40.0});

  /// The diameter of the circle. Defaults to 40.0.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        // The actual color is irrelevant - the shimmer gradient masks over it.
        // White is used for visibility in DevTools widget inspector.
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A rectangular skeleton for larger content like images or cards.
@immutable
class SkeletonBox extends StatelessWidget {
  /// Creates a rectangular skeleton.
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  /// The width of the box.
  final double width;

  /// The height of the box.
  final double height;

  /// The border radius of the box. Defaults to 8.0 circular.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // The actual color is irrelevant - the shimmer gradient masks over it.
        // White is used for visibility in DevTools widget inspector.
        color: Colors.white,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// A composite skeleton widget mimicking a standard [ListTile].
///
/// Includes an optional leading avatar, a title line, and an optional subtitle line.
@immutable
class SkeletonListTile extends StatelessWidget {
  /// Creates a list tile skeleton.
  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasSubtitle = true,
    this.leadingSize = 40.0,
    this.titleWidthFactor = 0.72,
    this.subtitleWidthFactor = 0.52,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) : assert(
         titleWidthFactor > 0 && titleWidthFactor <= 1,
         'titleWidthFactor must be in the range (0.0, 1.0].',
       ),
       assert(
         subtitleWidthFactor > 0 && subtitleWidthFactor <= 1,
         'subtitleWidthFactor must be in the range (0.0, 1.0].',
       );

  /// Whether to show a leading avatar.
  final bool hasLeading;

  /// Whether to show a subtitle line.
  final bool hasSubtitle;

  /// The size of the leading avatar. Defaults to 40.0.
  final double leadingSize;

  /// The width of the title line as a fraction of available width (0.0 to 1.0).
  final double titleWidthFactor;

  /// The width of the subtitle line as a fraction of available width (0.0 to 1.0).
  final double subtitleWidthFactor;

  /// The padding surrounding the list tile.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (hasLeading) ...[
            SkeletonAvatar(size: leadingSize),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: titleWidthFactor,
                  child: const SkeletonLine(height: 14),
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: subtitleWidthFactor,
                    child: const SkeletonLine(height: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A composite skeleton widget representing a paragraph of text.
///
/// Generates multiple [SkeletonLine]s with a shorter last line to simulate
/// natural text flow.
@immutable
class SkeletonParagraph extends StatelessWidget {
  /// Creates a paragraph skeleton.
  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 14.0,
    this.spacing = 8.0,
    this.lastLineWidthFactor = 0.65,
  }) : assert(lines > 0, 'lines must be at least 1.'),
       assert(
         lastLineWidthFactor > 0 && lastLineWidthFactor <= 1,
         'lastLineWidthFactor must be in the range (0.0, 1.0].',
       );

  /// The number of lines to show.
  final int lines;

  /// The height of each line.
  final double lineHeight;

  /// The vertical spacing between lines.
  final double spacing;

  /// The width of the last line as a fraction of the others (0.0 to 1.0).
  final double lastLineWidthFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final bool isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: FractionallySizedBox(
            widthFactor: isLast ? lastLineWidthFactor : 1.0,
            child: SkeletonLine(height: lineHeight),
          ),
        );
      }),
    );
  }
}
