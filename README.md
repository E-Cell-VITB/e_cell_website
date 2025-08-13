# E-Cell Website 🚀

[![Flutter](https://img.shields.io/badge/Flutter-3.4.3+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive Flutter web application for the Entrepreneurship Cell (E-Cell) at VIT Bhopal. This platform serves as the central hub for event management, team collaboration, and community engagement.

## 🌟 Features

- **📅 Event Management**: Create, manage, and track events with real-time updates
- **📊 Results Dashboard**: Dynamic results display with search and filtering
- **👥 Team Management**: Team registration and profile management
- **📝 Blog System**: Content management for news and updates
- **🖼️ Gallery**: Image showcase with optimized loading
- **🔐 Authentication**: Secure user authentication with role-based access
- **📱 Responsive Design**: Optimized for desktop, tablet, and mobile devices

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.4.3)
- Firebase project setup
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/E-Cell-VITB/e_cell_website.git
   cd e_cell_website
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Set up your Firebase project
   - Add your `firebase_options.dart` configuration
   - Enable Firestore, Authentication, and Storage

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```

## 📁 Project Structure

```
lib/
├── 📱 app/                    # App configuration & routing
├── 🔧 backend/               # Firebase services & models
├── 🎨 const/                 # Constants & themes
├── 📺 screens/               # UI screens
│   ├── 🏠 home/             # Landing page
│   ├── 📅 events/           # Event management
│   ├── 🏃 ongoing_events/   # Live events & results
│   ├── 👥 team/             # Team profiles
│   ├── 📝 blogs/            # Blog system
│   └── 🖼️ gallery/          # Image gallery
├── 🔧 services/             # Business logic
├── 🧩 widgets/              # Reusable components
└── 🏁 main.dart             # App entry point
```

## 🛠️ Tech Stack

- **Frontend**: Flutter, Dart
- **Backend**: Firebase (Firestore, Auth, Storage)
- **State Management**: Provider
- **Routing**: GoRouter
- **UI**: Material Design, Custom Components
- **Deployment**: Firebase Hosting

## 📖 Documentation

For detailed documentation, please refer to:
- **[Complete Documentation](DOCUMENTATION.md)** - Comprehensive guide
- **[Troubleshooting Guide](TROUBLESHOOTING.md)** - Common issues and solutions
- **[API Reference](docs/API.md)** - Backend API documentation *(if available)*

## 🎯 Key Components

### Results Display System
Real-time results dashboard with:
- Dynamic DataTable with horizontal scrolling
- Search and filter functionality  
- Responsive design for all devices
- Medal system for top performers
- Live Firebase integration

### Event Management
- Event creation and editing
- Team registration system
- Real-time status updates
- Participant management

### Authentication System
- Firebase Authentication
- Role-based access control
- User profile management
- Secure route protection

## 🚀 Deployment

### Web Deployment
```bash
# Build for production
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Mobile Deployment
```bash
# Android
flutter build apk --release

# iOS  
flutter build ios --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read our [Contributing Guidelines](CONTRIBUTING.md) for more details.

## 🐛 Issues & Support

- **Bug Reports**: [Create an issue](https://github.com/E-Cell-VITB/e_cell_website/issues)
- **Feature Requests**: [Request a feature](https://github.com/E-Cell-VITB/e_cell_website/issues)
- **Questions**: Check our [Troubleshooting Guide](TROUBLESHOOTING.md)

## 📸 Screenshots

### Desktop View
![Desktop Dashboard](screenshots/desktop-dashboard.png)

### Mobile View
![Mobile Interface](screenshots/mobile-interface.png)

### Results System
![Results Dashboard](screenshots/results-dashboard.png)

## 🔧 Development Commands

```bash
# Install dependencies
flutter pub get

# Run development server
flutter run -d chrome

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

# Build for web
flutter build web

# Clean build files
flutter clean
```

## 📊 Performance

- **Lighthouse Score**: 95+ for Performance, Accessibility, SEO
- **First Contentful Paint**: < 1.5s
- **Time to Interactive**: < 2.5s
- **Responsive**: Supports all device sizes

## 🔐 Security

- Firebase Security Rules configured
- Authentication required for sensitive operations
- Input validation and sanitization
- Secure API endpoints

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Development Team**: E-Cell VITB
- **Maintainers**: [List of maintainers]
- **Contributors**: [All contributors](https://github.com/E-Cell-VITB/e_cell_website/contributors)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and supporters

---

<div align="center">
  Made with ❤️ by E-Cell VITB Team
  
  [Website](https://ecell-vitb.web.app) • [Documentation](DOCUMENTATION.md) • [Issues](https://github.com/E-Cell-VITB/e_cell_website/issues)
</div>
