import 'package:flutter/material.dart';
//import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//import 'package:scroll_to_id/scroll_to_id.dart';
class ClientProductDet extends StatefulWidget {
  const ClientProductDet({ Key ? key }) : super(key: key);

  @override
  State<ClientProductDet> createState() => _ClientProductDetState();
}

class _ClientProductDetState extends State<ClientProductDet> {
final ScrollController _controller = ScrollController();

void _scrollDown() {
  /*_controller.animateTo(
    //_controller.position.maxScrollExtent,
    400,
    //500,
    duration: Duration(seconds: 2),
    curve: Curves.fastOutSlowIn,
  );
  */
  _controller.jumpTo(400);
}

  @override
  void initState() {
    super.initState();

    /// Create ScrollToId instance
 
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton.small(
      onPressed: _scrollDown,
      child: Icon(Icons.arrow_downward),
    ),
    body: SingleChildScrollView(
       controller: _controller,
      child: Column(
        children: [
          Container(
          height: 500,
          ),

          Container(
            child: ListView.builder(
             physics: NeverScrollableScrollPhysics(),
               shrinkWrap: true,
              itemCount: 21,
              itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
                       
            ),
          ),
        ],
      ),
    ),
  );
}
}