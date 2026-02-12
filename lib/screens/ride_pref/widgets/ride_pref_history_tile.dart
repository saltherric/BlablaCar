import 'package:flutter/material.dart';
import '../../../models/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_time_util.dart';

///
/// This tile represents an item in the list of past entered ride inputs
///
class RidePrefHistoryTile extends StatelessWidget {
  const RidePrefHistoryTile({
    super.key,
    required this.ridePref,
    required this.onTap,
  });

  final RidePref ridePref;
  final VoidCallback onTap;

  String get title => "${ridePref.departure.name} → ${ridePref.arrival.name}";
  String get subtitle => "${DateTimeUtils.formatDateTime(ridePref.departureDate)}, ${ridePref.requestedSeats} passenger${ridePref.requestedSeats>1? "s" : ""}";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.history, color: BlaColors.iconLight,),
      title: Text(title, style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),),
      subtitle: Text(subtitle, style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),),
      trailing: Icon(Icons.arrow_forward_ios, color: BlaColors.iconLight, size: 16,),
    );
  }
}
