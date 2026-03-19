import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/core/widgets/empty_state_widget.dart';
import '../providers/program_provider.dart';

class ProgramScreen extends ConsumerWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programContentProvider);

    return Column(
      children: [
        AppBar(title: const Text('My Program')),
        Expanded(
          child: programAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (content) {
              if (content == null || content.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.fitness_center,
                  iconGradient: AppTheme.primaryGradient,
                  title: 'No program yet',
                  subtitle:
                      'Ask your AI coach to create a training program for you',
                  actionLabel: 'Ask Coach',
                  onAction: () => context.go('/chat'),
                );
              }

              return Markdown(
                data: content,
                padding: const EdgeInsets.all(16),
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  h1: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                  h2: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                  h3: GoogleFonts.spaceGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  p: GoogleFonts.inter(
                    fontSize: 15,
                    height: 1.5,
                    color: AppTheme.textPrimary,
                  ),
                  strong: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  em: GoogleFonts.inter(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                  ),
                  code: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.primaryGreenLight,
                    backgroundColor: AppTheme.surfaceLight,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  listBullet: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppTheme.primaryGreen,
                  ),
                  tableHead: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  tableBody: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.surfaceBright, width: 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
