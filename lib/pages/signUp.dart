import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:teknotodolist/pages/homepage.dart';
import 'package:teknotodolist/pages/phoneAuth.dart';
import 'package:teknotodolist/pages/signin.dart';
import 'package:teknotodolist/service/Auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool indecator = false;
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'sign Up',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              buttonitem(
                  context,
                  'https://wallpapercave.com/wp/wp2860517.jpg',
                  MediaQuery.of(context).size.width,
                  '  Continue with google', () async {
                authClass.googlesignin(context);
              }),
              buttonitem(
                  context,
                  'https://as1.ftcdn.net/v2/jpg/01/98/91/60/1000_F_198916049_Fdnb49GbwX3A8Y037i03Oo7xR7s6FecL.jpg',
                  MediaQuery.of(context).size.width,
                  '  Continue with mobile ', () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PhoneAuth(),
                ));
              }),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'or',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              textitem(context, 'Email', emailcontroller, false),
              textitem(context, 'Password', passwordcontroller, true),
              colorButton(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'already have an account ?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ));
                    },
                    child: const Text(
                      'login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell colorButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          indecator = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: emailcontroller.text,
                  password: passwordcontroller.text);
          print(userCredential.user?.email);
          setState(() {
            indecator = false;
          });

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ), (route) => false);
        } catch (e) {
          // Show snackbar with error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(" ${e.toString()}"),
              backgroundColor: Colors.red, // Customize color if needed
            ),
          );
          setState(() {
            indecator = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(colors: [
              Color(0xfffd746c),
              Color(0xffff9068),
              Color(0xfffd746c),
            ])),
        child: Center(
            child: indecator
                ? const CircularProgressIndicator()
                : const Text(
                    'Sign up ',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
      ),
    );
  }

  InkWell buttonitem(BuildContext context, String imagename, double size,
      String name, Function ontab) {
    return InkWell(
      onTap: () {
        ontab();
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          width: size - 60,
          height: 60,
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  imagename,
                  height: 44,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          )),
    );
  }

  Container textitem(BuildContext context, String text,
      TextEditingController controller, bool obsecure) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        obscureText: obsecure,
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xfffd746c)), // Color when focused
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
            labelText: text,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.white)),
      ),
    );
  }
}
