import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupHeaderImages extends StatelessWidget {

  final String profileImage;
  GroupHeaderImages({@required this.profileImage});

  @override
  Widget build(BuildContext context) {
    BigGroupProvider _p = Provider.of<BigGroupProvider>(context, listen: true);

    return Positioned(
      top: 110,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        color: Colors.green,
                        spreadRadius: -10)
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: IconButton(
                  icon: Image.network('$APP_ASSETS_URL/profile/crown/'
                      '${_p.toGroup?.level != null && _p.toGroup.level >= 10000 ? 1 :
                         _p.toGroup?.level != null && _p.toGroup.level >= 50000 ? 2 :
                         _p.toGroup?.level != null && _p.toGroup.level >= 100000 ? 3 : 0}.png'
                  ),
                  onPressed: null,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3,2,3,2),
                  child: Text(
                    "Exp  ${_p.toGroup?.level != null ? _p.toGroup.level : '0'}",
                    style: TextStyle(
                      fontSize: 8,
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: 150,
                width: 150,
                child: Stack(
                  children:[
                    Positioned(
                      top:30,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(48),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6,
                                offset: Offset(0, 1),
                                color: Color(0xff000000).withOpacity(0.2),
                                spreadRadius: -35),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/no_image.jpg'),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              borderRadius: BorderRadius.circular(48),
                            ),
                            child: Text(''),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
             !["", null, false, 0, "0"].contains(_p.toGroup?.countryCode) ? Container(
                height: 48,
                width: 48,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 8),
                          color: Colors.green,
                          spreadRadius: -10)
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                ),
                child: IconButton(
                  icon: Image.network('$APP_ASSETS_URL/flags/${_p.toGroup.countryCode.toLowerCase()}.png', width: 30,), // Image.asset('assets/profile/flag_bd.png'),
                ),
              ) : Container(height: 48,),
              Container(
                padding: EdgeInsets.fromLTRB(3,0,3,0),
                decoration: BoxDecoration(
                  color: Color(0xFFfbc81e),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3,2,3,2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${_p.toGroup?.view != null ? _p.toGroup.view : "0"}",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
