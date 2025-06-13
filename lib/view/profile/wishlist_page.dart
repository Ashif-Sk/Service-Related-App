import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/favourite_model.dart';
import 'package:contrador/provider/favourite_provider.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

import '../details/service_details_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final UiComponents _uiComponents = UiComponents();
  double _currentRating = 4.0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: _uiComponents.headline2('Wishlist'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<FavouriteProvider>(
            builder: (context, favouriteProvider, child) {
          final List<FavouriteModel> favouriteItems =
              favouriteProvider.favourites;
          if(favouriteItems.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/empty_wishlist.png',fit: BoxFit.fill,height: height * 0.25,width: width * 0.5,),
                  15.verticalSpace,
                  _uiComponents.headline3('No favourite services')
                ],
              ),
            );
          }
          return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2),
              itemCount: favouriteItems.length,
              itemBuilder: (context, index) {
                FavouriteModel item = favouriteItems[index];
                _currentRating = item.rating;
                return InkWell(
                  onTap: () {
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                child: SizedBox(
                                  height: height * 0.13,
                                  width: double.maxFinite,
                                  child: Image.network(
                                    item.imagePath.isEmpty
                                        ? "https://strapi.dhiwise.com/uploads/Firebase_Node_JS_OG_Image_f6223f11a9.png"
                                        : item.imagePath[0],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 15,
                                    child: IconButton(
                                      onPressed: () {
                                        favouriteProvider.addToWishlist(item);
                                      },
                                      icon: favouriteProvider.isFavourite(item)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 15,
                                            )
                                          : const Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Colors.black,
                                              size: 15,
                                            ),
                                    ),
                                  ))
                            ],
                          ),
                          2.verticalSpace,
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              item.name,
                              style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 35.rt,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: item.price.toString(),
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontSize: 30.rt,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w600)),
                            ),
                            TextSpan(
                              text: "/${item.option}",
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.visible,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 30.rt,
                                      fontWeight: FontWeight.w500)),
                            )
                          ])),
                          SizedBox(
                              height: height * 0.035,
                              // width: width * 0.067,
                              child: RatingBar(
                                  feedbackUIType: FeedbackUIType.bottomSheet,
                                  showFeedbackForRatingsLessThan: 2,
                                  iconSize: 20,
                                  // Size of the rating icons
                                  allowHalfRating: false,
                                  // Allows selection of half ratings
                                  filledIcon: Icons.star,
                                  // Icon to display for a filled rating unit
                                  emptyIcon: Icons.star_border,
                                  // Icon to display for an empty rating units
                                  filledColor: Colors.amber,
                                  // Color of filled rating units
                                  emptyColor: Colors.grey,
                                  // Color of empty rating units
                                  currentRating: _currentRating,
                                  onRatingChanged: (changedRating) {})),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 15,
                              ),
                              SizedBox(
                                width: width * 0.34,
                                child: Text(
                                  item.address,
                                  style: GoogleFonts.abel(
                                    textStyle: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 30.rt,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }));
  }
}
