import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';



Widget cachedNetworkImg(context,String mediaUrl){
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error_outline),
  //  width: MediaQuery.of(context).size.width,
   // height: 200,
  );
}

Widget cachedNetworkImgPost(context,String mediaUrl){
  return Container(
    child: CachedNetworkImage(
      imageUrl: mediaUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => Container(child: Text(''),),
      errorWidget: (context, url, error) => Icon(Icons.error_outline),
      //  width: MediaQuery.of(context).size.width,
      // height: 200,
    ),
  );
}

Widget cachedNetworkImgPostDetail(context,String mediaUrl){
  return Container(
    child: CachedNetworkImage(
      imageUrl: mediaUrl,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      placeholder: (context, url) => Container(child: Text(''),),
      errorWidget: (context, url, error) => Icon(Icons.error_outline),
      //  width: MediaQuery.of(context).size.width,
      // height: 200,
    ),
  );
}

Widget cachedNetworkImageCircular(BuildContext context, String mediaUrl){
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    placeholder: (context, url) => Container(),
    errorWidget: (context, url, error) => Container(padding: EdgeInsets.all(3),child: Image.asset("assets/icons/me.png",)),
    imageBuilder: (context, imageProvider) => Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: imageProvider, fit: BoxFit.cover),
      ),
    )
  );
}



Widget cachedNetworkImgStory(context,String mediaUrl){
  return Container(
    width: 47,
    height: 68,
    margin: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(new Radius.circular(6.0)),
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset(-1, 1), // changes position of shadow
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      child: CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: Container(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error_outline),
        //  width: MediaQuery.of(context).size.width,
        // height: 200,
      ),
    ),
  );
}



Widget cachedNetworkImgCrown(context,String mediaUrl){
  return Container(
    width: 55,
    height: 55,
    margin: EdgeInsets.all(8.0),

    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: Container(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error_outline),
        //  width: MediaQuery.of(context).size.width,
        // height: 200,
      ),
    ),
  );
}

Widget giftCachedNetworkImage(context,String mediaUrl){
  return Container(
    width: 200,
    height: 200,
    child: CachedNetworkImage(
      imageUrl: mediaUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error_outline),
      //  width: MediaQuery.of(context).size.width,
      // height: 200,
    ),
  );
}

Widget giftReactCachedNetworkImage(context,String mediaUrl){
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(
      child: Container(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error_outline),
    //  width: MediaQuery.of(context).size.width,
    // height: 200,
  );
}
