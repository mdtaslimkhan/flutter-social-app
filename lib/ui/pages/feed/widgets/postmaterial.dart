
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';


Widget threeDotOptionBottomsheetItem(IconData icon, String text,Function func) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: func,
  );
}

Widget threeDotOptionMenuItem(IconData icon, String text, Function fnc){
  return SimpleDialogOption(
    child: Row(
    children: [
      Icon(icon,
        color: Colors.black54,
        size: 15,),
      Text(' $text'),
    ],),
    onPressed: fnc,
  );
}

Widget badgeEarnedTemplate(data){
  return Image.asset(
    'assets/profile/crown/${data.id}.png',
    height: 15,
    width: 15,
  );
}


Widget imageIcon(context, int url, double left){
  return Positioned(
    left: left,
    child: Image.asset(
      'assets/profile/react/react$url.png',
      width: 20,
      height: 18,
      fit: BoxFit.cover,
    ),
  );
}

class FollowingButton extends StatelessWidget {
  final Function onPressed;
  final bool isFollowing;
  FollowingButton({this.onPressed , this.isFollowing});
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 65, //wraps child's width
      height: 23, //wraps child's height
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isFollowing ? Icons.person_outline : Icons.person_add,
          size: 15,
          color: Colors.white,
        ),
        label:  Text(
         isFollowing ? "Un follow" : "Follow",
          style: TextStyle(
            fontSize: 8,
            color: Color(0xFFffffff),
          ),
        ),
      ),
    );
  }
}

class ThreeDotButton extends StatelessWidget {

  final Function onPressed;
  final int type;
  ThreeDotButton({this.onPressed,this.type});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 35, //wraps child's width
      height: 25, //wraps child's height
      child: TextButton(
        onPressed: onPressed,
        child:  Image.asset(
         type == 2 ? 'assets/profile/threedot.png' : 'assets/feed/three.png',
          width: 4,
        ),
      ),
    );
  }
}


class PostBottomReactHolder extends StatelessWidget {

  PostBottomReactHolder({this.likeCount,this.itemChild,this.isLiked,this.onPressed,this.type});

  final String likeCount;
  final Widget itemChild;
  final bool isLiked;
  final Function onPressed;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // stack container for emoticons or reacts
        Container(
          width: 100,
          height: 30,
          child: Stack(
            children: [
              // imageIcon(context, 4, 40),
              // imageIcon(context, 3, 28),
              // imageIcon(context, 2, 15),
              // imageIcon(context, 1, 0),
              Positioned(
                left: 15,
                child:  Text("$likeCount",
                  style: type == 2 ? ftwhite18 :fldarkgrey18,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          child: Stack(
            children: [
              Positioned(
                left: isLiked ? 5 : 25,
                top: 4,
                child: Container(
                  width: 28,
                  height: 25,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                      boxShadow: [ BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(-0.5,0.5),
                          spreadRadius: 0.5,
                          blurRadius: 0
                      )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,5,0),
                    child: Icon(
                      Icons.thumb_up,
                      color: Color(0xFF3175fe),
                      size: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [ BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(-0.5,0.5),
                          spreadRadius: 0.5,
                          blurRadius: 0
                      )
                      ]
                  ),
                  child: ButtonTheme(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 35, //wraps child's width
                      height: 35, //wraps child's height
                      child: SizedBox.fromSize(
                        size: Size(32, 32), //// button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                              splashColor: Color(0xFF3175fe), // splash color
                              onTap: onPressed, // button pressed
                              child: Icon(
                                Icons.thumb_up,
                                size: 18,
                                color: isLiked ? Color(0xFF3175fe) : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class PostBottomItem extends StatelessWidget {

  final String likeCount;
  final Widget childItem;
  final Function onPressed;
  final int type;
  PostBottomItem({this.likeCount, this.childItem, this.onPressed,this.type});

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: likeCount != null ? Text('$likeCount',
            style: type == 2 ? ftwhite18 : fldarkgrey18,
          ) : Text('0'),
        ),
        SizedBox(height: 5),
        // dislike button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [ BoxShadow(
             color: Colors.black.withOpacity(0.2),
             offset: Offset(-0.5,0.5),
             spreadRadius: 0.5,
             blurRadius: 0
            )
            ]
          ),
          child: Stack(
            children: [
              Positioned(
                child: ButtonTheme(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 35, //wraps child's width
                    height: 35, //wraps child's height
                    child: SizedBox.fromSize(
                      size: Size(32, 32), //// button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Color(0xFF3175fe), // splash color
                            onTap: onPressed,// button pressed
                            child: childItem,
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class StoryLike extends StatelessWidget {

  final String likeCount;
  final Widget childItem;
  final Function onPressed;
  final int type;
  StoryLike({this.likeCount, this.childItem, this.onPressed,this.type});

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [ BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(-0.5,0.5),
                  spreadRadius: 0.5,
                  blurRadius: 0
              )
              ]
          ),
          child: Stack(
            children: [
              Positioned(
                child: ButtonTheme(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 35, //wraps child's width
                    height: 35, //wraps child's height
                    child: SizedBox.fromSize(
                      size: Size(32, 32), //// button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Color(0xFF3175fe), // splash color
                            onTap: onPressed,// button pressed
                            child: childItem,
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



