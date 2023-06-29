import 'dart:math';

import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/home_screen/home.dart';
import '../../controller/cart_controller.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  var controller = Get.find<CartController>();
  String referenceId = "";
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
            height: 60,
            child: controller.placingOrder.value
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  )
                : ourButton(() async {
                    if (controller.paymentIndex.value == 0) {
                      // ignore: use_build_context_synchronously
                      //VxToast.show(context, msg: "Order placed successfully");
                      payWithKhaltiInApp();
                      Text(referenceId);
                    } else {
                      await controller.placeMyOrder(
                          orderPaymentMethod:
                              paymentMethods[controller.paymentIndex.value],
                          totalAmount: controller.totalP.value,
                          status: "Unpaid",
                          randomNum:
                              (Random().nextInt(111111) + 11111).toString());
                      await controller.clearCart();
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Order placed successfully");
                      Get.offAll(() => const Home());
                    }
                  }, redColor, whiteColor, "Place my order")),
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(
            () => Column(
                children: List.generate(paymentMethodimg.length, (index) {
              return GestureDetector(
                onTap: () {
                  controller.changePaymentIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: controller.paymentIndex.value == index
                              ? Colors.green
                              : Colors.transparent,
                          width: 3)),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(paymentMethodimg[index],
                          width: double.infinity,
                          height: 110,
                          colorBlendMode: controller.paymentIndex.value == index
                              ? BlendMode.darken
                              : BlendMode.color,
                          color: controller.paymentIndex.value == index
                              ? Colors.black.withOpacity(0.4)
                              : Colors.transparent,
                          fit: BoxFit.cover),
                      controller.paymentIndex.value == index
                          ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  value: true,
                                  onChanged: (value) {}))
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: paymentMethods[index]
                            .text
                            .white
                            .fontFamily(semibold)
                            .size(15)
                            .make(),
                      )
                    ],
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: getAmt(context), //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          actions: [
            SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () async {
                  setState(() {
                    referenceId = success.idx;
                  });
                  await controller.placeMyOrder(
                      orderPaymentMethod:
                          paymentMethods[controller.paymentIndex.value],
                      totalAmount: controller.totalP.value,
                      status: "Paid",
                      randomNum: (Random().nextInt(51) + 50).toString());
                  await controller.clearCart();
                  Get.offAll(() => const Home());
                })
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }
}

getAmt(context) {
  var controller = Get.find<CartController>();
  int Total = 0;
  int cost = 100;
  int detail = controller.totalP.value;
  Total = cost * detail;
  return Total;
}
