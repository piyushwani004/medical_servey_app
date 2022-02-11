import 'dart:io';
import 'package:medical_servey_app/models/common/pdf_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generatePatientData(PdfModel patient) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      
      build: (context) => [
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildPatientTitle(),
        Divider(),
        buildPatientTable(patient),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_patient_data.pdf', pdf: pdf);
  }

  static Widget buildPatientTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildPatientTable(PdfModel pdf) {
    final headers = [
      'id',
      'Name',
      'profession',
      'email',
      'mobileNumber',
      'address',
      'gender',
      'date',
      'diseases',
      'otherDisease',
      'age',
      'village'
    ];

    final data = pdf.patientLst!.map((item) {
      return [
        item.id,
        "${item.firstName} ${item.middleName} ${item.lastName}",
        item.profession,
        item.email,
        item.mobileNumber,
        item.address,
        item.gender,
        item.date,
        item.diseases,
        item.otherDisease,
        item.age,
        item.village,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  // static Future<File> generateSurveyorData(Surveyor surveyor) async {
  //   final pdf = Document();

  //   pdf.addPage(MultiPage(
  //     build: (context) => [
  //       SizedBox(height: 3 * PdfPageFormat.cm),
  //       buildSurveyorTitle(surveyor),
  //       Divider(),
  //       buildSurveyorTable(surveyor),
  //     ],
  //   ));

  //   return PdfApi.saveDocument(name: 'my_surveyor_data.pdf', pdf: pdf);
  // }

  // static Widget buildSurveyorTitle(Surveyor patient) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Patient Data',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 0.8 * PdfPageFormat.cm),
  //       ],
  //     );

  // static Widget buildSurveyorTable(Surveyor surveyor) {
  //   final headers = [
  //     'Description',
  //     'Date',
  //     'Quantity',
  //     'Unit Price',
  //     'VAT',
  //     'Total'
  //   ];

  //   return Table.fromTextArray(
  //     headers: headers,
  //     data: data,
  //     border: null,
  //     headerStyle: TextStyle(fontWeight: FontWeight.bold),
  //     headerDecoration: BoxDecoration(color: PdfColors.grey300),
  //     cellHeight: 30,
  //     cellAlignments: {
  //       0: Alignment.centerLeft,
  //       1: Alignment.centerRight,
  //       2: Alignment.centerRight,
  //       3: Alignment.centerRight,
  //       4: Alignment.centerRight,
  //       5: Alignment.centerRight,
  //     },
  //   );
  // }

  // static Widget buildFooter(Patient invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Address', value: invoice.supplier.address),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //       ],
  //     );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
