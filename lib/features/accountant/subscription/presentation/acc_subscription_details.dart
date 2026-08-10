import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/core/voucher/controller/voucher_controller.dart';

import '../../../../core/utility/app_loader.dart';
import '../../../../core/voucher/model/voucher_model.dart';
import '../../../subscriptions/controller/subscription_controller.dart';
import '../controller/acc_subscription_controller.dart';

class AccSubscriptionDetails extends StatefulWidget {
  const AccSubscriptionDetails({super.key});

  @override
  State<AccSubscriptionDetails> createState() => _AccSubscriptionDetailsState();
}

class _AccSubscriptionDetailsState extends State<AccSubscriptionDetails> {
  final accSubController = Get.find<AccSubscriptionController>();
  final subController = Get.find<SubscriptionController>();
  final voucherController = Get.find<VoucherController>();
  final loader = Get.find<AppLoaderController>();
  final remarksController = TextEditingController();
  final txnController = TextEditingController();
  bool showDetails = false;

  Widget makeSummaryCell(String v) {
    return TextHelper(
      text: currenyFormater(value: v, withDrCr: false, withCurrency: false),
      fontsize: 11,
      color: getMainStore().theme.value.HeadColor,
      fontweight: FontWeight.w600,
      textalign: TextAlign.center,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        if (accSubController.selectedUser == null) {
          showAlert("No user found!", AlertType.error);
          return;
        }
        VoucherModel? v = await voucherController.getReceiptVoucher();
        if (v != null) {
          accSubController.voucher = v;
          await accSubController.loadPaymentModes(v.paymentMethods);
          await accSubController.loadChargesLedgers();
          // logG(subController.list.firstWhereOrNull((s) => s.id == accSubController.selectedUser!.subscriptionId));
          if (accSubController.selectedUser != null && accSubController.selectedUser!.subscriptions.isNotEmpty) {
            List<GSTDetails> itemsGst = [];
            for (final f in accSubController.selectedUser!.subscriptions) {
              itemsGst.add(
                accSubController.getCalculationDetails(selectedUser: f, service: subController.list.firstWhereOrNull((s) => s.id == f.subscriptionId)!),
              );
            }
            if (itemsGst.isNotEmpty) {
              accSubController.gstDetails = GSTDetails(
                gstPer: itemsGst.first.gstPer,
                withGST: itemsGst.first.withGST,
                totalAmount: itemsGst.map((m) => m.totalAmount).fold(0.0, (a, b) => a + b),
                grossAmount: itemsGst.map((m) => m.grossAmount).fold(0.0, (a, b) => a + b),
                gstAmount: itemsGst.map((m) => m.gstAmount).fold(0.0, (a, b) => a + b),
                netAmount: itemsGst.map((m) => m.netAmount).fold(0.0, (a, b) => a + b),
                discPer: itemsGst.map((m) => m.discPer).fold(0.0, (a, b) => a + b) / itemsGst.length,
                discAmount: itemsGst.map((m) => m.discAmount).fold(0.0, (a, b) => a + b),
                discountWithGST: itemsGst.first.discountWithGST,
              );
              accSubController.update();
            }
          }

          accSubController.update();
        } else {
          showAlert("No voucher found!", AlertType.error);
        }
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    accSubController.amount.clear();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccSubscriptionController>(
      init: accSubController,
      autoRemove: false,
      builder: (accSubController) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(title: Text("Subscription Details")),
            body: Builder(
              builder: (context) {
                final us = accSubController.selectedUser;
                final user = accSubController.selectedUser!.user;
                if (us == null) {
                  return Center(child: Text("No data found!"));
                }
                if (user == null) {
                  return Center(child: Text("No user data found!"));
                }
                final balance = user.balance;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Member :", width: 80, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(text: us.user!.name, fontsize: 12),
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Address :", width: 80, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(text: us.user!.address, fontsize: 12),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 6,
                              children: [
                                TextHelper(text: "Subscription Id :", width: 110, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                                TextHelper(text: us.name, fontsize: 12),
                              ],
                            ),
                            Row(
                              children: [
                                TextHelper(text: "Show Details :", fontweight: FontWeight.w600, fontsize: 12, color: Colors.grey.shade600),
                                Transform.scale(
                                  scale: 0.6,
                                  child: Switch(
                                    value: showDetails,
                                    activeThumbColor: getMainStore().theme.value.HeadColor,
                                    onChanged: (v) => setState(() {
                                      showDetails = v;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   spacing: 1,
                        //   children: [
                        //     TextHelper(text: 'Bill Details', fontsize: 12, fontweight: FontWeight.w600, textalign: TextAlign.left, padding: EdgeInsets.zero),
                        //     Divider(),
                        //     // if (accSubController.voucher != null && accSubController.voucher!.withDiscount)
                        //     //   Row(
                        //     //     spacing: 20,
                        //     //     mainAxisAlignment: MainAxisAlignment.end,
                        //     //     children: [
                        //     //       TextHelper(text: 'Total Amount :', fontsize: 12),
                        //     //       TextHelper(
                        //     //         text: currenyFormater(value: us.totalAmount, withDrCr: false),
                        //     //         width: 150,
                        //     //         fontweight: FontWeight.w600,
                        //     //         fontsize: 12,
                        //     //         color: Colors.grey.shade700,
                        //     //         textalign: TextAlign.right,
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     // if (accSubController.voucher != null && accSubController.voucher!.withDiscount)
                        //     //   Row(
                        //     //     spacing: 20,
                        //     //     mainAxisAlignment: MainAxisAlignment.end,
                        //     //     children: [
                        //     //       TextHelper(text: 'Discount :', fontsize: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                        //     //       TextHelper(
                        //     //         text: currenyFormater(value: us.discAmount, withDrCr: false),
                        //     //         width: 150,
                        //     //         fontweight: FontWeight.w600,
                        //     //         fontsize: 12,
                        //     //         color: getMainStore().theme.value.HeadColor.withAlpha(200),
                        //     //         textalign: TextAlign.right,
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     Row(
                        //       spacing: 20,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         TextHelper(text: 'Gross Amount :', fontsize: 12, width: 95),
                        //         TextHelper(
                        //           text: currenyFormater(value: us.grossAmount, withDrCr: false),
                        //           width: 150,
                        //           fontweight: FontWeight.w600,
                        //           fontsize: 12,
                        //           color: Colors.grey.shade700,
                        //           textalign: TextAlign.right,
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       spacing: 20,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         TextHelper(text: 'Tax Amount :', fontsize: 12, width: 95),
                        //         TextHelper(
                        //           text: currenyFormater(value: us.taxAmount, withDrCr: false),
                        //           width: 150,
                        //           textalign: TextAlign.right,
                        //           fontweight: FontWeight.w600,
                        //           color: Colors.grey.shade700,
                        //           fontsize: 12,
                        //         ),
                        //       ],
                        //     ),
                        //
                        //     Row(
                        //       spacing: 20,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         TextHelper(text: 'Discount :', fontsize: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200), width: 95),
                        //         TextHelper(
                        //           text: currenyFormater(value: us.discAmount, withDrCr: false),
                        //           width: 150,
                        //           fontweight: FontWeight.w600,
                        //           fontsize: 12,
                        //           color: getMainStore().theme.value.HeadColor.withAlpha(200),
                        //           textalign: TextAlign.right,
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       spacing: 20,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         TextHelper(text: 'Net Amount :', fontsize: 12, width: 95),
                        //         TextHelper(
                        //           text: currenyFormater(value: us.netAmount, withDrCr: false),
                        //           width: 150,
                        //           fontsize: 12,
                        //           textalign: TextAlign.right,
                        //           fontweight: FontWeight.w600,
                        //           color: Colors.grey.shade700,
                        //         ),
                        //       ],
                        //     ),
                        //     Divider(),
                        //   ],
                        // ),
                        SizedBox(
                          height: 200,
                          child: Builder(
                            builder: (context) {
                              List<Map<String, dynamic>> list = accSubController.selectedUser!.subscriptions
                                  .map((m) => {...m.toJSON(), "taxableAmount": m.netAmount + m.discAmount})
                                  .toList();
                              return DataGridHelper3(
                                dataSource: list,
                                headerColor: Colors.blueGrey.shade50.withAlpha(70),
                                rowHeight: 50,
                                showAlternateColor: false,
                                showBorderVertical: true,
                                columnFixCount: ((MediaQuery.sizeOf(context).width * 0.4) + 400) < Get.width
                                    ? 0
                                    : showDetails
                                    ? 1
                                    : 0,
                                fontSize: 10.5,
                                headerFontColor: Colors.blueGrey.shade400,
                                showFooter: true,
                                columnList: [
                                  DataGridColumnModel3(
                                    dataField: "name",
                                    dataType: CellDataType3.string,
                                    width: ((MediaQuery.sizeOf(context).width * 0.4) + 400) < Get.width ? null : MediaQuery.sizeOf(context).width * 0.4,
                                    title: "Service",
                                    withSummery: false,
                                    summeryType: SummeryType3.count,
                                    customCell: (c) {
                                      return Column(
                                        children: [
                                          TextHelper(
                                            text: subController.list.firstWhereOrNull((s) => s.id == c.rowValue['subscriptionId'])?.name ?? "",
                                            fontsize: 11,
                                            isWrap: true,
                                            fontweight: FontWeight.w600,
                                          ),
                                          TextHelper(
                                            text:
                                                '${parseDateToString(data: c.rowValue['startDate'], formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: "")}  -  ${parseDateToString(data: c.rowValue['endDate'], formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: "")}',
                                            fontsize: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  if (showDetails)
                                    DataGridColumnModel3(
                                      dataField: "taxableAmount",
                                      title: "Amount",
                                      dataType: CellDataType3.int,
                                      withSummery: true,
                                      summeryType: SummeryType3.sum,
                                      width: 80,
                                      customCell: (c) {
                                        return TextHelper(
                                          text: currenyFormater(
                                            value: parseDouble(data: c.rowValue['netAmount']) + parseDouble(data: c.rowValue['discAmount']),
                                            withDrCr: false,
                                          ),
                                          fontsize: 11,
                                          textalign: TextAlign.center,
                                        );
                                      },
                                      customSummaryCell: makeSummaryCell,
                                    ),
                                  if (showDetails)
                                    DataGridColumnModel3(
                                      dataField: "discAmount",
                                      width: 70,
                                      title: "Disc Amt",
                                      summeryType: SummeryType3.sum,
                                      withSummery: true,
                                      customSummaryCell: makeSummaryCell,
                                      dataType: CellDataType3.int,

                                      customCell: (c) {
                                        return TextHelper(
                                          text: currenyFormater(value: c.rowValue['discAmount'], withDrCr: false),
                                          fontsize: 11,
                                          textalign: TextAlign.center,
                                          color: getMainStore().theme.value.HeadColor,
                                        );
                                      },
                                    ),
                                  DataGridColumnModel3(
                                    dataField: "amount",
                                    width: 80,
                                    title: "Bill Amt",
                                    summeryType: SummeryType3.sum,
                                    withSummery: true,
                                    dataType: CellDataType3.int,
                                    customSummaryCell: makeSummaryCell,
                                    customCell: (c) {
                                      return TextHelper(
                                        text: currenyFormater(value: c.rowValue['netAmount'], withDrCr: false),
                                        fontsize: 11,
                                        textalign: TextAlign.center,
                                      );
                                    },
                                  ),
                                  DataGridColumnModel3(
                                    dataField: "paidAmount",
                                    width: 80,
                                    title: "Paid Amt",
                                    summeryType: SummeryType3.sum,
                                    withSummery: true,
                                    dataType: CellDataType3.int,
                                    textAlign: CellTextAlignment3.center,
                                    customSummaryCell: makeSummaryCell,
                                    customCell: (c) {
                                      return TextHelper(
                                        text: currenyFormater(value: c.rowValue['paidAmount'], withDrCr: false),
                                        fontsize: 11,
                                        textalign: TextAlign.center,
                                      );
                                    },
                                  ),
                                  DataGridColumnModel3(
                                    dataField: "dueAmount",
                                    width: 80,
                                    title: "Due Amt",
                                    withSummery: true,
                                    customSummaryCell: (String v) {
                                      return TextHelper(
                                        text: currenyFormater(value: v, withDrCr: false, withCurrency: false),
                                        fontsize: 11,
                                        color: Colors.deepOrangeAccent.shade700,
                                        fontweight: FontWeight.w600,
                                        textalign: TextAlign.center,
                                      );
                                    },
                                    summeryType: SummeryType3.sum,
                                    dataType: CellDataType3.int,
                                    customCell: (c) {
                                      return TextHelper(
                                        text: currenyFormater(value: c.rowValue['dueAmount'], withDrCr: false),
                                        fontsize: 11,
                                        color: Colors.deepOrangeAccent.shade700,
                                        textalign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ],
                                uniqueKey: "items",
                                width: MediaQuery.sizeOf(context).width * 0.98,
                              );
                            },
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   spacing: 6,
                        //   children: [
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       spacing: 6,
                        //       children: [
                        //         TextHelper(text: "Service :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //         TextHelper(text: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.name ?? "", fontsize: 12),
                        //       ],
                        //     ),
                        //
                        //     Container(
                        //       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        //       decoration: BoxDecoration(color: getMainStore().theme.value.lowShadeColor),
                        //       child: TextHelper(text: us.isActive ? "Active" : "Not Active", color: getMainStore().theme.value.HeadColor, fontsize: 11),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   spacing: 6,
                        //   children: [
                        //     TextHelper(text: "Per session :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //     TextHelper(
                        //       text: currenyFormater(
                        //         value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.amount.toString(),
                        //         withDrCr: false,
                        //       ),
                        //       fontsize: 12,
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   spacing: 6,
                        //   children: [
                        //     TextHelper(text: "Full Package :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //     TextHelper(
                        //       text: currenyFormater(
                        //         value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.totalAmount.toString(),
                        //         withDrCr: false,
                        //       ),
                        //       fontsize: 12,
                        //     ),
                        //   ],
                        // ),
                        //
                        // Row(
                        //   spacing: 0,
                        //   children: [
                        //     Row(
                        //       spacing: 6,
                        //       children: [
                        //         TextHelper(text: "Booking Type :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //         TextHelper(
                        //           text: parseString(data: us.isFullPackage ? "Package" : "Custom", defaultValue: '0'),
                        //           fontsize: 12,
                        //           width: 96,
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       spacing: 6,
                        //       children: [
                        //         TextHelper(text: "Session Count :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //         TextHelper(
                        //           text: parseString(data: us.totalSessions, defaultValue: '0'),
                        //           fontsize: 12,
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   spacing: 30,
                        //   children: [
                        //     Row(
                        //       spacing: 6,
                        //       children: [
                        //         TextHelper(text: "Start Date :", width: 95, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //         TextHelper(
                        //           text: parseDateToString(data: us.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                        //           fontsize: 12,
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       spacing: 6,
                        //       children: [
                        //         TextHelper(text: "End Date :", width: 65, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                        //         TextHelper(
                        //           text: parseDateToString(data: us.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                        //           fontsize: 12,
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        if (balance > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 6,
                            children: [
                              TextHelper(text: "Advance :", fontsize: 12, width: 85, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                              TextHelper(
                                text: currenyFormater(value: balance, withDrCr: false),
                                fontsize: 12,
                                width: 80,
                                fontweight: FontWeight.w600,
                                color: Colors.blue.shade600,
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 6,
                          children: [
                            TextHelper(text: "Due Amount :", fontsize: 12, width: 85, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(
                              text: currenyFormater(value: us.dueAmount, withDrCr: false),
                              fontsize: 12,
                              // width: 80,
                              fontweight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              decoration: balance > 0 ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                            if (balance > 0)
                              TextHelper(
                                text: currenyFormater(value: us.dueAmount - balance < 0 ? 0 : us.dueAmount - balance, withDrCr: false),
                                fontsize: 12,
                                textalign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                color: Colors.blue.shade600,
                              ),
                          ],
                        ),
                        if (us.dueAmount - balance > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 6,
                            children: [
                              TextHelper(text: "Payment :", fontsize: 12, width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                              SizedBox(
                                width: 115,
                                child: DropDownHelperG(
                                  height: 35,
                                  showBorder: true,
                                  leading: SizedBox.shrink(),
                                  labelText: "Method",
                                  placeHolder: "Select....",
                                  // showLabelAlways: true,
                                  trailing: Icon(Icons.arrow_drop_down, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                                  fontSize: 11.8,
                                  rowHeight: 30,
                                  showClearText: false,
                                  uniqueKey: UniqueKey().toString(),
                                  value: accSubController.selectedPaymentMode?.toJSON() ?? {},
                                  onValueChange: (v) {
                                    accSubController.selectedPaymentMode = accSubController.paymentModes.firstWhereOrNull((f) => f.id == (v['id'] ?? ''));
                                    accSubController.update();
                                  },
                                  items: accSubController.paymentModes.map((m) => m.toJSON()).toList(),
                                ),
                              ),
                            ],
                          ),
                        if (us.dueAmount - balance > 0)
                          if (accSubController.selectedPaymentMode != null && accSubController.selectedPaymentMode!.base != 'cash')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 6,
                              children: [
                                TextHelper(text: "Txn No. :", fontsize: 12, width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                                SizedBox(width: 215, child: TextBox(controller: txnController, height: 35, withBorder: true, fontSize: 11.8)),
                              ],
                            ),
                        if (us.dueAmount - balance > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 6,
                            children: [
                              TextHelper(text: "Paid :", fontsize: 12, width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: TextBox(
                                      controller: accSubController.amount,
                                      height: 35,
                                      width: 120,
                                      showAlwaysLabel: true,
                                      labelText: 'Total ',
                                      withBorder: true,
                                      backgroundColor: getMainStore().theme.value.lowShadeColor,
                                      fontSize: 13,
                                      onValueChange: (v) {
                                        double amount = parseDouble(data: v, defaultValue: 0);
                                        // if (amount > us.netAmount) {
                                        //   showAlert("Paid amount is greater than total amount", AlertType.error);
                                        //   accSubController.amount.clear();
                                        // }
                                      },
                                      leading: Icon(FontAwesomeIcons.indianRupeeSign, size: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                                    ),
                                  ),
                                  ButtonHelperG(
                                    onTap: () {
                                      accSubController.amount.text = (us.dueAmount).toStringAsFixed(2);
                                      // accSubController.amount.text = (us.dueAmount - balance < 0 ? 0 : us.dueAmount - balance).toStringAsFixed(2);
                                    },
                                    width: 80,
                                    height: 30,
                                    background: getMainStore().theme.value.mediumShadeColor,
                                    label: TextHelper(text: 'Full Paid', fontweight: FontWeight.w600, fontsize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (us.dueAmount - balance < 0) SizedBox(height: 10),
                        TextAreaBox(
                          height: 40,
                          labelText: 'Remarks  ',
                          showAlwaysLabel: true,
                          borderRadius: BorderRadius.circular(10),
                          controller: remarksController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  // final s = subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId);
                                  // if (s == null) {
                                  //   showAlert("No subscription found!", AlertType.error);
                                  //   return;
                                  // }
                                  loader.startLoading();
                                  await accSubController.makePaid(
                                    selectedUser: us,
                                    // service: s,
                                    txnValue: txnController.text,
                                    remarks: remarksController.text.trim(),
                                  );
                                  accSubController.selectedPaymentMode = null;
                                  showAlert("Success", AlertType.success);
                                  goBack(context);
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              width: 80,
                              label: TextHelper(text: "Paid", color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
