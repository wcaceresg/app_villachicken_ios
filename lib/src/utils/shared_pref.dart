import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPref{
  void save(String key,dynamic value) async{
    final presf=await SharedPreferences.getInstance();
    presf.setString(key,json.encode(value));
  }
  Future<dynamic> read(String key) async{
    final prefs=await SharedPreferences.getInstance();
    if(prefs.getString(key)==null)return null;
    return json.decode(prefs.getString(key)!);
  }

  Future<bool> contains(String key) async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
  Future<bool> remove(String key) async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
  void logout(BuildContext context)  async{
    /*UserProvider userprovider=new UserProvider();
    userprovider.init(context,null);
    await userprovider.logout(iduser);
   await remove('user');
   Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
   */
   await remove('user');
   Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);

  }  

}