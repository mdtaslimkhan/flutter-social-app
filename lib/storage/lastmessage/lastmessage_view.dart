import 'package:chat_app/storage/local_db.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:flutter/material.dart';



class LastMessageView extends StatefulWidget {
  @override
  _LastMessageViewState createState() => _LastMessageViewState();
}

class _LastMessageViewState extends State<LastMessageView> {

  List<Map<String, dynamic>> mList = [];


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    List<Map<String, dynamic>> allData = await LocalDbHelper.instance.getAllLastMessage();
    setState(() {
      mList = allData;
    });
  }


  dataList(List<Map<String, dynamic>> rows){
    return ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {

         int id = rows[index][LocalDbHelper.lastmessageId];
         String title = rows[index][LocalDbHelper.lastmessageTitle];
         String message = rows[index][LocalDbHelper.lastmessageMessage];
         String date = rows[index][LocalDbHelper.lastmessageDate];
         String images = rows[index][LocalDbHelper.lastmessageImage];
         int type = rows[index][LocalDbHelper.lastmessageType];
          return ListTile(
              leading: images != null ? cachedNetworkImageCircular(context,images) : Image.asset('assets/profile/user.png'),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title'),
                  Text('$message'),
                  Text('$date and $type'),
                ],
              ),
             trailing: GestureDetector(
                onTap: () async {
                  int i = await LocalDbHelper.instance.deleteLastMessage(id);
                  setState(() {
                  });
                },
                child: Icon(Icons.delete),
              ),

          );

        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder(
                future: LocalDbHelper.instance.getAllLastMessage(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }
                  return snapshot.data != null ? dataList(snapshot.data) : circularProgress();
                }
             ),
              ),
              MaterialButton(
                color: Colors.amber,
                  onPressed: () async {
                int i = await  LocalDbHelper.instance.insertLastMessage({
                    LocalDbHelper.lastmessageTitle : 'Bangladesh',
                    LocalDbHelper.lastmessageMessage : '11/02/2021',
                    LocalDbHelper.lastmessageImage : '11/02/2021',
                    LocalDbHelper.lastmessageDate : '11/02/2021',
                    LocalDbHelper.lastmessageSeen : '11/02/2021',
                    LocalDbHelper.lastmessageDocId : '11/02/2021',
                    LocalDbHelper.lastmessageType : 1,
                  });
                setState(() {

                });

                  },
                child: Text('Insert'),
              ),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  List<Map<String, dynamic>> allData = await LocalDbHelper.instance.getAllLastMessage();
                  setState(() {
                    mList = allData;
                  });
                },
                child: Text('Get data'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: () async {

                  int nRows = await LocalDbHelper.instance.updateLastMessage({
                    LocalDbHelper.lastmessageId : 3,
                    LocalDbHelper.lastmessageTitle: "This is a muslim country from",
                    LocalDbHelper.lastmessageDate: "1947"
                  });

                },
                child: Text('Update'),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () async {
                  int i = await LocalDbHelper.instance.deleteLastMessage(2);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        )
    );
  }


}
