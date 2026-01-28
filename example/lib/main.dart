import 'package:flutter/material.dart';
import 'package:flutter_contrast_checker/flutter_contrast_checker.dart';

void main() {
  runApp(const ContrastDemoApp());
}

class ContrastDemoApp extends StatelessWidget {
  const ContrastDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrast Checker Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)), useMaterial3: true),
      builder: (context, child) =>
          ContrastCheckerOverlay(initialForeground: Colors.red, initialBackground: Colors.white, child: child!),
      initialRoute: '/',
      routes: {'/': (context) => const ContrastDemoHome(), '/details': (context) => const ContrastDetailScreen()},
    );
  }
}

class ContrastDemoHome extends StatelessWidget {
  const ContrastDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contrast Checker')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Tap the floating target to sample two colors on screen.\n'
            'Long-press the button to drag it anywhere.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/details'),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open second screen'),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20)),
            child: const Text(
              'Dark card with bright copy',
              style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Text(
              'Warm pastel surface with darker text',
              style: TextStyle(color: Color(0xFF92400E), fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF14B8A6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFFB7185)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContrastDetailScreen extends StatelessWidget {
  const ContrastDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF334155)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text(
              'High contrast hero section',
              style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(18)),
            child: const Text(
              'Soft blue panel with slate text',
              style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: const Color(0xFFFAE8FF), borderRadius: BorderRadius.circular(18)),
                  child: const Center(
                    child: Text(
                      'Lavender',
                      style: TextStyle(color: Color(0xFF701A75), fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(18)),
                  child: const Center(
                    child: Text(
                      'Sky',
                      style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
