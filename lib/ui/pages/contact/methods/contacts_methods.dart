
import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/storage/local_db.dart';
import 'package:chat_app/ui/pages/contact/user_contact_item.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ContactsMethods{
  Future<List<UserContactItem>> getContacts() async {
    List<UserContactItem> _uList = [];
    Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    var iter = 0;
    contacts.forEach((contact) async {
      var mobilenum = contact.phones.toList();
      if (mobilenum.length != 0) {
        var userContact = UserContactItem(
            contactName: contact.displayName,
            number: mobilenum[0],
            imageUrl: contact.avatar);
        _uList.add(userContact);
        iter++;
      } else {
        iter++;
      }
    });
    return _uList;
  }

  Future<UserModel> getContactInfo({@required String contact}) async {
    try{
      final String url = BaseUrl.baseUrl("ifContactExist");
      final http.Response response = await http.post(Uri.parse(url),
          headers: {'test-pass' : ApiRequest.mToken},
          body: {
            "number" : contact
          }
      );
      Map usr = jsonDecode(response.body);
      UserModel u = UserModel.fromJson(usr);
     // if(response.statusCode == 200) {
        return u;
      // }else{
      //   return null;
      // }
    }catch(e){
      print(e);
      return null;
    }
  }

 // getting all contacts
  getAllcontact({UserModel user}) async {
    List<UserContactItem> allContact = await getContacts();
    for(UserContactItem ui in allContact) {
      String number = ui.number.value;
      // remove white space from number
      String nm = number.replaceAll(new RegExp(r"\s+"), "");
      // remove hyphen from number
      String num = nm.replaceAll(new RegExp("[\\s\\-()]"), "");
    
      UserModel um = await getContactInfo(contact: num);
   
      if(um != null) {
        if (um.exist == 1) {
          insertData(contact: um.number,
              from: user,
              name: ui.contactName,
              to: um);
        }
      }else{
      
      }
    }
  }



  insertData({String contact, UserModel from, String name, UserModel to}) async {
    var exist = await LocalDbHelper.instance.checkIfContactExist(to.id);
    if(!exist) {
      int i = await LocalDbHelper.instance.insertContact({
        LocalDbHelper.contactName : name != null ? name : "",
        LocalDbHelper.contactNumber : contact != null ? contact : "",
        LocalDbHelper.contactIsExist : '1',
        LocalDbHelper.contactImage : to.photo != null ? to.photo : "",
        LocalDbHelper.contactFromUserId : from.id != null ? from.id : "",
        LocalDbHelper.contactToUserId : to.id != null ? to.id : "",
      });
      // contact imported 
    }else{

    }
  }






}