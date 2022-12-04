import 'package:flutter/material.dart';

import 'package:hotel_database_app/provider/hotel_service.dart';

import 'package:hotel_database_app/screens/confirm/confirm_screen.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? roomIndex;
  List<dynamic> rooms1 = [];

  int? _children;
  int? _adults;
  String _room = 'Выберите вид номера ';

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HotelModel>(context);
    rooms1.clear();
    rooms1.addAll(model.hotels!.rooms!);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.cyan,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                model.hotels!.imagePath!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Число посетителей:',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Взрослых:'),
                      SizedBox(
                        width: 20,
                        height: 150,
                        child: NumberPicker(
                          minValue: 0,
                          maxValue: 5,
                          value: _adults == null ? 0 : _adults!,
                          onChanged: (value) => setState(() => _adults = value),
                        ),
                      ),
                      Text('Детей:'),
                      SizedBox(
                        width: 20,
                        height: 150,
                        child: NumberPicker(
                          minValue: 0,
                          maxValue: 5,
                          value: _children == null ? 0 : _children!,
                          onChanged: (value) => setState(
                            () => _children = value,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(
                  //   height: 20,
                  // ),
                  Row(
                    children: [
                      Text(
                        'Вид номера: ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_room',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Выберите вид номера:'),
                            content: Container(
                              width: 300,
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: rooms1.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return TextButton(
                                    onPressed: () {
                                      setState(() {
                                        roomIndex = i;
                                        _room = model.hotels!.rooms![i];

                                        Navigator.pop(context, false);
                                      });
                                    },
                                    child: Text(
                                      '${rooms1[i]}',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Выбрать',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'Далее',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (roomIndex != null &&
                                _children != null &&
                                _adults != null) {
                              model.setIndex(roomIndex!);
                              model.setPeopleCount(_adults!, _children!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmScreenWidget(),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Ошибка'),
                                    content: Container(
                                        width: 200,
                                        height: 100,
                                        child: Text(
                                          'Сначала выберите вид номера и колличество посетителей',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  );
                                },
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
