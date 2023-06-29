import 'dart:async';

import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/category_screen/item_detail.dart';
import 'package:emart_user/views/home_screen/components/feature_button.dart';
import 'package:emart_user/views/home_screen/search_screen.dart';
import 'package:emart_user/widgets_common/home_buttom.dart';
import 'package:flutter/rendering.dart';
import '../../controller/home_controller.dart';
import '../speek_to_text/speek_to_text.dart';
import 'components/offer_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFabVisible = false;
  Duration timerDuration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timerRef.onValue.listen((event) {
      final data = event.snapshot.value as int?;
      if (data != null) {
        setState(() {
          timerDuration = Duration(seconds: data);
          startTimer();
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    if (timerDuration.inSeconds > 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          timerDuration -= const Duration(seconds: 1);
        });

        if (timerDuration.inSeconds <= 0) {
          timer?.cancel();
          timerRef.remove(); // Remove the timer value from Firebase
        }
      });
    }
  }

  String formatTime(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.forward) {
          setState(() => isFabVisible = true);
        } else if (notification.direction == ScrollDirection.reverse) {
          setState(() => isFabVisible = false);
        }
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
            child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: 55,
            color: lightGrey,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                          title: controller.searchController.text));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: const TextStyle(color: textfieldGrey)),
            ),
          ),
          Visibility(
            visible: isFabVisible,
            child: IconButton(
                onPressed: () {
                  Get.to(() => const SpeakToText());
                },
                icon: const Icon(Icons.mic, size: 20)),
          ),
          10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: slidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          slidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),
                  10.heightBox,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          2,
                          ((index) => homeButtons(
                              context.screenWidth / 2.9,
                              context.safePercentHeight * 11.15,
                              index == 0 ? icTodaysDeal : icFlashDeal,
                              index == 0 ? todayDeal : flashsale,
                              () {})))),
                  10.heightBox,
                  Container(
                    child: '${formatTime(timerDuration)}' == "00:00:00"
                        ? Container()
                        : Stack(
                            children: [
                              //  if(' ${formatTime(timerDuration)}'==00)
                              Image.asset(
                                imgFd1,
                                fit: BoxFit.fill,
                                height: 180,
                                color: Colors.black.withOpacity(0.4),
                                colorBlendMode: BlendMode.darken,
                              ),
                              Positioned(
                                bottom: 40,
                                right: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${formatTime(timerDuration)}',
                                        style: const TextStyle(
                                            fontSize: 42, color: whiteColor),
                                      ),
                                      const Text(
                                        "Offer! Offer!",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Color.fromARGB(
                                                255, 45, 248, 123)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make()
                            .onTap(() {
                            Get.to(() => const OfferDetails());
                          }),
                  ),
                  // VxSwiper.builder(
                  //     aspectRatio: 16 / 9,
                  //     autoPlay: true,
                  //     height: 150,
                  //     enlargeCenterPage: true,
                  //     itemCount: secondsliderList.length,
                  //     itemBuilder: (context, index) {
                  //       return Image.asset(
                  //         secondsliderList[index],
                  //         fit: BoxFit.fill,
                  //       )
                  //           .box
                  //           .rounded
                  //           .clip(Clip.antiAlias)
                  //           .margin(const EdgeInsets.symmetric(horizontal: 8))
                  //           .make();
                  //     }),
                  10.heightBox,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButtons(
                              context.screenWidth / 3.3,
                              context.safePercentHeight * 9.15,
                              index == 0
                                  ? icTopCategories
                                  : index == 1
                                      ? icBrands
                                      : icTopSeller,
                              index == 0
                                  ? topCat
                                  : index == 1
                                      ? brand
                                      : topSallers,
                              () {}))),
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .color(darkFontGrey)
                          .size(14)
                          .fontFamily(semibold)
                          .make()),
                  15.heightBox,
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            3,
                            (index) => Column(
                                  children: [
                                    featuredButton(featuredTitles1[index],
                                        featuredImages1[index]),
                                    8.heightBox,
                                    featuredButton(featuredTitles2[index],
                                        featuredImages2[index]),
                                  ],
                                )).toList(),
                      )),
                  20.heightBox,

                  //Features Product
                  Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: redColor),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            featuredProduct.text.white
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                            10.heightBox,
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder(
                                  future:
                                      FirestoreServices.getFeaturedProducts(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation(redColor),
                                        ),
                                      );
                                    } else if (snapshot.data!.docs.isEmpty) {
                                      return "No Featured products"
                                          .text
                                          .white
                                          .makeCentered();
                                    } else {
                                      var featuredData = snapshot.data!.docs;

                                      return Row(
                                          children: List.generate(
                                              featuredData.length,
                                              (index) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.network(
                                                        featuredData[index]
                                                            ["p_imgs"][0],
                                                        width: 150,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      10.heightBox,
                                                      "${featuredData[index]["p_name"]}"
                                                          .text
                                                          .fontFamily(semibold)
                                                          .size(8)
                                                          .color(darkFontGrey)
                                                          .make(),
                                                      10.heightBox,
                                                      "Rs. ${featuredData[index]["p_price"]}"
                                                          .text
                                                          .color(redColor)
                                                          .fontFamily(bold)
                                                          .size(5)
                                                          .make()
                                                    ],
                                                  )
                                                      .box
                                                      .white
                                                      .margin(const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5))
                                                      .roundedSM
                                                      .padding(
                                                          const EdgeInsets.all(
                                                              8))
                                                      .make()
                                                      .onTap(() {
                                                    Get.to(() => ItemDetails(
                                                          title:
                                                              "${featuredData[index]["p_name"]}",
                                                          data: featuredData[
                                                              index],
                                                        ));
                                                  })));
                                    }
                                  }),
                            )
                          ])),
                  20.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondsliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondsliderList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: "All Products"
                          .text
                          .color(darkFontGrey)
                          .size(14)
                          .fontFamily(semibold)
                          .make()),
                  20.heightBox,
                  StreamBuilder(
                      stream: FirestoreServices.allProducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            ),
                          );
                        } else {
                          var allproductsdata = snapshot.data!.docs;
                          return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allproductsdata.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 300),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                        allproductsdata[index]["p_imgs"][0],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover),
                                    const Spacer(),
                                    "${allproductsdata[index]["p_name"]}"
                                        .text
                                        .fontFamily(semibold)
                                        .size(10)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    "Rs. ${allproductsdata[index]["p_price"]}"
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(8)
                                        .make()
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .roundedSM
                                    .padding(const EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  Get.to(() => ItemDetails(
                                        title:
                                            "${allproductsdata[index]["p_name"]}",
                                        data: allproductsdata[index],
                                      ));
                                });
                              });
                        }
                      })
                ],
              ),
            ),
          )
        ])),
      ),
    );
  }
}
