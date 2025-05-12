// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  final usercontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final _authprovider = Provider.of<AuthProvider>(context);
    final isLoading = _authprovider.isLoading;
    bool isMobile() {
      return MediaQuery.of(context).size.width < 600;
    }

    final authprovider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: (isMobile())
          ? const EdgeInsets.all(20.0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearGradientText(
              child: Text(
            "Register Now!",
            style: TextStyle(fontSize: 28),
          )),
          SizedBox(
            height: 8,
          ),
          Text(
            "Join the E-Cell Family Today!",
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 14,
          ),

          //name input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearGradientText(
                  child: Text(
                "Name",
                style: TextStyle(fontSize: 15),
              )),
              SizedBox(
                height: 6,
              ),
              TextField(
                controller: usercontroller,
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Color(0xFF1E1E1E),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: (isMobile()) ? 9 : 12),
                    hintText: "Enter your name",
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 72, 72, 72)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    )),
              )
            ],
          ),
          SizedBox(
            height: 14,
          ),

          //email input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearGradientText(
                  child: Text(
                "Email",
                style: TextStyle(fontSize: 15),
              )),
              SizedBox(
                height: 6,
              ),
              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Color(0xFF1E1E1E),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: (isMobile()) ? 9 : 12),
                    hintText: "Enter your email",
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 72, 72, 72)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    )),
              )
            ],
          ),
          SizedBox(
            height: 14,
          ),

          //password input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearGradientText(
                  child: Text(
                "Create Password",
                style: TextStyle(fontSize: 15),
              )),
              SizedBox(
                height: 6,
              ),
              TextField(
                obscureText: true,
                controller: passwordcontroller,
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Color(0xFF1E1E1E),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: (isMobile()) ? 9 : 12),
                    hintText: "Enter Password",
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 72, 72, 72)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: (isMobile()) ? 0.25 : 0.2,
                          color: Colors.amber),
                    )),
              )
            ],
          ),

          SizedBox(
            height: 20,
          ),

          //signup button
          GestureDetector(
            onTap: () async {
              if (!isLoading) {
                final _user = await _authprovider.signup(
                  usercontroller.text.trim(),
                  emailcontroller.text.trim(),
                  passwordcontroller.text.trim(),
                );

                if (_user != null) {
                  showCustomToast(
                      title: "Signup", description: "Signup Successfully");
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: linerGradient),
                  borderRadius: BorderRadius.circular(7)),
              child: Center(
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ))
                      : Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          //google button
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF1E1E1E),
                border: Border.all(color: Color.fromARGB(76, 230, 230, 230))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 18,
                      width: 18,
                      child: Image.asset(
                        "assets/icons/google icon.png",
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    width: 12,
                  ),
                  Text("Signup with google", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 8,
              ),
              GestureDetector(
                  onTap: () {
                    authprovider.setPage(Pages.login);
                  },
                  child: LinearGradientText(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 12),
                  )))
            ],
          )
        ],
      ),
    );
  }
}
