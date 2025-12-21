# ⚾ Baseball Diary

야구 관람 기록을 저장하고, 개인 데이터를 기반으로 승률과 패턴을 분석하는 모바일 애플리케이션입니다.  
단순한 SNS가 아닌 **야구 관람 경험 기록과 통계 분석**에 초점을 둔 캡스톤 프로젝트입니다.

---

## 📌 Project Overview

- **Project Type**: Capstone Project
- **Platform**: Mobile App
- **Purpose**:
  - 야구 경기 관람 기록을 체계적으로 저장
  - 기록 데이터를 기반으로 개인 승률 및 패턴 분석 제공
  - 감정, 팀, 구장 등 다양한 요소를 결합한 분석 기능 구현

---

## 🎯 Target Users

- 야구 직관 기록을 남기는 팬
- 경기 결과와 감정을 함께 기록하고 싶은 사용자
- 개인 관람 데이터를 통계로 확인하고 싶은 사용자

---

## 🛠 Tech Stack

### Frontend
- Flutter
- Dart
- GetX (State Management / Routing / Dependency Injection)
- flutter_screenutil (Responsive UI)

### Data
- Local Dummy Data (현재 단계)
- 구조 설계 완료, 추후 DB/API 연동 가능

### Design
- Figma 기반 UI/UX 설계
- Custom Design System 적용

---

## 📂 Project Structure

```bash
lib/
├── controller/        # GetX Controllers
├── model/             # Data Models
├── view/
│   ├── home/           # 홈 / 캘린더
│   ├── record/         # 기록 작성 / 상세 / 수정
│   ├── analysis/       # 승률 및 통계 분석
│   └── common/         # 공통 UI 컴포넌트
├── theme/              # Colors / Fonts
├── data/               # 더미 데이터, 상수
└── app.dart / main.dart
