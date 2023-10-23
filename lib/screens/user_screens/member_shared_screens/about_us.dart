import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    //GymUser user = currentUser.getCurrentUser;
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "About Us",
                style: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gym Logo
              Image.asset(
                'assets/branding-logo.png', // Replace with your gym logo image
                width: 250,
                height: 250,
                fit: BoxFit.fill,
              ),

              // Gym Name and Description
              const Text(
                'Fitness World Gym',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change to your app's theme color
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Your Fitness Journey Starts Here!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey, // Change to your app's text color
                ),
              ),
              const SizedBox(height: 24.0),

              // Gym Mission and Values
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change to your app's theme color
                ),
              ),
              const Text(
                'To empower individuals to achieve their fitness goals and lead healthier lives through dedication and support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38, // Change to your app's text color
                ),
              ),
              const SizedBox(height: 16.0),

              const Text(
                'Our Values',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change to your app's theme color
                ),
              ),
              const Text(
                'Dedication, Community, Excellence, Health, and Fitness',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38, // Change to your app's text color
                ),
              ),

              // Gym Features and Programs
              const SizedBox(height: 24.0),
              const Text(
                'What Sets Us Apart',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change to your app's theme color
                ),
              ),
              const Text(
                'Our state-of-the-art facility, certified trainers, personalized workout plans, and supportive community make us the perfect choice for your fitness journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38, // Change to your app's text color
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
