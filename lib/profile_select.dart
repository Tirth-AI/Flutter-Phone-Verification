import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSelectScreen extends StatefulWidget {
  const ProfileSelectScreen({super.key});

  @override
  State<ProfileSelectScreen> createState() => _ProfileSelectScreenState();
}

class _ProfileSelectScreenState extends State<ProfileSelectScreen> {
  var level = "Shipper";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.black),
          backgroundColor: Colors.transparent),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          // height: 400,
          child: Column(
            children: [
              const Text("Please select your profile",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(
                height: 35,
              ),

              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: ListTile(
                  title: const Text("Shipper"),
                  trailing: Image.asset("assets/images/warehouse.png", width: 40, height: 40,),
                  leading: Radio(
                    value: "Shipper",
                    groupValue: level,
                    onChanged: (value){
                      setState(() {
                        level = value.toString();
                      });
                    },
                  ),
                )
              ),

              const SizedBox(
                height: 25,
              ),

              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListTile(
                    title: const Text("Transporter"),
                    trailing: Image.asset("assets/images/transporter.png", width: 45, height: 45,),
                    leading: Radio(
                      value: "Transporter",
                      groupValue: level,
                      onChanged: (value){
                        setState(() {
                          level = value.toString();
                        });
                      },
                    ),
                  )
              ),

              SizedBox(
                height: 25,
              ),

              Container(
                height: 50,
                color: const Color(0xFF2e3a63),
                child: TextButton(
                  onPressed: () {
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero))),
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
