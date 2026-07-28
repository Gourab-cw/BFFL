import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Payment/controller/payment_controller.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final PaymentController pc = Get.find<PaymentController>();
  final mainStore = Get.find<MainStore>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await pc.getUser();
        await pc.getBranch();
      } catch (e) {
        showAlert('$e', AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: pc,
      autoRemove: false,
      builder: (pc) {
        final item = pc.selectedPayment;
        if (item == null) {
          return Center(child: TextHelper(text: "No Payment Found!"));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Payment Details'),
            actions: [
              ButtonHelperG(
                shadow: [],
                width: 35,
                height: 35,
                background: mainStore.theme.value.BackgroundColor.withAlpha(40),
                onTap: () async {
                  try {
                    Loader.startLoading();
                    await pc.downloadPDF();
                  } catch (e) {
                    showAlert('$e', AlertType.error);
                  } finally {
                    Loader.stopLoading();
                  }
                },
                icon: Icon(FontAwesomeIcons.solidFilePdf),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper(text: 'ID : '),
                          TextHelper(text: item.voucherNumber, fontweight: FontWeight.w600),
                        ],
                      ),
                      Row(children: [TextHelper(text: DateFormat('dd-MM-yyyy hh:mm a').format(item.createdAt.toDate()), fontsize: 12.5)]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper(text: 'Subscription ID : '),
                          TextHelper(text: item.subscriptionId, fontweight: FontWeight.w600),
                        ],
                      ),
                      Row(
                        children: [
                          TextHelper(text: 'Branch : '),
                          TextHelper(text: pc.branch?.name ?? ""),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: Builder(
                      builder: (context) {
                        List<Map<String, dynamic>> list = item.subscriptions?.map((m) => m.toJSON()).toList() ?? [];
                        return DataGridHelper3(
                          dataSource: list,
                          headerColor: Colors.blueGrey.shade50.withAlpha(70),
                          rowHeight: 50,
                          showAlternateColor: false,
                          fontSize: 10.5,
                          headerFontColor: Colors.blueGrey.shade400,
                          columnList: [
                            DataGridColumnModel3(
                              dataField: "name",
                              dataType: CellDataType3.string,
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              title: "Service",
                              customCell: (c) {
                                return Container(
                                  child: Column(
                                    children: [
                                      TextHelper(text: c.rowValue['subscriptionName'] ?? "", fontsize: 11, isWrap: true, fontweight: FontWeight.w600),
                                      TextHelper(
                                        text:
                                            '${parseDateToString(data: c.rowValue['startDate'], formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: "")}  -  ${parseDateToString(data: c.rowValue['endDate'], formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: "")}',
                                        fontsize: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            DataGridColumnModel3(
                              dataField: "dueAmount",
                              title: "Due Amount",
                              dataType: CellDataType3.string,
                              customCell: (c) {
                                return TextHelper(
                                  text: currenyFormater(value: c.rowValue['dueAmount'], withDrCr: false),
                                  fontsize: 11,
                                  textalign: TextAlign.center,
                                );
                              },
                            ),
                            DataGridColumnModel3(
                              dataField: "paidAmount",
                              title: "Paid Amount",

                              dataType: CellDataType3.string,
                              customCell: (c) {
                                return TextHelper(
                                  text: currenyFormater(value: c.rowValue['paidAmount'], withDrCr: false),
                                  fontsize: 11,
                                  textalign: TextAlign.center,
                                );
                              },
                            ),
                          ],
                          uniqueKey: "items",
                          width: MediaQuery.sizeOf(context).width * 0.96,
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'User : '),
                      TextHelper(
                        text: pc.selectedUser == null ? "" : ('${pc.selectedUser?.name ?? ''}  (${pc.selectedUser?.mobile ?? ''})'),
                        fontweight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Paid By : '),
                      TextHelper(text: item.paymentModeName, fontweight: FontWeight.w600),
                    ],
                  ),
                  Container(
                    color: mainStore.theme.value.lowShadeColor,
                    padding: EdgeInsets.all(2),
                    child: Column(
                      children: [
                        TextHelper(text: 'Paid Amount : ', fontsize: 11.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextHelper(
                                    text: currenyFormater(value: item.paidAmount, withDrCr: false),
                                    fontweight: FontWeight.w600,
                                    fontsize: 22,
                                    textalign: TextAlign.right,
                                    color: mainStore.theme.value.HeadColor,
                                  ),
                                  if (parseDouble(data: item.advanceAmount) > 0)
                                    TextHelper(
                                      text: "Advance:  ${currenyFormater(value: item.advanceAmount, withDrCr: false)}",
                                      fontweight: FontWeight.w600,
                                      fontsize: 12,
                                      padding: EdgeInsets.only(right: 5),
                                      textalign: TextAlign.right,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                              Container(
                                color: mainStore.theme.value.BackgroundColor.withAlpha(100),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextHelper(text: 'Remarks: ', fontsize: 11),
                                    TextHelper(text: item.remarks, fontsize: 11, fontweight: FontWeight.w600),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
