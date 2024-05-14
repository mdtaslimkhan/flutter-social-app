import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GemsToDiamond1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width / 1,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: (Colors.grey)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.ad_units),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "4",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Are you sure?',
                  desc: 'To redeem 4 diamonds with 10 beans',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();

                // AwesomeDialog(
                //   context: context,
                //   animType: AnimType.SCALE,
                //   dialogType: DialogType.INFO,
                //   body: Center(child: Text(
                //     'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
                //     style: TextStyle(fontStyle: FontStyle.italic),
                //   ),),
                //   title: 'This is Ignored',
                //   desc:   'This is also Ignored',
                //   btnOkOnPress: () {},
              //  )..show();

                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) => AlertDialog(
                //     title: const Text('Are you sure?'),
                //     content: const Text('To redeem 4 diamonds with 10 beans'),
                //     actions: <Widget>[
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pop(context, 'Cancel');
                //         },
                //         child: const Text('Cancel'),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => PasswordsRedeem()),
                //           );
                //
                //           // incressDiamond.currentGemsfun10();
                //           // incressDiamond.currentdiamondfun4();
                //         },
                //         child: const Text('OK'),
                //       ),
                //     ],
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 120,
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(7)),
                  child: Text("10GEMS"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
