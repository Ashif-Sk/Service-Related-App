import 'dart:async';

import 'package:contrador/components/ui_components.dart';
import 'package:contrador/view/Authentication/main_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _isLoading = false;
      Flexify.goRemove(const MainPage(),
          animation: FlexifyRouteAnimations.slide,
          duration: const Duration(milliseconds: 600));
    });
  }

  UiComponents uiComponents = UiComponents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            uiComponents.headline1('CONTRADOR', context),
            SizedBox(
                height: 150.rh,
                width: 800.rw,
                child: Image.asset(
                  // fit: BoxFit.contain,
                  'images/splash0.png',
                )),
            20.verticalSpace,
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: uiComponents.headline2(
                    "'Find Home services,Construction,Automotive,Transportation,Tech & Repairs and Personal services'",
                    Theme.of(context).colorScheme.secondary)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Flexify.goRemove(
                //     const MainPage(),
                //   animation: FlexifyRouteAnimations.slide,
                //   duration: const Duration(milliseconds: 650)
                // );
              },
              child: _isLoading
                  ? Center(
                      child: SpinKitThreeBounce(
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : CircleAvatar(
                      radius: 80.rs,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.navigate_next,
                        size: 100.rs,
                      ),
                    ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
