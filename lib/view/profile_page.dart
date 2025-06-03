import 'package:contrador/components/ui_components.dart';
import 'package:contrador/view/Authentication/main_page.dart';
import 'package:contrador/view/profile/edit_profile_page.dart';
import 'package:contrador/view/profile/help_support_page.dart';
import 'package:contrador/view/profile/settings_page.dart';
import 'package:contrador/view/profile/wishlist_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../provider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UiComponents _uiComponents = UiComponents();
  final UserProvider _userProvider = UserProvider();
  @override
  void initState() {
    _userProvider.getUserDetails();
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<UserProvider>(context,listen: true);
    if(user.userData == null){
      return Center(
        child: SpinKitCircle(
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            Container(
              alignment: Alignment.center,
              height: height * 0.095,
              width: width * 0.30,
              child: Image.asset('images/logo1.png'),
            ),
            Divider(
              thickness: 0.4,
              color: Theme.of(context).colorScheme.primary,
            ),
            4.verticalSpace,
            Container(
              height: height * 0.135,
              width: width * 0.26,
              decoration: BoxDecoration(
                  image:  DecorationImage(
                      image: user.userData != null ? const NetworkImage(
                          "https://th.bing.com/th/id/OIP.voWdvTJvgTx7MS9hmo8sQAHaHa?pid=ImgDet&w=202&h=202&c=7&dpr=1.3")
                          : NetworkImage(
                          user.userData!.imagePath),
                      fit: BoxFit.contain),
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.35)),
            ),
            4.verticalSpace,
            user.userData != null ? _uiComponents.headline2(user.userData!.name):SpinKitCircle(
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            8.verticalSpace,
            NormalMaterialButton(
                text: 'Edit Profile',
                onPressed: () {
                  Flexify.go(const EditProfilePage(),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 500));
                }),
            10.verticalSpace,
            ReusableListTile(
                text: 'Favourite',
                leadingIcon: Icons.favorite_rounded,
                onTap: () {
                  Flexify.go(const WishlistPage(),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 400),);
                },
                trailingIcon: Icons.navigate_next),
            4.verticalSpace,
            ReusableListTile(
                text: 'Help & Support',
                leadingIcon: Icons.headset_mic,
                onTap: () {
                  Flexify.go(const HelpSupportPage(),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 400));
                },
                trailingIcon: Icons.navigate_next),
            4.verticalSpace,
            ReusableListTile(
                text: 'Settings',
                leadingIcon: Icons.settings,
                onTap: () {
                  Flexify.go(const SettingsPage(),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 400));
                },
                trailingIcon: Icons.navigate_next),
            4.verticalSpace,
            ReusableListTile(
                text: 'Share our app',
                leadingIcon: Icons.share,
                onTap: () {
                  _shareContent();
                },
                trailingIcon: Icons.navigate_next),
            4.verticalSpace,
            ReusableListTile(
                text: 'Rate us',
                leadingIcon: Icons.star_rate_rounded,
                onTap: () {},
                trailingIcon: Icons.navigate_next),
            4.verticalSpace,
            ReusableListTile(
                text: 'Log Out',
                leadingIcon: Icons.exit_to_app_rounded,
                onTap: () {
                  _uiComponents.confirmationDialog(
                      context,
                      'Are you sure, you want to logout?',
                      'Confirm',
                      'Back', () {
                    FirebaseAuth.instance.signOut().then((_) {
                      Flexify.goRemoveAll(const MainPage(),
                          animation: FlexifyRouteAnimations.slideFromBottom,
                          duration: const Duration(milliseconds: 300));
                    });
                  }, () => Flexify.back());
                },
                trailingIcon: Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}

void _shareContent() {
  Share.share('Check out this amazing Flutter app!', subject: 'Flutter App');
}
