import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/controller/home_controller.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  //text controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var phoneController = TextEditingController();
  var postalcodeController = TextEditingController();

  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var venders = [];
  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]["tprice"].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder(
      {required orderPaymentMethod,
      required totalAmount,
      required randomNum,
      required status}) async {
    placingOrder(true);
    await getProductDetails();

    await firestore.collection(ordersCollection).doc().set({
      "order_code": randomNum,
      "order_date": FieldValue.serverTimestamp(),
      "order_by": currentUser!.uid,
      "order_by_name": Get.find<HomeController>().username,
      "order_by_email": currentUser!.email,
      "order_by_address": addressController.text,
      "order_by_state": stateController.text,
      "order_by_city": cityController.text,
      "order_by_phone": phoneController.text,
      "order_by_postalcode": postalcodeController.text,
      "shippling_method": "Home Delivery",
      "payment_method": orderPaymentMethod,
      "order_placed": true,
      "order_confirmed": false,
      "order_delivered": false,
      "order_on_delivery": false,
      "payment": status,
      "total_amount": totalAmount,
      "order": FieldValue.arrayUnion(products),
      "venders": FieldValue.arrayUnion(venders),
      "longitude": Get.find<HomeController>().longitude.value,
      "latitude": Get.find<HomeController>().latitude.value,
      "Address": Get.find<HomeController>().address.value,
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    venders.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        "color": productSnapshot[i]["color"],
        "img": productSnapshot[i]["img"],
        "vender_id": productSnapshot[i]["vender_id"],
        "tprice": productSnapshot[i]["tprice"],
        "qty": productSnapshot[i]["qty"],
        "title": productSnapshot[i]["title"],
      });
      venders.add(productSnapshot[i]["vender_id"]);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
