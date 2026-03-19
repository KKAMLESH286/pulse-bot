abstract final class FirestoreConstants {
  static const String usersCollection = 'users';
  static const String messagesSubcollection = 'messages';
  static const String workoutLogsSubcollection = 'workout_logs';
  static const String prsSubcollection = 'prs';
  static const String agentConfigSubcollection = 'agent_config';
}

abstract final class MessageStatus {
  static const String sent = 'sent';
  static const String processing = 'processing';
  static const String done = 'done';
  static const String error = 'error';
}

abstract final class MessageRole {
  static const String user = 'user';
  static const String assistant = 'assistant';
}
