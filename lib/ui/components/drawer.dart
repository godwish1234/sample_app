import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/localizations/locale_keys.g.dart';

class CustomDrawer extends StatefulWidget {
  final String? username;
  final VoidCallback? signOut;
  const CustomDrawer({super.key, this.username, this.signOut});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Text('${LocaleKeys.welcome.tr()} ${widget.username}'),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        child: Text(LocaleKeys.signout.tr()),
                        onPressed: () => widget.signOut?.call()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
