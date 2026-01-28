import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../../app/provider.dart';


class UserAdd extends ConsumerStatefulWidget {
  const UserAdd({super.key});

  @override
  ConsumerState<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends ConsumerState<UserAdd> {
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      final appLoader = ref.read(appLoaderProvider.notifier);
       try{
         final pickListRef = ref.read(pickListProvider.notifier);
         appLoader.startLoading();
         await pickListRef.getPickLists();

       }catch(e){
         showAlert("$e", AlertType.error);
       }finally{
         appLoader.stopLoading();
       }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: TextHelper(text: "Add Member",fontsize: 18,),
      ),
      body: Text("data"),
    );
  }
}
