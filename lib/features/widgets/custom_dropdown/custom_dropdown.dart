// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../core/utils/consts/app_sizes.dart';
import '../custom_elevatedButton/custom_text.dart';
import 'dropdown_model.dart';

// class CustomSearchDropdown extends StatelessWidget {
//   final String? fieldTitle, hint;
//   final DropdownModel? selectedItem;
//   final List<DropdownModel> spinnerItemList;
//   final Color? dropdownColor;
//   final Color? titleColor, valueTextColor;
//   final bool? isEnable;
//   final double? manuMaxHeight, titleFontSize;
//   final void Function(DropdownModel) onChanged;
//   const CustomSearchDropdown({Key? key,
//     this.fieldTitle,
//     required this.spinnerItemList,
//     required this.onChanged,
//     this.selectedItem,
//     this.dropdownColor,
//     this.hint,
//     this.titleColor,
//     this.manuMaxHeight,
//     this.isEnable,
//     this.titleFontSize,
//     this.valueTextColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<DropdownModel>(
//       // popupProps: PopupProps.menu(
//       //   showSelectedItems: true,
//       //   // disabledItemFn: (String s) => s.startsWith('I'),
//       // ),
//       items: spinnerItemList,
//       dropdownDecoratorProps: DropDownDecoratorProps(
//         dropdownSearchDecoration: InputDecoration(
//           labelText: fieldTitle,
//           hintText: hint,
//         ),
//       ),
//       onChanged: print,
//       selectedItem: selectedItem,
//     );
//   }
// }

class CustomDropDown extends StatelessWidget {
  final String? fieldTitle, hint;
  final DropdownModel? selectedItem;
  final List<DropdownModel> spinnerItemList;
  final Color? dropdownColor;
  final Color? titleColor, valueTextColor;
  final bool? isEnable;
  final double? manuMaxHeight, titleFontSize, selectedTextSize;
  final void Function(DropdownModel) onChanged;

  const CustomDropDown(
      {Key? key,
      this.fieldTitle,
      required this.spinnerItemList,
      required this.onChanged,
      this.selectedItem,
      this.dropdownColor,
      this.hint,
      this.titleColor,
      this.manuMaxHeight,
      this.isEnable,
      this.titleFontSize,
      this.valueTextColor,
      this.selectedTextSize,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (fieldTitle?.isNotEmpty ?? false)
            ? FieldTitleText(
                text: fieldTitle!,
                color: titleColor,
                fontSize: titleFontSize,
              )
            : SizedBox.shrink(),
        (fieldTitle?.isNotEmpty ?? false)
            ? const SizedBox(
                height: 3,
              )
            : SizedBox.shrink(),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                  // color: Colors.grey.withOpacity(0.1),
                  border: Border.all(
                    width: 0.6,
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: DropdownButton<DropdownModel>(
                    dropdownColor: dropdownColor ?? HexColor("#F8F8F8"),
                    borderRadius: BorderRadius.circular(10),
                    hint: Text(
                      "$hint",
                      style: TextStyle(
                        fontSize: AppSizes.size12,
                        color: Colors.black,
                      ),
                    ),
                    value: selectedItem,
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: const SizedBox(),
                    isExpanded: true,
                    autofocus: false,
                    focusColor: Colors.transparent,
                    elevation: 0,
                    menuMaxHeight: manuMaxHeight,
                    style:  TextStyle(color: Colors.red, fontSize: AppSizes.size17),
                    onChanged: isEnable == false
                        ? null
                        : (newValue) {
                            onChanged(newValue!);
                          },
                    items: spinnerItemList.map<DropdownMenuItem<DropdownModel>>(
                        (DropdownModel value) {
                      return DropdownMenuItem<DropdownModel>(
                        key: UniqueKey(), // Set a unique key here
                        value: value,
                        child: CustomSimpleText(
                          text: value.name,
                          color: valueTextColor ?? Colors.black,
                          textAlignment: TextAlign.start,
                          fontSize: selectedTextSize ?? AppSizes.size17,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomDropDownForThreeData extends StatelessWidget {
  final String? fieldTitle, hint;
  final DropdownModelForTwoValue? selectedItem;
  final List<DropdownModelForTwoValue> spinnerItemList;
  final Color? dropdownColor;
  final Color? titleColor, valueTextColor;
  final bool? isEnable;
  final double? manuMaxHeight, titleFontSize;
  final FontWeight? fontWeight;
  final void Function(DropdownModelForTwoValue) onChanged;

  const CustomDropDownForThreeData(
      {Key? key,
      this.fieldTitle,
      required this.spinnerItemList,
      required this.onChanged,
      this.selectedItem,
      this.dropdownColor,
      this.hint,
      this.titleColor,
      this.manuMaxHeight,
      this.isEnable,
      this.titleFontSize,
      this.fontWeight,
      this.valueTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldTitle != null
            ? FieldTitleText(
                text: fieldTitle!,
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: fontWeight ?? FontWeight.normal,
              )
            : SizedBox(),
        fieldTitle != null
            ? const SizedBox(
                height: 3,
              )
            : SizedBox(),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.1),
                  // border: Border.all(
                  //   width: 0.6,
                  //   color: Colors.grey.withOpacity(0.4),
                  // ),
                ),
                child: DropdownButton<DropdownModelForTwoValue>(
                  dropdownColor: dropdownColor ?? Colors.white,
                  hint: Text(
                    "$hint",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  value: selectedItem,

                  icon: SizedBox.shrink(),
                  underline: const SizedBox(),
                  isExpanded: true,
                  // Hide default dropdown icon
                  elevation: 16,
                  menuMaxHeight: manuMaxHeight,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  onChanged: isEnable == false
                      ? null
                      : (newValue) {
                          onChanged(newValue!);
                        },
                  items: spinnerItemList
                      .map<DropdownMenuItem<DropdownModelForTwoValue>>(
                          (DropdownModelForTwoValue value) {
                    return DropdownMenuItem<DropdownModelForTwoValue>(
                      key: UniqueKey(), // Set a unique key here
                      value: value,
                      child: Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(100),
                          //   child: CachedNetworkImage(
                          //     imageUrl: "http://erp.superhomebd.com/super_home/${value.name1}",
                          //     width: 30,
                          //     height: 30,
                          //     fit: BoxFit.fill,
                          //     placeholder: (context, url) =>
                          //     const CircularProgressIndicator(),
                          //     errorWidget: (context, url, error) =>
                          //     Image.asset("assets/images/app_logo.png", width: 30,
                          //       height: 30,
                          //       fit: BoxFit.fill,),
                          //   ),
                          // ),
                          // const SizedBox(width: 10,),
                          Expanded(
                            child: CustomSimpleText(
                              text: value.name,
                              color: valueTextColor ?? Colors.black,
                              textAlignment: TextAlign.start,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
