import 'dart:developer';

import 'package:bloctry/pages/widets/dial_button.dart';
import 'package:bloctry/styles/colors.dart';
import 'package:bloctry/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DialerPage extends StatefulWidget {
  const DialerPage({super.key});

  @override
  State<DialerPage> createState() => _DialerPageState();
}

class _DialerPageState extends State<DialerPage>
    with AutomaticKeepAliveClientMixin<DialerPage> {
  final TextEditingController _textPhone = TextEditingController();

  void _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  bool _isValidPhoneNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\s'), '');
    final regex = RegExp(r'^[\d\+\*\#]{3,20}$');
    return regex.hasMatch(cleaned);
  }

  @override
  void initState() {
    super.initState();
    _textPhone.addListener(() {
      final String text = _textPhone.text.toLowerCase();
      _textPhone.value = _textPhone.value.copyWith(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _textPhone,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: GoogleFonts.inter(fontSize: 32.0),
            keyboardType: TextInputType.none,
          ),
          SizedBox(
            height: 5.0,
          ),
          Column(
            spacing: 10,
            children: [
              for (var row in [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
                ['*', '0', '#'],
              ])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: row
                      .map(
                        (key) => DialKey(
                          label: key,
                          onPressed: () {
                            setState(() {
                              _textPhone.text += key.toString();
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              SizedBox(
                height: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _textPhone.text += '+';
                    }),
                    onLongPress: () => setState(() {
                      _textPhone.text += ' ';
                    }),
                    icon: SizedBox(
                      height: 58.0,
                      width: 58.0,
                      child: Icon(Icons.add),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20.0),
                    ),
                    onPressed: () {
                      final phone = _textPhone.text;
                      if (_isValidPhoneNumber(phone)) {
                        _callNumber(phone);
                        Navigator.pop(context, true);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Invalid number"),
                            content: Text(
                              "Please enter a valid phone number",
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
                    },
                    child: Icon(
                      Icons.call_outlined,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onLongPress: () => setState(() {
                      _textPhone.text = '';
                    }),
                    onPressed: () => setState(() {
                      final text = _textPhone.text;
                      if (text.isNotEmpty) {
                        _textPhone.text = text.substring(
                          0,
                          text.length - 1,
                        );
                        _textPhone.selection = TextSelection.fromPosition(
                          TextPosition(offset: _textPhone.text.length),
                        );
                      }
                    }),
                    icon: SizedBox(
                      height: 58.0,
                      width: 58.0,
                      child: Icon(Icons.backspace_outlined),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
