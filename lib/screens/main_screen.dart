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
  Object? _mainBackground;

  @override
  void initState() {
    super.initState();
    _loadMainBackground();
  }

  Future<void> _loadMainBackground() async {
    final urlParams = Uri.parse(Uri.base.toString()).queryParameters;
    final mainBackground = urlParams['CM'];

    if (mainBackground != null) {
      final ref = FirebaseStorage.instance.ref().child("images/$mainBackground");
      final url = await ref.getDownloadURL();
      setState(() {
        _mainBackground = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _mainBackground != null
                    ? _mainBackground as ImageProvider<Object>
                    : AssetImage(Constants.ticketFrontImage) as ImageProvider<Object>,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(60, 25),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomScreen()),
                      );
                    },
                    child: Text('Enter'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
