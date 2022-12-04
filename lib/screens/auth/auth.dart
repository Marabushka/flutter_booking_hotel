import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hotel_database_app/screens/auth/auth_service.dart';
import 'package:provider/provider.dart';

class AuthEnter extends StatefulWidget {
  const AuthEnter({Key? key}) : super(key: key);

  @override
  State<AuthEnter> createState() => _AuthEnterState();
}

class _AuthEnterState extends State<AuthEnter> {
  bool isLoged = true;
  final TextEditingController loginRegisterController = TextEditingController();
  final TextEditingController passwordRegisterController =
      TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController passportController = TextEditingController();

  String email = '';
  String password = '';
  String registerEmail = '';
  String registerPassword = '';
  String name = '';
  String surname = '';
  String passport = '';
  String? loginErrorMessage;
  String? passwordErrorMessage;
  @override
  Widget build(BuildContext context) {
    if (isLoged == true) {
      String? errorMessage = context.watch<AuthService>().errorMessage;

      return Scaffold(
        body: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Войти в аккаунт',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      controller: loginController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        errorText: errorMessage,
                        hintText: 'Введите логин',
                        prefixIcon: Icon(Icons.supervised_user_circle),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration:
                        getDecoration(null, Icons.password, 'Введите пароль'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Нет аккаунта:',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLoged = false;
                          });
                        },
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
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
                            'Войти',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (email.isNotEmpty && password.isNotEmpty) {
                              onSingInButtonTap(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Ошибка'),
                                    content: Container(
                                        width: 200,
                                        height: 50,
                                        child: Text(
                                          'Введите логин и пароль',
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
        ]),
      );
    } else {
      String? errorRegisterMessage =
          context.watch<AuthService>().errorRegisterMessage;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Регистрация',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          registerEmail = value;
                        });
                      },
                      controller: loginRegisterController,
                      decoration: getDecoration(
                          loginErrorMessage, Icons.mail, 'Введите email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          registerPassword = value;
                        });
                      },
                      controller: passwordRegisterController,
                      obscureText: true,
                      decoration: getDecoration(passwordErrorMessage,
                          Icons.password, 'Введите пароль'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Уже есть аккаунт?',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLoged = true;
                            });
                          },
                          child: Text(
                            'Вход',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Введите имя:'),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            controller: nameController,
                            decoration:
                                getDecoration(null, Icons.face, 'Введите имя'),
                          ),
                        ),
                        Text('Введите фамилию:'),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                surname = value;
                              });
                            },
                            controller: surnameController,
                            decoration: getDecoration(
                                null,
                                Icons.supervised_user_circle_rounded,
                                'Введите фамилию'),
                          ),
                        ),
                        Text('Введите пасспорт:'),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                passport = value;
                              });
                            },
                            controller: passportController,
                            decoration: getDecoration(
                                null,
                                Icons.supervised_user_circle,
                                'Введите пасспорт'),
                          ),
                        ),
                      ],
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
                              'Зарегистрироваться',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (registerEmail.isNotEmpty &&
                                  passport.isNotEmpty &&
                                  registerPassword.isNotEmpty &&
                                  surname.isNotEmpty &&
                                  name.isNotEmpty) {
                                if (registerEmail.trim().isValidEmail() ==
                                        true &&
                                    registerPassword.length > 7) {
                                  onRegisterButtonTap(context);

                                  create(
                                      name, surname, registerEmail, passport);
                                } else {
                                  if (registerEmail.trim().isValidEmail() ==
                                      false) {
                                    setState(() {
                                      loginErrorMessage =
                                          'Неправильный формат почты';
                                    });
                                    if (registerPassword.length < 7) {
                                      setState(() {
                                        passwordErrorMessage =
                                            'Длинна пароля должна быть больше 7 символов';
                                      });
                                    }
                                  }
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Ошибка'),
                                      content: Container(
                                          width: 200,
                                          height: 50,
                                          child: Text(
                                            'Введены не все данные',
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

  create(String name, String surname, String email, String passport) async {
    List<String> bookingDate = [];
    String rooms = '';
    String hotels = '';
    String imagePath = '';
    String adults = '';
    String children = '';
    await FirebaseFirestore.instance
        .collection('Users')
        .doc('${email.trim()}st')
        .set({
      'adults': adults,
      'children': children,
      'name': name,
      'imagePath': imagePath,
      'email': email,
      'surname': surname,
      'hotel': hotels,
      'passport': passport,
      'bookingDate': bookingDate,
      'room': rooms,
    });
  }

  void onSingInButtonTap(
    BuildContext context,
  ) async {
    final model = Provider.of<AuthService>(context, listen: false);
    if (email.isEmpty || password.isEmpty) {
      return;
    }

    try {
      await model.singInInWithEmail(
          email: loginController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {}
  }

  void onRegisterButtonTap(BuildContext context) async {
    final model = Provider.of<AuthService>(context, listen: false);
    if (registerEmail.isEmpty || registerPassword.isEmpty) {
      return;
    }

    try {
      await model.registerInWithEmail(
          email: loginRegisterController.text.trim(),
          password: passwordRegisterController.text.trim());
    } on FirebaseAuthException catch (e) {}
  }
}

getDecoration(String? error, IconData icon, String title) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    errorText: error,
    hintText: title,
    prefixIcon: Icon(icon),
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
