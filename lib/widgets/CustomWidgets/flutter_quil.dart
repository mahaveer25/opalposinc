// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:get/get.dart';
// import 'package:opalsystem/utils/constants.dart';
//
// class RichTextEditor extends StatefulWidget {
//   @override
//   _RichTextEditorState createState() => _RichTextEditorState();
// }
//
// class _RichTextEditorState extends State<RichTextEditor> {
//   final quill.QuillController _controller = quill.QuillController.basic();
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//
//       decoration: BoxDecoration(
//         color: Colors.white38,
//         border: Border.all(
//           color: Constant.colorGrey
//         )
//       ),
//       // width: context.width*0.4,
//       child: Column(
//         children: [
//           Container(
//             // decoration: BoxDecoration(
//             //   border: Border.all(
//             //     color: Constant.colorGrey
//             //   )
//             // ),
//             child: quill.QuillSimpleToolbar(
//
//               controller: _controller,
//               configurations: const quill.QuillSimpleToolbarConfigurations(
//                 buttonOptions: quill.QuillSimpleToolbarButtonOptions(
//
//                 )
//               ),
//             ),
//           ),
//           Divider(),
//           // Editor
//           Container(
//             height: 300,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               // color: Constant.colorGrey
//               // border: Border.all(color: Colors.grey.shade300),
//               // borderRadius: BorderRadius.circular(8),
//             ),
//             child: quill.QuillEditor.basic(
//
//               controller: _controller,
//               configurations: const quill.QuillEditorConfigurations(
//
//               ),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
//
