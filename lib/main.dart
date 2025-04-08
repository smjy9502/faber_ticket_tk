import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:faber_ticket_tk/screens/main_screen.dart';
import 'package:faber_ticket_tk/screens/error_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously(); // 익명 로그인 추가
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faber Ticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CustomFont',
      ),
      home: FutureBuilder(
        future: checkInitialAccess(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return MainScreen();
          } else {
            return ErrorScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<bool> checkInitialAccess() async {
  if (foundation.kIsWeb) {
    final userAgent = html.window.navigator.userAgent;
    print('User Agent: $userAgent'); // User Agent 출력
    final isMobile = userAgent.contains('Mobile') || userAgent.contains('Android') || userAgent.contains('iPhone') || userAgent.contains('Macintosh');
    if (isMobile) {
      return true; // 모바일 기기에서만 접속 허용
    } else {
      return false;
    }
  } else {
    return true; // 모바일 앱에서는 NFC 기능을 사용하여 접속 제한 (현재는 NFC 관련 코드가 필요하지 않음)
  }
}
