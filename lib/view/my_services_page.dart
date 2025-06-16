import 'package:contrador/components/ui_components.dart';
import 'package:contrador/services/contractor_services.dart';
import 'package:contrador/view/Publish%20Job/category_selection_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/contractor_model.dart';

class MyServicesPage extends StatefulWidget {
  const MyServicesPage({super.key});

  @override
  State<MyServicesPage> createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  final UiComponents _uiComponents = UiComponents();
  final ContractorServices _contractorServices = ContractorServices();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _uiComponents.headline2('My services',Theme.of(context).colorScheme.tertiary),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
          future: _contractorServices.getAllServicesByContractorId(_userId),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: _uiComponents.loading()
              );
            }

            if(snapshot.hasError){
              return Center(
                  child: _uiComponents.normalText(snapshot.error.toString()),
              );
            }

            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/requirements.png',fit: BoxFit.fill,height: height * 0.25,width: width * 0.5,),
                    15.verticalSpace,
                    NormalMaterialButton(text: 'Publish a service', onPressed: () {
                      Flexify.go(
                          const CategorySelectionPage(),
                          animation: FlexifyRouteAnimations.slide,
                          animationDuration: const Duration(milliseconds: 400)
                      );
                    }),
                  ],
                ),
              );
            }
            List<ContractorModel>? myService= snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: myService?.length,
                itemBuilder: (context, index) {
                  ContractorModel service = myService![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                    child: SizedBox(
                      height: height * 0.137,
                      width: double.maxFinite,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: width * 0.25,
                                  height: double.maxFinite,
                                  child: service.imagePaths.isEmpty?Image.asset(
                                    'images/splash0.png',
                                    fit: BoxFit.fill,
                                  ):Image.network(service.imagePaths[0])),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  5.verticalSpace,
                                  Text(
                                    service.businessName,
                                    style: GoogleFonts.abel(
                                      textStyle: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 35.rt,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: "Rs ${service.cost}",
                                      style: GoogleFonts.abel(
                                          textStyle: TextStyle(
                                              overflow: TextOverflow.visible,
                                              fontSize: 30.rt,
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    TextSpan(
                                        text: "/${service.pricingModel}",
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
                                    'Published:${service.timeStamp.day}/${service.timeStamp.month}/${service.timeStamp.year}',
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
                              const Spacer(),
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      color: Color.fromRGBO(225, 0, 0, 1),
                                      size: 25,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
