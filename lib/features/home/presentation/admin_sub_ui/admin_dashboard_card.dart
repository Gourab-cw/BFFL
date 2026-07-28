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
      width: widget.extra == null ? 140 : 310,
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Skeletonizer(
        enabled: widget.enabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.iconBgColor.withAlpha(50),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: widget.icon,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHelper(
                        text: widget.title,
                        fontsize: 11,
                        color: Colors.blueGrey.shade400,
                        fontweight: FontWeight.w500,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 2),
                      TextHelper(
                        text: widget.content,
                        padding: EdgeInsets.zero,
                        fontsize: widget.contentFontSize,
                        color: Colors.blueGrey.shade900,
                        fontweight: FontWeight.w700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.extra != null) ...[
              const SizedBox(width: 8),
              widget.extra!,
            ],
          ],
        ),
      ),
    );
  }
}
