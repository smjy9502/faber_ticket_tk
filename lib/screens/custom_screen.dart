import 'package:flutter/material.dart';
import 'package:faber_ticket_tk/services/firebase_service.dart';
import 'package:faber_ticket_tk/screens/main_screen.dart';
import 'package:faber_ticket_tk/utils/constants.dart';

class CustomScreen extends StatefulWidget {
  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  int _rating = 0; // 평점
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController rowController = TextEditingController();
  final TextEditingController seatController = TextEditingController();

  Future<void> saveData() async {
    try {
      Map<String, dynamic> data = {
        'rating': _rating,
        'review': reviewController.text,
        'section': sectionController.text,
        'row': rowController.text,
        'seat': seatController.text,
      };
      await _firebaseService.saveCustomData(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully!')));
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.ticketBackImage),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter, // 배경 이미지를 화면 상단에 맞춤
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back 버튼 (화면 좌측 상단)
              Positioned(
                top: 5, // 화면 최상단에 위치하도록 조정
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                ),
              ),
              // Save 버튼 (화면 우측 상단)
              Positioned(
                top: 21, // 화면 최상단에 위치하도록 조정
                right: 29,
                child: ElevatedButton(
                  onPressed: saveData,
                  child: Text('Save'),
                ),
              ),
              // Rate (평점 기능)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.68, // 이미지 위치를 아래로 이동
                left: MediaQuery.of(context).size.width * 0.5 - 125, // 이미지 위치 조정
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 이미지 간격 조정
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (index < _rating) {
                            _rating = index + 1;
                          } else if (index == _rating) {
                            _rating = index;
                          } else {
                            _rating = index + 1;
                          }
                        });
                      },
                      child: Image.asset(
                        index < _rating ? Constants.petalFullImage : Constants.petalEmptyImage,
                        width: 45, // 이미지 크기 조정
                        height: 45,
                      ),
                    );
                  }).map((child) => [child, SizedBox(width: 10)]).expand((pair) => pair).toList(),
                ),
              ),
              // Review 입력
              Positioned(
                top: MediaQuery.of(context).size.height * 0.815, // 이미지 상의 "Review" 위치
                left: MediaQuery.of(context).size.width * 0.5 - 200,
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: reviewController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write your review",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none, // 밑줄 제거
                    ),
                  ),
                ),
              ),
              // Section, Row, Seat 입력
              Positioned(
                top: MediaQuery.of(context).size.height * 0.917, // 이미지 상의 "Section", "Row", "Seat" 위치
                left: MediaQuery.of(context).size.width * 0.12,
                right: MediaQuery.of(context).size.width * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4.9),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                          textAlign: TextAlign.center, // 텍스트 중간 정렬
                          controller: sectionController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Section",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // 밑줄 제거
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: TextField(
                        textAlign: TextAlign.center, // 텍스트 중간 정렬
                        controller: rowController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Row",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, // 밑줄 제거
                        ),
                      ),
                    ),
                    // SizedBox(width: 20,),
                    Padding(
                      padding: EdgeInsets.only(right: 4.9),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                          textAlign: TextAlign.center, // 텍스트 중간 정렬
                          controller: seatController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Seat",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // 밑줄 제거
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
