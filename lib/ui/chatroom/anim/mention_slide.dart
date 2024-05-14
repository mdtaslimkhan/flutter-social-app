
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/gift_showing_model.dart';
import 'package:flutter/material.dart';

class SlideMention extends StatelessWidget {

  final GiftShowingModel gShowingModel;
  final Animation sliderAnimationElement;
  final AnimationController sliderAnimationController;
  SlideMention({this.gShowingModel,
    this.sliderAnimationElement,
    this.sliderAnimationController});

  @override
  Widget build(BuildContext context) {
    print('hello animation');
    print(gShowingModel.fromPhoto);

    return Positioned(
      top: 100,
      left: 110,
      child: AnimatedBuilder(
        animation: sliderAnimationController.view,
        builder: (context, child){
          return Transform.translate(
            offset: Offset(sliderAnimationElement.value, 0.0),
            child: Container(
              height: 90,
              width: 210,
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/gift/gift_send.png"),
                  fit: BoxFit.contain,
                ),
                //  color: Colors.black87,

              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 105,
                    child: Container(
                      width: 25,
                      height: 25,
                      child:  gShowingModel != null
                          ? cachedNetworkImageCircular(
                          context, gShowingModel.toPhoto)
                          : Image.asset('assets/b1.gif'),
                      // 1 != null
                      //     ? cachedNetworkImageCircular(
                      //     context, "https://www.google.com/logos/doodles/2021/doodle-champion-island-games-july-26-6753651837109017-s.png")
                      //     : Image.asset('assets/b1.gif'),
                    ),



                  ),
                  Positioned(
                    top: 16,
                    left: 70,
                    child: Container(
                      width: 25,
                      height: 25,
                      //   child: gShowingModel != null
                      //       ? cachedNetworkImageCircular(
                      //       context, gShowingModel.fromPhoto)
                      //       : Image.asset('assets/b1.gif'),
                      child: gShowingModel != null
                          ? cachedNetworkImageCircular(
                          context, gShowingModel.fromPhoto)
                          : Image.asset('assets/b1.gif'),
                    ),
                  ),
                  Positioned(
                    top: 44,
                    left: -3,
                    child: Container(
                      width: 210,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "${gShowingModel != null ? gShowingModel.fromName + "" : ""}",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                " sent ",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "${gShowingModel != null ? gShowingModel
                                      .toName : ""}",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2,),
                              Text(
                                "${gShowingModel.diamond}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(width: 2,),
                              Image.asset("assets/gift/dimond_blue.png", width: 12,),



                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
