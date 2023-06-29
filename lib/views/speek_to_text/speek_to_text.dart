import 'package:emart_user/consts/colors.dart';
import 'package:emart_user/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../category_screen/item_detail.dart';

class SpeakToText extends StatefulWidget {
  const SpeakToText({super.key});

  @override
  State<SpeakToText> createState() => _SpeakToTextState();
}

class _SpeakToTextState extends State<SpeakToText> {
  SpeechToText speechToText = SpeechToText();
  @override
  void onInit() {
    // super.onInit();
    speechToText = SpeechToText();
  }

  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = "Speak to search";
  double _confidence = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        // backgroundColor: redColor,
        title: Text(
          _text,
        ).text.color(Vx.black).make(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: redColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      // body: Container(
      //   alignment: Alignment.center,
      //   child: Text(
      //     _text,
      //     style: const TextStyle(fontSize: 13, color: Vx.black),
      //   ),
      // ),
      body: FutureBuilder(
          future: FirestoreServices.searchProducts(_text),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No Products Found!"
                  .text
                  .size(12)
                  .color(Vx.black)
                  .makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where((element) => element["p_name"]
                      .toString()
                      .toLowerCase()
                      .contains(_text.toLowerCase()))
                  .toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300),
                  children: filtered
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(filtered[index]["p_imgs"][0],
                                  height: 200, width: 200, fit: BoxFit.cover),
                              const Spacer(),
                              "${filtered[index]["p_name"]}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(10)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]["p_price"]}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(8)
                                  .make()
                            ],
                          )
                              .box
                              .white
                              .outerShadowMd
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(() => ItemDetails(
                                  title: "${filtered[index]["p_name"]}",
                                  data: filtered[index],
                                ));
                          }))
                      .toList(),
                ),
              );
            }
          }),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        speechToText.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      speechToText.stop();
    }
  }
}
