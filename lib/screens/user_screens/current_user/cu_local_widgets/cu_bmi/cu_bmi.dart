import 'dart:async';

import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/utils/calculate_bmi.dart';

enum Gender {
  male,
  female,
}

class CuBmi extends StatefulWidget {
  const CuBmi({super.key});

  @override
  State<CuBmi> createState() => _CuBmiState();
}

class _CuBmiState extends State<CuBmi> {
  double screenWidth = 0;
  double screenHeight = 0;

  Color inactiveColor = const Color(0xFF24232F);
  Color activeColor = Colors.blueGrey;

  int height = 180;
  int weight = 30;
  int age = 15;

  Gender selectedGender = Gender.male;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    // CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "B M I",
                style: TextStyle(
                  fontSize: screenWidth / 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: selectedGender == Gender.male
                              ? activeColor
                              : inactiveColor,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.male,
                              color: Colors.white,
                              size: screenWidth / 5.5,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "male",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth / 40,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: selectedGender == Gender.female
                              ? activeColor
                              : inactiveColor,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.female,
                              color: Colors.white,
                              size: screenWidth / 5.5,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "female",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth / 40,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: inactiveColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "HEIGHT",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            height.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "cm",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTickMarkColor: Colors.white,
                          overlayColor: const Color(0x291DE9B6),
                          inactiveTrackColor: Colors.grey,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16.0,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 30.0,
                          ),
                          thumbColor: const Color(0xFF1DE9B6),
                        ),
                        child: Slider(
                          value: height.toDouble(),
                          min: 100.0,
                          max: 250.0,
                          onChanged: (double v) {
                            setState(() {
                              height = v.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: inactiveColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Weight (kg)",
                              style: TextStyle(
                                fontSize: screenWidth / 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              weight.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (weight < 400) {
                                        weight++;
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      timer = Timer.periodic(
                                          const Duration(milliseconds: 50),
                                          (timer) {
                                        setState(() {
                                          if (weight < 400) {
                                            weight++;
                                          }
                                        });
                                      });
                                    });
                                  },
                                  onLongPressEnd: (_) => setState(() {
                                    timer?.cancel();
                                  }),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (weight > 10) {
                                        weight--;
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      timer = Timer.periodic(
                                          const Duration(milliseconds: 50),
                                          (timer) {
                                        setState(() {
                                          if (weight > 10) {
                                            weight--;
                                          }
                                        });
                                      });
                                    });
                                  },
                                  onLongPressEnd: (_) => setState(() {
                                    timer?.cancel();
                                  }),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: inactiveColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Age",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              age.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (age < 200) {
                                        age++;
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      timer = Timer.periodic(
                                          const Duration(milliseconds: 50),
                                          (timer) {
                                        setState(() {
                                          if (age < 200) {
                                            age++;
                                          }
                                        });
                                      });
                                    });
                                  },
                                  onLongPressEnd: (_) => setState(() {
                                    timer?.cancel();
                                  }),
                                  // ignore: prefer_const_constructors
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (age > 5) {
                                        age--;
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      timer = Timer.periodic(
                                          const Duration(milliseconds: 50),
                                          (timer) {
                                        setState(() {
                                          if (age > 5) {
                                            age--;
                                          }
                                        });
                                      });
                                    });
                                  },
                                  onLongPressEnd: (_) => setState(() {
                                    timer?.cancel();
                                  }),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    CalculateResult obj = CalculateResult(weight, height);
                    showBmiResult(obj.calculateResult(), obj.getMsg(),
                        obj.getDescription());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    margin: const EdgeInsets.only(top: 10.0),
                    width: double.infinity,
                    height: 80.0,
                    color: const Color(0xFF1DE9B6),
                    child: const Center(
                      child: Text(
                        "Calculate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBmiResult(String result, String msg, String des) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('BmiResult'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  textAlign: TextAlign.center,
                  "Your BMI is $result. $des",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
