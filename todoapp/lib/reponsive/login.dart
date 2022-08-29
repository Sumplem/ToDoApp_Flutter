// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore, sort_child_properties_last

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/homePage.dart';
import 'package:todoapp/reponsive/register.dart';
import 'package:todoapp/services/auth.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

TextFormField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: text,
      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: isPasswordType
        ? ((value) => value?.length == 0 ? "Enter password" : null)
        : (value) =>
            EmailValidator.validate(value!) ? null : "Email not valid!",
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? "LOG IN" : "SIGN UP",
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey.shade100;
            }
            return Colors.lightBlue;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

class _MyLoginState extends State<MyLogin> {
  final auth = AuthService();
  final keyForm = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            // ignore: prefer_const_constructors
            image: DecorationImage(
                image: AssetImage('images/login.png'), fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.width * 0.4, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 35, top: 150),
                child: Text(
                  'Welcome Back',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              ),
              Form(
                key: keyForm,
                child: Column(
                  children: [
                    reusableTextField(
                        "Email", Icons.person_outline, false, _emailController),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextField(
                        "Password", Icons.lock_outline, true, _passwordController),
                    SizedBox(
                      height: 30,
                    ),
                    signInSignUpButton(context, true, () async {
                      if(keyForm.currentState?.validate() ?? false) {
                        dynamic result = await auth.signinWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                        if (result == null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Wrong email/password!'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK')
                                  )
                                ],
                              );
                            }
                          );
                        }else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                        }
                      }
                    }
                    ),
                  ],
                )
              ),
              signUpOption()
            ],
          ),
        )),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? ",
            style: TextStyle(color: Colors.black87)),
        GestureDetector(
          onTap: () {
            // chuyển sang trang mới
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyRegister()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
