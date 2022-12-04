import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_database_app/entity/hotels.dart';
import 'package:hotel_database_app/provider/hotel_service.dart';
import 'package:hotel_database_app/screens/account/account_screen.dart';

import 'package:hotel_database_app/screens/auth/auth_service.dart';
import 'package:hotel_database_app/screens/hotel_info/hotel_info.dart';
import 'package:hotel_database_app/screens/search/hotel_prewiew_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Hotels> listHotelss = [];
  List<Hotels> listSearchHotels = [];

  String? searchHotelName;
  final TextEditingController _controller = TextEditingController();

  void filterSearchResults() {
    final query = _controller.text;

    if (query.isNotEmpty) {
      listSearchHotels = listHotelss.where((Hotels hotel) {
        return hotel.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      listSearchHotels = listHotelss;
    }
    setState(() {});
  }

  @override
  void initState() {
    listSearchHotels = listHotelss;
    _controller.addListener(filterSearchResults);
    super.initState();
  }

  Widget build(BuildContext context) {
    final model = Provider.of<HotelModel>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Row(
        children: [
          TextButton(
            child: Text(
              'Личный кабинет',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(),
                ),
              );
            },
          ),
          TextButton(
            child: Text(
              'Выйти',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () => AuthService().logOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('hotel1').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            listHotelss.clear();
            for (int i = 0; i < docs.length; i++) {
              listHotelss.add(Hotels.fromJson(docs[i].data()));
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
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
                          'Поиск отеля',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _controller,
                          onChanged: (value) {},
                          onEditingComplete: () {
                            setState(() {
                              searchHotelName = _controller.text;
                              FocusScope.of(context).unfocus();
                            });

                            ;
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: 'Поиск отеля',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listSearchHotels.length,
                    itemBuilder: (BuildContext context, int i) {
                      final data = docs[i].data();

                      return InkWell(
                        onTap: () {
                          model.getHotel(data);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelInfo(),
                            ),
                          );
                        },
                        child: HotelPrewiewWidget(
                          imagePath: listSearchHotels[i].imagePath!,
                          address: listSearchHotels[i].location!,
                          hotelName: listSearchHotels[i].name!,
                          raiting: listSearchHotels[i].raiting!,
                          price: listSearchHotels[i].price!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
