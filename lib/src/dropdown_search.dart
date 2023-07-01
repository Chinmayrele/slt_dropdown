import 'package:flutter/material.dart';

class DropdownSearch extends StatefulWidget {
  final TextEditingController? textController;
  final String? hintText;
  final List<String>? items;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? dropdownTextStyle;
  final IconData? suffixIcon;
  final double? dropdownHeight;
  final Color? dropdownBgColor;
  final InputBorder? textFieldBorder;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String itemsList) itemsList;

  const DropdownSearch({
    super.key,
    required this.textController,
    this.hintText,
    required this.items,
    this.hintStyle,
    this.style,
    this.dropdownTextStyle,
    this.suffixIcon,
    this.dropdownHeight,
    this.dropdownBgColor,
    this.textFieldBorder,
    this.contentPadding,
    required this.itemsList,
  });

  @override
  State<DropdownSearch> createState() => _DropdownSearchState();
}

class _DropdownSearchState extends State<DropdownSearch> {
  bool _isTapped = false;
  List<String> _filteredList = [];
  List<String> _mainList = [];

  @override
  initState() {
    _filteredList = widget.items!;
    _mainList = _filteredList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Text Field
        TextFormField(
          controller: widget.textController,
          onChanged: (val) {
            setState(() {
              _filteredList = _mainList
                  .where((element) => element
                      .toLowerCase()
                      .startsWith(widget.textController!.text.toLowerCase()))
                  .toList();
              // _filteredList.isEmpty ?  : null;
            });
          },
          validator: (val) => val!.isEmpty ? 'Field can\'t empty' : null,
          style: widget.style ??
              TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
          onTap: () => setState(() => _isTapped = true),
          decoration: InputDecoration(
              border: widget.textFieldBorder ?? const UnderlineInputBorder(),
              hintText: widget.hintText ?? "Write here...",
              hintStyle: widget.hintStyle ??
                  const TextStyle(fontSize: 16.0, color: Colors.grey),
              suffixIcon:
                  Icon(widget.suffixIcon ?? Icons.arrow_drop_down, size: 25),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              isDense: true,
              suffixIconConstraints:
                  BoxConstraints.loose(MediaQuery.of(context).size),
              suffix: InkWell(
                  onTap: () {
                    widget.textController!.clear();
                    _isTapped = true;
                    // setState(() {});
                    setState(() {
                      _filteredList = widget.items!;
                    });
                  },
                  child: const Icon(Icons.clear, color: Colors.grey))),
        ),

        ///Dropdown Items
        _isTapped && _filteredList.isNotEmpty
            ? Container(
                height: widget.dropdownHeight ?? 150.0,
                color: widget.dropdownBgColor ?? Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemCount: _filteredList.length + 1,
                  itemBuilder: (context, index) {
                    int pos = 1;
                    if (_filteredList.first == widget.textController!.text) {
                      pos = 0;
                    }
                    if (pos == 0 && index == _filteredList.length ) {
                      return Container();
                    }
                    debugPrint("Value : $_filteredList");
                    if (index == 0 &&
                        !_filteredList.contains(widget.textController!.text)) {
                      return InkWell(
                        onTap: () {
                          _filteredList.add(widget.textController!.text);
                          // _mainList.add(widget.textController!.text);
                          // widget.items!.add(widget.textController!.text);
                          widget.itemsList(widget.textController!.text);
                          setState(() => _isTapped = !_isTapped);
                        },
                        child: widget.textController!.text.isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                    "Create \"${widget.textController!.text}\"",
                                    style: widget.dropdownTextStyle ??
                                        TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 16.0)),
                              ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          setState(() => _isTapped = !_isTapped);
                          widget.textController!.text =
                              _filteredList[index - pos];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(_filteredList[index - pos],
                              style: widget.dropdownTextStyle ??
                                  TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16.0)),
                        ),
                      );
                    }
                  },
                ),
              )
            : _isTapped
                ? Container(
                    height: widget.dropdownHeight ?? 50.0,
                    color: widget.dropdownBgColor ?? Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // widget.textController!.text = _filteredList[index];
                            _filteredList.add(widget.textController!.text);
                            // widget.items!.add(widget.textController!.text);
                            widget.itemsList(widget.textController!.text);
                            setState(() => _isTapped = !_isTapped);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                "Create \"${widget.textController!.text}\"",
                                style: widget.dropdownTextStyle ??
                                    TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 16.0)),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox()
      ],
    );
  }
}
