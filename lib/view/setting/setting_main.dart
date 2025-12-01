import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingMain extends StatelessWidget {
  const SettingMain({super.key});

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          // top widget
          Text(
            '마이 페이지',
            style: FontStyles.KBO_bold_17.copyWith(color: AppColors.grey_title),
          ),
          SizedBox(height: 82.h),
          // 선택 팀 로고
          Container(),
          // 응원 팀 선택
          Text('응원 팀:', style: FontStyles.KBO_medium_13),
        ],
      ),
    );
  }
}
