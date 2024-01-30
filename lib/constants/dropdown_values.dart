class DropDownValues {
  final String name;
  final dynamic value;
  final dynamic subValue;

  DropDownValues({required this.name, required this.value, this.subValue});
}

List<DropDownValues> userAccountTypes = [
  DropDownValues(name: "Single Account", value: 1),
  DropDownValues(name: "Joint Account", value: 2)
];
