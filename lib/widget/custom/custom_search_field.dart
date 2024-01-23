import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/debouncer_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_icon_button.dart';

class CustomSearchField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onClearText;
  final GestureTapCallback? onSearchTap;
  final bool enabled;
  final int milliseconds;
  final Color iconColor;
  final Color textColor;
  final String? hint;

  const CustomSearchField({
    super.key,
    this.onChanged,
    this.onFieldSubmitted,
    this.onClearText,
    this.onSearchTap,
    this.enabled = true,
    this.iconColor = ColorResources.text,
    this.textColor = ColorResources.text,
    this.milliseconds = 500,
    this.hint,
  });

  @override
  CustomSearchFieldState createState() => CustomSearchFieldState();
}

class CustomSearchFieldState extends State<CustomSearchField> {
  final TextEditingController _searchController = TextEditingController();

  late Debouncer _debouncer;
  late bool _enabled;

  String? _searchPhrase;

  void _onChanged(String value) {
    _searchPhrase = value;
    if (widget.onChanged != null) {
      _debouncer.run(() => widget.onChanged!(value));
    }
    if (mounted) setState(() {});
  }

  void clearText() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    _onChanged("");
  }

  String get text => _searchController.text;

  void setEnabled(bool enabled) {
    if (_enabled != enabled) setState(() => _enabled = enabled);
  }

  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
    _debouncer = Debouncer(milliseconds: widget.milliseconds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.cardRadiusLarge)),
        // color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Dimens.paddingWidget),
            child: CustomIconButton(
              onPressed: widget.onSearchTap,
              icon: Icon(Icons.search, size: Dimens.iconSize, color: widget.iconColor),
              tooltip: "Cari",
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _searchController,
              autofocus: false,
              autocorrect: false,
              textInputAction: TextInputAction.search,
              // textAlignVertical: TextAlignVertical.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: widget.textColor),
              maxLines: 1,
              readOnly: !widget.enabled,
              onChanged: _onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                hintText: widget.hint ?? "Cari",
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: widget.textColor),
                border: InputBorder.none,
              ),
            ),
          ),
          !TextUtils.isEmpty(_searchPhrase)
              ? Padding(
                  padding: const EdgeInsets.only(left: Dimens.paddingWidget),
                  child: CustomIconButton(
                    onPressed: widget.onClearText ?? clearText,
                    icon: Icon(Icons.cancel, size: Dimens.iconSize, color: widget.iconColor),
                    tooltip: "Hapus",
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
