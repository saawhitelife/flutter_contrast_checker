# flutter_contrast_checker

Overlay contrast checker for Flutter apps. It shows a draggable floating button; tapping it reveals two color pickers (powered by eye_dropper) and a modern WCAG contrast card. Close the card to return to the floating button.

## Features

- Always-on draggable overlay trigger (long-press to reposition)
- Dual pickers with lens buttons for text and background colors
- WCAG 2.1 contrast ratio + AA/AAA badges for normal/large text
- Modern, light UI with gradients, blur, and polished elevation

## Getting started

Add the dependency:

```yaml
dependencies:
  flutter_contrast_checker: ^0.0.1
```

## Usage

Wrap your app (or any subtree) with the overlay. It already embeds `EyeDropper`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_contrast_checker/flutter_contrast_checker.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContrastCheckerOverlay(
        child: Scaffold(
          appBar: AppBar(title: const Text('Contrast Demo')),
          body: const Center(child: Text('Tap the floating button')),
        ),
      ),
    );
  }
}
```

## Additional information

The picker uses the `eye_dropper` package under the hood. Use long-press on the floating button to drag it anywhere within the app window.
