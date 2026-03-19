import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:track_me/core/routing/route_names.dart';
import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/core/widgets/section_header_widget.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:track_me/features/profile/presentation/providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _goalsController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  String _level = 'intermediate';
  bool _isSaving = false;
  bool _populated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _goalsController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalsController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _populateFields(dynamic profile) {
    if (profile == null || _populated) return;
    _populated = true;
    if (profile.name != null) _nameController.text = profile.name!;
    if (profile.goals != null) _goalsController.text = profile.goals!;
    if (profile.weightKg != null) {
      _weightController.text = profile.weightKg!.toString();
    }
    if (profile.heightCm != null) {
      _heightController.text = profile.heightCm!.toString();
    }
    if (profile.level != null) _level = profile.level!;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'name': _nameController.text.trim(),
            'goals': _goalsController.text.trim(),
            'weight_kg': double.tryParse(_weightController.text),
            'height_cm': double.tryParse(_heightController.text),
            'level': _level,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authServiceProvider).signOut();
    if (mounted) context.go(RouteNames.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    return Column(
      children: [
        AppBar(title: const Text('Profile')),
        Expanded(
          child: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (profile) {
              _populateFields(profile);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Profile header
                          Center(
                            child: Column(
                              children: [
                                // Avatar with gradient ring
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      color: AppTheme.surface,
                                      child: user?.photoURL != null
                                          ? Image.network(
                                              user!.photoURL!,
                                              width: 72,
                                              height: 72,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) => Center(
                                                child: Text(
                                                  _getInitials(
                                                    user.displayName,
                                                  ),
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        color: AppTheme
                                                            .primaryGreen,
                                                      ),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                _getInitials(user?.displayName),
                                                style: theme
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color:
                                                          AppTheme.primaryGreen,
                                                    ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (user?.email != null)
                                  Text(
                                    user!.email!,
                                    style: theme.textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Personal Info section
                          const SectionHeader(
                            label: 'Personal Info',
                            color: AppTheme.primaryGreen,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Body Metrics section
                          const SectionHeader(
                            label: 'Body Metrics',
                            color: AppTheme.primaryGreen,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _weightController,
                                          decoration: const InputDecoration(
                                            labelText: 'Weight (kg)',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _heightController,
                                          decoration: const InputDecoration(
                                            labelText: 'Height (cm)',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Level selector chips
                                  Row(
                                    children: [
                                      Text(
                                        'Level',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _LevelChip(
                                        label: 'Beginner',
                                        isSelected: _level == 'beginner',
                                        onTap: () =>
                                            setState(() => _level = 'beginner'),
                                      ),
                                      const SizedBox(width: 8),
                                      _LevelChip(
                                        label: 'Intermediate',
                                        isSelected: _level == 'intermediate',
                                        onTap: () => setState(
                                          () => _level = 'intermediate',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _LevelChip(
                                        label: 'Advanced',
                                        isSelected: _level == 'advanced',
                                        onTap: () =>
                                            setState(() => _level = 'advanced'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Training Goals section
                          const SectionHeader(
                            label: 'Training Goals',
                            color: AppTheme.primaryGreen,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                controller: _goalsController,
                                decoration: const InputDecoration(
                                  labelText: 'Goals',
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Save button with gradient
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: _isSaving
                                  ? null
                                  : AppTheme.primaryGradient,
                              color: _isSaving ? AppTheme.surfaceBright : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: _isSaving ? null : _save,
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Save Profile',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign out
                          const Divider(),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: _signOut,
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text('Sign Out'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.error,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
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

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? AppTheme.primaryGreen : AppTheme.card,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
