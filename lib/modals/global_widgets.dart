// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_user.dart';

import '../../constants/constants.dart';
import '../routes/Login Registration/Login.dart';

class MyCard extends StatelessWidget {
  MyCard({required this.name,
    required this.quantity,
    required this.image,
    required this.color});

  final String name, quantity;
  final Image image;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        height: 160.0,
        width: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quantity,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.elliptical(80.0, 80.0),
                      topLeft: Radius.elliptical(50.0, 20.0),
                      bottomRight: Radius.elliptical(13.0, 50.0),
                      bottomLeft: Radius.circular(30.0))),
              child: image,
            )
          ],
        ),
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  TableCard({required this.text, required this.quantity});

  final String quantity;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      maxRadius: 50.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
              maxRadius: 25.0,
              backgroundColor: primaryColor,
              child: Text(
                quantity,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              )),
          Center(
            child: Text(
              text,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class MultiLevelTile extends StatelessWidget {
  final String name;
  final Icon icon;
  final List<Widget> subLevelTiles;

  MultiLevelTile(
      {required this.icon, required this.name, required this.subLevelTiles});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: icon,
      childrenPadding: EdgeInsets.only(left: 00.0),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green.shade500,
      iconColor: Colors.white,
      textColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      collapsedIconColor: primaryColor,
      collapsedTextColor: primaryColor,
      children: subLevelTiles,
    );
  }
}

class SingleLevelTile extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  final String name;
  final Icon? icon;
  final Color? color;
  final String? screen;

  SingleLevelTile({required this.name, this.icon, this.color, this.screen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (screen != null) Navigator.pushNamed(context, screen!);
        if (screen == Login.id){
          print('LogOut');
          auth.signOut();
        }
      },
      child: ListTile(
        iconColor: color == null ? Colors.white : primaryColor,
        textColor: color == null ? Colors.white : primaryColor,
        leading: icon == null
            ? Icon(Icons.keyboard_double_arrow_right_rounded)
            : icon,
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String? hintText;
  final Icon? hintIcon;
  IconButton? icon;
  bool passwordHide;
  Function()? onTap;
  bool noKeyboard;
  TextEditingController? controller = TextEditingController();
  bool numberKeyboard;
  final FormFieldValidator? validator;
  Function(String)? onChanged;

  MyTextField({this.hintText,
    this.hintIcon,
    this.icon,
    this.passwordHide = false,
    this.controller,
    this.onTap,
    this.noKeyboard = false,
    this.numberKeyboard = false,
    this.validator,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 0.0, top: 10.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        keyboardType: noKeyboard == true
            ? TextInputType.none
            : numberKeyboard == true ? TextInputType.number : TextInputType
            .text,
        onTap: onTap,
        controller: controller,
        obscureText: passwordHide,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(20.0),
            prefixIcon: hintIcon,
            suffixIcon: icon,
            hintText: hintText,
            fillColor: Colors.grey.shade200,
            filled: true
        ),
      ),
    );
  }
}

class MyDropDownMenu extends StatelessWidget {
  final String? hintText;
  final Icon? hintIcon;
  final int items;
  SingleValueDropDownController? controller = SingleValueDropDownController();
  List<DropDownValueModel> DropDownEntries = [];

  MyDropDownMenu({this.hintText,
    this.hintIcon,
    required this.items,
    required this.DropDownEntries,
    this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: DropDownTextField(
        controller: controller,
        dropdownRadius: 0.0,
        dropDownItemCount: items,
        textFieldDecoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(20.0),
          fillColor: Colors.grey.shade200,
          filled: true,
          prefixIcon: hintIcon,
          hintText: hintText,
        ),
        dropDownList: DropDownEntries,
      ),
    );
  }
}

class StaffListColumn extends StatelessWidget {
  final String? columnName;
  final double? fontSize;
  final Color? color;
  bool? inContainer;
  Color? containerColor;

  StaffListColumn({
    required this.columnName,
    this.fontSize,
    this.color,
    this.inContainer,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: inContainer == true
          ? Container(
        decoration: BoxDecoration(
            color: containerColor == null ? greenColor : containerColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        height: 30.0,
        width: 50.0,
        child: Center(
          child: Text(
            ('$columnName'),
            style: TextStyle(
                fontWeight: fontSize != null ? FontWeight.bold : null,
                fontSize: fontSize != null ? 15.0 : null,
                color: color != null ? color : Colors.white),
          ),
        ),
      )
          : Center(
        child: Text(
          ('$columnName'),
          style: TextStyle(
              fontWeight: fontSize != null ? FontWeight.bold : null,
              fontSize: fontSize != null ? 15.0 : null,
              color: color != null ? color : Colors.black),
        ),
      ),
    );
  }
}

class ShowOnOffButton extends StatefulWidget {
  bool switchValue = false;

  @override
  State<ShowOnOffButton> createState() => _ShowOnOffButtonState();
}

class _ShowOnOffButtonState extends State<ShowOnOffButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        trackColor: Colors.red,
        value: widget.switchValue,
        onChanged: (bool value) {
          setState(() {
            widget.switchValue = value;
          });
        });
  }
}

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  ActionIcon({required this.color, required this.icon,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(4.0))),
      height: 30.0,
      width: 30.0,
      child: Icon(
        icon,
        size: 18.0,
        color: Colors.white,
      ),
    );
  }
}

class EditAndDeleteButton extends StatelessWidget {
  final Function()? onTapDelete;
  final Function()? onTapEdit;


  EditAndDeleteButton({this.onTapDelete, this.onTapEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: onTapEdit,
                child: ActionIcon(
                  icon: FontAwesomeIcons.pen,
                  color: greenColor,
                ),
              ),
              GestureDetector(
                onTap: onTapDelete,
                child: ActionIcon(
                  icon: FontAwesomeIcons.trashCan,
                  color: Colors.red,
                ),
              )
            ],
          )),
    );
  }
}

class CustomTableRowDesign extends StatelessWidget {
  List<TableRow> children = [
  ];
  Map<int, TableColumnWidth>? customColumnWidths = {};

  CustomTableRowDesign({
    required this.children,
    this.customColumnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: FixedColumnWidth(100),
            columnWidths: customColumnWidths,
            border: TableBorder.all(),
            children: children,
          ),
        ),
      ),
    );
  }

  static TableRow CustomTableRow({bool? userList}) {

    return TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        children: [
          StaffListColumn(
            columnName: 'Name',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'Email',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'Phone',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'Joining Date',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'User Type',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'Status',
            fontSize: fontSize,
          ),
          StaffListColumn(
            columnName: 'Action',
            fontSize: fontSize,
          ),
        ]);
  }
}

class dateSelectionTextField extends StatefulWidget {
  String? hintText;
  TextEditingController? calendarDate = TextEditingController();
  final FormFieldValidator? validator;
  Function(String)? onChanged;


  dateSelectionTextField({this.hintText, this.calendarDate, this.validator,this.onChanged});


  @override
  State<dateSelectionTextField> createState() => _dateSelectionTextFieldState();
}

class _dateSelectionTextFieldState extends State<dateSelectionTextField> {
  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onChanged: widget.onChanged,
      validator: widget.validator,
      noKeyboard: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100));
        setState(() {
          widget.calendarDate?.text = DateFormat.yMd().format(picked!).toString();

          // widget.calendarDate?.text = picked.toString();
        });
      },
      hintText: widget.hintText,
      hintIcon: const Icon(
        FontAwesomeIcons.calendarCheck,
        color: greenColor,
      ),
      controller: widget.calendarDate,
    );
  }
}

class CustomButton extends StatelessWidget {
  String? buttonName;
  Function()? onPressed;
  IconData? icon;

  CustomButton({required this.buttonName, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
            width: 320.0,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff109C5B),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.0,
                    ),
                  ),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                  if (icon != null)
                    SizedBox(
                      width: 5.0,
                    ),
                  Text(
                    '$buttonName',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1.5,
            indent: 8.0,
            endIndent: 8.0,
          ),
        ],
      ),
    );
  }
}

class TotalReportInfo extends StatelessWidget {
  String? total;

  TotalReportInfo(this.total);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          ('$total'),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ));
  }
}

class InformationText extends StatelessWidget {
  String? informationText;

  InformationText(this.informationText);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
        child: Text(
          '$informationText:',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    required this.controller,
    required this.hintText,
    this.validator,
    // this.style = bodyTextStyle,
    this.value = "",
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.height = 15,
    // this.upperHintStyle = headlineSecondaryTextStyle,
    this.isEnable = false,
    this.onConfirmPress,
    this.isEditBox = false,
    this.onTap,
    this.prefix,
    this.onChanged,
    this.maxLines,
    this.showHelperText = false,
    this.allowDigitsOnly = false,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final String value;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  // final style;
  final double height;

  // final TextStyle upperHintStyle;
  final bool isEditBox;
  bool isEnable;
  final Function()? onConfirmPress;
  final Function(String)? onChanged;
  final Widget? prefix;
  final int? maxLines;
  final void Function()? onTap;
  final bool showHelperText;
  final bool allowDigitsOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}


class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    // implement initState
    _passwordVisible = widget.obscureText;

    super.initState();
  }

  var _passwordVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onTap: widget.onTap,
          // enabled: widget.isEnable,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          validator: widget.validator,
          controller: widget.controller,
          obscureText: _passwordVisible,
          keyboardType:
          widget.allowDigitsOnly ? TextInputType.number : widget.keyboardType,
          inputFormatters: widget.allowDigitsOnly
              ? [FilteringTextInputFormatter.digitsOnly]
              : widget.inputFormatters,
          // style: widget.style,
          readOnly: widget.isEnable,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            // prefixIconConstraints: BoxConstraints.loose(Size(30, 10)),
            prefixIcon: widget.prefix != null
                ? Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 3),
              child: widget.prefix,
            )
                : null,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 8, vertical: widget.height),
            isDense: true,
            // isCollapsed: true,
            label: widget.showHelperText
                ? Text(
              widget.hintText,
              // style: ,
            )
                : null,
            border: OutlineInputBorder(borderSide: BorderSide(color: greenColor)),
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: greenColor)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: greenColor)),
            disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: greenColor)),

            // suffixIconConstraints: BoxConstraints.loose(Size(20, 20)),
            suffixIcon: widget.obscureText
                ? IconButton(
              // constraints: BoxConstraints(maxHeight: 8),
              splashRadius: 16,
              padding: EdgeInsets.zero,
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  // widget.isEnable = !widget.isEnable;
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
                : widget.isEditBox
                ? IconButton(
              // constraints: BoxConstraints(maxHeight: 8),
              splashRadius: 15,
              padding: EdgeInsets.only(right: 12, bottom: 8),
              icon: Icon(
                // Based on passwordVisible state choose the icon
                widget.isEnable ? Icons.edit : Icons.check,
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  widget.isEnable = !widget.isEnable;
                });
                if (widget.onConfirmPress != null &&
                    widget.isEnable == true) widget.onConfirmPress!();
              },
            )
                : null,
          ),
        ),
        SizedBox(height: 20.0,)
      ],
    );
  }
}

class MyDropdownButton extends StatelessWidget {
  String hintText;
  Icon icon;
  List<DropdownMenuItem> dropDownList = [];
  void Function(dynamic) onChanged;
  final FormFieldValidator? validator;


  MyDropdownButton({required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.dropDownList,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10,bottom: 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            validator: validator,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            hint: Text(hintText),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                fillColor: Colors.grey.shade200,
                filled: true,
                prefixIcon: icon),
            items: dropDownList,
            onChanged: onChanged,
          ),
        )
    );
  }
}

//For Staff List Screen
class ShowList extends StatefulWidget {
  List<DropdownMenuItem<dynamic>> salaryList = [];
  bool? userList;
  ShowList({required this.userList});


  @override
  State<ShowList> createState() => _ShowListState();
}


class _ShowListState extends State<ShowList> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('editStaff Made False');
    AddUser.editStaff = false;}

  String? name;

  String? email;

  String? phone;

  // String? salary;

  String? userType;

  String? calendarDate;

  String? password;


  final firestore = FirebaseFirestore.instance;
  deleteField(String id){
    return firestore.collection('Staff List').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('Staff List').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
          }
          List<TableRow>? addStaffList = [
            CustomTableRowDesign.CustomTableRow()
          ];
          print("number of staff is ${addStaffList}");
          List<TableRow>? addUserList = [
          CustomTableRowDesign.CustomTableRow(userList: true)
          ];
          dynamic data = snapshot.data?.docs;
          for (var dataOfSnapshot in data) {
            name = dataOfSnapshot.data()['Name'];
            email = dataOfSnapshot.data()['Email'];
            phone = dataOfSnapshot.data()['Phone'];
            // salary = dataOfSnapshot.data()['Salary'];
            calendarDate = dataOfSnapshot.data()['Calendar Date'];
            userType = dataOfSnapshot.data()['User Type'];
            password = dataOfSnapshot.data()['Password'];

            if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
              if(userType == 'Staff') {
                addStaffList.add(TableRow(
                  children: [
                    StaffListColumn(columnName: name),
                    StaffListColumn(columnName: email),
                    StaffListColumn(columnName: phone),
                    StaffListColumn(
                      columnName: calendarDate
                      ,),
                    StaffListColumn(columnName: userType),
                    ShowOnOffButton(),
                    EditAndDeleteButton(
                        onTapDelete: () {
                      setState(() {
                        showDialog(context: context, builder: (
                            BuildContext context) {
                          return AlertDialog(
                            title: Text('Warning!'),
                            content: Text(
                                'Are you sure you want to delete this information?'),
                            actions: [
                              CustomButton(buttonName: 'Delete', onPressed: () {
                                Navigator.pop(context);
                                deleteField(dataOfSnapshot.data()['Email']);
                                Fluttertoast.showToast(
                                    msg: '${dataOfSnapshot.data()['Email'] +
                                        ' Deleted'}');
                              },),
                              CustomButton(buttonName: 'Cancel', onPressed: () {
                                Navigator.pop(context);
                              }),
                            ],
                          );
                        });
                      });
                    },
                        onTapEdit: () {
                          AddUser.editStaff = true;
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return AddUser(
                              name: dataOfSnapshot.data()['Name'],
                              email: dataOfSnapshot.data()['Email'],
                              phone: dataOfSnapshot.data()['Phone'],
                              password: dataOfSnapshot.data()['Password'],
                              // salary: dataOfSnapshot.data()['Salary'],
                              address: dataOfSnapshot.data()['Address'],
                              userType: dataOfSnapshot.data()['User Type'],
                              calendarDate: dataOfSnapshot
                                  .data()['Calendar Date'],
                            );
                          }));
                        }

                    ),
                  ]
              ));
            }else{
              addUserList.add(TableRow(
                  children: [
                    StaffListColumn(columnName: name),
                    StaffListColumn(columnName: email),
                    StaffListColumn(columnName: phone),
                    StaffListColumn(
                      columnName: calendarDate
                      ,),
                    StaffListColumn(columnName: userType,inContainer: true,containerColor: greenColor,),
                    ShowOnOffButton(),
                    EditAndDeleteButton(
                        onTapDelete: () {
                      setState(() {
                        showDialog(context: context, builder: (
                            BuildContext context) {
                          return AlertDialog(
                            title: Text('Warning!'),
                            content: Text(
                                'Are you sure you want to delete this information?'),
                            actions: [
                              CustomButton(buttonName: 'Delete', onPressed: () {
                                Navigator.pop(context);
                                deleteField(dataOfSnapshot.data()['Email']);
                                Fluttertoast.showToast(
                                    msg: '${dataOfSnapshot.data()['Email'] +
                                        ' Deleted'}');
                              },),
                              CustomButton(buttonName: 'Cancel', onPressed: () {
                                Navigator.pop(context);
                              }),
                            ],
                          );
                        });
                      });
                    },
                        onTapEdit: () {
                          print('editStaff made True');
                          AddUser.editStaff = true;
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return AddUser(
                              name: dataOfSnapshot.data()['Name'],
                              email: dataOfSnapshot.data()['Email'],
                              phone: dataOfSnapshot.data()['Phone'],
                              password: dataOfSnapshot.data()['Password'],
                              // user: dataOfSnapshot.data()['Salary'],
                              address: dataOfSnapshot.data()['Address'],
                              userType: dataOfSnapshot.data()['User Type'],
                              calendarDate: dataOfSnapshot
                                  .data()['Calendar Date'],
                            );
                          }));
                        }

                    ),
                  ]
              ));
            }
          }
          return CustomTableRowDesign(customColumnWidths: {
            0: FixedColumnWidth(130),
            1: FixedColumnWidth(200),
            2: FixedColumnWidth(120),
            5: FixedColumnWidth(130),
          }, children: widget.userList == true ? addUserList: addStaffList);
        });
  }
}


class MyTypeAhead extends StatelessWidget {
  MyTypeAhead({
    required this.controller,
    required this.firestore,
    required this.validatorText,
    this.hideKeyboard = false,
    this.onTap,
    required this.prefixIcon,
    this.suffixOnTap,
    required this.hintText,
    required this.onSuggestionSelected,
    required this.onSuggestionCallback
  });

  TextEditingController controller;
  FirebaseFirestore firestore;
  String validatorText;
  bool hideKeyboard = false;
  Function()? onTap;
  Icon prefixIcon;
  Function()? suffixOnTap;
  String hintText;
  Function(String?) onSuggestionSelected;
  Future<Iterable<String?>> Function(String) onSuggestionCallback;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0, left: 10.0,right: 10.0, bottom: 0),
      child: TypeAheadFormField(
        hideKeyboard: hideKeyboard,
        hideOnEmpty: true,
          hideKeyboardOnDrag: false,
          hideSuggestionsOnKeyboardHide: hideKeyboard == false ? true:false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$validatorText';
            } else {
              return null;
            }
          },
          textFieldConfiguration: TextFieldConfiguration(
              onTap: onTap,
              controller: controller,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.all(20.0),
                  prefixIcon: prefixIcon,
                  suffix: GestureDetector(
                      onTap: suffixOnTap,
                      child: Icon(
                          FontAwesomeIcons.remove,
                          color: Colors.grey.shade500,
                          size: 20)),
                  hintText: hintText,
                  fillColor: Colors.grey.shade200,
                  filled: true)),
          onSuggestionSelected: onSuggestionSelected,
          itemBuilder: (
              context,
              String? suggestion
              ) {
            return ListTile(
                title: Text(' $suggestion ')
            );
          },
          suggestionsCallback: onSuggestionCallback),
    );
  }
}


