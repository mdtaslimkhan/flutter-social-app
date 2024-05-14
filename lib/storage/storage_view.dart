import 'package:chat_app/storage/lastmessage/lastmessage_view.dart';
import 'package:chat_app/storage/local_db.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:flutter/material.dart';



class StorageView extends StatefulWidget {
  @override
  _StorageViewState createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {

  List<Map<String, dynamic>> mList = [];


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    List<Map<String, dynamic>> allData = await LocalDbHelper.instance.getAllData();
    setState(() {
      mList = allData;
    });
  }


  dataList(List<Map<String, dynamic>> rows){
    return ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {

         int id = rows[index][LocalDbHelper.columnId];
         String title = rows[index][LocalDbHelper.columnTitle];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('this is title : $title'),
              MaterialButton(
                color: Colors.red,
                onPressed: () async {
                  int i = await LocalDbHelper.instance.delete(id);
                  setState(() {

                  });
                },
                child: Text('Delete'),
              ),
            ],
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
                future: LocalDbHelper.instance.getAllData(),
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
                int i = await  LocalDbHelper.instance.insertData({
                    LocalDbHelper.columnTitle : 'Bangladesh',
                    LocalDbHelper.columnDate : '11/02/2021'
                  });
                setState(() {

                });


                  },
                child: Text('Insert'),
              ),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  List<Map<String, dynamic>> allData = await LocalDbHelper.instance.getAllData();
                  setState(() {
                    mList = allData;
                  });
                },
                child: Text('Get data'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: () async {

                  int nRows = await LocalDbHelper.instance.update({
                    LocalDbHelper.columnId : 3,
                    LocalDbHelper.columnTitle: "This is a muslim country from",
                    LocalDbHelper.columnDate: "1947"
                  });

                },
                child: Text('Update'),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () async {
                  int i = await LocalDbHelper.instance.delete(2);
                },
                child: Text('Delete'),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LastMessageView()));

                },
                child: Text('Lastmessage'),
              ),
            ],
          ),
        )
    );
  }


}
