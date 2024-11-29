
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State createState() => _DesktopLandingPageState();
}

class _DesktopLandingPageState extends State {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 242, 215, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/MilkMinderLogo2.png',
            height: 200,
            width: 180,
          ),
        ),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {},
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 51, 255, 235),
                      Color.fromARGB(255, 50, 38, 214),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                height: 226,
                width: 360,
                child: Row(
                  children: [
                    Image.asset(
                      './assets/milk-can-clipart-vector-art-illustratio_761413-22050-removebg-preview.png',
                      height: 185,
                      width: 185,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text(
                          "Collection     50L",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 121, 190, 225),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: 226,
                width: 360,
                child: Row(
                  children: [
                    Image.asset(
                      './assets/distrubition.png',
                      height: 185,
                      width: 185,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text(
                          "Distribution     50L",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
