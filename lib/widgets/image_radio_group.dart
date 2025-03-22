// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// const selectedImg = "assets/svgs/radio_button_selected.svg";
// const unSelectedImg = "assets/svgs/radio_button_deselected.svg";

// typedef OnOptionChanged = void Function(String option);

// const double iconSize = 18;
// const double textMinWidth = 50;

// enum TextWidth { minWidth, mediumWidth, maxWidth }

// class ImageRadioGroup extends StatefulWidget {
//   final List<RadioOption> arOptions;
//   final OnOptionChanged onOptionChanged;
//   final String? initialSelection;
//   final TextStyle? textStyle;

//   final TextWidth textWidth;
//   const ImageRadioGroup({
//     super.key,
//     required this.arOptions,
//     required this.onOptionChanged,
//     required this.initialSelection,
//     this.textStyle,
//     this.textWidth = TextWidth.minWidth,
//   });

//   @override
//   State<ImageRadioGroup> createState() => _ImageRadioGroupState();
// }

// class _ImageRadioGroupState extends State<ImageRadioGroup> {
//   late List<Widget> _arRadioOption;
//   late String _selectedId;

//   @override
//   void initState() {
//     _selectedId = widget.arOptions
//         .lastWhere(
//           (element) => element.id == widget.initialSelection,
//           orElse: () => RadioOption(id: "", value: ""),
//         )
//         .id;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _arRadioOption = _organizeWidgets(
//       widget.arOptions,
//     );
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Wrap(
//         spacing: 25,
//         runAlignment: WrapAlignment.start,
//         children: _arRadioOption,
//       ),
//     );
//   }

//   Widget _radioWidget(RadioOption radioOption) => GestureDetector(
//         onTap: () {
//           _selectedId = radioOption.id;
//           widget.onOptionChanged(radioOption.id);
//           setState(() {});
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 20,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SvgPicture.asset(
//                 radioOption.id == _selectedId ? selectedImg : unSelectedImg,
//                 height: iconSize,
//                 width: iconSize,
//               ),
//               const SizedBox(
//                 width: 14,
//               ),
//               Flexible(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minWidth: _radioTextWidth(widget.textWidth),
//                   ),
//                   child: Text(
//                     radioOption.value,
//                     style: widget.textStyle ??
//                         Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );

//   List<Widget> _organizeWidgets(List<RadioOption> options) {
//     List<Widget> widgets = [];
//     for (var i = 0; i < options.length; i++) {
//       widgets.add(_radioWidget(options[i]));
//     }
//     return widgets;
//   }

//   double _radioTextWidth(TextWidth textWidth) {
//     double width = textMinWidth;
//     if (textWidth == TextWidth.mediumWidth) {
//       return 100;
//     } else if (textWidth == TextWidth.maxWidth) {
//       return MediaQuery.of(context).size.width * 75;
//     }

//     return width;
//   }
// }

// class RadioOption {
//   String id;
//   String value;

//   RadioOption({
//     required this.id,
//     required this.value,
//   });
// }
