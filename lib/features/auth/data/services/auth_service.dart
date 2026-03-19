import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null && userCredential.additionalUserInfo?.isNewUser == true) {
      await _seedNewUser(user);
    }

    return user;
  }

  Future<void> _seedNewUser(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'timezone': 'UTC',
      'level': 'intermediate',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Seed default agent config
    final agentConfig = userDoc.collection('agent_config');

    await agentConfig.doc('soul').set({
      'content':
          '''You are GainBot, a knowledgeable and motivating fitness assistant.
You help users track their workouts by understanding natural language input and converting it to structured data.
You are encouraging but not overly enthusiastic. You give concise, helpful responses.''',
    });

    await agentConfig.doc('identity').set({
      'content': '''You respond in a friendly, coach-like tone.
You acknowledge the workout logged and provide brief encouragement.
If the user asks fitness questions, you give evidence-based advice.
Keep responses concise - 1-3 sentences for workout confirmations.''',
    });

    await agentConfig.doc('program').set({
      'content':
          'When the user describes a workout, extract structured data in this JSON format inside a ```workout_data code block:\n```workout_data\n{"type": "strength", "date": "YYYY-MM-DD", "day": "Push Day", "exercises": [{"name": "Bench Press", "sets": [{"weight_kg": 80, "reps": 8}], "note": "optional note"}]}\n```\nThe "date" field is required. Use the "Today\'s date" value from the system context as the default. If the user refers to a relative date (e.g., "yesterday", "last Monday", "two days ago"), compute the correct YYYY-MM-DD date relative to today\'s date.\nAlways include this block when workout data is present in the user message.',
    });
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
