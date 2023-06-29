// ignore_for_file: avoid_print

import 'dart:io';
import 'package:emart_user/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImgPath = "".obs;
  var profileImageLink = "";
  var isloading = false.obs;

//textfield
  var nameController = TextEditingController();
  var newpassController = TextEditingController();
  var oldpassController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = "images/${currentUser!.uid}/$filename";
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile(name, password, imgUrl) async {
    var store = firestore.collection(usersCollection).doc(currentUser!.uid);
    await store.set({"name": name, "password": password, "imageUrl": imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString("Wrong name or Password"));
    });
  }
}
