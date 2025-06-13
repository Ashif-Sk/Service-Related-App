import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/contractor_model.dart';
import 'package:contrador/models/user_model.dart';
import 'package:contrador/provider/user_provider.dart';
import 'package:contrador/services/review_services.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

import '../../models/review_model.dart';

class ReviewTabView extends StatefulWidget {
  final String contractorId;
  final ContractorModel? contractor;

  const ReviewTabView(
      {super.key, required this.contractorId, required this.contractor});

  @override
  State<ReviewTabView> createState() => _ReviewTabViewState();
}

class _ReviewTabViewState extends State<ReviewTabView> {
  final ReviewServices _reviewServices = ReviewServices();
  final UiComponents _uiComponents = UiComponents();
  final UserProvider _userProvider = UserProvider();

  final TextEditingController _reviewController = TextEditingController();
  double _selectedRating = 4;
  double _rating = 0;
  int _totalReviews = 0;

  Future<void> loadRatingData(String contractorId) async {
    Map<String, dynamic>? ratingData = await _reviewServices.getRatingData(contractorId);

    if (ratingData != null) {
      setState(() {
        _rating = ratingData['rating'] ?? 0.0;
        _totalReviews = ratingData['totalRatings'] ?? "";
      });
    }
  }


  @override
  void initState() {
    _userProvider.getUserDetails();
    loadRatingData(widget.contractorId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<UserProvider>(context, listen: true).userData;
    return StreamBuilder(
        stream: _reviewServices.getReviews(widget.contractorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: _uiComponents.normalText(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/feedback.png',
                    fit: BoxFit.fill,
                    height: height * 0.25,
                    width: width * 0.5,
                  ),
                  15.verticalSpace,
                  NormalMaterialButton(
                      text: 'Be a first person to write a review',
                      onPressed: () {
                        showReviewDialog(context, user);
                      }),
                ],
              ),
            );
          }
          List<ReviewModel>? reviews = snapshot.data;
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
                                currentRating: _rating,
                                onRatingChanged: (changedRating) {})),
                        Text(
                          '($_totalReviews)',
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
                    onTap: () {
                      showReviewDialog(context, user);
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
                      itemBuilder: (context, index) {
                        ReviewModel review = reviews![index];
                        return Container(
                          // height: height * 0.15,
                          width: width * 1,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ReusableIconButton(
                                      radius: 15,
                                      icon: Icons.person,
                                      iconColor: Colors.black,
                                      iconSize: 15,
                                      onPressed: () {}),
                                  20.horizontalSpace,
                                  _uiComponents.headline3(review.userName),
                                  const Spacer(),
                                  SizedBox(
                                      height: height * 0.035,
                                      // width: width * 0.067,
                                      child: RatingBar(
                                        feedbackUIType:
                                            FeedbackUIType.bottomSheet,
                                        showFeedbackForRatingsLessThan: 2,
                                        iconSize: 17,
                                        // Size of the rating icons
                                        allowHalfRating: false,
                                        // Allows selection of half ratings
                                        filledIcon: Icons.star,
                                        // Icon to display for a filled rating unit
                                        emptyIcon: Icons.star_border,
                                        // Icon to display for an empty rating units
                                        filledColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        // Color of filled rating units
                                        emptyColor: Colors.grey,
                                        // Color of empty rating units
                                        currentRating: review.rating,
                                        onRatingChanged: (double value) {},
                                      )),
                                ],
                              ),
                              Divider(
                                thickness: 0.4,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                review.reviewText,
                                textAlign: TextAlign.start,
                                // maxLines: 4,
                                style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontSize: 30.rt,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: _uiComponents.normalText(
                                    "Published:${review.reviewDate.day}/${review.reviewDate.month}/${review.reviewDate.year}"),
                              )
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> showReviewDialog(BuildContext context, UserModel? user) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: _uiComponents.headline2('Rate & Review'),
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
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
                        filledColor: Theme.of(context).colorScheme.primary,
                        // Color of filled rating units
                        emptyColor: Colors.grey,
                        // Color of empty rating units
                        currentRating: _selectedRating,
                        onRatingChanged: (changedRating) {
                          setState(() {
                            _selectedRating = changedRating;
                          });
                        }),
                    4.verticalSpace,
                    _uiComponents
                        .normalText('What do you think about the service?'),
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
                                  fontSize: 35.rt,
                                  fontWeight: FontWeight.w500)),
                          labelStyle: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  fontSize: 36.rt,
                                  fontWeight: FontWeight.normal)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
              actions: [
                NormalMaterialButton(
                    text: 'Submit',
                    onPressed: () {
                      _reviewServices
                          .uploadReview(
                              ReviewModel(
                                  contractorId: widget.contractorId,
                                  reviewText: _reviewController.text.toString(),
                                  rating: _selectedRating,
                                  userId: user!.userId,
                                  userProfileImage: user.imagePath,
                                  userName: user.name,
                                  reviewDate: DateTime.now()),
                              widget.contractorId)
                          .then((_) {
                        _reviewServices
                            .updateRatingReviews(widget.contractorId);
                        Flexify.back();
                      });
                    }),
                NormalMaterialButton(
                    text: 'back',
                    onPressed: () {
                      Flexify.back();
                    })
              ],
            );
          });
        });
  }
}
