import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/no_data_widget.dart';
import 'big_text.dart';
import 'small_text.dart';

class AddressListWidget extends StatelessWidget {
  final bool enabled;
  final List<dynamic> addressList;
  final int selectedIndex;
  final Function(int) onSelect;

  const AddressListWidget({
    Key? key,
    required this.enabled,
    required this.addressList,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      child: addressList.length>0?Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: addressList.length,
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {
                onSelect(index);
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == index
                      ? MyColors.secondaryColor
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      width: 30,
                      child: Icon(
                        Icons.location_on_sharp,
                        color: selectedIndex == index
                            ? MyColors.yellowcolor
                            : Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: BigText(
                                text: (addressList[index]['ADD_ADI_NOMBRE']).toUpperCase(),
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                size: 12,
                                overFlow: TextOverflow.ellipsis,
                                maxlines: 3,
                              ),
                            ),
                            Container(
                              height: 30,
                              child: SmallText(
                                text: addressList[index]['ADD_DIR_DOMICILIO'] +
                                    '-' +
                                    addressList[index]['ADD_DIR_REFERENCIA'],
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Color(0xFFccc7c5),
                                size: 12,
                                height: 1.2,
                               // overflow: TextOverflow.ellipsis,
                               // maxLines: 2,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: SmallText(
                                text: addressList[index]['ADD_ADI_TELEFONO'],
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Color(0xFFccc7c5),
                                size: 12,
                                height: 1.2,
                                //overflow: TextOverflow.ellipsis,
                               // maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ):NoDataWidget(path: 'assets/img/villy_not_address.png',text: 'No tienes direccion',),
    );
  }
}
