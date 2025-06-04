import 'package:contrador/services/contractor_services.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/ui_components.dart';
import '../../models/contractor_model.dart';

class ServicesTabView extends StatefulWidget {
  final String contractorId;
  const ServicesTabView({super.key,required this.contractorId});

  @override
  State<ServicesTabView> createState() => _ServicesTabViewState();
}

class _ServicesTabViewState extends State<ServicesTabView> {
  final ContractorServices _contractorServices = ContractorServices();
  final UiComponents _uiComponents =UiComponents();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: _contractorServices.getAllServicesByContractorId(widget.contractorId),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: _uiComponents.normalText(snapshot.error.toString()),
            );
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(
              child: _uiComponents.headline3('No Services')
            );
          }
          List<ContractorModel>? serviceList= snapshot.data;
          return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0,left: 10,right: 10),
              itemCount: serviceList!.length,
              itemBuilder: (context, index) {
                ContractorModel service = serviceList[index];
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
                              child: service.imagePaths.isEmpty?Image.asset(
                                'images/splash0.png',
                                fit: BoxFit.fill,
                              ):Image.network(service.imagePaths[0]),),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              5.verticalSpace,
                              Text(
                                service.name,
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
                                    text: "/${service.option}",
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
                        ],
                      ),
                    ),
                  ),
                );
              });
        });



  }
}
