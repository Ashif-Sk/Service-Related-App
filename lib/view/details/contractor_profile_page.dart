import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/contractor_model.dart';
import 'package:contrador/view/details/review_tab_view.dart';
import 'package:contrador/view/details/services_tab_view.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContractorProfilePage extends StatefulWidget {
  final String contractorId;
  final ContractorModel? contractor;

  const ContractorProfilePage(
      {super.key, required this.contractorId, required this.contractor});

  @override
  State<ContractorProfilePage> createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage>
    with SingleTickerProviderStateMixin {
  final UiComponents _uiComponents = UiComponents();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.31,
            width: width * 1,
            // color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: SizedBox(
                    height: height * 0.2,
                    width: width * 1,
                    child: Image.asset(
                      'images/background.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    top: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableIconButton(
                              radius: 20,
                              icon: Icons.arrow_back_rounded,
                              iconColor:
                                  Theme.of(context).colorScheme.secondary,
                              iconSize: 20,
                              onPressed: () {
                                Flexify.back();
                              }),
                          // const Spacer(),
                          ReusableIconButton(
                              radius: 20,
                              icon: Icons.more_vert_outlined,
                              iconColor:
                                  Theme.of(context).colorScheme.secondary,
                              iconSize: 20,
                              onPressed: () {}),
                        ],
                      ),
                    )),
                Positioned(
                  top: height * 0.13,
                  child: Container(
                    height: height * 0.135,
                    width: width * 0.26,
                    decoration: BoxDecoration(
                        image:  DecorationImage(
                            image: widget.contractor!.profileImage == ''
                                ? const NetworkImage(
                                "https://th.bing.com/th/id/OIP.voWdvTJvgTx7MS9hmo8sQAHaHa?pid=ImgDet&w=202&h=202&c=7&dpr=1.3")
                                : NetworkImage(
                                widget.contractor!.profileImage),
                            fit: BoxFit.contain),
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.35)),
                  ),
                ),
                Positioned(
                  top: height * 0.260,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.withOpacity(0.1)),
                    child: _uiComponents.headline3(widget.contractor!.name),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReusableIconButton(
                  radius: 20,
                  icon: Icons.call_outlined,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 20,
                  onPressed: () {}),
              30.horizontalSpace,
              ReusableIconButton(
                  radius: 20,
                  icon: Icons.messenger_outline_rounded,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 20,
                  onPressed: () {}),
              30.horizontalSpace,
              ReusableIconButton(
                  radius: 20,
                  icon: Icons.person_add_alt_outlined,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 20,
                  onPressed: () {}),
              30.horizontalSpace,
              ReusableIconButton(
                  radius: 20,
                  icon: Icons.report_problem_outlined,
                  iconColor: const Color.fromRGBO(225, 0, 0, 1),
                  iconSize: 20,
                  onPressed: () {
                    showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: height * 0.55),
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
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
          ),
          5.verticalSpace,
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
                    title: 'Service Id',
                    subTitle: widget.contractor!.serviceId),
                ReusableDetailsRow(
                    uiComponents: _uiComponents,
                    title: 'Experience',
                    subTitle: widget.contractor!.experience),
                ReusableDetailsRow(
                  title: 'Followers',
                  subTitle: '20',
                  uiComponents: _uiComponents,
                ),
              ],
            ),
          ),
          4.verticalSpace,
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary),
            child: TabBar(
                unselectedLabelColor: Colors.white,
                padding: const EdgeInsets.all(5),
                controller: _tabController,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.abel(
                    textStyle: const TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiary),
                tabs: const [
                  Tab(
                    text: 'Services',
                  ),
                  Tab(
                    text: 'Reviews',
                  )
                ]),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: TabBarView(controller: _tabController, children:  [
              ServicesTabView(contractorId: widget.contractorId,),
               ReviewTabView(contractorId: widget.contractorId,contractor: widget.contractor,),
            ]),
          )
        ],
      ),
    );
  }
}
