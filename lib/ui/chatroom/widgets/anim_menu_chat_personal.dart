import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as VectorMath;


class MenuAnimationPersonalChat extends StatelessWidget {
  MenuAnimationPersonalChat({Key key, this.animationController}) :
      scale = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.fastOutSlowIn
        )
      ),
      translation = Tween(
        begin: 0.0,
        end: 70.0,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut
        ),
      ),
      rotation = Tween<double>(
        begin: 0.0,
        end: 0,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
              0.0, 0.7,curve: Curves.decelerate),
        )
      ),
      super(key: key);

  AnimationController animationController;
  Animation<double> scale;
  Animation<double> translation;
  Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, builder){
        return Container(
          width: 35,
          height: 35,
          child: Transform.rotate(
            angle: VectorMath.radians(rotation.value),
            child: Stack(
              // I dont understand how it works
              alignment: Alignment.bottomRight,
              children: [
                _buildButton(270, color: Colors.amber, icon: Icons.call,
                    onPressed: () {
                      _close();

                   
                    }, pos: 1),
                _buildButton(270, color: Colors.blue, icon: Icons.video_call, pos: 2),


                Transform.scale(
                  scale: scale.value - 1.0,
                  child: FloatingActionButton(
                    child: Icon(Icons.close,
                    color: Colors.white,),
                    onPressed: _close,
                    backgroundColor: Colors.red,
                  ),
                ),
                Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                    child: Icon(Icons.attach_file,
                        color: Colors.white,
                      size: 15,
                    ),
                    onPressed: _open,
                    backgroundColor: Colors.lightBlue,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _buildButton(double angle, {Color color, IconData icon, Function onPressed, int pos}){
    final double rad = VectorMath.radians(angle);
    return Transform(transform: Matrix4.identity()..translate(
        (translation.value) * cos(rad) * pos,
        (translation.value) * sin(rad) * pos,
    ),
    child: Container(
      width: 45,
      height: 45,
      child: FloatingActionButton(
        child: Icon(icon,size: 20,
          color: Colors.white,
        ),
        backgroundColor: color,
        onPressed: onPressed,
      ),
    ),
    );
  }

  _open(){
    animationController.forward();
  }
  _close(){
    animationController.reverse();
  }
}

