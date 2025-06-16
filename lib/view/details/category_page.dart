import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/favourite_model.dart';
import 'package:contrador/services/contractor_services.dart';
import 'package:contrador/services/review_services.dart';
import 'package:contrador/view/details/service_details_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

import '../../models/contractor_model.dart';
import '../../provider/favourite_provider.dart';

class CategoryPage extends StatefulWidget {
  final String appBarTitle;
  final List<String> subCategoryList;

  const CategoryPage(
      {super.key, required this.appBarTitle, required this.subCategoryList});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final UiComponents _uiComponents = UiComponents();
  final ContractorServices _contractorServices = ContractorServices();
  final ReviewServices _reviewServices = ReviewServices();
  // double _currentRating = 4.0;
  String _categoryName = 'all';



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    // final favourite = Provider.of<FavouriteProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _uiComponents.headline2(widget.appBarTitle,Theme.of(context).colorScheme.tertiary),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            8.verticalSpace,
            SizedBox(
              height: height * 0.048,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.subCategoryList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _categoryName =
                                widget.subCategoryList[index].toLowerCase();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _categoryName ==
                                      widget.subCategoryList[index]
                                          .toLowerCase()
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                                child: Text(
                              widget.subCategoryList[index].toString(),
                              style: GoogleFonts.abel(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: _categoryName ==
                                        widget.subCategoryList[index]
                                            .toLowerCase()
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            10.verticalSpace,
            FutureBuilder<List<ContractorModel>?>(
                future: _contractorServices
                    .getAllServicesBySubcategoryId(_categoryName.toLowerCase()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: _uiComponents.loading()
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child:
                          _uiComponents.normalText("Error ${snapshot.error}"),
                    );
                  } else {
                    List<ContractorModel>? contractorList = snapshot.data;
                    return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2),
                        itemCount: contractorList!.length,
                        itemBuilder: (context, index) {
                          ContractorModel contractor = contractorList[index];
                         final favouriteModel = FavouriteModel(
                              contractorId: contractorList[index].contractorId,
                              serviceId:  contractorList[index].serviceId,
                              name:  contractorList[index].name,
                              price:  int.parse(contractorList[index].cost),
                              rating:  contractorList[index].rating,
                              imagePath:  contractorList[index].imagePaths.isEmpty?'':contractorList[index].imagePaths[0],
                              option:  contractorList[index].option,
                              address:  contractorList[index].address);
                          return InkWell(
                            onTap: () {
                              Flexify.go(
                                  ServiceDetailsPage(
                                    contractor: contractor,
                                  ),
                                  animation: FlexifyRouteAnimations.slide,
                                  animationDuration:
                                      const Duration(milliseconds: 500));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        Positioned(
                                          child: SizedBox(
                                            height: height * 0.13,
                                            width: double.maxFinite,
                                            child: Image.network(
                                              contractor.imagePaths.isEmpty
                                                  ? "https://strapi.dhiwise.com/uploads/Firebase_Node_JS_OG_Image_f6223f11a9.png"
                                                  : contractor.imagePaths[0],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        // Positioned(
                                        //     right: 0,
                                        //     child: CircleAvatar(
                                        //       radius: 15,
                                        //       child: IconButton(
                                        //         onPressed: () {
                                        //           favourite.addToWishlist(favouriteModel);
                                        //         },
                                        //         icon:  Icon(
                                        //           favourite.isFavourite(favouriteModel)?Icons.favorite:Icons.favorite_outline_rounded,
                                        //           color: favourite.isFavourite(favouriteModel)?Colors.red:Colors.black,
                                        //           size: 15,
                                        //         ),
                                        //       ),
                                        //     ))
                                      ],
                                    ),
                                    2.verticalSpace,
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        contractor.businessName,
                                        style: GoogleFonts.abel(
                                          textStyle: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                        text: contractor.cost,
                                        style: GoogleFonts.abel(
                                            textStyle: TextStyle(
                                                overflow: TextOverflow.visible,
                                                fontSize: 14,
                                                color: Colors.blue.shade900,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      TextSpan(
                                        text: "/${contractor.pricingModel}",
                                        style: GoogleFonts.abel(
                                            textStyle: TextStyle(
                                                overflow: TextOverflow.visible,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      )
                                    ])),
                                    2.verticalSpace,
                                    _uiComponents
                                        .normalText("📍${contractor.address}"),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "[More Info]",
                                        style: GoogleFonts.abel(
                                            textStyle: TextStyle(
                                                overflow: TextOverflow.visible,
                                                fontSize: 14,
                                                color: Colors.blue.shade900,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
