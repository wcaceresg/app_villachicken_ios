import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/register/ClientsRegisterController.dart';

class ClientsRegisterPage extends StatefulWidget {
  const ClientsRegisterPage({super.key});

  @override
  State<ClientsRegisterPage> createState() => _ClientsRegisterPageState();
}

class _ClientsRegisterPageState extends State<ClientsRegisterPage> {
  ClientsRegisterController _con=new ClientsRegisterController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
           _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  void refresh(){
    setState(() {
      
    });
  }
}