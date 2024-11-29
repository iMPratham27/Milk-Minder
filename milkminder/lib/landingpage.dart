
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/user_admin.dart';
import 'package:slider_button/slider_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();

  List<Map> contentList = [
    {
      "image": "./assets/MbN0A77CMotLa6Vw18.gif",
      "title": "Smart Solutions for Sustainable Dairy Farming"
    },
    {
      "image": "./assets/image 1.png",
      "title": "Let's Begin with Milk Minder"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        // Customize AppBar if needed
      ),
      body: Column(
        children: [
          Image.asset(
            "./assets/MilkMinderLogo1.png",
            height: 120,
            width: 120,
          ),
          // The PageView that contains the gif and text content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: contentList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          contentList[index]["image"],
                          width: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          contentList[index]["title"],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 90),

                      // Conditionally render the slider button only on the second page
                      if (index == 1) // Check if it's the second page (index 1)
                        Center(
                          child: SliderButton(
                            action: () async {
                              
                              //Navigate to UserAdmin page
                              Navigator.of(context).push(
                                MaterialPageRoute(builder:(context){
                                  return const UserAdmin();
                                }
                              ));
                              
                              return true;
                            },
                            label: const Text(
                              "Know more",
                              style: TextStyle(
                                color: Color(0xff4a4a4a),
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                            // icon: const Text(
                            //   "x",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.w400,
                            //     fontSize: 44,
                            //   ),
                            // ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // SmoothPageIndicator placed outside the PageView, below the content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: contentList.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.green,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
