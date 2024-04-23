import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gellary/Controller/logincontroller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor('#DDCDFF'),
      statusBarIconBrightness: Brightness.dark,
    ));
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(LoginController());
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/login_background.svg',
            semanticsLabel: 'background',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.3),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/middleiconslogin.svg',
                semanticsLabel: 'MiddleIcons',
                height: screenHeight * 0.35,
                width: screenHeight * 0.35,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.07),
              child: Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    children: [
                      if (!isKeyboardVisible)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'My\nGellary',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Segoe UI',
                                    color: HexColor('#4A4A4A')),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.40,
                        decoration: BoxDecoration(
                            color: Colors.white10.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            if (!isKeyboardVisible)
                              Text(
                                textAlign: TextAlign.center,
                                'LOG IN',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.085,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Segoe UI',
                                    color: HexColor('#4A4A4A')),
                              ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Container(
                              width: screenWidth * 0.694,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextFormField(
                                    onChanged: (value) =>
                                        controller.email.value = value,
                                    decoration: InputDecoration(
                                      hintText: 'User Name',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.040,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Segoe UI',
                                        color: HexColor('#988F8C'),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                  )),
                            ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Container(
                              width: screenWidth * 0.694,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextFormField(
                                    onChanged: (value) =>
                                        controller.password.value = value,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.040,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Segoe UI',
                                        color: HexColor('#988F8C'),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Container(
                              width: screenWidth * 0.694,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#7BB3FF'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        if (controller.email.value.isNotEmpty &&
                                            controller
                                                .password.value.isNotEmpty) {
                                          controller.login();
                                        } else if (controller
                                            .email.value.isEmpty) {
                                          Get.snackbar('Required',
                                              'Enter your Email or Username');
                                        } else if (controller
                                            .password.value.isEmpty) {
                                          Get.snackbar('Required',
                                              'Enter your Password');
                                        }
                                      },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.016,
                                    horizontal: screenWidth * 0.047,
                                  ),
                                  child: Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.052,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Segoe UI',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!isKeyboardVisible)
            Positioned(
              top: -screenHeight * 0.145,
              left: -screenWidth * 0.0893,
              child: Image.asset(
                'assets/images/topleftlogin.png',
                height: screenHeight * 0.4,
                width: screenWidth * 0.7,
              ),
            ),
        ],
      ),
    ));
  }
}
