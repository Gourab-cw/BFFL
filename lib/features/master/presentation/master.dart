import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {

  final mainStore = Get.find<MainStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextHelper(text: "Admin Control Panel",fontsize: 18,fontweight: FontWeight.w600,padding: EdgeInsets.symmetric(horizontal: 8),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  CardHelper(
                    boxShadow: [],
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing:15,
                          children: [
                            Icon(FontAwesomeIcons.suitcaseMedical,size: 20,color: mainStore.theme.value.HeadColor.withAlpha(180),),
                            TextHelper(text: "Company",fontweight: FontWeight.w600,)
                          ],
                        ),
                        ButtonHelperG(
                          background: Colors.transparent,
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  CardHelper(
                    boxShadow: [],
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing:15,
                          children: [
                            Icon(FontAwesomeIcons.houseMedical,size: 20,color: mainStore.theme.value.HeadColor.withAlpha(180),),
                            TextHelper(text: "Branch",fontweight: FontWeight.w600,)
                          ],
                        ),
                        ButtonHelperG(
                          background: Colors.transparent,
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  CardHelper(
                    onTap: (){
                      Get.toNamed('/memberapproveregister');
                    },
                    boxShadow: [],
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing:15,
                          children: [
                            Icon(FontAwesomeIcons.solidUser,size: 20,color: mainStore.theme.value.HeadColor.withAlpha(180),),
                            TextHelper(text: "Approve Member",fontweight: FontWeight.w600,)
                          ],
                        ),
                        ButtonHelperG(
                          onTap: (){
                            Get.toNamed('/memberapproveregister');
                          },
                          background: Colors.transparent,
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  CardHelper(
                    boxShadow: [],
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing:15,
                          children: [
                            Icon(FontAwesomeIcons.users,size: 20,color: mainStore.theme.value.HeadColor.withAlpha(180),),
                            TextHelper(text: "Staffs",fontweight: FontWeight.w600,)
                          ],
                        ),
                        ButtonHelperG(
                          background: Colors.transparent,
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  ),
                  CardHelper(
                    boxShadow: [],
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing:15,
                          children: [
                            Icon(FontAwesomeIcons.calendarDay,size: 20,color: mainStore.theme.value.HeadColor.withAlpha(180),),
                            TextHelper(text: "Holidays",fontweight: FontWeight.w600,)
                          ],
                        ),
                        ButtonHelperG(
                          background: Colors.transparent,
                          icon: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
