import 'package:bloctry/widget/icon_text_item.dart';
import 'package:bloctry/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bloctry/pages/dialer_page.dart';
import 'package:bloctry/widget/my_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<List<IconTextItem>> iconTextItems = [
    [
      IconTextItem(
        icon: Icons.wifi,
        text: "Network and internet",
        desc: "JIO 5G",
      ),
      IconTextItem(
        icon: Icons.devices_other_outlined,
        text: "Connected Devices",
        desc: "Druba CMF • 100%",
      ),
    ],
    [
      IconTextItem(icon: Icons.screen_lock_portrait, text: "Lock Screen"),
      IconTextItem(icon: Icons.format_paint, text: "Customization"),
    ],
    [
      IconTextItem(icon: Icons.apps, text: "Apps"),
      IconTextItem(icon: Icons.notifications_outlined, text: "Notifications"),
      IconTextItem(icon: Icons.battery_full, text: "Battery"),
      IconTextItem(icon: Icons.storage, text: "Storage"),
      IconTextItem(icon: Icons.volume_up_outlined, text: "Sound & Vibration"),
      IconTextItem(
        icon: Icons.brightness_medium_outlined,
        text: "Display",
      ),
    ],
    [
      IconTextItem(icon: Icons.settings_accessibility, text: "Accessibility"),
      IconTextItem(icon: Icons.lock_outline, text: "Security & Privacy"),
      IconTextItem(icon: Icons.location_on_outlined, text: "Location"),
      IconTextItem(icon: Icons.emergency, text: "Safety and emergency"),
      IconTextItem(
        icon: Icons.account_circle_outlined,
        text: "Password, Passkeys, and accounts",
      ),
    ],
    [
      IconTextItem(icon: Icons.info_outline, text: "System"),
      IconTextItem(icon: Icons.gamepad_outlined, text: "Special Features"),
      IconTextItem(icon: Icons.emoji_objects_outlined, text: "Tips & Feedback"),
      IconTextItem(icon: Icons.perm_device_info_outlined, text: "About phone"),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey('settings_scroll'),
      slivers: <Widget>[
        MyAppBar(title: "Settings"),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        ...iconTextItems
            .map(
              (group) => [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Radius rd = Radius.circular(20);
                      Radius rdictu = Radius.circular(2);
                      final item = group[index];
                      bool isFirst = index == 0;
                      bool isLast = index == (group.length - 1);
                      return Container(
                        margin: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 2,
                        ),
                        child: Material(
                          color: const Color.fromARGB(
                            20,
                            255,
                            255,
                            255,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: isFirst ? rd : rdictu,
                            topRight: isFirst ? rd : rdictu,
                            bottomLeft: isLast ? rd : rdictu,
                            bottomRight: isLast ? rd : rdictu,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            autofocus: false,
                            onTap: () {
                              // tap logic
                            },
                            child: IconTextTile(item: item),
                          ),
                        ),
                      );
                    },
                    childCount: group.length,
                  ),
                ),

                // Optional spacing between groups
                SliverToBoxAdapter(child: SizedBox(height: 10)),
              ],
            )
            .expand((e) => e),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}
