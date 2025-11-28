import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeCalendar extends GetView<HomeController> {
  const HomeCalendar({super.key});

  /// 모든 날짜 셀 공통 레이아웃
  /// - 가로: 가운데
  /// - 세로: 위에서 6.h 내려온 위치
  /// - [selected]일 때만 동그라미 배경 추가
  Widget _buildDayCell(DateTime day, Color textColor, {bool selected = false}) {
    final textStyle = FontStyles.KBO_medium_12.copyWith(
      color: selected ? AppColors.white : textColor,
    );

    Widget child;
    if (selected) {
      child = Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 24.h,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mainColor,
            ),
          ),
          Text('${day.day}', style: textStyle),
        ],
      );
    } else {
      child = Text('${day.day}', style: textStyle);
    }

    return SizedBox.expand(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedMonth.value,
        locale: 'ko_KR',

        // 월 기준
        calendarFormat: CalendarFormat.month,

        // 한 주 시작 요일 (일요일 시작)
        startingDayOfWeek: StartingDayOfWeek.sunday,

        // 요일(일~토) 줄 높이
        daysOfWeekHeight: 18.h,
        // 각 날짜 칸 높이
        rowHeight: 40.h,

        // ✅ 요일/날짜 셀 커스텀 빌더
        calendarBuilders: CalendarBuilders(
          // --- 요일 헤더 (일~토) ---
          dowBuilder: (context, day) {
            final text = DateFormat.E('ko_KR').format(day).substring(0, 1);

            Color color;
            if (day.weekday == DateTime.sunday) {
              color = Colors.red; // 일요일
            } else if (day.weekday == DateTime.saturday) {
              color = AppColors.blue_01; // 토요일
            } else {
              color = AppColors.black; // 평일
            }

            return Center(
              child: Text(
                text,
                style: FontStyles.KBO_medium_10.copyWith(color: color),
              ),
            );
          },

          // --- 일반 날짜 셀 ---
          defaultBuilder: (context, day, focusedDay) {
            Color color;
            if (day.weekday == DateTime.sunday) {
              color = Colors.red;
            } else if (day.weekday == DateTime.saturday) {
              color = AppColors.blue_01;
            } else {
              color = AppColors.black;
            }

            return _buildDayCell(day, color);
          },

          // --- 오늘 날짜 셀 (텍스트 색만 메인컬러) ---
          todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, AppColors.mainColor);
          },

          // --- 선택된 날짜 셀 (배경 메인컬러 + 흰 글씨)
          //     → 숫자 위치는 다른 날과 100% 동일
          selectedBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, AppColors.mainColor, selected: true);
          },
        ),

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: FontStyles.KBO_medium_13,
          titleTextFormatter: (date, locale) {
            return DateFormat('yyyy. MM', locale).format(date);
          },
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: 20.sp,
            color: AppColors.grey_04,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: 20.sp,
            color: AppColors.grey_04,
          ),
          headerPadding: EdgeInsets.only(bottom: 6.h),
        ),

        selectedDayPredicate: (day) =>
            isSameDay(day, controller.selectedDate.value),
        onDaySelected: (selectedDay, focusedDay) {
          controller.onDaySelected(selectedDay, focusedDay);
        },

        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.zero,
          cellPadding: EdgeInsets.zero,
          outsideDaysVisible: false,
          isTodayHighlighted: true,
        ),
      ),
    );
  }
}
