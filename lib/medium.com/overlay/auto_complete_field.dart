import 'package:flutter/material.dart';

/**https://juejin.cn/post/6844904115764658189 */
class AutoCompleteField extends StatefulWidget {
  const AutoCompleteField({super.key});

  @override
  State<AutoCompleteField> createState() => _AutoCompleteFieldState();
}

class _AutoCompleteFieldState extends State<AutoCompleteField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _entry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _entry = _builtOverEntry();
        Overlay.of(context)?.insert(_entry!);
      } else if (_entry != null) {
        _entry!.remove();
      }
    });
  }

  OverlayEntry _builtOverEntry() {
    RenderBox render = context.findRenderObject() as RenderBox;
    Size size = render.size;
    Offset offset = render.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5.0),
              child: Material(
                elevation: 4.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text("Syria"),
                    ),
                    const ListTile(
                      title: Text("Lebanon"),
                    ),
                  ],
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        decoration: const InputDecoration(labelText: "Country"),
      ),
    );
  }
}
