
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

Widget peopleYouMayKnowTemplate(BuildContext context, UserModel data, UserModel user){
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed('/viewProfile', arguments: {
        'userId' : data.id.toString(), 'currentUser' : user
      });
    },
    child: Container(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(

            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(data.photo),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            offset: Offset(2, 2),
                            color: Colors.black45.withOpacity(0.3),
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: flcolorBlue,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  right: 0,
                  bottom: 0,
                ),

              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.fromLTRB(1,0,1,0),
            child: Text(
              '${data.nName}',
              style: fldarkgrey8,
              overflow: TextOverflow.ellipsis,

            ),
          ),
        ],
      ),
    ),
  );
}