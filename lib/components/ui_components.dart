import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UiComponents {
  Widget headline2(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
            textStyle:  const TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 20,
                fontWeight: FontWeight.w600)));
  }

  Widget headline3(String text) {
    return Text(text,
        // textAlign: TextAlign.left,
        style: GoogleFonts.abel(
            textStyle: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 35.rt,
                fontWeight: FontWeight.w600)));
  }

  Widget normalText(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: GoogleFonts.abel(
            textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 30.rt,
                fontWeight: FontWeight.w600)));
  }

  Widget headline1(String text, BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
          textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 85.rt,
              fontWeight: FontWeight.bold,
              letterSpacing: 4),
        ));
  }

  Future<dynamic> errorDialog(String message, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            actionsAlignment: MainAxisAlignment.center,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.verticalSpace,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abel(
                      textStyle: TextStyle(
                          overflow: TextOverflow.visible,
                          fontSize: 32.rt,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Flexify.back();
                  },
                  child: Text('OK',
                      style: GoogleFonts.aclonica(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15),
                      )))
            ],
          );
        });
  }

  Future<dynamic> confirmationDialog(
      BuildContext context,
      String title,
      String buttonText0,
      String buttonText1,
      Function() onPressed0,
      Function() onPressed1) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            actionsAlignment: MainAxisAlignment.center,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.verticalSpace,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abel(
                      textStyle: TextStyle(
                          overflow: TextOverflow.visible,
                          fontSize: 32.rt,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: onPressed0,
                child: Text(
                  buttonText0,
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28.rt),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onPressed1,
                child: Text(
                  buttonText1,
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28.rt),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<dynamic> mediaBottomSheet (
      BuildContext context,
      double height,
      String? enabled,
      Function() cameraPressed,
      Function() galleryPressed,
      Function() deletePressed){
        return showModalBottomSheet(
        showDragHandle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
        constraints: BoxConstraints(maxHeight: height),
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.1)
                    ),
                    child: IconButton(
                        onPressed: cameraPressed,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        )),
                  ),
                  normalText('Camera')
                ],
              ),
              30.horizontalSpace,
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: IconButton(
                      onPressed: galleryPressed,
                      icon: Icon(
                        Icons.photo_outlined,
                        size: 30,
                        color:
                        Theme.of(context).colorScheme.primary,
                      ),),
                  ),
                  normalText('Gallery'),

                ],
              ),
              enabled == null?30.horizontalSpace:0.horizontalSpace,
              enabled == null?Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: IconButton(
                      onPressed: deletePressed,
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        size: 30,
                        color:
                        Theme.of(context).colorScheme.primary,
                      ),),
                  ),
                  normalText('Remove'),

                ],
              ):0.horizontalSpace,
            ],
          );
        });
  }
}

class BigImage extends StatelessWidget {
  final String imagePath;

  const BigImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.25,
      width: width * 05,
      child: Image(image: AssetImage(imagePath)),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double height;
  final double width;
  final void Function() onPressed;

  const CategoryCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.onPressed, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height * 0.19,
        width: width * 0.30,
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                4.verticalSpace,
                SizedBox(
                    height: height * 0.08,
                    width: width * 0.18,
                    child: Image.asset(imagePath,fit: BoxFit.fill,)),
                3.verticalSpace,
                FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    height: height * 0.045,
                    width: width * 0.22,
                    child: Text(
                      textScaler: const TextScaler.linear(1.0),
                      maxLines: 2,
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.abel(
                          textStyle: TextStyle(
                              overflow: TextOverflow.visible,
                              color: Theme.of(context).colorScheme.secondary,
                              // fontSize: 31.rt,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String imagepath;
  final String title;
  final void Function() onPressed;

  const JobCard(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height * 0.19,
        width: width * 1,
        child: Card(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.10,
                    width: width * 0.18,
                    child: Image.asset(imagepath)),
                1.5.verticalSpace,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abel(
                      textStyle: TextStyle(
                          overflow: TextOverflow.visible,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 31.rt,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableListTile extends StatelessWidget {
  final String text;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final void Function()? onTap;

  const ReusableListTile(
      {super.key,
      required this.text,
      required this.leadingIcon,
      required this.onTap,
      required this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      leading: Icon(
        leadingIcon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(text,
          style: GoogleFonts.abel(
              textStyle: TextStyle(
            overflow: TextOverflow.visible,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 35.rt,
            fontWeight: FontWeight.bold,
          ))),
      trailing: Icon(
        trailingIcon,
        size: 35,
      ),
    );
  }
}

class NormalTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final String? extraText;

  const NormalTextButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.extraText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(extraText!),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText,
              style: GoogleFonts.aclonica(
                textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 15),
              )),
        ),
      ],
    );
  }
}

class UniversalButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;

  const UniversalButton(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.066,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Theme.of(context).colorScheme.primary),
        child: Text(buttonText,
            style: GoogleFonts.acme(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.tertiary),
            )),
      ),
    );
  }
}

class BigOutlineButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final String image;

  const BigOutlineButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.066,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 30,
              width: 30,
            ),
            15.horizontalSpace,
            Text(buttonText,
                style: GoogleFonts.acme(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary),
                )),
          ],
        ),
      ),
    );
  }
}

class NormalMaterialButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const NormalMaterialButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height * 0.048,
      // width: double.maxFinite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Theme.of(context).colorScheme.primary,
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.acme(
            textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final double height;
  final double width;
  final String buttonText;
  final void Function() onPressed;
  final IconData icon;
  const IconTextButton({super.key, required this.height, required this.width, required this.buttonText, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: FilledButton(
            style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                )
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(icon,size: 20,),
                10.horizontalSpace,
                Text(
                  buttonText,
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            ),),);
  }
}
/*

 */
class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final UiComponents _uiComponents = UiComponents();
  List<String> reportList = ['Fraud','Scam','Inappropriate behaviour','Inappropriate content','Fake profile','Other'];
  String selectedValue = '';
  final TextEditingController _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _uiComponents.headline2('Report?'),
              IconButton(onPressed: (){Flexify.back();}, icon: const Icon(Icons.close_rounded))
            ],
          ),
          Divider(
            thickness: 0.4,
            color: Theme.of(context).colorScheme.primary,
          ),
          4.verticalSpace,
          _uiComponents.headline3('Share your experience:'),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: reportList.length,
              itemBuilder: (context , index){
            return SizedBox(
              height: height * 0.04,
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: reportList[index],
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
                title: _uiComponents.normalText(reportList[index]),
                activeColor: Theme.of(context).colorScheme.primary,
                selected: selectedValue == reportList[index],
                // controlAffinity: ListTileControlAffinity.trailing,
              ),
            );
          }),
          10.verticalSpace,
          _uiComponents.headline3('Your feedback:'),
          4.verticalSpace,
          TextFormField(
            maxLines: 2,
            maxLength: 1000,
            controller: _feedbackController,
            // textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                hintText: 'Give your feedback here',
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
    );
  }
}

class ReusableDetailsRow extends StatelessWidget {
  final String title;
  final String subTitle;

  ReusableDetailsRow({
    super.key,
    required UiComponents uiComponents,
    required this.title,
    required this.subTitle,
  });

  final UiComponents _uiComponents = UiComponents();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _uiComponents.normalText(title),
        Text(
          subTitle,
          style: GoogleFonts.abel(
            textStyle: TextStyle(
                overflow: TextOverflow.visible,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 30.rt,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

/*

 */
class ReusableIconButton extends StatefulWidget {
  final double radius;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final void Function() onPressed;
  const ReusableIconButton({super.key,
    required this.radius,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.onPressed});

  @override
  State<ReusableIconButton> createState() => _ReusableIconButtonState();
}

class _ReusableIconButtonState extends State<ReusableIconButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      radius: widget.radius,
      child: IconButton(
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
  }
}



