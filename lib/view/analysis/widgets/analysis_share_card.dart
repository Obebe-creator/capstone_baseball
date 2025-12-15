// lib/view/analysis/widgets/analysis_share_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisShareCard extends StatelessWidget {
  final String teamName;
  final String? teamLogoAsset; // 있으면 사용
  final int total;
  final int win;
  final int lose;

  const AnalysisShareCard({
    super.key,
    required this.teamName,
    this.teamLogoAsset,
    required this.total,
    required this.win,
    required this.lose,
  });

  int get winRate => total == 0 ? 0 : ((win / total) * 100).round();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단: 팀 로고 + 팀명
          Row(
            children: [
              if (teamLogoAsset != null)
                Image.asset(teamLogoAsset!, width: 36.w, height: 36.w),
              if (teamLogoAsset != null) SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  teamName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // 중앙: 승률 크게
          Text(
            '직관 승률',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '$winRate%',
            style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),

          // 하단: 경기 수 요약
          Text(
            '총 $total경기 · $win승 $lose패',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),

          // 푸터(브랜딩/앱명)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'HO·UNG',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
