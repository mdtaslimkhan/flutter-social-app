import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/settings/wallet/model/diamond_recharge.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/redeem/widgets/balanceWidgets.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';


class BankRechargeAmountList extends StatefulWidget {

  @override
  _BankRechargeAmountListState createState() => _BankRechargeAmountListState();
}

class _BankRechargeAmountListState extends State<BankRechargeAmountList> {
  final TextEditingController diamondController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    BalanceProvider _redeem = Provider.of<BalanceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text("Send diamonds")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('Balance',
              style: fldarkgrey22,),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: CurrentDiamond(text: 'Bank diamond', amount: _redeem.bankDiamond, color: Colors.blue, icon: Icons.import_contacts),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 1,
              margin: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
            SizedBox(height: 20),
            Text('Enter the amount to send',
              style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),),
            SizedBox(height: 20,),
            Column(
                    children: [
                      cachedNetworkImageCircular(context, _redeem.toUserModel.photo),
                      SizedBox(height: 20,),
                      Text("${_redeem.toUserModel.fName + " " + _redeem.toUserModel.nName}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 16,top: 5),
                                width: 18,
                                child: Image.asset('assets/gift/dimond_blue.png')
                            ),
                            SizedBox(width: 10),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 120,
                                margin: EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(7)),
                                child: TextFormField(
                                  controller: diamondController,
                                  decoration: const InputDecoration(labelText: ''),
                                  keyboardType: TextInputType.number,
                                  validator: (val) => validateCode(val),

                                ),
                              ),
                            )
                          ],
                      ),
                      SizedBox(height: 50,),
                      Center(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Text("Confirm",
                                style: ftwhite15,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/bankRechargeConfirmScreen',arguments : {'diamond': diamondController.text.trim()});
                            FocusScope.of(context).unfocus();

                          },
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.1),
                      ),

                    ],
                  ),
          ],
        ),
      ),
    );
  }

  String validateCode(String value) {
    if (value.length == 0) {

      return 'Please enter trx number';
    }
    if (value.length > 8) {
      return 'Trx number should not be too long';
    }
    return null;
  }
}
