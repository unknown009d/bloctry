import 'dart:async';

import 'package:bloctry/pages/recents.dart';
import 'package:bloctry/pages/widets/call_bg.dart';
import 'package:bloctry/styles/colors.dart';
import 'package:bloctry/styles/text_styles.dart';
import 'package:bloctry/utils/call_and_refresh.dart';
import 'package:bloctry/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloctry/utils/permission.dart';
import 'package:phone_state/phone_state.dart';

class ContactPage extends StatefulWidget {
  final GlobalKey<RecentsState> recentsKey;

  const ContactPage({super.key, required this.recentsKey});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  StreamSubscription<PhoneState>? _phoneStateSub;

  // Future<void> _initiateCallAndRefresh(Contact contact) async {
  //   final number = contact.phones.isNotEmpty ? contact.phones[0].number : null;
  //   if (number == null) return;

  //   await FlutterPhoneDirectCaller.callNumber(number);

  //   _phoneStateSub?.cancel();

  //   _phoneStateSub = PhoneState.stream.listen((PhoneState state) async {
  //     if (state.status == PhoneStateStatus.CALL_ENDED) {
  //       await Future.delayed(Duration(seconds: 1));
  //       widget.recentsKey.currentState?.refreshCallLogs();
  //       _phoneStateSub?.cancel();
  //     }
  //   });
  // }

  List<Contact> _contacts = [];
  bool _isLoading = false;

  // Future<void> _fetchContacts() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (await FlutterContacts.requestPermission()) {
  //     final contacts = await FlutterContacts.getContacts(
  //       withProperties: true,
  //       withPhoto: true,
  //     );
  //     setState(() {
  //       _contacts = contacts;
  //     });
  //   } else {
  //     debugPrint('Permission to read contacts denied');
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  Future<void> _fetchContacts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    debugPrint('Requesting permission...');
    final granted = await FlutterContacts.requestPermission();
    if (!mounted) return;

    debugPrint('Permission granted: $granted');
    if (!granted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to read contacts is required.')),
      );
      return;
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );
    if (!mounted) return;

    debugPrint('Fetched ${contacts.length} contacts');
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    // initPermissionsAndFetchContacts();
  }

  // Future<void> initPermissionsAndFetchContacts() async {
  //   final granted = await requestPhonePermissions();
  //   if (granted) {
  //     _fetchContacts();
  //   } else {
  //     await openSettingsIfPermanentlyDenied();
  //   }
  // }

  @override
  void dispose() {
    _phoneStateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: AppColors.lightGray,
      edgeOffset: 20,
      displacement: 50,
      onRefresh: () => _fetchContacts(),
      child: CustomScrollView(
        slivers: [
          MyAppBar(title: "Contacts"),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_contacts.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text("No contacts")),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final contact = _contacts.elementAt(index);
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Dismissible(
                    direction: DismissDirection.horizontal,
                    background: CallBG(),
                    key: ValueKey(contact.id),
                    confirmDismiss: (direction) async {
                      if (contact.phones.isNotEmpty) {
                        await callAndRefresh(
                          number: contact.phones[0].number,
                          onCallEnded: () async =>
                              widget.recentsKey.currentState?.refreshCallLogs(),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Invalid number"),
                            content: Text(
                              "No phone number provided.",
                              style: AppTextStyles.normal,
                            ),
                            actions: [
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.lightGray,
                                  foregroundColor: AppColors.darkGray,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Ok",
                                  style: AppTextStyles.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return false;
                    },
                    child: ListTile(
                      leading: contact.thumbnail != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.thumbnail!),
                            )
                          : Icon(
                              Icons.account_circle_outlined,
                              size: 38,
                            ),
                      title: Text(
                        contact.displayName.isNotEmpty
                            ? contact.displayName
                            : "Unknown",
                        style: GoogleFonts.inter(),
                      ),
                      subtitle: Text(
                        contact.phones[0].number,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              }, childCount: _contacts.length),
            ),
        ],
      ),
    );
  }
}
