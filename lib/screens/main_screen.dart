import 'package:flutter/material.dart';
import 'package:faber_ticket_tk/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:faber_ticket_tk/screens/custom_screen.dart';
import 'package:faber_ticket_tk/widgets/custom_button.dart';
import 'package:faber_ticket_tk/services/firebase_service.dart';
import 'error_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ImageProvider? _mainBackground;

  @override
  void initState() {
    super.initState();
    _loadMainBackground();
  }

  Future<void> _loadMainBackground() async {
    try {
      final urlParams = Uri.base.queryParameters;
      final mainBackground = urlParams['cm'];

      if (mainBackground != null) {
        final ref = FirebaseStorage.instance.ref("images/$mainBackground");
        final url = await ref.getDownloadURL();
        print("이미지 URL: $url"); // 성공 로그
        setState(() => _mainBackground = NetworkImage(url));
      } else {
        throw Exception('Custom Image 파라미터 없음');
      }
    } catch (e) {
      print("이미지 로드 실패: $e"); // 실패 로그
      setState(() => _mainBackground = AssetImage(Constants.ticketFrontImage));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainBackground == null
          ? Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: _mainBackground!,
            image: _mainBackground ?? AssetImage(Constants.ticketFrontImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomScreen()),
                ),
                child: Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
