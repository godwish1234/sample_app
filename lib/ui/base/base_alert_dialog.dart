import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final Widget? headerTrailingWidget;
  final Widget? content;
  final List<Widget>? actions;
  final bool scrollable;
  final bool showBackButton;
  final bool? showCloseButton;
  final bool noContentPadding;
  final AlignmentGeometry? alignment;

  const BaseAlertDialog({
    super.key,
    required this.title,
    this.titleTextStyle,
    this.headerTrailingWidget,
    this.content,
    this.actions,
    this.scrollable = true,
    this.showBackButton = false,
    this.showCloseButton,
    this.noContentPadding = false,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        alignment: alignment,
        title: Column(
          children: [
            showCloseButton == true
                ? Transform.translate(
                    offset: Offset(20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Icon(Icons.close),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        titlePadding: EdgeInsets.only(
          top: showCloseButton == true ? 0 : 15,
          left: 15,
          right: 15
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.only(
            top: 15,
            bottom: 10,
            left: noContentPadding ? 0 : 20,
            right: noContentPadding ? 0 : 20,
          ),
          // decoration: BoxDecoration(
          //   border: Border.symmetric(
          //     horizontal: BorderSide(
          //       color: Theme.of(context)
          //           .colorScheme
          //           .fmiBaseThemeAltSurfaceInverseAltSurface,
          //     ),
          //   ),
          // ),
          child: scrollable ? SingleChildScrollView(child: content) : content,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        actions: actions,
      ),
    );
  }
}
