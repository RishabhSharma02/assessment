import 'dart:async';

import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/views/login_screen.dart';
import 'package:bhaada/sections/Onboarding/views/new_details_screen.dart';
import 'package:bhaada/sections/Onboarding/views/vechicle_selection.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../homescreen/views/nav_screen.dart';

class  SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final OnboardingController onboardingController=Get.put(OnboardingController());
  late VideoPlayerController _controller;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    //_isPlaying = true;
    _controller = VideoPlayerController.asset('assets/videos/spalsh_video.mp4')
      ..initialize().then((_) {
        // setState(() {
        //   _controller.play();
        // });
        Timer(const Duration(seconds: 1), () {
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
            if (user == null) {
              Get.offAll(() => LoginScreen());
            } else {
              if (await onboardingController.isProfilePresent(user.uid)) {
                Get.offAll(() => NavScreen());
              } else {
                profileDialog(context, "Please complete your profile to access your account!".tr, "", () {
                  Get.to(() => PersonalDetailsScreen());
                }, () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => LoginScreen()); // Ensure you navigate to LoginScreen after signing out
                });
              }
            }
          });
        });

      });

    // _controller.addListener(() {
    //   if (!_controller.value.isPlaying && _isPlaying) {
    //     // Video finished playing, navigate after the video ends
    //     _isPlaying = false; // Set flag to prevent multiple navigations
    //     FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //       if (user == null) {
    //         Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (context) => NavScreen()), // Navigate to NavScreen for non-authenticated users
    //         );
    //       } else {
    //         Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (context) => NavScreen()), // Navigate to NavScreen for authenticated users
    //         );
    //       }
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : CircularProgressIndicator();
  }
}