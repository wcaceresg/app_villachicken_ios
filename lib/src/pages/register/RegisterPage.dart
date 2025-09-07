import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/documents/TypeDocumentPage.dart';
import 'package:villachicken/src/pages/clients/main/ClientsMainPage.dart';
import 'package:villachicken/src/pages/register/RegisterController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/document_legal.dart';
import 'package:villachicken/src/widgets/form_input.dart';
import 'package:villachicken/src/widgets/genero_form_field.dart';
import 'package:villachicken/src/widgets/small_text.dart';
import 'package:villachicken/src/widgets/text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController _con= new RegisterController();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //print('inica primer init');
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
        _con.init(context,refresh);
      });
    }
@override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         color: Colors.white,
        /*(gradient:LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           //  Color(0xFF303151).withOpacity(1),
          //  Color(0xFF303151).withOpacity(0.1),
          //MyColors.primarycolor.withOpacity(1),
         // MyColors.primarycolor.withOpacity(0.9),
          ]
        )*/
      ), 
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          //padding: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [

                 Positioned(
                   top: 55,
                   left: 10,
                   child:_iconoback(context),
                   ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top:55),
                    child: Column(
                      children: [
                        
                         SizedBox(height: 20,),
                         Title(),
                          SizedBox(height: 5,),
                         SubTitle(),
                          SizedBox(height: 20,),
                         _correo(),
                         SizedBox(height: 5,),
                         _usuario_documento(),
                         SizedBox(height: 5,),
                         _usuario_nombre(),
                         SizedBox(height: 5,),
                         _usuario_apellido(),
                         SizedBox(height: 5,),
                         _tipo_genero(),
                         SizedBox(height: 5,),
                         Fecha_Nacimiento(),
                         SizedBox(height: 5,),
                        
                         _user_contrasenia(),
                         SizedBox(height: 5,),
                         _user_confirmar(),
                         _check(),
                         _button(context),
                         

 /*FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                  hintText: 'Please select expense',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
              isEmpty: _currentSelectedValue == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currentSelectedValue,
                  isDense: true,
                  onChanged: ( newValue) {
                    setState(() {
                      _currentSelectedValue = newValue.toString();
                      state.didChange(newValue.toString());
                    });
                  },
                  items: _con.currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        )



*/









                      ],
                    ),
                  )


              ],
            ),
          ),
        )
        
      ),
    );
  }
   Widget Title(){
    return BigText(text: 'CREA TU USUARIO',size: 28,);

  }
  Widget SubTitle(){
    return SmallText(text: 'Por favor ingrese los datos',);
    
  }
  Widget _tipo_genero(){

 return GeneroFormWidget(
  hintText: 'Selecciona una moneda',
  currentSelectedValue: _con.currentSelectedValue,
  items: _con.currencies,
  onChanged: (int? newValue) {
    setState(() {
      _con.currentSelectedValue = newValue!;
    });
  },
);

  return           Container(
                            margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                            decoration: BoxDecoration(
                              //color: MyColors.primaryopacitycolor,
                              color: MyColors.blackBG,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                           child: Center(
                            child: DropdownButton(
                              icon: Padding( //Icon at tail, arrow bottom is default icon
                                padding: EdgeInsets.only(left:10),
                                child:Icon(Icons.arrow_drop_down_circle)
                              ), 
                              iconEnabledColor: Colors.white,                             
                              hint: Text('text'),
                              style: TextStyle(color: MyColors.white.withOpacity(0.8)),
                              dropdownColor: MyColors.black,
                              value:_con.currentSelectedValue,
                              onChanged: (index){
                                setState(() {
                                  _con.currentSelectedValue=int.parse(index.toString());
                                });
                              },
                              items: _con.currencies.map((map) => DropdownMenuItem(
                                  child: Text(map["name"]),
                                  value: map["id"],
                                ),
                              ).toList(),
                            ),
                           ),
                         );

  }
   Widget _textregister(){
   return 
       Text('Regresar',
       style: TextStyle(
         color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22),
        
        );
   
 }
 Widget _iconoback(context){
   return  IconButton
   (
    icon: Icon(Icons.arrow_back_ios,color: Colors.white,), 
    onPressed :() => {} // con void function
   );
 }

 Widget _circleLogin(){
   return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        //color: MyColors.primarycolor
      ),
   );
 }

  Widget _correo(){
  return TextFormFieldWidget(
         controller: _con.emailcontroller,
         focusNode: _con.emailNodeFocus, 
         labelText: 'Correo electrónico',
         enabled: true,
         maxLines: 1,
         keyboardType: TextInputType.emailAddress, 
         maxLength: 50,
         prefixIcon: Icon(Icons.email,color: MyColors.white),
         validator: (value){
                       final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        //RegExp regExp = new RegExp(pattern);
                        if (value?.length == 0) {
                              return 'Ingrese el correo electrónico';
                        }
                        else if(!emailRegex.hasMatch(value.toString())) {
                          return 'Ingresa correctamente el correo electrónico';
                        }else{
                          return null;
                        }
         }
    );


    return FormInput(
            text: 'Correo electrónico',
            textEditingController: _con.emailcontroller,
            textInputType:TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email,size: 21, color: MyColors.white.withOpacity(0.4)),
            );
  }

  Widget _usuario_documento(){
    return TextFormFieldWidget(
            controller: _con.documentocontroller,
            focusNode: _con.documentNodeFocus, 
            labelText: 'Documento',
            keyboardType: TextInputType.number, 
            maxLength: 8,
            //fontSize: 9,
            prefixIcon: Icon(Icons.document_scanner,color: MyColors.white),
            validator: (value){
                            String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                            RegExp regExp = new RegExp(pattern);
                            if (value?.length == 0) {
                                  return 'Ingre el número de documento';
                            }
                            else if (!regExp.hasMatch(value.toString())) {
                              return 'Ingresa correctamente el número de documento';
                            }else{
                              return null;
                            }
            }
    );

    return FormInput(text: 'Documento',
            textEditingController: _con.documentocontroller,
            textInputType:TextInputType.text,
            prefixIcon: Icon(Icons.document_scanner,size: 21, color: MyColors.white.withOpacity(0.4)),
            );
  }

  Widget _usuario_nombre(){
    return TextFormFieldWidget(
            controller: _con.nombrecontroller,
            focusNode: _con.nombreNodeFocus, 
            labelText: 'Nombres',
            keyboardType: TextInputType.text, 
            maxLength: 30,
            //fontSize: 9,
            prefixIcon: Icon(Icons.person,color: MyColors.white),
            validator: (value){
                            if (value?.length == 0) {
                                  return 'Ingre Nombres';
                            }else{
                              return null;
                            }
            }
    );

    return FormInput(text: 'Nombres',
            textEditingController: _con.nombrecontroller,
            textInputType:TextInputType.text,
            prefixIcon: Icon(Icons.person,size: 21, color: MyColors.white.withOpacity(0.4)),
            );
  }

 Widget _usuario_apellido(){
    return TextFormFieldWidget(
            controller: _con.apellidocontroller,
            focusNode: _con.apellidoNodeFocus, 
            labelText: 'Apellidos',
            keyboardType: TextInputType.text, 
            maxLength: 30,
            //fontSize: 9,
            prefixIcon: Icon(Icons.person,color: MyColors.white),
            validator: (value){
                            if (value?.length == 0) {
                                  return 'Ingre Nombres';
                            }else{
                              return null;
                            }
            }
    );

  return FormInput(
          text: 'Apellidos',
          textEditingController: _con.apellidocontroller,
          textInputType:TextInputType.text,prefixIcon: Icon(Icons.person,size: 21, color: MyColors.white.withOpacity(0.4)),
          );
  }

Widget Fecha_Nacimiento(){
    return TextFormFieldWidget(
            controller: _con.dateinput,
            focusNode: _con.dateNodeFocus, 
            labelText: 'Fecha de nacimiento YYYY-MM-DD',
            keyboardType: TextInputType.text, 
            maxLength: 10,
            //enabled: false,
            //fontSize: 9,
            prefixIcon: Icon(Icons.calendar_today,color: MyColors.white),
            validator: (value){
                            String pattern = r'(^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$)';
                            RegExp regExp = new RegExp(pattern);
                            if (value?.length == 0) {
                                  return 'Ingre Fecha de nacimiento';
                            }
                            else if (!regExp.hasMatch(value.toString())) {
                              return 'Ingresa correctamente la Fecha de nacimiento';
                            }else{
                              return null;
                            }
            },
            onTap: (){_con.seleccionar_fecha();}
    );

  return FormInput(text: 'Fecha de nacimiento', 
        textEditingController: _con.dateinput,
        textInputType:TextInputType.text,
        prefixIcon: Icon(Icons.calendar_today,size: 21, color: MyColors.white.withOpacity(0.4)),
        onTap: (){_con.seleccionar_fecha();},);
}



 Widget _user_contrasenia(){
    return TextFormFieldWidget(
            controller: _con.passwordcontroller,
            focusNode: _con.passwordNodeFocus, 
            labelText: 'Contraseña',
            keyboardType: TextInputType.text, 
            maxLength: 30,
            obscureText:true,
            //enabled: false,
            //fontSize: 9,
            prefixIcon: Icon(Icons.security,color: MyColors.white),
            validator: (value){
                            if (value?.length == 0) {
                                  return 'Ingre el numero de celular';
                            }
                            else{
                              return null;
                            }
            },
            onTap: (){}
    );

  return FormInput(
          text: 'Contraseña',
          textEditingController: _con.passwordcontroller,
          textInputType:TextInputType.text,
          obscureText: true,
          prefixIcon: Icon(Icons.security,size: 21, color: MyColors.white.withOpacity(0.4)),
          );
  }


 Widget _user_confirmar(){
    return TextFormFieldWidget(
            controller: _con.confirmcontroller,
            focusNode: _con.confirmNodeFocus, 
            labelText: 'Confirmar contraseña',
            keyboardType: TextInputType.visiblePassword, 
            maxLength: 30,
            obscureText:true,
            //enabled: false,
            //fontSize: 9,
            prefixIcon: Icon(Icons.security,color: MyColors.white),
            validator: (value){
                            if (value?.length == 0) {
                                  return 'Ingre el numero de celular';
                            }else{
                              return null;
                            }
            },
            onTap: (){}
    );

   return FormInput(
          text: 'Confirmar contraseña',
          textEditingController: _con.confirmcontroller,
          textInputType:TextInputType.text,
          obscureText: true,
          prefixIcon: Icon(Icons.security,size: 21, color: MyColors.white.withOpacity(0.4)),
          );
  }



  Widget _button(context){
    return 
    BigButtonWidget(text: 'CONFIRMAR', onTap: (){_con.registrar();});
    return 
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
              child: ElevatedButton(
                onPressed: (){_con.registrar();},
                //onPressed: () =>_con.isEnable ? _con.registrar(context) : null, // void con parametros
                child: Text('Registrar',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                   //primary: MyColors.primarycolor,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20)
                ),
              ),
            );
  }
   /*Widget _check(){
    return 
            Container(
              //width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),
              child:  Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                        //checkColor: Colors.red,
                        //activeColor: Colors.red,
                        //selectedTileColor: Colors.red,
                        
                        title: Text("Acepto los terminos y condiciones",style:TextStyle(color: Colors.white),),
                        value: _con.checkvalue,
                        onChanged: (newValue) { setState(() {
                          if(_con.checkvalue==true){
                            _con.checkvalue=false;
                          }else{
                            _con.checkvalue=true;
                          }
                          
                        });},
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
              ) ,
            );
  }
  */
  Widget _check(){
    return             Container(
              //width: double.infinity,
              //margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child:  Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Row(
                  children: [
                    Checkbox(                  
                            value: _con.checkvalue,
                            onChanged: (newValue) { setState(() {
                              if(_con.checkvalue==true){
                                _con.checkvalue=false;
                              }else{
                                _con.checkvalue=true;
                              }
                              
                            });},
                           
                    ),
                    Container(
                      child: Text("Acepto los",style: TextStyle(color: Colors.black),),
                    ),
                    SizedBox(width: 2,),
                    GestureDetector(
                     // onTap: ()=>{  showAlertDialog(context)},
                     onTap: ()=>{  _con.AbrirModal()},
                      child: Container(
                        child: Text("términos y condiciones",style: TextStyle(color: MyColors.secondaryColor),),
                      ),
                    )
                  ],
                ),
              ) ,
            );
  }
  
showAlertDialog(BuildContext context) {  

  // Create button  
  Widget buttonAceptar = FloatingActionButton(  
    child: Text("Acepto"),  
    onPressed: () {  
      Navigator.of(_con.dialogContext).pop(); 
      setState(() {
        _con.checkvalue=true;
      }); 
    },  
  );
  Widget buttonCerrar = FloatingActionButton(  
    child: Text("Cerrar"),  
    onPressed: () {  
      Navigator.of(_con.dialogContext).pop();  
    },  
  );   
    
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("FINALIDAD DE LOS DATOS PERSONALES"),  
    content: SingleChildScrollView(
      child: 
        Column(
          children: [
            Text( 
            "LUCKY SEVEN Podrá solicitar a sus clientes, proveedores, trabajadores, postulantes y en general a los usuarios esta aplicación móvil(en adelante,los Titulares de los Datos Personales) datos personales con la siguiente finalidad:",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "• Para la promoción de los servicios de LUCKY SEVEN",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "• Para fines comerciales relacionados con los servicios ofrecidos por LUCKY SEVEN",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "• Para la verificación y consulta de información de clientes, proveedores, trabajadores y/o postulantes o puestos de trabajo.",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "• Por motivos de seguridad y videovigilancia",
            style: TextStyle(fontSize:11)),
            Text( 
            "• Para compartir información entre las empresas LUCKY SEVEN cuya necesidad estará estrictamente relacionada con la prestación de los servicios común prestados por estas.",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "Queda expresamente establecido que LUCKY SEVEN reconoce el derecho de los Titulares de los Datos Personales a manifestar su negativa respecto al uso y tratamiento de sus datos personales, cuando consideren que la información proporcionada no cumple ninguna de las funciones anteriormente descritas,o si los datos brindados no son necesarios para el establecimiento de una relación contraactual. Esto sin perjuicio del derecho de revocación de consentimiento previamente otorgado por porte del Titular de los Datos Personales o bien para ejercer su derecho de oposición al uso de sus datos en términos de las disposiciones aplicables, derechos que en todo caso serán garantizados por la empresa en todo momento.",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),
            Text( 
            "Los Datos Personales proporcionados serán incorporados, según corresponda, a las base de datos de : Clientes, Trabajadores y postulantes ex trabajadores, asi como podrán incorporarse o reorganizarse con las mismas finalidades, otras bases de datos de LUCKY SEVEN y/o terceros con los que éstas mantengan una relación contraactual a los fines arriba descritos.",
            textAlign: TextAlign.justify,style: TextStyle(fontSize:11)),



          ],
        ),
      
    ),  
    actions: [ 
      buttonCerrar, 
      buttonAceptar
      
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) { 
      _con.dialogContext=context; 
      return alert;  
    },  
  );  
}  
 void refresh(){
     setState(() {
            
    });
 }
}