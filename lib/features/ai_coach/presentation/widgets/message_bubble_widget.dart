import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/features/ai_coach/data/models/chat_message_model.dart';
import 'workout_card_widget.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, this.userPhotoUrl});
  final ChatMessage message;
  final String? userPhotoUrl;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isUser ? AppTheme.primaryGradient : null,
                      color: isUser ? null : AppTheme.assistantBubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      border: isUser
                          ? null
                          : Border(
                              left: BorderSide(
                                color: AppTheme.primaryGreen.withValues(
                                  alpha: 0.3,
                                ),
                                width: 2,
                              ),
                            ),
                    ),
                    child: isUser
                        ? Text(
                            message.text,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          )
                        : MarkdownBody(
                            data: message.text,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.inter(
                                fontSize: 15,
                                height: 1.4,
                                color: AppTheme.textPrimary,
                              ),
                              strong: GoogleFonts.inter(
                                fontSize: 15,
                                height: 1.4,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              code: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.primaryGreenLight,
                                backgroundColor: AppTheme.surfaceLight,
                              ),
                            ),
                          ),
                  ),
                  if (message.hasWorkoutData)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: WorkoutCard(data: message.workoutData!),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      timeago.format(message.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _UserAvatar(photoUrl: userPhotoUrl),
            ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({this.photoUrl});
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 32,
        height: 32,
        color: AppTheme.surfaceBright,
        child: photoUrl != null
            ? Image.network(
                photoUrl!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              )
            : const Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
      ),
    );
  }
}
