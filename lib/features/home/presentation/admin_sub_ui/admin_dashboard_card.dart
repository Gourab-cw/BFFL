import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utility/helper.dart';

class AdminDashboardCard extends StatefulWidget {
  final Widget icon;
  final Color iconBgColor;

  final void Function()? onTap;
  final String title;
  final String content;
  final double contentFontSize;

  final Widget? extra;

  final bool enabled;

  const AdminDashboardCard({
    super.key,
    this.onTap,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.content,
    required this.enabled,
    this.contentFontSize = 18.5,
    this.extra,
  });

  @override
  State<AdminDashboardCard> createState() => _AdminDashboardCardState();
}

class _AdminDashboardCardState extends State<AdminDashboardCard> {
  @override
  Widget build(BuildContext context) {
    return CardHelper(
      onTap: widget.onTap,
      width: widget.extra == null ? 130 : 300,
      height: 110,
      padding: EdgeInsets.all(8),
      child: Skeletonizer(
        enabled: widget.enabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: widget.iconBgColor, borderRadius: BorderRadius.circular(10)),
                    child: widget.icon,
                  ),
                  SizedBox(height: 11),
                  Column(
                    spacing: 0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHelper(
                        text: widget.title,
                        // textalign: TextAlign.center,
                        fontsize: 11,
                        color: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 2),
                      ),
                      TextHelper(
                        text: widget.content,
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        fontsize: widget.contentFontSize,
                        color: Colors.blueGrey.shade900,
                        fontweight: FontWeight.w600,
                        // textalign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.extra != null) widget.extra!,
          ],
        ),
      ),
    );
  }
}
