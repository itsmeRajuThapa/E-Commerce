import 'package:emart_user/consts/consts.dart';

// ignore: non_constant_identifier_names
Widget bgwidget(Widget? child) {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(imgBackground), fit: BoxFit.fill)),
    child: child,
  );
}
