import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/pedidos/ClientsPedidoController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/sidebar.dart';

class ClientspedidosPage extends StatefulWidget {
  const ClientspedidosPage({super.key});

  @override
  State<ClientspedidosPage> createState() => _ClientspedidosPageState();
}

class _ClientspedidosPageState extends State<ClientspedidosPage> {
  ClientsPedidoController _con=new ClientsPedidoController();
  int select=0;
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
    
  }
  @override
  Widget build(BuildContext context) {
        return Container(
                  decoration: BoxDecoration(
                        color: Colors.white
                    ),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 50, 
                            //leading: Icon(Icons.menu),
                            //title: Text('Page title'),
                        title:Column(
                          children: [
                              _TopBar2()
                          ]),    
                      backgroundColor: Colors.white,
                      //backgroundColor: Colors.purple,
                      ),
                                    key:_con.key,
              drawer: SideBarWidget(),
                body: Stack(
                    children: [ 
                        SingleChildScrollView(
                          child: Column(
                            children: [
                               title(),
                               _listOrders()



                            
                            ],
                          ),
                        ),
                    ],
                ),
                //bottomNavigationBar: _ButtonBottom(),

              ),
            );
  }
  Widget  _TopBar2(){
  return  Container(
              
            child: Container(
              //margin: EdgeInsets.only(top: 45,bottom: 15),
              //padding: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      GestureDetector(
                            onTap: _con.openDrawer,
                            child: Container(
                              margin: EdgeInsets.only(left: 0),
                              padding: EdgeInsets.only(left: 0),
                              ///alignment: Alignment.lef,
                              child: Image.asset('assets/img/menu.png',width: 20,height: 20),
                            ),
                          ),







                  ],
                ),

                ]
              ),
            ),
          );
  }
  Widget title(){
    return Container(
      width: double.infinity, 
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      //height: 50,
      decoration: BoxDecoration(
      color:  Colors.white,
        /* boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          */
      ),  
      child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: BigText(
              text:'ULTIMOS PEDIDOS '+_con.orders.length.toString(),
             //  color:Colors.black87,         
             size: 18,
          ),
      ),
      ),
    );
  }

 
 Widget _listOrders() {
  return Container(
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento independiente
      shrinkWrap: true,
      itemCount: _con.orders != null ? _con.orders.length : 0,
      itemBuilder: (_, index) {
        return customRadioREST(_con.orders[index], index);
      },
    ),
  );
}
Widget customRadioREST(order, int index) {
  bool isSelected = select == index;
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: isSelected ? MyColors.secondaryColor : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // Sombra suave
        ),
      ],
      
    ),
    child: OutlinedButton(
      onPressed: () {
        setState(() {
          select = index;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide.none, // Sin borde en el botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10), // Espacio al inicio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Número de pedido y precio
                _buildOrderHeader(order, isSelected),
                const SizedBox(height: 4),
                // Fecha de creación
                _buildInfoRow(
                  icon: Icons.calendar_month_outlined,
                  text: order['attributes']['fecha_creacion'],
                  isSelected: isSelected,
                ),
                const SizedBox(height: 4),
                // Dirección
                _buildInfoRow(
                  icon: Icons.location_on,
                  text: order['relationships']['direccion']['attributes']['add_domicilio'],
                  isSelected: isSelected,
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget para el encabezado del pedido (número de pedido y precio)
Widget _buildOrderHeader(order, bool isSelected) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Pedido Nº - ${order['id']}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      Text(
        'S/ ${order['attributes']["total"].toString()}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold, // Resaltar el precio
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    ],
  );
}

// Widget para filas de información con ícono
Widget _buildInfoRow({required IconData icon, required String text, required bool isSelected, double? maxWidth}) {
  return Row(
    children: [
      Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
      ),
      const SizedBox(width: 5), // Pequeño espaciado entre icono y texto
      if (maxWidth != null)
        SizedBox(
          width: maxWidth,
          child: Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: isSelected ? Colors.white : const Color(0xFFccc7c5),
            ),
          ),
        )
      else
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFFccc7c5),
          ),
        ),
    ],
  );
}
  void refresh(){
    setState(() {
      
    });
  }
}