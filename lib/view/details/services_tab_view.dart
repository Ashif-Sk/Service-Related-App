import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesTabView extends StatefulWidget {
  const ServicesTabView({super.key});

  @override
  State<ServicesTabView> createState() => _ServicesTabViewState();
}

class _ServicesTabViewState extends State<ServicesTabView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        padding: const EdgeInsets.only(top: 8.0,left: 10,right: 10),
        itemCount: 6,
        itemBuilder: (context, index) {
          return SizedBox(
            height: height * 0.137,
            width: width *1,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                        width: width * 0.25,
                        height: double.maxFinite,
                        child: Image.asset(
                          'images/splash0.png',
                          fit: BoxFit.fill,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        5.verticalSpace,
                        Text(
                          "Mechanic",
                          style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary,
                                fontSize: 35.rt,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Rs 20000",
                            style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontSize: 30.rt,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w600)),
                          ),
                          TextSpan(
                              text: "/month",
                              style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.visible,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 30.rt,
                                      fontWeight: FontWeight.w500)))
                        ])),
                        const Spacer(),
                        Text(
                          'Published:14/02/2025',
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  overflow: TextOverflow.visible,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                  fontSize: 25.rt,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // Container(
                    //   alignment: Alignment.topRight,
                    //   child: IconButton(
                    //       onPressed: () {},
                    //       icon: const Icon(
                    //         Icons.delete_rounded,
                    //         color: Color.fromRGBO(225, 0, 0, 1),
                    //         size: 25,
                    //       )),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
