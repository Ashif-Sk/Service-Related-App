import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/favourite_model.dart';
import 'package:contrador/provider/favourite_provider.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/details/contractor_profile_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

import '../../models/contractor_model.dart';

class ServiceDetailsPage extends StatefulWidget {
  final ContractorModel contractor;

  const ServiceDetailsPage({super.key, required this.contractor});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final UiComponents _uiComponents = UiComponents();
  final ChatServices _chatServices = ChatServices();
  double currentRating = 4.0;
  late final FavouriteModel _favouriteModel;
  @override
  void initState() {
   _favouriteModel = FavouriteModel(
        contractorId: widget.contractor.contractorId,
        serviceId:  widget.contractor.serviceId,
        name:  widget.contractor.name,
       price:  int.parse(widget.contractor.cost),
        rating:  widget.contractor.rating,
        imagePath:  widget.contractor.imagePaths.isEmpty?'':widget.contractor.imagePaths[0],
        option:  widget.contractor.option,
        address:  widget.contractor.address);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    final favourite = Provider.of<FavouriteProvider>(context,listen: true);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: _uiComponents
            .headline2(widget.contractor.subcategory.toUpperCase()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: SizedBox(
                        height: height * 0.3,
                        width: width * 1,
                        child: CarouselView(
                            itemSnapping: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.grey.withOpacity(0.35),
                            itemExtent: 400,
                            shrinkExtent: 200,
                            children: [
                              Image.network(
                                "https://strapi.dhiwise.com/uploads/Firebase_Node_JS_OG_Image_f6223f11a9.png",
                                fit: BoxFit.cover,
                              )
                            ]
                            //     widget.contractor.imagePaths.map((images) {
                            //   return Image.network(images);
                            // }).toList(),
                            ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: ReusableIconButton(
                            radius: 20,
                            icon: favourite.isFavourite(_favouriteModel)?Icons.favorite:Icons.favorite_outline_rounded,
                            iconColor: favourite.isFavourite(_favouriteModel)?Colors.red:Colors.white,
                            iconSize: 20,
                            onPressed: () {
                              favourite.addToWishlist(_favouriteModel);
                            }))
                  ],
                ),
                5.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contractor.businessName,
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 50.rt,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: widget.contractor.cost,
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontSize: 35.rt,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w600)),
                            ),
                            TextSpan(
                                text: "/${widget.contractor.pricingModel}",
                                style: GoogleFonts.abel(
                                    textStyle: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 35.rt,
                                        fontWeight: FontWeight.w500)))
                          ])),
                          _uiComponents
                              .normalText('📍${widget.contractor.address}'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Published:${widget.contractor.timeStamp.day}/${widget.contractor.timeStamp.month}/${widget.contractor.timeStamp.year}',
                            style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    overflow: TextOverflow.visible,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 25.rt,
                                    fontWeight: FontWeight.w500)),
                          ),
                          ReusableIconButton(
                              radius: 20,
                              icon: Icons.report_problem_outlined,
                              iconColor: const Color.fromRGBO(225, 0, 0, 1),
                              iconSize: 20,
                              onPressed: () {
                                showModalBottomSheet(
                                    constraints: BoxConstraints(
                                        maxHeight: height * 0.55),
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    useSafeArea: true,
                                    showDragHandle: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    context: context,
                                    builder: (context) {
                                      return const ReportForm();
                                    });
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 5, bottom: 5),
                  child: ListTile(
                    onTap: () {
                      Flexify.go(
                          ContractorProfilePage(
                            contractorId: widget.contractor.contractorId,
                            contractor: widget.contractor,
                          ),
                          animation: FlexifyRouteAnimations.slide,
                          animationDuration: const Duration(milliseconds: 500));
                    },
                    contentPadding: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: Colors.grey.withOpacity(0.1),
                    leading: Container(
                      height: height * 0.08,
                      width: width * 0.14,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: widget.contractor.profileImage == ''
                                  ? const NetworkImage(
                                      "https://th.bing.com/th/id/OIP.voWdvTJvgTx7MS9hmo8sQAHaHa?pid=ImgDet&w=202&h=202&c=7&dpr=1.3")
                                  : NetworkImage(
                                      widget.contractor.profileImage),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.35)),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    title: Text(
                      widget.contractor.name,
                      style: GoogleFonts.abel(
                          textStyle: TextStyle(
                        overflow: TextOverflow.visible,
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 31.rt,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    child: _uiComponents.headline2('Details')),
                4.verticalSpace,
                //subcategory,experience,options
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableDetailsRow(
                          uiComponents: _uiComponents,
                          title: 'Experience',
                          subTitle: widget.contractor.experience),
                      ReusableDetailsRow(
                          uiComponents: _uiComponents,
                          title: 'Option',
                          subTitle: widget.contractor.option),
                      ReusableDetailsRow(
                        title: 'Subcategory',
                        subTitle: widget.contractor.subcategory,
                        uiComponents: _uiComponents,
                      ),
                      Row(
                        children: [
                          _uiComponents.normalText('Ratings'),
                          const Spacer(),
                          SizedBox(
                              height: height * 0.035,
                              // width: width * 0.067,
                              child: RatingBar(
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
                                  currentRating: widget.contractor.rating,
                                  onRatingChanged: (changedRating) {})),
                          Text(
                            '(${widget.contractor.totalRatings})',
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
                    ],
                  ),
                ),
                4.verticalSpace,
                Divider(
                  thickness: 0.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    child: _uiComponents.headline2('Description')),
                4.verticalSpace,
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1)),
                    child: Text(widget.contractor.description,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                overflow: TextOverflow.visible,
                                fontSize: 30.rt,
                                fontWeight: FontWeight.w600)))),
                4.verticalSpace,
                Divider(
                  thickness: 0.4,
                  color: Theme.of(context).colorScheme.primary,
                ),

                4.verticalSpace,
              ],
            ),
          ),
          Container(
            height: height * 0.088,
            width: width * 1,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTextButton(
                    height: height * 0.06,
                    width: width * 0.4,
                    buttonText: 'Chat',
                    onPressed: () async {
                      _chatServices.startNewChat(widget.contractor.contractorId);
                    },
                    icon: Icons.chat_bubble_outline),
                30.horizontalSpace,
                IconTextButton(
                    height: height * 0.06,
                    width: width * 0.4,
                    buttonText: 'Contact',
                    onPressed: () {},
                    icon: Icons.call),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
