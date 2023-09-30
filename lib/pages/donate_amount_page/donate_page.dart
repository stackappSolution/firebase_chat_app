import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/donate_controller.dart';
import 'package:signal/modal/transaction_model.dart';
import 'package:signal/pages/donate_amount_page/donate_view_model.dart';
import 'package:signal/service/users_service.dart';

class DonatePage extends StatelessWidget {
  DonatePage({super.key});

  DonateViewModel? donateViewModel;

  DonateController? donateController;

  @override
  Widget build(BuildContext context) {
    donateViewModel ?? (donateViewModel = DonateViewModel(this));
    return GetBuilder(
      init: DonateController(),
      initState: (state) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          donateController = Get.find<DonateController>();
        });
        donateViewModel!.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            donateViewModel!.handlePaymentSuccess);
        donateViewModel!.razorpay.on(
            Razorpay.EVENT_PAYMENT_ERROR, donateViewModel!.handlePaymentError);
        donateViewModel!.razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
            donateViewModel!.handleExternalWallet);
      },
      dispose: (state) {
        donateViewModel!.razorpay.clear();
      },
      builder: (DonateController controller) {
        return Scaffold(
          appBar: const AppAppBar(
              title: AppText(
            'Payent to chat App',
            fontSize: 20,
          )),
          body: buildBody(controller),
        );
      },
    );
  }

  buildBody(DonateController controller) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.px),
                      child: AppTextFormField(
                        controller: donateViewModel!.amountController,
                        hintText: StringConstant.enteramount,
                        style: TextStyle(
                          fontSize: 22.px,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.number,
                        fontSize: 20.px,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.px,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.px),
            child: AppElevatedButton(
              onPressed: () async {
                donateViewModel!.amountController.text;
                controller.update();
                donateViewModel!
                    .startPayment(donateViewModel!.amountController.text);
                donateViewModel!.amountController.clear();
                await UsersService.instance.getTransactionHistory();
              },
              buttonColor: AppColorConstant.appYellowBorder,
              buttonHeight: 50,
              widget: const AppText(StringConstant.payment,
                  color: AppColorConstant.appWhite, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10.px,
          ),
          Expanded(
              child: FutureBuilder<List<TransactionsModel>>(
                future: UsersService.instance.getTransactionHistory(),
                builder:
                    (context, AsyncSnapshot<List<TransactionsModel>> snapshot) {
                  if (snapshot.hasError) {
                    return AppText('${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data != null &&
                        (snapshot.data?.isNotEmpty ?? false)) {
                      donateViewModel!.totalHistoryAmount = (snapshot.data!
                          .map((transaction) => transaction.amount ?? 0)
                          .reduce((sum, amount) => sum + amount))
                          .toDouble(); // Convert the result to a double

                      logs('total Amount-->${donateViewModel!.totalHistoryAmount}');
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemBuilder: (context, index) {
                            TransactionsModel transaction =
                                snapshot.data![index];
                            Color textColor = snapshot.data![index].status ==
                                    'Payment Successful'
                                ? Colors.green
                                : Colors.red;
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    createPDF(transaction);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text(snapshot.data?[index].paymentId ?? '',
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: Text(snapshot.data?[index].status ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: textColor)),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.end,
                                          '₹ ${(snapshot.data?[index].amount ?? 0).toString()}',
                                          style: TextStyle(
                                              fontSize: 15, color: textColor),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data?[index].time ?? '',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: AppColorConstant.grey,
                              thickness: 1,
                            );
                          },
                          itemCount: snapshot.data?.length ?? 0);
                    }
                  }
                  return Container();
                },
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: AppColorConstant.appYellowBorder,
              title: const AppText(
                'Total Amount  :',
                fontSize: 20,
                color: AppColorConstant.appWhite,
              ),
              trailing:  AppText('₹ ${donateViewModel!.totalHistoryAmount.toInt()}',
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20, color: AppColorConstant.appWhite),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),),
            ),
          )
        ]);
  }

  Future<void> createPDF(TransactionsModel selectedTransaction) async {
    final pdf = pw.Document();

    final tableheaders = ['Payment ID', 'Status', 'Amount', 'Date and Time'];
    final data = <List<String>>[
      [
        selectedTransaction.paymentId ?? '',
        selectedTransaction.status ?? '',
        (selectedTransaction.amount?.toStringAsFixed(2)) ?? '',
        selectedTransaction.time ?? '',
      ]
    ];
    const baseColor = PdfColors.green;
    const othercolor = PdfColors.black;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final table = pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(),
            headers: tableheaders,
            data: <List<String>>[...data],
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: baseColor,
            ),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: othercolor, width: .5),
                right: pw.BorderSide(color: othercolor, width: .5),
                bottom: pw.BorderSide(
                  color: baseColor,
                  width: .5,
                ),
              ),
            ),
            cellAlignment: pw.Alignment.centerRight,
            cellAlignments: {0: pw.Alignment.centerLeft},
          );
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text("Transaction Details",
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              table,
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${selectedTransaction.paymentId}.pdf';

    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(path);
  }
}
