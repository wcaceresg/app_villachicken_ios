
import 'package:flutter/material.dart';
class ClientsMainAddressListPage extends StatefulWidget {
  const ClientsMainAddressListPage({ Key ?  key }) : super(key: key);

  @override
  State<ClientsMainAddressListPage> createState() => _ClientsMainAddressListPageState();
}

class _ClientsMainAddressListPageState extends State<ClientsMainAddressListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.3,
      //padding: EdgeInsets.only(left: 20,right: 20),
      
       //padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
      child: Container(
    
        child: Column(
          children: [
            //_imageSliderShow(),
            //_textName(),
           //_textDescription(),
            Spacer(),
           // _addOrRemoveItem(),
           // _standarDelivery(),
           // _buttonShoppingBag()

          ],
        ),
      ),
    );
  }
}