import 'package:contrador/view/Publish%20Job/category_selection_page.dart';
import 'package:contrador/view/chat_home_page.dart';
import 'package:contrador/view/home_page.dart';
import 'package:contrador/view/my_services_page.dart';
import 'package:contrador/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
   final int initialPage;
   const BottomNavBar({super.key,  required this.initialPage,});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);
  late  PageController _myPage = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    _myPage = PageController(initialPage: widget.initialPage);
    _currentPage=widget.initialPage;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                    text: "Home",
                    icon: _currentPage == 0
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                    selected: _currentPage == 0 ? true : false,
                    onPressed: () {
                      _myPage.jumpToPage(0);
                    }),
                IconBottomBar(
                    text: "Chats",
                    icon: _currentPage == 1
                        ? Icons.messenger_rounded
                        : Icons.messenger_outline_rounded,
                    selected: _currentPage == 1 ? true : false,
                    onPressed: () {
                      _myPage.jumpToPage(1);
                    }),
                IconBottomBar2(
                    text: "Add",
                    icon: Icons.add_outlined,
                    selected: _currentPage == 2 ? true : false,
                    onPressed: () {
                      _myPage.jumpToPage(2);
                    }),
                IconBottomBar(
                    text: "My Services",
                    icon: _currentPage == 3
                        ? Icons.feed_rounded
                        : Icons.feed_outlined,
                    selected: _currentPage == 3 ? true : false,
                    onPressed: () {
                      _myPage.jumpToPage(3);
                    }),
                IconBottomBar(
                    text: "Profile",
                    icon: _currentPage == 4
                        ? Icons.person
                        : Icons.person_outline_rounded,
                    selected: _currentPage == 4 ? true : false,
                    onPressed: () {
                      _myPage.jumpToPage(4);
                    })
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (pageNumber) {
          setState(() {
            _currentPage = pageNumber;
          });
        },
        children: const <Widget>[
          HomePage(),
          ChatHomePage(),
          CategorySelectionPage(),
          MyServicesPage(),
          ProfilePage()
        ],
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed});

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final orangeColor = const Color(0xffFF8527);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.black54,
          ),
        ),
        Text(text,
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: .1,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(.75)),
            ))
      ],
    );
  }
}

class IconBottomBar2 extends StatelessWidget {
  const IconBottomBar2(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed});

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final orangeColor = const Color(0xffFF8527);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
