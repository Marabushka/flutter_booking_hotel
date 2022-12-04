import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_database_app/provider/hotel_service.dart';
import 'package:hotel_database_app/screens/auth/auth_service.dart';
import 'package:hotel_database_app/screens/search/search_screen.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class ConfirmScreenWidget extends StatefulWidget {
  ConfirmScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmScreenWidget> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreenWidget> {
  var name = AuthService().getCurrentUser?.email;

  DateFormat format = DateFormat("dd.MM.yyyy");
  String? roomId;
  String _startTime = '';
  String _endTime = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<Meeting>? dataSource;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HotelModel>(context);

    int index = context.read<HotelModel>().index!;
    var docId = model.hotels?.roomsId?[index];
    var collection = FirebaseFirestore.instance.collection('BookingDates');

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
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: collection.doc(docId).get(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.hasData) {
            if (snapshot.data!.data()!['date'].toString().length > 2) {
              var bookingData = snapshot.data!.data();
              dataSource = _getDataSource(bookingData!['date']);
              return Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      height: 300,
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(
                            _getDataSource(bookingData['date'])),
                        monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.red,
                              ),
                              Text(' - забронированные даты')
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Номер: ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('${model.hotels!.rooms![index]}'),
                            ],
                          ),
                          Text(
                            "Дата:",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'c ${_startDate.day} ${returnMonth(_startDate)} ${_startDate.year}'),
                              ),
                              Icon(Icons.arrow_right_alt_outlined),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'по ${_endDate.day} ${returnMonth(_endDate)} ${_endDate.year}'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024),
                                  ).then((value) => setState(
                                        () {
                                          if (value != null) {
                                            _startDate = value;
                                          } else {
                                            return;
                                          }
                                        },
                                      ));
                                },
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024),
                                  ).then((value) => setState(
                                        () {
                                          if (value != null) {
                                            _endDate = value;
                                          } else {
                                            return;
                                          }
                                        },
                                      ));
                                },
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Подтвердить',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    for (int i = 0;
                                        i <= bookingData['date'].length - 2;
                                        i++) {
                                      var i1 = format
                                          .parse(bookingData['date'][i])
                                          .millisecondsSinceEpoch;
                                      var i2 = format
                                          .parse(bookingData['date'][i + 1])
                                          .millisecondsSinceEpoch;
                                      var j1 =
                                          _startDate.millisecondsSinceEpoch;
                                      var j2 = _endDate.millisecondsSinceEpoch;
                                      if ((i2 < j1 && j2 > i1) ||
                                          (i2 > j1 && j2 < i1)) {
                                        collection.doc(docId).update(
                                          {
                                            'date': FieldValue.arrayUnion(
                                              [
                                                '${_startDate.day}.${_startDate.month}.${_startDate.year}',
                                                '${_endDate.day}.${_endDate.month}.${_endDate.year}',
                                              ],
                                            ),
                                          },
                                        );

                                        create(
                                            adults: model.adults!,
                                            children: model.children!,
                                            imagePath: model.hotels!.imagePath!,
                                            hotel: model.hotels!.name!,
                                            email: '${name}',
                                            room: model.hotels!.rooms![index],
                                            bookingDate: [
                                              '${_startDate.day}.${_startDate.month}.${_startDate.year}',
                                              '${_endDate.day}.${_endDate.month}.${_endDate.year}',
                                            ]);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Успешно',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              content: Container(
                                                  width: 200,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'Номер забронирован с ${_startDate.day}.${_startDate.month}.${_startDate.year} по ${_endDate.day}.${_endDate.month}.${_endDate.year}'),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SearchScreen(),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            'К поиску отелей'),
                                                      )
                                                    ],
                                                  )),
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Ошибка',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              content: Container(
                                                  width: 200,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'Выберите свободные даты!'),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Назад'),
                                                      )
                                                    ],
                                                  )),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              dataSource = _getDataBookingSource();
              return Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      height: 300,
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(_getDataBookingSource()),
                        monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Номер: ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('${model.hotels!.rooms![index]}'),
                            ],
                          ),
                          Text(
                            "Дата:",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'c ${_startDate.day} ${returnMonth(_startDate)} ${_startDate.year}'),
                              ),
                              Icon(Icons.arrow_right_alt_outlined),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'по ${_endDate.day} ${returnMonth(_endDate)} ${_endDate.year}'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024),
                                  ).then((value) => setState(
                                        () {
                                          if (value != null) {
                                            _startDate = value;
                                          } else {
                                            return;
                                          }
                                        },
                                      ));
                                },
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024),
                                  ).then((value) => setState(
                                        () {
                                          if (value != null) {
                                            _endDate = value;
                                          } else {
                                            return;
                                          }
                                        },
                                      ));
                                },
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Подтвердить',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    collection.doc(docId).update(
                                      {
                                        'date': FieldValue.arrayUnion(
                                          [
                                            '${_startDate.day}.${_startDate.month}.${_startDate.year}',
                                            '${_endDate.day}.${_endDate.month}.${_endDate.year}',
                                          ],
                                        ),
                                      },
                                    );
                                    create(
                                        adults: model.adults!,
                                        children: model.children!,
                                        imagePath: model.hotels!.imagePath!,
                                        hotel: model.hotels!.name!,
                                        email: '${name}',
                                        room: model.hotels!.rooms![index],
                                        bookingDate: [
                                          '${_startDate.day}.${_startDate.month}.${_startDate.year}',
                                          '${_endDate.day}.${_endDate.month}.${_endDate.year}',
                                        ]);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Успешно',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          content: Container(
                                              width: 200,
                                              height: 100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Номер забронирован с ${_startDate.day}.${_startDate.month}.${_startDate.year} по ${_endDate.day}.${_endDate.month}.${_endDate.year}'),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        Text('К поиску отелей'),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  create(
      {required String room,
      required int adults,
      required int children,
      required String hotel,
      required String email,
      required String imagePath,
      required List<String> bookingDate}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc('${email.trim()}st')
        .update(
      {
        'adults': adults.toString(),
        'children': children.toString(),
        'hotel': hotel,
        'bookingDate': bookingDate,
        'room': room,
        'imagePath': imagePath,
      },
    );
  }

  List<Meeting> _getDataSource(List<dynamic> bookStart) {
    final List<Meeting> meetings = <Meeting>[];

    List<DateTime> startTime = [];

    List<DateTime> endTime = [];
    for (int i = 0; i <= bookStart.length - 2; i++) {
      if (i % 2 == 0) {
        startTime.add(format.parse(bookStart[i]));
        endTime.add(format.parse(bookStart[i + 1]));
      }
    }
    for (int ind = 0; ind <= startTime.length - 1; ind++) {
      meetings.add(Meeting('', startTime[ind], endTime[ind], Colors.red, true));
    }

    return meetings;
  }

  List<Meeting> _getDataBookingSource() {
    final List<Meeting> meetings = <Meeting>[];
    final List<DateTime> today = [
      DateTime.now(),
    ];
    final DateTime startTime = DateTime.now();

    final DateTime endTime = DateTime.now();
    meetings.add(Meeting('', startTime, endTime, Colors.green, true));
    return meetings;
  }

  String returnMonth(DateTime date) {
    return new DateFormat.MMMM('ru').format(
      date,
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
