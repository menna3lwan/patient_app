
# Hen Lehen – هُنَّ لَهُنَّ  
## Patient Application

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20Application-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-Authentication-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Supabase-Backend%20%26%20Database-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-C8A97E?style=flat-square"/>
  <img src="https://img.shields.io/badge/Users-Female%20Patients-D291BC?style=flat-square"/>
  <img src="https://img.shields.io/badge/Status-Production%20Ready-9BCF9B?style=flat-square"/>
</p>

---

## Overview

**Hen Lehen – هُنَّ لَهُنَّ Patient Application** is a mobile application developed using **Flutter**, integrated with **Firebase** and **Supabase**, and designed exclusively for **women**.

The application represents the patient-side of the Hen Lehen women-only healthcare platform, providing a safe, private, and emotionally comfortable environment where women can access healthcare services, book consultations, and communicate with female doctors confidently.

---

## Vision & Experience

The application is designed to make every patient feel:
- Safe and respected
- Comfortable seeking medical help
- Guided step-by-step
- Protected in terms of privacy and data

The design language is calm, feminine, and reassuring, focusing on clarity and emotional comfort.

---

## Technology Stack

| Layer | Technology |
|-----|-----------|
| Mobile Development | Flutter |
| Authentication | Firebase Authentication |
| Backend Services | Supabase |
| Database | Supabase |
| Notifications | Firebase |
| State Management | Provider |

---

## High-Level Architecture

```

┌──────────────────────────────────┐
│        Flutter UI Layer          │
│ Screens • Tabs • Widgets • Theme │
└───────────────┬──────────────────┘
│
State Management
Provider
│
┌───────────────┴──────────────────┐
│        Application Logic         │
│ Auth • Booking • Chat • Profile │
└───────────────┬──────────────────┘
│
┌───────┴──────────┐
│                  │
┌───────▼────────┐ ┌───────▼────────┐
│   Firebase     │ │   Supabase      │
│ Authentication│ │ Database & API  │
└────────────────┘ └────────────────┘

```

---

## Project Structure

The project follows a **feature-based structure** under the `lib` directory.

```

lib/
│
├── main.dart
│
├── config/
│   ├── locale.dart
│   ├── providers.dart
│   ├── routes.dart
│   └── theme.dart
│
├── models/
│   ├── models.dart
│   └── user_model.dart
│
├── screens/
│   ├── auth/
│   │   ├── onboarding_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   ├── home/
│   │   ├── home_tab.dart
│   │   ├── home_screen.dart
│   │   └── main_screen.dart
│   │
│   ├── appointments/
│   │   ├── appointments_screen.dart
│   │   ├── appointments_tab.dart
│   │   └── appointment_details_screen.dart
│   │
│   ├── booking/
│   │   ├── booking_screen.dart
│   │   ├── payment_screen.dart
│   │   └── booking_success_screen.dart
│   │
│   ├── chat/
│   │   └── chat_screen.dart
│   │
│   ├── doctor/
│   │   └── doctor_profile_screen.dart
│   │
│   ├── community/
│   │   ├── community_screen.dart
│   │   ├── community_tab.dart
│   │   └── create_post_screen.dart
│   │
│   ├── favorites/
│   │   └── favorites_screen.dart
│   │
│   ├── notifications/
│   │   └── notifications_screen.dart
│   │
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── profile_tab.dart
│   │   └── settings_screen.dart
│   │
│   └── search/
│       └── search_screen.dart
│
└── widgets/
└── widgets.dart

```

---

## Patient Journey

```

App Launch
│
Onboarding
│
Login / Register
│
Home Screen
│
Search / Browse Doctors
│
Book Appointment
│
Online Chat or Clinic Visit
│
History & Profile

```

---

## Core Features

### Authentication & Onboarding
- Smooth onboarding experience
- Secure login and registration
- Women-only access

### Home & Navigation
- Bottom tab navigation
- Personalized home content
- Quick access to doctors and features

### Doctor Discovery
- Search doctors by specialization
- View detailed doctor profiles
- Save doctors to favorites

### Appointment Booking
- Choose consultation type:
  - Online consultation
  - Clinic visit
- Select date and time
- Secure payment flow for online consultations
- Booking success confirmation

### Online Medical Chat
- Available only for online consultations
- Private one-to-one chat
- Supports medical attachments
- Chat linked to a single appointment

### Appointments Management
- View upcoming appointments
- View appointment details
- Track appointment status
- Access chat from appointment

### Community
- Women-only community space
- Create and view posts
- Supportive and safe interaction

### Notifications
- Appointment updates
- Booking confirmations
- System alerts

### Profile & Settings
- Edit personal profile
- View medical history
- Manage favorites
- Application settings

---

## Consultation Types

| Type | Description | Chat |
|----|-------------|------|
| Online Consultation | Medical chat-based consultation | Enabled |
| Clinic Visit | Physical appointment at clinic | Disabled |

---

## UI & UX Design Principles

- Soft feminine color palette
- Calm and reassuring visual identity
- Simple and guided flows
- Light and dark mode support
- Arabic and English localization
- RTL and LTR layout handling
- Emotionally comfortable user experience

---

## Project Status

| Component | Status |
|---------|--------|
| Flutter UI | Completed |
| Firebase Integration | Completed |
| Supabase Integration | Completed |
| Patient Flow | Implemented |
| Doctor Application | Separate Module |

---

## Conclusion

Hen Lehen – هُنَّ لَهُنَّ Patient Application delivers a safe, private, and supportive healthcare experience designed specifically for women.  
The application combines thoughtful design with secure technology to ensure trust, comfort, and usability.

---

## License

This project is developed for educational and demonstration purposes as part of the Hen Lehen – هُنَّ لَهُنَّ platform.
```

