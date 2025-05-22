# 📝 Notes App

A complete notes application built with Flutter.  
Includes essential features for a modern note-taking experience:

![image](https://github.com/user-attachments/assets/cdea0f93-0317-4763-9d81-69ad1a5b0019)


### ✅ Features
- Create, Read, Update, Delete (CRUD) operations  
- Search functionality  
- Category filtering  
- Local database storage  
- Clean layered architecture  

---

### 🧱 Architecture Pattern

We're using a **Layered Architecture** to ensure separation of concerns and maintainability:


Each layer is responsible for a specific part of the app:
- **UI Layer**: Contains all visual components (Screens, Widgets)
- **Service Layer**: Handles business logic and coordinates data flow
- **Database Layer**: Manages all database interactions
- **Model Layer**: Defines the structure of data used in the app

---

### 📂 Tech Stack
- **Flutter**
- **SQLite (sqflite)**
- **Provider / setState**
- **Dart**

---

### 🚀 Get Started

```bash
git clone https://github.com/your-username/notes_app.git
cd notes_app
flutter pub get
flutter run
