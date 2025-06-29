import 'package:bloctry/pages/widets/call_bg.dart';
import 'package:bloctry/styles/colors.dart';
import 'package:bloctry/styles/text_styles.dart';
import 'package:bloctry/utils/permission.dart';
import 'package:bloctry/widget/my_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bloctry/utils/call_and_refresh.dart';

class Recents extends StatefulWidget {
  const Recents({super.key});

  @override
  State<Recents> createState() => RecentsState();
}

class RecentsState extends State<Recents>
    with AutomaticKeepAliveClientMixin<Recents> {
  void refreshCallLogs() async {
    setState(() => _isLoading = true);
    await _fetchCallLogs();
    setState(() => _isLoading = false);
  }

  final _batchSize = 15;
  final _timeFmt = DateFormat("hh:mm a");
  final _dateFmt = DateFormat("dd/MM/yy");
  late final String _today;
  late final String _yesterday;

  final ScrollController _scrollController = ScrollController();
  List<CallLogEntry> _allLogs = [];
  List<CallLogEntry> _visibleLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _today = _dateFmt.format(DateTime.now());
    _yesterday = _dateFmt.format(DateTime.now().subtract(Duration(days: 1)));
    _scrollController.addListener(_onScroll);
    _initPermissionsAndFetchLogs();
  }

  Future<void> _initPermissionsAndFetchLogs() async {
    final granted = await requestCallLogPermission();
    if (granted) {
      await _fetchCallLogs();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Call log permission is required to show recent calls.",
          ),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () => openAppSettings(),
            textColor: AppColors.white,
          ),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels + 200 >=
            _scrollController.position.maxScrollExtent &&
        _visibleLogs.length < _allLogs.length) {
      final next = _allLogs.skip(_visibleLogs.length).take(_batchSize);
      setState(() => _visibleLogs.addAll(next));
    }
  }

  Future<void> _fetchCallLogs() async {
    final status = await Permission.phone.request();
    if (!status.isGranted) {
      setState(() => _isLoading = false);
      return;
    }
    final logs = await CallLog.get();
    _allLogs = logs.toList();
    setState(() {
      _visibleLogs = _allLogs.take(_batchSize).toList();
      _isLoading = false;
    });
  }

  String _getDisplayName(CallLogEntry log) {
    if (log.name != null && log.name!.isNotEmpty) return log.name!;
    if (log.number != null && log.number!.isNotEmpty) return log.number!;
    return "Unknown";
  }

  String _getDuration(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: AppColors.lightGray,
      edgeOffset: 20,
      displacement: 50,
      onRefresh: () {
        return _fetchCallLogs();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          MyAppBar(title: "Recents"),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_visibleLogs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text("No recent calls"),
              ),
            )
          else
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final log = _visibleLogs.elementAt(index);
              final IconData iconData = log.callType == CallType.incoming
                  ? Icons.call_received
                  : log.callType == CallType.missed
                  ? Icons.call_missed
                  : log.callType == CallType.rejected
                  ? Icons.call_end
                  : log.callType == CallType.outgoing
                  ? Icons.call_made
                  : Icons.hide_source;

              final logtime = DateTime.fromMillisecondsSinceEpoch(
                log.timestamp!,
              );
              final timeStr = _timeFmt.format(logtime);
              final dateStr = _dateFmt.format(logtime);
              final label = dateStr == _today
                  ? "Today"
                  : dateStr == _yesterday
                  ? "Yesterday"
                  : dateStr;

              return Dismissible(
                key: ValueKey(log.timestamp), // Ensure uniqueness
                direction: DismissDirection.horizontal,
                background: CallBG(),
                confirmDismiss: (direction) async {
                  final number = log.number;
                  if (number != null && number.isNotEmpty) {
                    await callAndRefresh(
                      number: number,
                      onCallEnded: () async => refreshCallLogs(),
                    );
                  }
                  return false;
                },
                onDismissed: (_) {
                  final deletedLog = log;
                  final deletedIndex = _visibleLogs.indexOf(log);
                  setState(() {
                    _visibleLogs.remove(log);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Deleted ${_getDisplayName(log)}",
                        style: TextStyle(color: AppColors.white),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: AppColors.lightGrayer,
                      action: SnackBarAction(
                        label: "Undo",
                        backgroundColor: AppColors.darkGray,
                        textColor: AppColors.white,
                        onPressed: () {
                          setState(() {
                            _visibleLogs.insert(deletedIndex, deletedLog);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Material(
                  borderRadius: BorderRadius.circular(24),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.account_circle_outlined, size: 24),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _getDisplayName(log),
                                      style: AppTextStyles.thName,
                                    ),
                                    SizedBox(width: 8),
                                    Icon(iconData, size: 14),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${_getDuration(log.duration ?? 0)} • $timeStr • $label",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(width: 8),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.darkGray,
                              ),
                              padding: EdgeInsets.all(8),
                              icon: Icon(Icons.call_outlined, size: 18),
                              onPressed: () async {
                                final number = log.number;
                                if (number != null && number.isNotEmpty) {
                                  await callAndRefresh(
                                    number: number,
                                    onCallEnded: () async => refreshCallLogs(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: _batchSize),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
