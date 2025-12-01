import 'dart:io';

import 'package:quiver/strings.dart';

const sessionTokenPath = '.dart_tool/aoc/.session_token';

Future<String> getSessionToken() async {
  final sessionToken = _readSessionToken();
  if (sessionToken != null) {
    return sessionToken;
  }

  final token = _promptSessionToken();
  await _writeSessionToken(token);
  return token;
}

String? _readSessionToken() {
  try {
    final token = File(sessionTokenPath).readAsStringSync();
    if (token.isNotEmpty) {
      return token;
    }
  } on Exception catch (e) {
    print('Error reading session token: $e');
  }
  return null;
}

Future<void> _writeSessionToken(String token) async {
  try {
    final file = await File(sessionTokenPath).create(recursive: true);
    file.writeAsStringSync(token);
  } on Exception catch (e) {
    print('Error writing session token: $e');
  }
}

String _promptSessionToken() {
  stdout.write(_kSessionTokenPromptMessage);
  final token = stdin.readLineSync();
  stdout.writeln();
  if (isBlank(token)) {
    print('Session token cannot be empty!');
    return _promptSessionToken();
  }
  return token!;
}

const String _kSessionTokenPromptMessage = '''
  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                          Session token required!                           ║
  ║                                                                            ║
  ║  Please visit https://adventofcode.com and log in.                         ║
  ║                                                                            ║
  ║  Once logged in, get your session token from the cookie:                   ║
  ║  1. Open DevTools (F12)                                                    ║
  ║  2. Go to Application > Cookies > https://adventofcode.com                 ║
  ║  3. Copy the value of the `session` cookie                                 ║
  ║                                                                            ║
  ╚════════════════════════════════════════════════════════════════════════════╝

  Please enter your session token:
  ''';
