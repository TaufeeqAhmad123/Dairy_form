import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';

class UserSettings extends StatefulWidget {
  static String id = 'UserSettings';

  static XFile? profileImage;

 static String name = 'M. Waqas';
  static String phone = '03127959553';

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  //Image Picker From Phone Gallery.
  ImagePicker _imagePicker = ImagePicker();

  //Controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Settings'),
        actions: [
          GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tap To Save Information"),
              ));
            },
            onTap: (){
              UserSettings.name = userNameController.text;
              UserSettings.phone = phoneNumberController.text;
              Fluttertoast.showToast(msg: 'Data Updated');
              setState(() {});
            },
            child: Icon(FontAwesomeIcons.check),),
          SizedBox(width: 15,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              //User Image Text
            InformationText('User Image'),
            //Image Container
            Container(
              height: 200.0,
              width: 200.0,
              child: UserSettings.profileImage == null
                  ? Image.asset(
                'images/dummyImage.png',
              )
                  : Image.file(
                File('${UserSettings.profileImage?.path}'),
              ),
            ),
            //Upload Image Button
            CustomButton(
              icon: Icons.photo,
              buttonName: 'Upload Image',
              onPressed: () async {
                UserSettings.profileImage = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {});
              },
            ),
              //User Name Text Field
              MyTextField(
                hintIcon: Icon(FontAwesomeIcons.user,color: greenColor,),
                hintText: 'User Name',
                controller: userNameController,
              ),
              //Phone Number Text Field
              MyTextField(
                numberKeyboard: true,
                hintIcon: Icon(FontAwesomeIcons.phone,color: greenColor,),
                hintText: 'Phone Number',
                controller: phoneNumberController,
              )
          ],),

        ),
      ));
  }
}
