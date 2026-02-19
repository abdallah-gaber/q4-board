import 'package:flutter/material.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import '../../../domain/enums/quadrant_type.dart';

class QuadrantVisual {
  const QuadrantVisual({
    required this.icon,
    required this.accentColor,
    required this.paperColor,
    required this.titleBuilder,
    required this.labelBuilder,
  });

  final IconData icon;
  final Color accentColor;
  final Color paperColor;
  final String Function(AppLocalizations) titleBuilder;
  final String Function(AppLocalizations) labelBuilder;

  String title(AppLocalizations l10n) => titleBuilder(l10n);

  String actionLabel(AppLocalizations l10n) => labelBuilder(l10n);

  Color panelTint(Brightness brightness) {
    final opacity = brightness == Brightness.dark ? 0.16 : 0.1;
    return accentColor.withValues(alpha: opacity);
  }

  Color cardTint(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return Color.alphaBlend(
        accentColor.withValues(alpha: 0.08),
        const Color(0xFF1D222A),
      );
    }
    return Color.alphaBlend(accentColor.withValues(alpha: 0.09), paperColor);
  }
}

QuadrantVisual quadrantVisualFor(QuadrantType type) {
  switch (type) {
    case QuadrantType.iu:
      return const QuadrantVisual(
        icon: Icons.bolt_rounded,
        accentColor: Color(0xFFCC6B73),
        paperColor: Color(0xFFFFFAF1),
        titleBuilder: _q1,
        labelBuilder: _q1Label,
      );
    case QuadrantType.inu:
      return const QuadrantVisual(
        icon: Icons.event_available_rounded,
        accentColor: Color(0xFF5F9B87),
        paperColor: Color(0xFFF2FBF6),
        titleBuilder: _q2,
        labelBuilder: _q2Label,
      );
    case QuadrantType.niu:
      return const QuadrantVisual(
        icon: Icons.support_agent_rounded,
        accentColor: Color(0xFFC69663),
        paperColor: Color(0xFFFFF7EC),
        titleBuilder: _q3,
        labelBuilder: _q3Label,
      );
    case QuadrantType.ninu:
      return const QuadrantVisual(
        icon: Icons.block_rounded,
        accentColor: Color(0xFF6F8FA6),
        paperColor: Color(0xFFF3F8FF),
        titleBuilder: _q4,
        labelBuilder: _q4Label,
      );
  }
}

String _q1(AppLocalizations l10n) => l10n.q1Title;
String _q2(AppLocalizations l10n) => l10n.q2Title;
String _q3(AppLocalizations l10n) => l10n.q3Title;
String _q4(AppLocalizations l10n) => l10n.q4Title;

String _q1Label(AppLocalizations l10n) => l10n.q1Label;
String _q2Label(AppLocalizations l10n) => l10n.q2Label;
String _q3Label(AppLocalizations l10n) => l10n.q3Label;
String _q4Label(AppLocalizations l10n) => l10n.q4Label;
