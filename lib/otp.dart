import 'package:delivery/phone.dart';
import 'package:delivery/profile_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class MyOTP extends StatefulWidget {
  String text;

  MyOTP({super.key, required this.text});

  @override
  State<MyOTP> createState() => _MyOTPState(text);
}

class _MyOTPState extends State<MyOTP> {
  String text = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  _MyOTPState(this.text);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code="";

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
                const Text("Verify Phone",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("Code is sent to $text",
                    style: (const TextStyle(fontSize: 16, color: Colors.grey)),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 35,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onChanged: (value){
                    code=value;
                  },
                ),
                Row(
                  children: [
                    Text("Didn't receive the code?",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    TextButton(
                      child: Text("Request Again",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: text,
                          verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("OTP Resent"),
                        ));
                        MyPhoneScreen.verify = verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                      },
                      style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: 320,
                    height: 50,
                    color: const Color(0xFF2e3a63),
                    child: TextButton(
                      onPressed: () async {
                        try{
                          PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: MyPhoneScreen.verify,
                              smsCode: code);

                          await auth.signInWithCredential(credential);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => ProfileSelectScreen()), (Route<dynamic> route) => false);
                        }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Wrong OTP"),
                            ));
                        }

                      },
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero))),
                      child: const Text(
                        "VERIFY AND CONTINUE",
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
}
