import 'package:contrador/components/ui_components.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final UiComponents _uiComponents = UiComponents();
  double currentRating = 4.0;
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
      body: GridView.builder(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2),
          itemCount: 6,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
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
                              child: Image.asset(
                                'images/pic.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 15,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_outline_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                      2.verticalSpace,
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          'Ashif',
                          style:GoogleFonts.abel(
                            textStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary,
                              fontSize: 35.rt,
                              fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: '2000000',
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontSize: 30.rt,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600)),
                        ),
                        TextSpan(
                          text: "/sec",
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
                              iconSize: 20, // Size of the rating icons
                              allowHalfRating: false, // Allows selection of half ratings
                              filledIcon: Icons.star, // Icon to display for a filled rating unit
                              emptyIcon: Icons.star_border, // Icon to display for an empty rating units
                              filledColor: Colors.amber, // Color of filled rating units
                              emptyColor: Colors.grey, // Color of empty rating units
                              currentRating: currentRating,
                              onRatingChanged: (changedRating){
                                setState(() {
                                   currentRating=changedRating;
                                });
                              }
                          )
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.location_on,size: 15,),
                          SizedBox(
                            width: width * 0.34,
                            child: Text(
                              'Illambazar,birbhum',
                              style:GoogleFonts.abel(
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                  fontSize: 30.rt,
                                  fontWeight: FontWeight.w500,),
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
          }),
    );
  }
}
