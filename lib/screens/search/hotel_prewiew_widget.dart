import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HotelPrewiewWidget extends StatelessWidget {
  final String hotelName;
  final String address;
  final String raiting;
  final String price;
  final String imagePath;

  const HotelPrewiewWidget({
    Key? key,
    required this.address,
    required this.imagePath,
    required this.price,
    required this.hotelName,
    required this.raiting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 15,
                      ),
                      Expanded(
                        child: Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '$raiting/5',
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                '$price\$/ночь',
                style: TextStyle(
                  color: Colors.cyan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
