import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
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
          donateViewModel!.getTotal(donateController!);
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
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppAppBar(
              title: AppText(
            'Wallet',
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          )),
          body: buildBody(controller, context),
        );
      },
    );
  }

  buildBody(DonateController controller, context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 180.px,
                  decoration: BoxDecoration(
                      color: AppColorConstant.appYellow,
                      borderRadius: BorderRadius.circular(10.px)),
                  child: Padding(
                    padding: EdgeInsets.all(22.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          'Signal App',
                          fontSize: 25,
                          color: AppColorConstant.appWhite,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 20.px),
                        const AppText(
                          'Total Balance',
                          color: AppColorConstant.appWhite,
                        ),
                        SizedBox(height: 2.px),
                         AppText(
                           '₹ ${donateViewModel!.totalHistoryAmount.toStringAsFixed(2) ?? '0.00'}',
                          color: AppColorConstant.appWhite,
                          fontSize: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 10.px,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: AppColorConstant.grey,
              thickness: 1,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: AppText('Transaction',fontSize: 20),
          ),
          Expanded(
            child: FutureBuilder<List<TransactionsModel>>(
              future: UsersService.instance.getTransactionHistory(),
              builder:
                  (context, AsyncSnapshot<List<TransactionsModel>> snapshot) {
                if (snapshot.hasError) {
                  return AppText(
                    '${snapshot.error}',
                    color: Theme.of(context).colorScheme.primary,
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data != null &&
                      (snapshot.data?.isNotEmpty ?? false)) {
                    snapshot.data!
                        .sort((a, b) => b.time!.compareTo(a.time.toString()));
                    return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          TransactionsModel transaction = snapshot.data![index];
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
                                title: AppText(
                                  snapshot.data?[index].paymentId ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                subtitle: Text(
                                    snapshot.data?[index].status ?? '',
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
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              color: AppColorConstant.grey,
                              thickness: 1,
                            ),
                          );
                        },
                        itemCount: snapshot.data?.length ?? 0);
                  }
                }
                return Container();
              },
            ),
          ),
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
