import 'package:contrador/components/ui_components.dart';
import 'package:contrador/view/details/category_page.dart';
import 'package:contrador/view/search_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          25.verticalSpace,
          const BigImage(imagePath: 'images/van2.png'),
          10.verticalSpace,
          InkWell(
            onTap: (){
              Flexify.go(
                  const SearchPage(),
                  animation: FlexifyRouteAnimations.slide,
                  animationDuration: const Duration(milliseconds: 400));

            },
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      offset: const Offset(12, 26),
                      blurRadius: 50,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(.1)),
                ],
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.tertiary
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search_rounded,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                    40.horizontalSpace,
                    _uiComponents.normalText('Search by ID,name etc')
                  ],
                )
            ),
          ),
          15.verticalSpace,
          Align(alignment: Alignment.centerLeft,
              child: _uiComponents.headline2('Services')),
          Divider(
            thickness: 0.4,
            color: Theme.of(context).colorScheme.primary,
          ),
          4.verticalSpace,
          Wrap(
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
                }, height: height , width: width ,
              ),
              CategoryCard(
                imagePath: 'images/helmet.png',
                title: 'Construction Services',
                height: height , width: width ,
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
                height: height , width: width ,
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
                height: height , width: width ,
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
                height: height , width: width ,
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
                height: height , width: width ,
                onPressed: () {
                  Flexify.go(
                      const CategoryPage(
                        appBarTitle:  'Personal Services',
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
          )
        ],
      ),
    );
  }
}


