import 'package:contrador/components/ui_components.dart';
import 'package:contrador/view/details/category_page.dart';
import 'package:contrador/view/search_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UiComponents _uiComponents = UiComponents();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 72, 54, 1),
        title: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Flexify.go(const SearchPage(),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 400));
                },
                child: Container(
                    height: 45,
                    // width: width * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(12, 26),
                              blurRadius: 50,
                              spreadRadius: 0,
                              color: Colors.grey.withOpacity(.1)),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.tertiary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.search_rounded,
                            size: 20, color: Theme.of(context).colorScheme.primary),
                        40.horizontalSpace,
                        _uiComponents.normalText('Search by ID,name etc')
                      ],
                    )),
              ),
            ),
            20.horizontalSpace,
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person,color: Colors.black,),
            )
          ],
        ),
        elevation: 0,
      ),
      body: ListView(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            height: height * 0.3,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(239, 72, 54, 1),
                      Color.fromRGBO(250, 169, 62, 1),
                    ]),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 60,
                    child: Column(
                      children: [
                        Text("Your Fix",
                        style: GoogleFonts.lobster(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w400
                          )
                        ),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {},
                          child:  Text('Just a Tap',
                              style: GoogleFonts.syne(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                        Text("Away",
                          style: GoogleFonts.lobster(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400
                              )
                          ),),
                      ],
                    )),
                Positioned(
                  bottom: 30,
                  left: 5,
                  child: Transform.rotate(
                    angle: 0,
                    child: Image.asset(
                      "images/hammer.png",
                      color: Colors.white,
                      height: 100,
                    ),),),
                Positioned(
                  bottom: 40,
                  right: -10,
                  child: Transform.rotate(
                    angle: 0.4,
                    child: Image.asset(
                      "images/paint-roller.png",
                      color: Colors.white,
                      height: 100,
                    ),),),
              ],
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: _uiComponents.headline2('Services')),
          ),
          Divider(
            thickness: 0.4,
            color: Theme.of(context).colorScheme.primary,
          ),
          4.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 5,
              children: [
                CategoryCard(
                  imagePath: 'images/house.png',
                  title: 'Home Services',
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Home Services',
                          subCategoryList: [
                            'All',
                            'Cleaning',
                            'Plumbing',
                            'Electrician',
                            'Painting',
                            'Carpentry'
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                  height: height,
                  width: width,
                ),
                CategoryCard(
                  imagePath: 'images/helmet.png',
                  title: 'Construction Services',
                  height: height,
                  width: width,
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Construction Services',
                          subCategoryList: [
                            'All',
                            'Builders',
                            'Tiles & Marbles',
                            'Masons',
                            'Roofers',
                            'Architect',
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                ),
                CategoryCard(
                  imagePath: 'images/automotive.png',
                  title: 'Automotive Services',
                  height: height,
                  width: width,
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Automotive Services',
                          subCategoryList: [
                            'All',
                            'Mechanics',
                            'Car Washers',
                            'Tow truck',
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                ),
                CategoryCard(
                  imagePath: 'images/transportation.png',
                  title: 'Transportation Services',
                  height: height,
                  width: width,
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Transportation Services',
                          subCategoryList: [
                            'All',
                            'Movers',
                            'Delivery',
                            'Taxi',
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                ),
                CategoryCard(
                  imagePath: 'images/tech.png',
                  title: 'Tech & Repair Services',
                  height: height,
                  width: width,
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Tech & Repair Services',
                          subCategoryList: [
                            'All',
                            'Mobile Repair',
                            'Appliance',
                            'It technician',
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                ),
                CategoryCard(
                  imagePath: 'images/workers.png',
                  title: 'Personal Services',
                  height: height,
                  width: width,
                  onPressed: () {
                    Flexify.go(
                        const CategoryPage(
                          appBarTitle: 'Personal Services',
                          subCategoryList: [
                            'All',
                            'Fitness Trainer',
                            'Beauty Services',
                            'Tutors',
                          ],
                        ),
                        animation: FlexifyRouteAnimations.slide,
                        animationDuration: const Duration(milliseconds: 500));
                  },
                ),
              ],
            ),
          ),
          15.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("With Love,\nContrador.",
              style: GoogleFonts.archivoBlack(
                  textStyle: const TextStyle(
                    height: 1,
                      color: Colors.grey,
                      fontSize: 42,
                      fontWeight: FontWeight.bold
                  )
              ),),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
