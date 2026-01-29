/// Overlay contrast checker for Flutter apps.
///
/// Shows a draggable floating button that opens dual color pickers and a WCAG
/// contrast card. Close the card to return to the button.
library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:eye_dropper/eye_dropper.dart';
import 'package:flutter/material.dart';

import 'contrast_checker_theme.dart';
import 'contrast_utils.dart';

part 'contrast_checker_overlay_color_chip.dart';
part 'contrast_checker_overlay_color_lens_button.dart';
part 'contrast_checker_overlay_contrast_badge.dart';
part 'contrast_checker_overlay_contrast_card.dart';
part 'contrast_checker_overlay_floating_button.dart';
part 'contrast_checker_overlay_lens_row.dart';
part 'contrast_checker_overlay_position.dart';
part 'contrast_checker_overlay_widget.dart';
