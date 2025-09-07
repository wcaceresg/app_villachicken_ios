
import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/favorites_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/traits/functions.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientsFavoriteController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 int counter=1;
 SharedPref _sharedPref=new SharedPref();
 List selectedProducts=[];
 List carrito_sesion=[];
 bool enabled = true;
 UserProvider userprovider=new UserProvider();
 FavoriteProvider favoritesProvider=new FavoriteProvider();
 List favorites=[];
Future init(BuildContext context,Function refresh) async{
   this.context=context;
   this.refresh=refresh;
   initUserProvider();
   _onLoading();
   initReloadToken().then((value) => {
      initFavoritesProvider().then((rest)=>{
              RequestFavorites()
            
      })
   }).catchError((error)=>{
    Navigator.pop(dialogContext),
    mySnackbar.show(context, Catalogs.error_500)
   });
   
  //refresh();
  //setTimeout(()=>{enabled=false,refresh()},1000);
  
}

Future initUserProvider() async{
  try {await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;} 
  catch (e) {print(e);}
}
Future initFavoritesProvider() async{
  try {await favoritesProvider.init(context,  User.fromJson(await _sharedPref.read('user') ?? {}));
  } catch (e) { print(e);
  }
}

Future initReloadToken() async{
    try { await userprovider.reload_token();} catch (e) { print(e);}
}

Future RequestFavorites() async{
  try 
  {     
         await favoritesProvider.listar().then((value) => { 
           favorites=value,
           Navigator.pop(dialogContext),
          // enabled=true,
          refresh()
           
         });
         
  } catch (e) {
        Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}
void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return LoaderWidget();
    },
  );
}
void deleteFavorite(index){
   _onLoading();
   initReloadToken().then((value) => {
              delete(index),
   }).catchError((error)=>{
    Navigator.pop(dialogContext),
    mySnackbar.show(context, Catalogs.error_500)
   });

}
Future delete(id) async{
  try 
  {     
         await favoritesProvider.delete(favorites[id]['attributes']['id_favorite']).then((value) => { 
          Navigator.pop(dialogContext),
          favorites.remove(favorites[id]),
          print(favorites),
          refresh()
           //favorites=value,
           //Navigator.pop(dialogContext),
          // enabled=true,
          //srefresh()
           
         });
         
  } catch (e) {
        Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}

void goToDetallePaquete(id){
   Navigator.of(context).pushNamed("client/product_details",arguments:{'id':id.toString()});
}
void close_page(){
  Navigator.of(context).pop();
}

}