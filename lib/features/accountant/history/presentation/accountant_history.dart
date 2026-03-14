import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Payment/data/payment_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../../Payment/controller/payment_controller.dart';
import '../controller/accountant_history_controller.dart';

class AccountantHistory extends StatefulWidget {
  const AccountantHistory({super.key});

  @override
  State<AccountantHistory> createState() => _AccountantHistoryState();
}

class _AccountantHistoryState extends State<AccountantHistory> {
  final AccountantHistoryController controller = Get.find<AccountantHistoryController>();
  final MainStore mainStore = Get.find<MainStore>();
  final Authenticator auth = Get.find<Authenticator>();
  final PaymentController paymentController = Get.find<PaymentController>();
  final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await controller.getList();
        scrollController.addListener(() async {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
            try {
              Loader.startLoading();
              await controller.getList(force: true);
            } catch (e) {
              showAlert("$e", AlertType.error);
            } finally {
              Loader.stopLoading();
            }
          }
        });
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  String getBranchName(PaymentModel p) {
    if (auth.state != null && auth.state!.userType != UserType.admin) {
      return "";
    }
    String branchName = controller.branchList.firstWhereOrNull((f) => f.id == p.branchId)?.name ?? "";
    if (branchName == "") {
      return "";
    }
    return ' ( $branchName )';
  }

  List<PaymentModel> getFilteredList() {
    if (controller.searchText.isEmpty) {
      return controller.list;
    }
    String s = controller.searchText.removeAllWhitespace.toLowerCase();
    return controller.list
        .where(
          (m) =>
              m.userName.removeAllWhitespace.toLowerCase().contains(s) ||
              m.voucherNumber.removeAllWhitespace.toLowerCase().contains(s) ||
              m.paymentModeName.removeAllWhitespace.toLowerCase().contains(s) ||
              m.txnValue.removeAllWhitespace.toLowerCase().contains(s) ||
              m.paidAmount.toString().removeAllWhitespace.toLowerCase().contains(s) ||
              getBranchName(m).removeAllWhitespace.toLowerCase().contains(s) ||
              DateFormat('dd-MM-yyyy').format(m.createdAt.toDate()).removeAllWhitespace.toLowerCase().contains(s),
        )
        .toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      autoRemove: false,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Payment History')),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextBox(
                          onValueChange: (v) {
                            controller.searchText = v;
                            controller.update();
                          },
                          controller: searchController,
                          placeholder: 'Search',
                          leading: Icon(MoonIcons.generic_search_24_regular, color: Colors.grey),
                        ),
                      ),
                    ),
                    // ButtonHelperG(
                    //   onTap: () async {
                    //     try {
                    //       Loader.startLoading();
                    //       await controller.getList(force: true);
                    //     } catch (e) {
                    //       showAlert("$e", AlertType.error);
                    //     } finally {
                    //       Loader.stopLoading();
                    //     }
                    //   },
                    //   background: mainStore.theme.value.mediumShadeColor,
                    //   icon: Icon(Icons.refresh),
                    // ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      List<PaymentModel> list = getFilteredList();
                      return ListView.builder(
                        itemCount: list.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return CardHelper(
                            onTap: () {
                              paymentController.selectedPayment = item;
                              Get.toNamed('/paymentDetails');
                            },
                            height: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextHelper(text: item.voucherNumber + getBranchName(item), fontsize: 13, fontweight: FontWeight.w600),
                                    Row(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextHelper(text: 'Paid by: ', fontsize: 11),
                                            TextHelper(
                                              text: '${item.paymentModeName}${item.txnValue.isEmpty ? '' : ' ( ${item.txnValue} ) '}',
                                              fontsize: 10.5,
                                              fontweight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextHelper(text: 'Member : ', fontsize: 11),
                                        TextHelper(text: item.userName, fontsize: 10.5, fontweight: FontWeight.w600),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextHelper(
                                      text: currenyFormater(value: item.paidAmount, withDrCr: false),
                                      fontsize: 14,
                                      fontweight: FontWeight.w600,
                                      textalign: TextAlign.end,
                                    ),
                                    TextHelper(text: DateFormat('dd-MM-yyyy').format(item.createdAt.toDate()), fontsize: 10),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
