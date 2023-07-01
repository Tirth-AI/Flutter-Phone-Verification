import 'package:delivery/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPhoneScreen extends StatefulWidget {
  const MyPhoneScreen({super.key});
  static String verify = "";

  @override
  State<MyPhoneScreen> createState() => _MyPhoneScreenState();
}

class _MyPhoneScreenState extends State<MyPhoneScreen> {
  TextEditingController countryCode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  var phone = "";

  @override
  void initState() {
    countryCode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: Center(
          child: Container(
            width: 340,
            height: 400,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text("Please enter your mobile number",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                const Text("You'll receive a 4 digit code \nto verify next",
                    style: (TextStyle(fontSize: 16, color: Colors.grey)),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            controller: countryCode,
                            style: const TextStyle(fontSize: 20),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      const SizedBox(width: 10),
                      const Text("|",
                          style: TextStyle(fontSize: 30, color: Colors.grey)),
                      const SizedBox(width: 20),
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Mobile Number"),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: 320,
                    height: 50,
                    color: const Color(0xFF2e3a63),
                    child: TextButton(
                      onPressed: () {
                        sendDataToOtpScreen();
                      },
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero))),
                      child: const Text(
                        "SEND THE CODE",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void sendDataToOtpScreen() async {
    if (phone.length == 10) {
      var textToSend = "${countryCode.text}$phone";
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: textToSend,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          MyPhoneScreen.verify = verificationId;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyOTP(text: textToSend)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter a valid number"),
      ));
    }
  }
}
