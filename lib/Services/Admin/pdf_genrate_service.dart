import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:universal_html/html.dart' as html;

import 'package:medical_servey_app/models/common/pdf_model.dart';

class PdfInvoiceApi {
// *************************** generate Patient PDF **********************//

  static Future<void> generatePatientData(PdfModel patient) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(10),
        header: (context) => buildPatientTitle(),
        build: (context) => [
          Divider(),
          buildPatientTable(patient),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    PdfApi.saveDocument(name: 'my_patient_data.pdf', pdf: pdf);
  }

  static Widget buildPatientTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildPatientTable(PdfModel pdf) {
    final headers = [
      'Id',
      'Name',
      'Profession',
      'Email',
      'MobileNumber',
      'Address',
      'Gender',
      'Date',
      'Diseases',
      'OtherDisease',
      'Age',
      'Village'
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
      headerHeight: 20,
      data: data,
      //border: null,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.blueGrey400,
      ),
      cellHeight: 20,
      defaultColumnWidth: const IntrinsicColumnWidth(flex: 10),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.blueGrey900,
        fontSize: 6,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.blueGrey900,
            width: .5,
          ),
        ),
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
    );
  }

  // *************************** generate Surveyor PDF **********************//

  static Future<void> generateSurveyorData(PdfModel surveyor) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(10),
        header: (context) => buildSurveyorTitle(),
        build: (context) => [
          Divider(),
          buildSurveyorTable(surveyor),
        ],
      ),
    );

    PdfApi.saveDocument(name: 'my_surveyor_data.pdf', pdf: pdf);
  }

  static Widget buildSurveyorTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Surveyor Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildSurveyorTable(PdfModel pdf) {
    final headers = [
      'Name',
      'Profession',
      'Email',
      'MobileNumber',
      'Address',
      'Gender',
      'JoiningDate',
      'District',
      'Taluka',
      'Age',
      'Assign village',
      'AadhaarNumber'
    ];

    final data = pdf.surveyorLst!.map((item) {
      return [
        "${item.firstName} ${item.middleName} ${item.lastName}",
        item.profession,
        item.email,
        item.mobileNumber,
        item.address,
        item.gender,
        item.joiningDate,
        item.district,
        item.taluka,
        item.age,
        item.village,
        item.aadhaarNumber,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      headerHeight: 20,
      data: data,
      // border: null,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.blueGrey400,
      ),
      cellHeight: 20,
      defaultColumnWidth: const IntrinsicColumnWidth(flex: 10),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.blueGrey900,
        fontSize: 6,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.blueGrey900,
            width: .5,
          ),
        ),
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
    );
  }

  // *************************** generate Report PDF **********************//

  static Future<void> generateReportData(PdfModel report) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(10),
        header: (context) => buildReportTitle(),
        build: (context) => [
          Divider(),
          buildReportTable(report),
        ],
      ),
    );

    PdfApi.saveDocument(name: 'my_report_data.pdf', pdf: pdf);
  }

  static Widget buildReportTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildReportTable(PdfModel pdf) {
    final headers = [
      'Disease Name',
      'Disease Percentage',
    ];
    print("pdf : ${pdf.reportLst}");
    final data = pdf.reportLst!.keys.map((e) => []).toList();

    return Table.fromTextArray(
      headers: headers,
      headerHeight: 20,
      data: data,
      // border: null,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.blueGrey400,
      ),
      cellHeight: 20,
      defaultColumnWidth: const IntrinsicColumnWidth(flex: 10),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.blueGrey900,
        fontSize: 6,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.blueGrey900,
            width: .5,
          ),
        ),
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
    );
  }
}

class PdfApi {
  static Future<void> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$name';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
