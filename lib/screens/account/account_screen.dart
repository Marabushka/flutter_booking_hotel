import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_database_app/screens/auth/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var name = AuthService().getCurrentUser?.email;

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: collection.doc('${name}st').get(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              var output = snapshot.data!.data();

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.2,
                          horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            'Личный кабинет',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          Text(
                            'Здравствуйте! ${output!['name']}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ваше имя:',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text('${output['name']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ваша фамилия:',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text('${output['surname']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ваш email:',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text('${output['email']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Вы забронировали:',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          output['bookingDate'].toString().length > 2
                              ? bookingInfo(
                                  context,
                                  output['adults'],
                                  output['children'],
                                  output['room'],
                                  output['hotel'],
                                  output['imagePath'],
                                  output['bookingDate'],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Назад',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

Widget bookingInfo(
  BuildContext context,
  String adults,
  String children,
  String room,
  String hotelName,
  String imagePath,
  List<dynamic> bookingDate,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.cyan.withOpacity(0.3),
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    height: 100,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            bottomLeft: const Radius.circular(15.0),
          ), // BorderRadius
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          // width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotelName,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text('Взрослых: $adults '),
                  Text('Детей: $children'),
                ],
              ),
              Text('Номер: $room'),
              Text('c ${bookingDate[0]} по ${bookingDate[1]}')
            ],
          ),
        ),
      ],
    ),
  );
}
