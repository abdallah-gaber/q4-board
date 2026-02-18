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
    final opacity = brightness == Brightness.dark ? 0.2 : 0.12;
    return accentColor.withValues(alpha: opacity);
  }

  Color cardTint(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return Color.alphaBlend(
        accentColor.withValues(alpha: 0.12),
        const Color(0xFF1D222A),
      );
    }
    return Color.alphaBlend(accentColor.withValues(alpha: 0.16), paperColor);
  }
}

QuadrantVisual quadrantVisualFor(QuadrantType type) {
  switch (type) {
    case QuadrantType.iu:
      return const QuadrantVisual(
        icon: Icons.bolt_rounded,
        accentColor: Color(0xFFD84D57),
        paperColor: Color(0xFFFFF9E9),
        titleBuilder: _q1,
        labelBuilder: _q1Label,
      );
    case QuadrantType.inu:
      return const QuadrantVisual(
        icon: Icons.event_available_rounded,
        accentColor: Color(0xFF2F9E8B),
        paperColor: Color(0xFFEFFAF3),
        titleBuilder: _q2,
        labelBuilder: _q2Label,
      );
    case QuadrantType.niu:
      return const QuadrantVisual(
        icon: Icons.support_agent_rounded,
        accentColor: Color(0xFFE39B45),
        paperColor: Color(0xFFFFF5E7),
        titleBuilder: _q3,
        labelBuilder: _q3Label,
      );
    case QuadrantType.ninu:
      return const QuadrantVisual(
        icon: Icons.block_rounded,
        accentColor: Color(0xFF5F8FB1),
        paperColor: Color(0xFFF0F6FF),
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
