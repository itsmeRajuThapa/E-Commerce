import 'package:emart_user/consts/consts.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        const Divider(),
        10.heightBox,
        "Are you sure you want to exit"
            .text
            .size(16)
            .color(darkFontGrey)
            .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ourButton(() {
              SystemNavigator.pop();
            }, redColor, whiteColor, "Yes"),
            ourButton(() {
              Navigator.pop(context);
            }, redColor, whiteColor, "No"),
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(15)).roundedSM.make(),
  );
}
