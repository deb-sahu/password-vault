import 'dart:math';

String generateStrongPassword() {
  const int length = 12;
  const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
  const String digits = '0123456789';
  const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  String allChars = uppercase + lowercase + digits + specialChars;
  Random rnd = Random();

  String password = '';

  // Ensure at least one character from each category
  password += uppercase[rnd.nextInt(uppercase.length)];
  password += lowercase[rnd.nextInt(lowercase.length)];
  password += digits[rnd.nextInt(digits.length)];
  password += specialChars[rnd.nextInt(specialChars.length)];

  // Fill the rest with random characters
  for (int i = 4; i < length; i++) {
    password += allChars[rnd.nextInt(allChars.length)];
  }

  // Shuffle to avoid predictable pattern
  return String.fromCharCodes(password.runes.toList()..shuffle());
}
