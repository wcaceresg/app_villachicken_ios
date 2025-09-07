import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/address/create/clients_address_create_controller.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/text_form_field.dart';
class ClientsAddressCreatePage extends StatefulWidget {
   //final Map<String,dynamic> address;
   //final Color passedColor;
   ClientsAddressCreatePage({ Key ? key}) : super(key: key);

  @override
  State<ClientsAddressCreatePage> createState() => _ClientsAddressCreatePageState();
}

class _ClientsAddressCreatePageState extends State<ClientsAddressCreatePage> {
  //final formkey=GlobalKey<FormState>();
  ClientsAddressCreateController _con=new ClientsAddressCreateController();
  
  
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //print('inica primer init');
      //imageCache.clear();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
        _con.init(context,refresh);
       // imageCache.clear();
       //print(this.address);
       //print($address);
      });
    }

@override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context).settings.arguments;
    //final routes=ModalRoute.of(context).settings.arguments as Map<String,String>;
    //final data=args;
    //Map<String,dynamic> data=args;
   // print(data['address']);
    final double height=MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldkey=GlobalKey<ScaffoldState>();
    return Scaffold(
       //onGenerateRoute: (settings) {}
      key:_scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
     body: SingleChildScrollView(
       padding: const EdgeInsets.all(8.0),
       child: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Form(
          key: _con.formkey,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              SizedBox(height:height*0),
              //Text('Guardar dirección',style: TextStyle(fontSize: 24,color: Colors.black),),
              BigText(text: 'Guarda tu Dirección'),
              //Text('Welcome!',style: TextStyle(fontSize: 30,color: Colors.black),)
              SizedBox(height: height*0.02,),
              _FormAddress(),
              SizedBox(height: 15,),
              _FormReferencia(),
              SizedBox(height: 15,),
              _FormPhone(),


              SizedBox(height:height*0.01),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: BigText(text:'Alias',size: 18,)),

               SizedBox(height:height*0.01),

               _Aliasbox(),


              
              Row(
                children: [
                  // badge_alias('Casa',0),
                  // badge_alias('Trabajo', 1),
                  // badge_alias('Otro', 2),
                   //badge_alias_other('Otro', 2)



                ],
              ),

              SizedBox(height: height*0.05,),
              _con.selectalias==2?
              _FormAlias()
             /* TextFormField(
                controller: _con.aliasController,
                decoration: InputDecoration(
                  labelText: "Ingresa Alias",
                  
                
                ),
                validator: (value){
                  if(value!.isEmpty ){
                    return "Ingrese Alias";
                  }else{
                    return null;
                  }
                },
              )*/:Container(),







            ],
          ),
        ),
       ),
     ),
     bottomNavigationBar: Container(
            // alignment: Alignment.bottomCenter,
             child: _ButtonAccept(),
           )     
    );
  }
  Widget _Aliasbox(){
    return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              badge_alias_component('Casa',0),
              badge_alias_component('Trabajo',1),
              badge_alias_component('Otro',2)
               
            ],
          ),
        );
  }
  Widget badge_alias_component(name,int index){
    return               Expanded(
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(      
                      backgroundColor: _con.selectalias==index?MyColors.blackTextFild:Colors.white,
                     foregroundColor: _con.selectalias==index?Colors.white:MyColors.blackTextFild
                    ),
                 onPressed: () => setState(() {
                     _con.selectalias=index;
                  }),
                  child: Text(''+name),
                ),
              );
  }
    Widget _FormAlias(){
       return TextFormFieldWidget(
          controller: _con.aliasController,
          focusNode: _con.aliasNodeFocus, 
          labelText: 'Ingresa Alias',
         enabled: true,
         maxLines: 1,
         keyboardType: TextInputType.text, 
         maxLength: 50,
         //fontSize: 9,
         prefixIcon: Icon(Icons.location_city,color: MyColors.white),
         validator: (value){
                        if(value!.isEmpty  ){
                          return "Ingrese Alias";
                        }else{
                          return null;
                        }
         }
         );

        return Container(
                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                    decoration: BoxDecoration(
                       color: MyColors.primaryopacitycolor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                     // style: TextStyle(color: MyColors.white.withOpacity(0.8)),
                    controller: _con.aliasController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText:'Ingresa Alias',
                      //labelText: "Referencia",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                     // labelStyle: TextStyle(color: MyColors.white.withOpacity(0.4)),
                      hintStyle: TextStyle(color: MyColors.primarycolorDark),              
                      prefixIcon: Icon(Icons.location_city,color: MyColors.primarycolor),
                      /*errorStyle: TextStyle(
                              fontSize: 11,
                          // color: Colors.red,
                            fontWeight: FontWeight.w600
                      ),
                      */
                    ),     
                    validator: (value){
                        if(value!.isEmpty  ){
                          return "Ingrese Alias";
                        }else{
                          return null;
                        }
                    },
                    

                  ),
                ) ;
    }
    Widget _FormAddress(){
       return TextFormFieldWidget(
          controller: _con.addressController,
          focusNode: _con.addressNodeFocus, 
          labelText: _con.data!=null?_con.data["address"]+'':'',
         enabled: false,
         maxLines: 2,
         keyboardType: TextInputType.text, 
         validator:null,
         maxLength: 150,
         //fontSize: 9,
         prefixIcon: Icon(Icons.location_on_outlined,color: MyColors.white),
         );
      
           return Container(
                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    decoration: BoxDecoration(
                      color: MyColors.primaryopacitycolor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                     // readOnly: true,
                    //controller: _con.referenciaController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      enabled: false, 
                      //labelText: _con.data['address'],
                      hintText:_con.data!=null?_con.data["address"]+'':'',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      hintStyle: TextStyle(color: MyColors.primarycolorDark),
                      prefixIcon: Icon(Icons.location_on_outlined,color: MyColors.primarycolor),
                      /*errorStyle: TextStyle(
                              fontSize: 11,
                          // color: Colors.red,
                            fontWeight: FontWeight.w600
                      ),
                      */
                    ),     
             
                    

                  ),
                ) ;
  }

    Widget _FormReferencia(){

       return TextFormFieldWidget(
          controller: _con.referenciaController,
          focusNode: _con.referenciaNodeFocus, 
          labelText: 'Avenida/Cruce/etc',
         enabled: true,
         maxLines: 2,
         keyboardType: TextInputType.text, 
         maxLength: 150,
         //fontSize: 9,
         prefixIcon: Icon(Icons.location_city,color: MyColors.white),
         validator: (value){
                      if(value!.isEmpty  ){
                          return "Ingrese referencia";
                        }else{
                          return null;
                        }
         }
         );

           return Container(
                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                    decoration: BoxDecoration(
                       color: MyColors.primaryopacitycolor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                     // style: TextStyle(color: MyColors.white.withOpacity(0.8)),
                    controller: _con.referenciaController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:'Avenida/Cruce/etc',
                      //labelText: "Referencia",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                     // labelStyle: TextStyle(color: MyColors.white.withOpacity(0.4)),
                      hintStyle: TextStyle(color: MyColors.primarycolorDark),              
                      prefixIcon: Icon(Icons.location_city,color: MyColors.primarycolor),
                      /*errorStyle: TextStyle(
                              fontSize: 11,
                          // color: Colors.red,
                            fontWeight: FontWeight.w600
                      ),
                      */
                    ),     
                    validator: (value){
                        if(value!.isEmpty  ){
                          return "Ingrese referencia";
                        }else{
                          return null;
                        }
                    },
                    

                  ),
                ) ;
  }
  Widget _FormPhone(){

       return TextFormFieldWidget(
          controller: _con.telefonoController,
          focusNode: _con.telefonoNodeFocus, 
          labelText: 'Telefono',
         enabled: true,
         maxLines: 1,
         keyboardType: TextInputType.number, 
         maxLength: 9,
         //fontSize: 9,
         prefixIcon: Icon(Icons.phone,color: MyColors.white),
         validator: (value){
                        String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value?.length == 0) {
                              return 'Ingre el numero de celular';
                        }
                        else if (!regExp.hasMatch(value.toString())) {
                          return 'Ingresa correctamente el número de celular';
                        }else{
                          return null;
                        }
         }
         );

           return Container(
                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    decoration: BoxDecoration(
                    color: MyColors.primaryopacitycolor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextFormField(
                     // style: TextStyle(color: MyColors.white.withOpacity(0.8)),
                     maxLines: 1,
                    controller: _con.telefonoController,
                    decoration: InputDecoration(
                      hintText: 'Telefono',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                     // hintStyle: TextStyle(color: MyColors.white.withOpacity(0.4)),
                      hintStyle: TextStyle(color: MyColors.primarycolorDark),
                      prefixIcon: Icon(Icons.phone,color: MyColors.primarycolor)
                    ),     
                    validator: (value){
                        String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value?.length == 0) {
                              return 'Ingre el numero de celular';
                        }
                        else if (!regExp.hasMatch(value.toString())) {
                          return 'Ingresa correctamente el número de celular';
                        }else{
                          return null;
                        }
                    }

                  ),
                ) ;
  }

    Widget _ButtonAccept(){
      return BigButtonWidget(text: 'Confirma tu Dirección', vertical:30 ,horizontal: 30, onTap: (){_con.registrar();});
    return Container(
      height: 50,
      width:double.infinity,// toda la pantalla
      margin: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
      child: ElevatedButton(
       // onPressed: _con.selectrefPoint,
       onPressed: (){_con.registrar();},
        child:Text(
          'Confirmar dirección'
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          //primary: MyColors.primarycolor,
          foregroundColor: Colors.white
        ),
        
      ),
    );
  }
  Widget badge_alias(names,int index){
                return    

                  //padding: const EdgeInsets.all(8.0),
                 Container(
                              margin: EdgeInsets.only(right: 15),
                              child:       TextButton(
        onPressed: () {                     setState(() {
                      _con.selectalias=index;
                      //print(select);
                      print(_con.selectalias);
                    });},
        child: Text(names),
      ),
                              /*Badge(
                                
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: _con.selectalias==index?Colors.purple.shade900:Colors.grey.shade300,
                                padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
                                 
                                borderRadius: BorderRadius.circular(18),
                                badgeContent: Text(name, 
                                style: TextStyle(
                                  color: _con.selectalias==index?Colors.white:Colors.black
                                
                                ,fontSize: 16)),
                              )*/
                            );
               


  }

  Widget badge_alias_other(name,int index){
                return        GestureDetector(
                  onTap: (){
                    setState(() {
                      _con.selectalias=index;
                      //print(select);
                      print(_con.selectalias);
                    });
                  }, 
                  child: Container(
                              margin: EdgeInsets.only(right: 15),
                              child: /*Badge(

                                
                                toAnimate: false,
                                shape: BadgeShape.square,
                                 badgeColor: _con.selectalias==index?Colors.purple.shade900:Colors.grey.shade300,
                                padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
                                 
                                borderRadius: BorderRadius.circular(18),
                                badgeContent: Row(
                                    children: [
                                            Icon(
                                                Icons.edit,
                                                color: _con.selectalias==index?Colors.white:Colors.black,
                                                size: 16,
                                              ),
                                              SizedBox(width: 5,),
                                    Text(name, 
                                style: TextStyle(color: _con.selectalias==index?Colors.white:Colors.black,fontSize: 16))

                                    ],
                                  ),
                              )*/Container(),
                            ),
                );


  }

  void refresh(){
    setState(() {
      
    });
  }

}


