import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gellary/Controller/homescreenController.dart';
import 'package:gellary/View/ViewImage.dart';
import 'package:gellary/View/cropper.dart';
import 'package:gellary/View/login_Screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gellaryHome extends StatefulWidget {
  const gellaryHome({super.key});

  @override
  State<gellaryHome> createState() => _gellaryHomeState();
}

class _gellaryHomeState extends State<gellaryHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor('#DDCDFF'),
      statusBarIconBrightness: Brightness.dark,
    ));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final controller = Get.put(HomeScreenController());
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/homeBackground.svg',
              semanticsLabel: 'backgroundHome',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned.fill(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: HexColor('#DDCDFF').withOpacity(0.6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.2,
                  left: screenWidth * 0.06,
                  right: screenWidth * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();

                      Get.off(const loginScreen());
                      Get.snackbar(
                        "Logout",
                        "You have been logged out successfully",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.39,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/logouticon.png',
                            height: screenWidth * 0.108,
                            width: screenWidth * 0.108,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'log out',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Baloo Thambi 2',
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: screenWidth * 0.39,
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.showUploadOptions(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/uploadicon.png',
                            height: screenWidth * 0.108,
                            width: screenWidth * 0.108,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'upload',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Baloo Thambi 2',
                              color: HexColor('#4A4A4A'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: Size(230, (230 * 0.5833333333333334).toDouble()),
                painter: RPSCustomPainter(),
              ),
            ),
            Positioned(
              top: screenHeight * 0.035,
              right: screenWidth * 0.085,
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
            ),
            Positioned(
                top: screenHeight * 0.03875,
                left: screenWidth * 0.0675,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome \nMina',
                      style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Baloo Thambi 2',
                          color: HexColor('#4A4A4A')),
                    ),
                  ],
                )),
            Positioned(
              top: screenHeight * 0.3125,
              left: 0,
              right: 0,
              bottom: 0,
              child: FutureBuilder<List<String>>(
                future: controller.fetchImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading images'));
                  } else {
                    List<String> imageUrls = snapshot.data ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerScreen(
                                      imageUrl: imageUrls[index]),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: imageUrls.length,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
