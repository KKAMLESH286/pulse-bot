import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSend});
  final Future<void> Function(String text) onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSending = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _controller.clear();
    try {
      await widget.onSend(text);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBright, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppTheme.primaryGreen.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                onTap: () => setState(() {}),
                onTapOutside: (_) {
                  _focusNode.unfocus();
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: 'What did you train today?',
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: _hasText && !_isSending
                  ? AppTheme.primaryGradient
                  : null,
              color: _hasText && !_isSending ? null : AppTheme.surfaceBright,
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _handleSend,
                customBorder: const CircleBorder(),
                child: Center(
                  child: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: _hasText
                              ? Colors.white
                              : AppTheme.textTertiary,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
