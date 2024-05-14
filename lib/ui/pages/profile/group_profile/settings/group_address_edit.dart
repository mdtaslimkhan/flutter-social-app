import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';




class GroupAddressEdit extends StatefulWidget {

  String name;
  String id;
  GroupAddressEdit({this.id,this.name});

  @override
  _GroupAddressEditState createState() => _GroupAddressEditState();
}

class _GroupAddressEditState extends State<GroupAddressEdit> {
  GroupFunctions _groupFunctions = GroupFunctions();

  bool showProgress = false;


  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: true);


    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Group Location edit")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,15,15.0,0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        offset: Offset(0,3),
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0,3),
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text("${_bg.toGroup.location}"),
                        ),
                            CountryCodePicker(
                              initialSelection: _bg.toGroup.countryCode != null ? _bg.toGroup.countryCode : 'bd',
                              hideMainText: true,
                              showDropDownButton: true,
                              onChanged: (val) async {
                                // for bangladeshi number
                                print('Select country code picker: ${val.name}');


                                setState(() {
                                  showProgress = true;
                                });
                                var isUpdated = await _groupFunctions.updateGroup(groupId: widget.id, text: val.name, field: "location");
                                await _groupFunctions.updateGroup(groupId: widget.id, text: val.code, field: "country_code");

                                if(isUpdated){
                                  setState(() {
                                    showProgress = false;
                                  });
                                }

                                _bg.getGroupModelData(groupId: widget.id);
                               // Navigator.pop(context);

                              },
                            ),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String validateText(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter name';
    }
    if (value.length > 500) {
      return 'Text should not be too long';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    return null;
  }
}
