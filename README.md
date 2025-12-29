# ChatApp (Name not deided yet)

A modern real-time chat application built with **Flutter** for the frontend and a scalable backend architecture.  
The project is designed to support real-time messaging, AI-assisted features, and extensibility.

- This project was developed as part of a college hackathon-style competition.
- The app build is shared via Firebase App Distribution for testing and evaluation purposes.

## [Backend Repo](https://github.com/Haruto-hyuuga/chatapp-backend)

## [Download Test Build (Android)](https://appdistribution.firebase.google.com/testerapps/1:300532789958:android:edffda26b9031922b89dc7/releases/008t5dvpin1ug?utm_source=firebase-console)

## Project Overview

ChatApp is a cross-platform chat application focusing on:

- Real-time communication
- Clean industry-grade architecture
- Scalability for future features (AI, moderation, media, etc.)
- Developer-friendly structure

> Each feature is modularized and follows Clean Architecture principles. Business logic resides in the domain layer with use cases and entities, data sources handle external communication, and the presentation layer uses BLoC for predictable state management, with dependency injection for loose coupling and scalability..

---

# Getting Started

### Prerequisites

Install these (im not goin to explain how, you can find it on thier official documentaions)

- Flutter/Android SDK

- Git, java

- Android Emulator or physical device (with debug mode)

Clone the Repository: `git clone https://github.com/Haruto-hyuuga/chatapp.git`

Go to progect folder: `cd chatapp`

Install Dependencies: `flutter pub get`

Run the App: `flutter run`

> you can use android simulator or something, i prefer usb debugging to run it on my phone

---

# Features

### Already Implemented

- User registration and login with email (not secure authentication)
- Token-based session validation and auto-login support
- One-to-one real-time messaging using Socket.IO
- Add contacts using registered email addresses
- Automatic conversation creation between users
- Fetch and display recent conversations
- Message history loading per conversation
- Real-time message delivery and updates
- User profile support (username, email, profile image)
- Integrated Gemini AI chatbot for AI-based conversations
- Proper error handling and loading states across the app
- markdown for text formatting

### In Progress

- User settings to update profile information (profile image, username, etc.)
- Search functionality for users and conversations
- Media support for sharing images and files in chats
- Message actions including reply, edit, and delete
- Delete conversations and remove contacts

### Planned Features

- Online / offline user presence and last-seen status
- Stories feature for sharing temporary status updates
- Stickers and GIF support in conversations
- Group chats with multiple participants and role-based controls
- Channels for one-to-many broadcasts and announcements
- Message reactions and rich message interactions
- Read receipts and typing indicators
- Message forwarding and pinning
- Enhanced media previews and file sharing controls

---

# 📂 Project Structure

```text
chatapp/
├── lib/   # app source code
│   └──
├── android/    # Android platform files
├── ios/    # iOS platform files
├── web/    # Web support
├── test/   # Unit & widget tests
├── pubspec.yaml    # Flutter dependencies
└── README.md
```

### 1. Core Layer (App-wide utilities)

```
lib/core/
├── show_error.dart (error popup widget)
├── animated_gradient_background.dart (ignore this)
├── socket_service.dart (Shared services Socket.IO)
├── theme.dart (Global theming & colors)
```

### 2. Feature-First Modularization

```
lib/features/
├── auth/
├── chat/
├── contacts/
├── conversation/
├── recents/
├── rushed/
```

> i was hoping to keep every feature isolated but as it turns out some relied on other for entity models or pages etc, while No feature directly depends on another feature they do use some parts.

### Inside Each Feature:

### 2A. Data Layer (Infrastructure Layer)

```
data/
├── datasource/
├── models/
├── repositories/
```

Responsibilities:

- API calls
- Socket communication
- DTOs / JSON parsing
- External data handling

> This layer depends on external frameworks and converts data into domain-friendly formats.

### 2B. Domain Layer (most important layer)

```
domain/
├── entities/
├── repositories/ (impl)
├── usecases/
```

Responsibilities:

- Core business rules
- Application logic
- Use cases (SendMessage, LoginUser, FetchContacts)

> No Flutter/HTTP/Socket/UI logic.
> Just Pure Dart logic

### 2C. Presentation Layer (UI + State Management)

```
presentation/
├── bloc/
│   ├── bloc.dart
│   ├── event.dart
│   ├── state.dart
├── pages/
├── widgets/
```

Responsibilities:

- UI rendering
- State transitions
- User interactions

### Dependency Injection (DI)

- The app uses Dependency Injection with **GetIt** to manage and provide dependencies across the application.
- All core services, data sources, repositories, and use cases are registered in a centralized DI container (`di_container.dart`).
- This approach enforces loose coupling, follows the Dependency Inversion Principle, and keeps the presentation, domain, and data layers independent.
- Dependencies are resolved lazily at runtime, improving performance and making the codebase easier to scale, test, and maintain.

---

# Contributing

Contributions are welcome.

1. Fork the repository

2. Create a feature branch

3. Commit your changes

4. Open a pull request

---

# Developer Notes

> This project is rushed (due to exams) not my best work, there will be few bugs which will be fixed overtime.
> Major features will be copied from telegram and implemented step-by-step until everything crashes and falls apart..
