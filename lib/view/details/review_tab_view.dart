import 'package:contrador/components/ui_components.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

class ReviewTabView extends StatefulWidget {
  const ReviewTabView({super.key});

  @override
  State<ReviewTabView> createState() => _ReviewTabViewState();
}

class _ReviewTabViewState extends State<ReviewTabView> {
  final UiComponents _uiComponents = UiComponents();
  TextEditingController _reviewController =TextEditingController();
  double currentRating = 4;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            5.verticalSpace,
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _uiComponents.headline3('Total Rating'),
                  const Spacer(),
                  SizedBox(
                      height: height * 0.035,
                      // width: width * 0.067,
                      child: RatingBar(
                          feedbackUIType: FeedbackUIType.bottomSheet,
                          showFeedbackForRatingsLessThan: 2,
                          iconSize: 17,
                          // Size of the rating icons
                          allowHalfRating: false,
                          // Allows selection of half ratings
                          filledIcon: Icons.star,
                          // Icon to display for a filled rating unit
                          emptyIcon: Icons.star_border,
                          // Icon to display for an empty rating units
                          filledColor:
                          Theme.of(context).colorScheme.primary,
                          // Color of filled rating units
                          emptyColor: Colors.grey,
                          // Color of empty rating units
                          currentRating: currentRating,
                          onRatingChanged: (changedRating) {
                            setState(() {
                              currentRating = changedRating;
                            });
                          })),
                  Text(
                    '(786)',
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            overflow: TextOverflow.visible,
                            color:
                            Theme.of(context).colorScheme.secondary,
                            fontSize: 30.rt,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: (){
                showReviewDialog(context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Write a review?",
                  // textAlign: TextAlign.right,
                  style: GoogleFonts.abel(
                    textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue.shade900,
                        fontSize: 30.rt,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
            _uiComponents.headline3('All reviews'),
            Divider(
              thickness: 0.4,
              color: Theme.of(context).colorScheme.primary,
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              itemCount: 1,
                itemBuilder: (context,index){
                  return Container(
                    // height: height * 0.15,
                    width: width*1,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ReusableIconButton(
                                radius: 15,
                                icon: Icons.person,
                                iconColor: Colors.black,
                                iconSize: 15,
                                onPressed: (){}),
                            20.horizontalSpace,
                            _uiComponents.headline3('Ashif'),
                            const Spacer(),
                            SizedBox(
                                height: height * 0.035,
                                // width: width * 0.067,
                                child: RatingBar(
                                    feedbackUIType: FeedbackUIType.bottomSheet,
                                    showFeedbackForRatingsLessThan: 2,
                                    iconSize: 17,
                                    // Size of the rating icons
                                    allowHalfRating: false,
                                    // Allows selection of half ratings
                                    filledIcon: Icons.star,
                                    // Icon to display for a filled rating unit
                                    emptyIcon: Icons.star_border,
                                    // Icon to display for an empty rating units
                                    filledColor:
                                    Theme.of(context).colorScheme.primary,
                                    // Color of filled rating units
                                    emptyColor: Colors.grey,
                                    // Color of empty rating units
                                    currentRating: currentRating,
                                    onRatingChanged: (changedRating) {
                                      setState(() {
                                        currentRating = changedRating;
                                      });
                                    })),
                          ],
                        ),
                        Divider(
                          thickness: 0.4,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      Text(
                          'Location Symbols are text icons that you can copy and paste like regular text. These Location Symbols can be used in any desktop, web, or phone application. To use Location Symbols/Signs you just need to click on the symbol icon and it will be copied to your clipboard, then paste it …',
                          textAlign: TextAlign.start,
                          // maxLines: 4,
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontSize: 30.rt,
                                  fontWeight: FontWeight.w600))),
                      ],
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showReviewDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return  AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            title: _uiComponents.headline2('Rate & Review'),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
            ),
            icon: Icon(Icons.emoji_emotions_outlined,color: Theme.of(context).colorScheme.primary,),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 0.4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  RatingBar(
                      iconSize: 35,
                      // Size of the rating icons
                      allowHalfRating: false,
                      // Allows selection of half ratings
                      filledIcon: Icons.star,
                      // Icon to display for a filled rating unit
                      emptyIcon: Icons.star_border,
                      // Icon to display for an empty rating units
                      filledColor:
                      Theme.of(context).colorScheme.primary,
                      // Color of filled rating units
                      emptyColor: Colors.grey,
                      // Color of empty rating units
                      currentRating: currentRating,
                      onRatingChanged: (changedRating) {
                        setState(() {
                          currentRating = changedRating;
                        });
                      }),
                  4.verticalSpace,
                  _uiComponents.normalText('What do you think about the service?'),
                  Divider(
                    thickness: 0.4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  _uiComponents.headline3('Your review:'),
                  4.verticalSpace,
                  TextFormField(
                    maxLines: 2,
                    maxLength: 1000,
                    controller: _reviewController,
                    // textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                        hintText: 'Give your review here',
                        // labelText: 'Description*',
                        hintStyle: GoogleFonts.abel(
                            textStyle: TextStyle(
                                fontSize: 35.rt, fontWeight: FontWeight.w500)),
                        labelStyle: GoogleFonts.acme(
                            textStyle: TextStyle(
                                fontSize: 36.rt, fontWeight: FontWeight.normal)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            actions: [
              NormalMaterialButton(text: 'Submit', onPressed: (){}),
              NormalMaterialButton(text: 'back', onPressed: (){Flexify.back();})
            ],
          );
        });
  }
}
