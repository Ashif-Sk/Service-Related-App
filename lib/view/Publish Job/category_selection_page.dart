import 'package:contrador/components/ui_components.dart';
import 'package:contrador/view/Publish%20Job/job_publish_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';


class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final UiComponents _uiComponents =UiComponents();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: _uiComponents.headline2('What are you offering?'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            8.verticalSpace,
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 5,
              children: [
                CategoryCard(
                  height: height , width: width ,
                  imagePath: 'images/house.png',
                  title: 'Home Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName: 'Home Services',
                          subCategoryList: [
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
                ),
                CategoryCard(
                  height: height , width: width ,
                  imagePath: 'images/helmet.png',
                  title: 'Construction Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName: 'Construction Services',
                          subCategoryList: [
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
                  height: height , width: width ,
                  imagePath: 'images/automotive.png',
                  title: 'Automotive Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName: 'Automotive Services',
                          subCategoryList: [
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
                  height: height , width: width ,
                  imagePath: 'images/transportation.png',
                  title: 'Transportation Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName: 'Transportation Services',
                          subCategoryList: [
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
                  height: height , width: width ,
                  imagePath: 'images/tech.png',
                  title: 'Tech & Repair Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName: 'Tech & Repair Services',
                          subCategoryList: [
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
                  height: height , width: width ,
                  imagePath: 'images/workers.png',
                  title: 'Personal Services',
                  onPressed: () {
                    Flexify.go(
                        const JobPublishPage(
                          categoryName:  'Personal Services',
                          subCategoryList: [
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
      ),
    );
  }
}
