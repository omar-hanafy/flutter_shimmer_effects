import 'package:flutter/material.dart';
import 'package:flutter_shimmer_effects/flutter_shimmer_effects.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimmer Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const ExamplesHomePage(),
    );
  }
}

class ExamplesHomePage extends StatelessWidget {
  const ExamplesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shimmer Examples')),
      body: ListView(
        children: [
          _ExampleTile(
            title: 'Basic Shimmer',
            subtitle: 'Simple shimmer effect with fromColors',
            icon: Icons.gradient,
            onTap: () => _navigate(context, const BasicShimmerPage()),
          ),
          _ExampleTile(
            title: 'Built-in Skeletons',
            subtitle: 'SkeletonLine, SkeletonAvatar, SkeletonBox, etc.',
            icon: Icons.view_agenda,
            onTap: () => _navigate(context, const SkeletonWidgetsPage()),
          ),
          _ExampleTile(
            title: 'ShimmerLoading',
            subtitle: 'Toggle between loading and content states',
            icon: Icons.swap_horiz,
            onTap: () => _navigate(context, const ShimmerLoadingPage()),
          ),
          _ExampleTile(
            title: 'ShimmerController',
            subtitle: 'Control animation programmatically',
            icon: Icons.play_circle,
            onTap: () => _navigate(context, const ShimmerControllerPage()),
          ),
          _ExampleTile(
            title: 'Directions',
            subtitle: 'LTR, RTL, TTB, BTT shimmer directions',
            icon: Icons.swap_calls,
            onTap: () => _navigate(context, const DirectionsPage()),
          ),
          _ExampleTile(
            title: 'Custom Gradient',
            subtitle: 'Use custom gradients for unique effects',
            icon: Icons.color_lens,
            onTap: () => _navigate(context, const CustomGradientPage()),
          ),
          _ExampleTile(
            title: 'Loop & Callback',
            subtitle: 'Finite loops with completion callback',
            icon: Icons.repeat_one,
            onTap: () => _navigate(context, const LoopCallbackPage()),
          ),
          _ExampleTile(
            title: 'List Loading',
            subtitle: 'Realistic list skeleton loading example',
            icon: Icons.list,
            onTap: () => _navigate(context, const ListLoadingPage()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// =============================================================================
// 1. Basic Shimmer
// =============================================================================

class BasicShimmerPage extends StatelessWidget {
  const BasicShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Shimmer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shimmer.fromColors',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('The simplest way to create a shimmer effect:'),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 200,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 250,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Shimmer on Text',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: const Text(
                'Shimmering Text Effect',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2. Built-in Skeleton Widgets
// =============================================================================

class SkeletonWidgetsPage extends StatelessWidget {
  const SkeletonWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Built-in Skeletons')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade400,
          highlightColor: Colors.grey.shade100,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('SkeletonLine'),
              SkeletonLine(),
              SizedBox(height: 8),
              SkeletonLine(width: 200, height: 20),
              SizedBox(height: 24),
              _SectionTitle('SkeletonAvatar'),
              Row(
                children: [
                  SkeletonAvatar(size: 32),
                  SizedBox(width: 12),
                  SkeletonAvatar(size: 48),
                  SizedBox(width: 12),
                  SkeletonAvatar(size: 64),
                ],
              ),
              SizedBox(height: 24),
              _SectionTitle('SkeletonBox'),
              SkeletonBox(width: 120, height: 80),
              SizedBox(height: 24),
              _SectionTitle('SkeletonListTile'),
              SkeletonListTile(),
              SkeletonListTile(hasSubtitle: false),
              SkeletonListTile(hasLeading: false),
              SizedBox(height: 24),
              _SectionTitle('SkeletonParagraph'),
              SkeletonParagraph(lines: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// =============================================================================
// 3. ShimmerLoading - Toggle between loading and content
// =============================================================================

class ShimmerLoadingPage extends StatefulWidget {
  const ShimmerLoadingPage({super.key});

  @override
  State<ShimmerLoadingPage> createState() => _ShimmerLoadingPageState();
}

class _ShimmerLoadingPageState extends State<ShimmerLoadingPage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShimmerLoading')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Loading'),
            subtitle: const Text('Toggle to simulate data loading'),
            value: _isLoading,
            onChanged: (v) => setState(() => _isLoading = v),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ShimmerLoading(
                  isLoading: _isLoading,
                  placeholder: const SkeletonListTile(),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('User ${index + 1}'),
                    subtitle: Text('user${index + 1}@example.com'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. ShimmerController - Programmatic control
// =============================================================================

class ShimmerControllerPage extends StatefulWidget {
  const ShimmerControllerPage({super.key});

  @override
  State<ShimmerControllerPage> createState() => _ShimmerControllerPageState();
}

class _ShimmerControllerPageState extends State<ShimmerControllerPage> {
  late final ShimmerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ShimmerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShimmerController')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Use ShimmerController to start/stop animations '
              'programmatically or synchronize multiple shimmers.',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _controller.start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _controller.stop,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: _controller.toggle,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Toggle'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Multiple shimmers sharing the same controller:'),
            const SizedBox(height: 16),
            // Multiple shimmers controlled by the same controller
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              controller: _controller,
              child: const SkeletonListTile(),
            ),
            Shimmer.fromColors(
              baseColor: Colors.blue.shade200,
              highlightColor: Colors.blue.shade50,
              controller: _controller,
              child: const SkeletonListTile(),
            ),
            Shimmer.fromColors(
              baseColor: Colors.green.shade200,
              highlightColor: Colors.green.shade50,
              controller: _controller,
              child: const SkeletonListTile(),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. Directions
// =============================================================================

class DirectionsPage extends StatelessWidget {
  const DirectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shimmer Directions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final direction in ShimmerDirection.values) ...[
              Text(
                direction.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade100,
                direction: direction,
                child: const SkeletonBox(width: double.infinity, height: 60),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 6. Custom Gradient
// =============================================================================

class CustomGradientPage extends StatelessWidget {
  const CustomGradientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Gradient')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rainbow Shimmer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Shimmer(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                ],
              ),
              child: SkeletonBox(width: double.infinity, height: 80),
            ),
            const SizedBox(height: 32),
            Text(
              'Gold Shimmer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Shimmer(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade700,
                  Colors.amber.shade300,
                  Colors.yellow.shade100,
                  Colors.amber.shade300,
                  Colors.amber.shade700,
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Neon Shimmer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16),
              child: const Shimmer(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.purple,
                    Colors.pink,
                    Colors.purple,
                    Colors.cyan,
                  ],
                ),
                period: Duration(milliseconds: 2000),
                child: Text(
                  'NEON VIBES',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 7. Loop & Callback
// =============================================================================

class LoopCallbackPage extends StatefulWidget {
  const LoopCallbackPage({super.key});

  @override
  State<LoopCallbackPage> createState() => _LoopCallbackPageState();
}

class _LoopCallbackPageState extends State<LoopCallbackPage> {
  int _completedCount = 0;
  int _loopCount = 3;
  Key _shimmerKey = UniqueKey();

  void _resetShimmer() {
    setState(() {
      _completedCount = 0;
      _shimmerKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loop & Callback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a finite loop count and get notified when complete.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Loops: '),
                DropdownButton<int>(
                  value: _loopCount,
                  items: [1, 2, 3, 5, 10]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _loopCount = v!);
                    _resetShimmer();
                  },
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _resetShimmer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Completed: $_completedCount time(s)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Shimmer.fromColors(
                      key: _shimmerKey,
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      loop: _loopCount,
                      onAnimationComplete: () {
                        setState(() => _completedCount++);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Animation completed!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const SkeletonBox(
                        width: double.infinity,
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 8. List Loading - Realistic example
// =============================================================================

class ListLoadingPage extends StatefulWidget {
  const ListLoadingPage({super.key});

  @override
  State<ListLoadingPage> createState() => _ListLoadingPageState();
}

class _ListLoadingPageState extends State<ListLoadingPage> {
  List<Map<String, String>>? _users;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _users = null);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _users = List.generate(
        10,
        (i) => {
          'name': 'User ${i + 1}',
          'email': 'user${i + 1}@example.com',
          'avatar': 'https://i.pravatar.cc/150?img=${i + 1}',
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _users == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Loading'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              bounce: true,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) => const SkeletonListTile(),
              ),
            )
          : ListView.builder(
              itemCount: _users!.length,
              itemBuilder: (context, index) {
                final user = _users![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar']!),
                  ),
                  title: Text(user['name']!),
                  subtitle: Text(user['email']!),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
    );
  }
}
