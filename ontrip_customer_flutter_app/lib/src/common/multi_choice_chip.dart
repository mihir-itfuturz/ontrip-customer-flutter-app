import '../../app_export.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip(this.reportList, {super.key, required this.onSelectionChanged});

  @override
  MultiSelectChipState createState() => MultiSelectChipState();
}

class MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.reportList) {
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            labelStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontFamily: "Product Sans"),
            backgroundColor: Colors.black,
            selectedColor: Colors.green,
            shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              setState(() {
                selectedChoices.contains(item) ? selectedChoices.remove(item) : selectedChoices.add(item);
                widget.onSelectionChanged(selectedChoices);
              });
            },
          ),
        ),
      );
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: _buildChoiceList());
  }
}
