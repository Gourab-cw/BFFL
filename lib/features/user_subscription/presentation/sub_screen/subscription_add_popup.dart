import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/daterangepicker.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/mainstore.dart';
import '../../../../core/utility/firebase_service.dart';
import '../../../accountant/subscription/controller/acc_subscription_controller.dart';
import '../../data/user_subscription.dart';

Future subscriptionAddPopup(BuildContext context, UserSubscriptionController subController, {UserSubscription? userSubscription}) async {
  final sc = Get.find<SubscriptionController>();
  final auth = Get.find<Authenticator>();
  final TextEditingController totalSessionCountController = TextEditingController();
  final TextEditingController discPerController = TextEditingController();
  final TextEditingController discAmountController = TextEditingController();

  final mainStore = Get.find<MainStore>();
  await showAdaptiveDialog(
    context: context,
    builder: (_) {
      ServiceModel? selectedService;
      bool isFullPackage = false;
      bool isPaidService = false;
      GSTDetails? gstDetails;
      DateTimeRange? selectedDate;

      if (userSubscription != null) {
        selectedService = sc.list.firstWhereOrNull((f) => f.id == userSubscription.subscriptionId);
      }
      if (selectedService != null && userSubscription != null) {
        isFullPackage = userSubscription.isFullPackage;
        isPaidService = userSubscription.isPaidSubscription;
        selectedDate = DateTimeRange(
          start: parseStringToDate(data: userSubscription.startDate, predefinedDateFormat: 'yyyy-MM-dd', defaultValue: DateTime.now()),
          end: parseStringToDate(data: userSubscription.endDate, predefinedDateFormat: 'yyyy-MM-dd', defaultValue: DateTime.now()),
        );
        gstDetails = GSTDetails(
          totalAmount: userSubscription.totalAmount,
          gstPer: selectedService.gstPer,
          withGST: selectedService.withGST,
          grossAmount: userSubscription.grossAmount,
          gstAmount: userSubscription.taxAmount,
          discPer: userSubscription.discPer,
          discAmount: userSubscription.discAmount,
          discountWithGST: parseBool(
            data: subController.chargesLedgers.firstWhereOrNull((f) => f.name.toLowerCase().removeAllWhitespace.contains('discount'))?.withGST,
            defaultValue: false,
          ),
          netAmount: userSubscription.netAmount,
        );
        totalSessionCountController.text = userSubscription.totalSessions.toString();
        discPerController.text = userSubscription.discPer.toString();
        discAmountController.text = userSubscription.discAmount.toString();
      }
      void calculateGST(
        void Function(void Function()) setState, {
        required bool isFullPackage,
        required bool isPaidService,
        bool updateByDiscAmount = false,
        bool updateByDiscPer = false,
      }) {
        final service = selectedService;
        if (service == null) {
          return;
        }
        if (!isPaidService) {
          gstDetails = GSTDetails.empty();
          setState(() {
            gstDetails = gstDetails;
          });
          return;
        }
        bool withDiscountOnGST = parseBool(
          data: subController.chargesLedgers.firstWhereOrNull((f) => f.name.toLowerCase().removeAllWhitespace.contains('discount'))?.withGST,
          defaultValue: false,
        );
        bool voucherHaveDiscount = parseBool(data: subController.voucher?.withDiscount, defaultValue: false);
        double gstPer = service.gstPer;
        bool withGST = service.withGST;
        int totalSessions = isFullPackage ? (selectedService?.totalDays ?? 0) : parseInt(data: totalSessionCountController.text, defaultInt: 0);
        double discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0);
        double discountPer = parseDouble(data: discAmountController.text, defaultValue: 0);
        double grossAmount = service.totalDays == totalSessions
            ? parseDouble(data: service.totalAmount, defaultValue: 0)
            : parseDouble(data: (service.amount * totalSessions), defaultValue: 0);
        double totalAmount = grossAmount;
        if (!withDiscountOnGST && voucherHaveDiscount) {
          if (updateByDiscAmount) {
            discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0).toPrecision(2);
            discountPer = (discountAmount / grossAmount * 100).toPrecision(2);
          } else if (updateByDiscPer) {
            discountPer = parseDouble(data: discPerController.text, defaultValue: 0).toPrecision(2);
            discountAmount = (discountPer / 100 * grossAmount).toPrecision(2);
          }
          grossAmount = grossAmount - discountAmount;
        }
        double gstAmount = 0;
        double netAmount = grossAmount;
        if (withGST) {
          gstAmount = (grossAmount * gstPer) / 100;
          netAmount += gstAmount;
        }
        if (withDiscountOnGST && voucherHaveDiscount) {
          if (updateByDiscAmount) {
            discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0).toPrecision(2);
            discountPer = (discountAmount / netAmount * 100).toPrecision(2);
          } else if (updateByDiscPer) {
            discountPer = parseDouble(data: discPerController.text, defaultValue: 0).toPrecision(2);
            discountAmount = (discountPer / 100 * netAmount).toPrecision(2);
          }
          netAmount = netAmount - discountAmount;
        }

        discPerController.text = parseDoubleWithLength(data: discountPer, defaultValue: '');
        discAmountController.text = discountAmount.toString();
        gstDetails = GSTDetails(
          totalAmount: totalAmount,
          gstPer: gstPer,
          withGST: withGST,
          grossAmount: grossAmount,
          gstAmount: gstAmount,
          netAmount: netAmount,
          discPer: discountPer,
          discAmount: discountAmount,
          discountWithGST: withDiscountOnGST,
        );
        setState(() {
          gstDetails = gstDetails;
        });
      }

      Future<void> addSubscription(GSTDetails? gstDetails) async {
        UserG? user = auth.state;
        String userId = parseString(data: subController.user['id'], defaultValue: '');
        String userName = parseString(data: subController.user['name'], defaultValue: '');
        final fb = Get.find<FB>();
        final db = await fb.getDB();
        final voucher = subController.voucher;
        if (voucher == null) {
          showAlert("No voucher found!", AlertType.error);
          return;
        }
        if (userId.isEmpty) {
          showAlert("No user found!", AlertType.error);
          return;
        }
        if (user == null) {
          showAlert("No user found!", AlertType.error);
          return;
        }
        if (selectedService == null) {
          showAlert("Please select service!", AlertType.error);
          return;
        }
        if (selectedDate == null) {
          showAlert("Please select date range!", AlertType.error);
          return;
        }
        if (gstDetails == null) {
          showAlert("Error on saving! Calculation not found! ", AlertType.error);
          return;
        }

        int count = 0;
        if (userSubscription == null) {
          count = parseInt(data: (await db.collection('userSubscription').where('userId', isEqualTo: userId).count().get()).count);
        }

        final userSubscriptionData = UserSubscription(
          id: userSubscription == null ? Uuid().v4() : userSubscription.id,
          voucherTypeId: voucher.id,
          voucherTypeName: voucher.name,
          name: userSubscription != null ? userSubscription.name : '${voucher.prefix}${(count + 1).toString().padLeft(4, '0')}${voucher.suffix}',
          userId: userId,
          userName: userName,
          branchId: auth.state!.branchId,
          subscriptionId: selectedService!.id,
          startDate: selectedDate!.start.toString(),
          endDate: selectedDate!.end.toString(),
          totalSessions: isFullPackage ? parseInt(data: selectedService?.totalDays) : parseInt(data: totalSessionCountController.text),
          usedSessions: 0,
          remainingSessions: isFullPackage ? parseInt(data: selectedService?.totalDays) : parseInt(data: totalSessionCountController.text),
          isActive: false,
          isPosted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          subscriptionName: selectedService!.name,
          subscriptionTotalDays: parseInt(data: selectedService?.totalDays),
          subscriptionTotalAmount: parseDouble(data: selectedService?.totalAmount, defaultValue: 0),
          subscriptionAmount: parseDouble(data: selectedService?.amount, defaultValue: 0),
          discAmount: gstDetails.discAmount,
          discPer: gstDetails.discPer,
          totalAmount: gstDetails.totalAmount,
          grossAmount: gstDetails.grossAmount,
          taxAmount: gstDetails.gstAmount,
          netAmount: gstDetails.netAmount,
          dueAmount: gstDetails.netAmount,
          discountWithGST: gstDetails.discountWithGST,
          isPaidSubscription: isPaidService,
          isFullPackage: isFullPackage,
        );

        if (userSubscription == null) {
          subController.allSubscriptions.add(userSubscriptionData);
        } else {
          int index = subController.allSubscriptions.indexWhere((f) => f.id == userSubscription.id);
          subController.allSubscriptions.replaceRange(index, index + 1, [userSubscriptionData]);
        }

        subController.update();
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8 > 500 ? 500 : MediaQuery.sizeOf(context).width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    DropDownHelperG(
                      labelText: "Select Service",
                      showLabelAlways: true,
                      showClearText: false,
                      uniqueKey: UniqueKey().toString(),
                      onValueChange: (v) {
                        setState(() {
                          selectedService = sc.list.firstWhereOrNull((m) => m.id == v['id']);
                        });
                        calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                      },
                      value: selectedService?.toJson(),
                      items: sc.list.map((m) => m.toJson()).toList(),
                      height: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MoonCheckbox(
                          value: isPaidService,
                          activeColor: mainStore.theme.value.HeadColor,
                          onChanged: (v) {
                            if (isPaidService) {
                              return;
                            }
                            setState(() {
                              isPaidService = true;
                            });
                            calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                          },
                        ),
                        TextHelper(text: "Paid Service", width: 100, fontweight: FontWeight.w500),
                        const SizedBox(width: 8),
                        MoonCheckbox(
                          value: !isPaidService,
                          activeColor: mainStore.theme.value.HeadColor,
                          onChanged: (v) {
                            if (!isPaidService) {
                              return;
                            }
                            setState(() {
                              isPaidService = false;
                            });
                            calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                          },
                        ),
                        TextHelper(text: "Trail Service", width: 110, fontweight: FontWeight.w500),
                      ],
                    ),
                    Row(
                      children: [
                        TextHelper(text: "Date Range :", width: 85),
                        DateRangePicker(
                          height: 40,
                          selectedDateRange: selectedDate,
                          onValueChange: (v) {
                            setState(() {
                              selectedDate = v;
                            });
                          },
                          backgroundColor: mainStore.theme.value.lowShadeColor,
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MoonCheckbox(
                          value: isFullPackage,
                          activeColor: mainStore.theme.value.HeadColor,
                          onChanged: (v) {
                            if (isFullPackage) {
                              return;
                            }
                            setState(() {
                              isFullPackage = true;
                            });
                            calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                          },
                        ),
                        TextHelper(text: "Full Package", width: 100, fontweight: FontWeight.w500),
                        const SizedBox(width: 8),
                        MoonCheckbox(
                          value: !isFullPackage,
                          activeColor: mainStore.theme.value.HeadColor,
                          onChanged: (v) {
                            if (!isFullPackage) {
                              return;
                            }
                            setState(() {
                              isFullPackage = false;
                            });
                            calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                          },
                        ),
                        TextHelper(text: "Custom Booking", width: 110, fontweight: FontWeight.w500),
                      ],
                    ),
                    Row(
                      children: [
                        TextHelper(text: "Total sessions :", width: 100),
                        isFullPackage
                            ? TextHelper(text: selectedService?.totalDays.toString() ?? '0', width: 60)
                            : TextBox(
                                width: 60,
                                height: 35,
                                withBorder: false,
                                controller: totalSessionCountController,
                                onSubmitted: (v) {
                                  calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                                },
                                onTapOutside: () {
                                  calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService);
                                },
                                backgroundColor: mainStore.theme.value.lowShadeColor,
                              ),
                      ],
                    ),
                    if (isPaidService)
                      Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              TextHelper(text: "Discount :", width: 90),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: TextBox(
                                      controller: discPerController,
                                      height: 35,
                                      width: 80,
                                      showAlwaysLabel: true,
                                      labelText: 'Per ',
                                      withBorder: false,
                                      backgroundColor: getMainStore().theme.value.lowShadeColor,
                                      fontSize: 13,
                                      selectTextOnFocus: true,
                                      onTapOutside: () {
                                        calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService, updateByDiscPer: true);
                                      },
                                      onSubmitted: (v) {
                                        calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService, updateByDiscPer: true);
                                      },
                                      onValueChange: (v) {},
                                      leading: Icon(FontAwesomeIcons.percentage, size: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                                    ),
                                  ),
                                  SizedBox(width: 12, height: 20, child: VerticalDivider()),
                                  SizedBox(
                                    width: 100,
                                    child: TextBox(
                                      controller: discAmountController,
                                      height: 35,
                                      width: 100,
                                      showAlwaysLabel: true,
                                      labelText: 'Amount ',
                                      selectTextOnFocus: true,
                                      readonly: true,
                                      withBorder: false,
                                      // backgroundColor: getMainStore().theme.value.lowShadeColor,
                                      fontSize: 13,
                                      onTapOutside: () {
                                        calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService, updateByDiscAmount: true);
                                      },
                                      onSubmitted: (v) {
                                        calculateGST(setState, isFullPackage: isFullPackage, isPaidService: isPaidService, updateByDiscAmount: true);
                                      },
                                      leading: Icon(FontAwesomeIcons.indianRupeeSign, size: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextHelper(text: "Total amount :", width: 100),
                              TextHelper(
                                text: currenyFormater(value: gstDetails?.totalAmount.toString() ?? "", withDrCr: false),
                                fontsize: 13,
                                textalign: TextAlign.right,
                                width: 100,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextHelper(text: "Gross amount :", width: 100),
                              TextHelper(
                                text: currenyFormater(value: gstDetails?.grossAmount.toString() ?? "", withDrCr: false),
                                textalign: TextAlign.right,
                                width: 100,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextHelper(text: "Tax amount :", width: 100),
                              TextHelper(
                                text: currenyFormater(value: gstDetails?.gstAmount.toString() ?? "", withDrCr: false),
                                textalign: TextAlign.right,
                                width: 100,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextHelper(text: "Net amount :", width: 100),
                              TextHelper(
                                text: currenyFormater(value: (gstDetails?.netAmount.toString() ?? ""), withDrCr: false),
                                textalign: TextAlign.right,
                                width: 100,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ButtonHelperG(
                      onTap: () async {
                        try {
                          Loader.startLoading();
                          await addSubscription(gstDetails);
                          goBack(context);
                        } catch (e) {
                          showAlert('$e', AlertType.error);
                        } finally {
                          Loader.stopLoading();
                        }
                      },
                      width: 100,
                      height: 35,
                      icon: Icon(FontAwesomeIcons.plus, fontWeight: FontWeight.w400, size: 14, color: mainStore.theme.value.BackgroundColor),
                      label: TextHelper(text: "Add", color: mainStore.theme.value.BackgroundColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
