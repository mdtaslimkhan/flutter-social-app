
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HonorVideoView extends StatefulWidget {

  final Crown crown;
  HonorVideoView({this.crown});

  @override
  _HonorVideoViewState createState() => _HonorVideoViewState();
}

class _HonorVideoViewState extends State<HonorVideoView> with SingleTickerProviderStateMixin {

  Future<LottieComposition> _composition;

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _composition = _loadComposition();
  }

  Future<LottieComposition> _loadComposition() async {
    var assetData = await rootBundle.load(widget.crown.video);
    return await LottieComposition.fromByteData(assetData);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Material(
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ClipRRect(
                    child: Lottie.network(
                      widget.crown.video,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),

                    // child: FutureBuilder<LottieComposition>(
                    //   future: _composition,
                    //   builder: (context, snapshot) {
                    //   var composition = snapshot.data;
                    //   if (composition != null) {
                    //   return Lottie(composition: composition);
                    //   } else {
                    //   return Center(child: CircularProgressIndicator());
                    //   }
                    //   },
                    //   ),

                    // child: VideoWidgetCached(
                    //   url: crown.video,
                    //   looping: true,
                    // ),
                    // child: VideoWidget(
                    //   videoPlayerController: VideoPlayerController.network(widget.photo),
                    //   looping: false,
                    // ),
                  ), // cachedNetworkImg(context, photo),
                ),
              ),
            ),
            Positioned(
              bottom: 70,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("${widget.crown.title}", style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: "Sego"
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20,),
                      Text("${widget.crown.description}", style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      Text("Time: ${widget.crown.date}", style: TextStyle(
                          color: Colors.white
                      ),),
                    ],
                  ),
                )
            )

          ],
        ),
      ),
    );
  }
}
