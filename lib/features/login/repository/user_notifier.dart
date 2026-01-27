import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import '../../../app/firebase_provider.dart';


class UserNotifier extends Notifier<UserG?> {

  late FirebaseG firebase;

  @override
  UserG? build() {
    firebase = ref.read(firebaseProvider);
    return null;
  }

  Future<void> checkIfUserLogin()async{
    final auth = await firebase.getAuth();
    auth.authStateChanges().listen((user){
      if(user!=null){
        if(state!=null && state?.uid!=user.uid){
          state = UserG(uid: user.uid, name: parseString(data: user.displayName, defaultValue: ""), mail: parseString(data: user.email, defaultValue: ""));
        }else if(state==null){
          state = UserG(uid: user.uid, name: parseString(data: user.displayName, defaultValue: ""), mail: parseString(data: user.email, defaultValue: ""));
        }
        Get.offAllNamed("/home");
      }else{
        state=null;
        Get.offAllNamed("/login");
      }
    });
  }

  Future<void> emailLogin({required String email,required String password}) async {
    try{
      // 1️⃣ Get Firebase instance
      final firebase = ref.read(firebaseProvider);

      // 2️⃣ Call Firebase function
      final UserG? user = await firebase.makeEmailLogin(email: email, password: password);

      // 3️⃣ Update state
      state = user;
    }catch(e){
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> addUser({required String email, required String password,required String name})async{
    try{
      final firebase = ref.read(firebaseProvider);

      // 2️⃣ Call Firebase function
      final UserG? user = await firebase.createNewUser(email: email, password: password,name: name);

      // 3️⃣ Update state
      state = user;
    }catch(e){
      showAlert("$e", AlertType.error);
    }
  }
}
