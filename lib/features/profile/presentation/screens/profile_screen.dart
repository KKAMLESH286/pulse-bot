import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:track_me/core/routing/route_names.dart';
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

    return Column(
      children: [
        AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
          ],
        ),
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
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _goalsController,
                            decoration: const InputDecoration(
                              labelText: 'Goals',
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _level,
                            decoration: const InputDecoration(
                              labelText: 'Level',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'beginner',
                                child: Text('Beginner'),
                              ),
                              DropdownMenuItem(
                                value: 'intermediate',
                                child: Text('Intermediate'),
                              ),
                              DropdownMenuItem(
                                value: 'advanced',
                                child: Text('Advanced'),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _level = v ?? 'intermediate'),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save Profile'),
                          ),
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
}
