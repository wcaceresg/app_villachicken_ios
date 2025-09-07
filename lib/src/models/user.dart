// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
       required this.token,
       required this.user,
    });

    String token;
    UserClass user;

    factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        user: UserClass.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class UserClass {
    UserClass({
      required this.id,
      required this.nombres,
      required this.apellidos,
      required  this.numDocu,
      required  this.genero,
      required  this.tipDocu,
      required this.nacimiento,
      required  this.name,
      required  this.telefono,
      required  this.email,
      required  this.admin,
      required  this.emailVerifiedAt,
      required  this.rememberToken,
      required  this.createdAt,
      required  this.updatedAt,
      required  this.tipoLogin,
      required  this.tiendaId,
      required  this.isNotify,
      required  this.whatsappId,
    });

    int id;
    String nombres;
    dynamic apellidos;
    dynamic numDocu;
    String genero;
    String tipDocu;
    String nacimiento;
    String name;
    dynamic telefono;
    String email;
    String admin;
    dynamic emailVerifiedAt;
    dynamic rememberToken;
    String createdAt;
    String updatedAt;
    String tipoLogin;
    dynamic tiendaId;
    dynamic isNotify;
    dynamic whatsappId;

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numDocu: json["num_docu"],
        genero: json["genero"],
        tipDocu: json["tip_docu"],
        //nacimiento: DateTime.parse(json["nacimiento"]),
     
        nacimiento: json["nacimiento"] != null ? json["nacimiento"] : '',
        name: json["name"],
        telefono: json["telefono"],
        email: json["email"],
        admin: json["admin"],
        emailVerifiedAt: json["email_verified_at"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        tipoLogin: json["tipo_login"],
        tiendaId: json["tienda_id"],
        isNotify: json["is_notify"],
        whatsappId: json["whatsapp_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": nombres,
        "apellidos": apellidos,
        "num_docu": numDocu,
        "genero": genero,
        "tip_docu": tipDocu,
        //"nacimiento": "${nacimiento.year.toString().padLeft(4, '0')}-${nacimiento.month.toString().padLeft(2, '0')}-${nacimiento.day.toString().padLeft(2, '0')}",
        "nacimiento":nacimiento,
        "name": name,
        "telefono": telefono,
        "email": email,
        "admin": admin,
        "email_verified_at": emailVerifiedAt,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "tipo_login": tipoLogin,
        "tienda_id": tiendaId,
        "is_notify": isNotify,
        "whatsapp_id": whatsappId,
    };
}
