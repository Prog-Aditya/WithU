import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:withu/helper/helper_function.dart';
import 'package:withu/pages/auth/login_page.dart';
import 'package:withu/pages/home_page.dart';
import 'package:withu/services/auth_service.dart';

import '../../widgets/widgets.dart';

class RegisterPAge extends StatefulWidget {
  const RegisterPAge({super.key});

  @override
  State<RegisterPAge> createState() => _RegisterPAgeState();
}

class _RegisterPAgeState extends State<RegisterPAge> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String email = "";
  String password = "";
  String fullName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "WithU",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Create a account now to chat",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 30),
                      Image.asset("asset/group.jpg"),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              fullName = value;
                              //log(password);
                            },
                          );
                        },
                        validator: (value) =>
                            value!.isNotEmpty ? null : "Name cannot be empty",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              email = value;
                              //log(value);
                            },
                          );
                        },
                        validator: (value) {
                          bool result = value!.contains(
                            RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
                          );
                          return result ? null : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: const Icon(
                            Icons.lock,
                          ),
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              password = value;
                              //log(password);
                            },
                          );
                        },
                        validator: (value) => value!.length > 6
                            ? null
                            : "Please enter a password grater than 6 characters",
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            register();
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Alredy have an account ? ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "LogIn!",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreenReplace(
                                        context, const LoginPage());
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registeruserwithemailanpassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared prefrence state
          await helperFunction.svaeUserLogedInstatus(true);
          await helperFunction.svaeUseremail(email);
          await helperFunction.svaeUserName(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          ShowSnakBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
