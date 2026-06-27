# Aura Estates

**A modern real estate platform connecting property owners with clients through a seamless mobile experience and powerful admin dashboard.**

---

## 🎯 What is Aura Estates?

Aura Estates is a complete real estate solution built with Flutter. Users can browse premium properties, request visits, and manage their favorites — while property managers control everything through a separate admin panel.

**Perfect for:** Real estate agencies, property managers, and real estate startups looking for a turnkey mobile + web solution.

---

## ✨ Key Features

### Mobile App (User Side)
- **Property Browsing** — Real-time property listings with advanced filtering by category, price, location
- **Detailed Views** — High-resolution images, property specs (beds, baths, area), price, location map
- **Booking System** — Multi-step form to request property visits with date/time selection
- **Favorites** — Save properties for later with persistent local storage
- **User Profiles** — Manage personal information and booking history
- **Authentication** — Secure Firebase authentication with email/password

### Admin Dashboard (Flutter Web)
- **Property Management** — Add, edit, delete properties in real-time
- **Image Upload** — Optimized image management via Cloudinary
- **Real-time Sync** — Changes instantly reflect in the mobile app
- **Booking Management** — View and manage all visitor requests

---

## 🏗️ Architecture

```
Aura Estates (Mobile + Admin)
├── Frontend
│   ├── Mobile App (Flutter)
│   └── Admin Dashboard (Flutter Web)
├── State Management
│   └── Riverpod (reactive, type-safe)
├── Navigation
│   └── GoRouter (type-safe routing, deep links)
└── Backend
    ├── Firebase Authentication
    ├── Cloud Firestore (real-time database)
    └── Cloudinary (image CDN)
```

**Design Pattern:** Feature-based clean architecture with separation of concerns
- **Data Layer** — Repositories handle Firebase & Cloudinary
- **Controller Layer** — Riverpod providers manage state
- **Presentation Layer** — UI components with real-time binding

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Mobile** | Flutter 3.11+, Dart 3.11+ |
| **State Management** | Riverpod 3.3.1 (with code generation) |
| **Navigation** | GoRouter 17.2.3 |
| **Backend** | Firebase Core, Cloud Firestore, Firebase Auth |
| **Images** | Cloudinary + Hive CE caching |
| **UI** | Material Design, Google Fonts (Cormorant Garamond) |

**Why this stack?**
- **Riverpod** — Modern, testable, zero boilerplate
- **Firebase** — Scales from MVP to production, real-time updates built-in
- **Cloudinary** — Professional image delivery, optimized for mobile
- **GoRouter** — Type-safe navigation, supports deep links (future-proof)

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.11.0+
- Dart 3.11.0+
- Firebase project (create free at [firebase.google.com](https://firebase.google.com))
- Cloudinary account (free tier available)

### Setup

1. **Clone and install dependencies**
   ```bash
   git clone <repo-url>
   cd aura_estates
   flutter pub get
   ```

2. **Configure Firebase**
   - Download your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place in `android/app/` and `ios/Runner/` respectively

3. **Setup Cloudinary**
   - Add your Cloudinary upload preset in `lib/core/utils/` (see `.env.example`)

4. **Run the app**
   ```bash
   flutter run                    # Mobile app
   flutter run -d chrome          # Admin dashboard (web)
   ```

### Build for Production

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release

# Web (Admin Dashboard)
flutter build web --release
```

---

## 📱 Screenshots & Demo

**Mobile App:**
- Home: Property listings with real-time Firestore sync, category filter
- Detail: Full property specs, high-res images, booking request form
- Booking: Multi-step form with date/time selection
- Profile: User data management, booking history

**Admin Dashboard (Web):**
- Property management (CRUD operations)
- Real-time image upload via Cloudinary
- Booking requests overview

*[Add 3-4 screenshots of main screens here for impact]*

---

## 🔄 Real-Time Features

Aura Estates leverages **Firestore real-time streams** for instant synchronization:
- Property updates appear immediately in the mobile app
- New bookings notify admins in real-time
- User data syncs across devices via Hive local storage

**Result:** No manual refresh needed, true real-time collaboration between mobile users and admins.

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── components/          # Reusable widgets (buttons, cards, forms)
│   ├── router/              # GoRouter configuration
│   ├── storage/             # Hive setup for local caching
│   ├── theme/               # Material theme (dark + gold)
│   └── utils/               # Helpers (price formatting, etc.)
├── features/
│   ├── Authentication/      # Login/signup/auth logic
│   ├── properties/
│   │   ├── data/
│   │   │   ├── controllers/ # Riverpod state providers
│   │   │   ├── models/      # PropertyModel, BookingModel, etc.
│   │   │   └── repository/  # Firebase & Cloudinary integration
│   │   └── presentation/    # UI screens (HomePage, PropertyPage, etc.)
│   └── Developer Page/      # About/contact screen
└── main.dart
```

---

## 🎨 Design System

- **Theme:** Dark mode with premium gold accents (#D4AF37)
- **Typography:** Cormorant Garamond (serif, elegant)
- **Components:** Material Design with custom refinements
- **Responsive:** Optimized for mobile (and web admin dashboard)

---

## 🔐 Security

- **Authentication** — Firebase Auth with email/password (extensible to Google, Apple)
- **Database Rules** — Firestore security rules restrict user access to own data
- **Image Upload** — Cloudinary preset limits file types and sizes
- **No Secrets in Code** — Firebase config handled via secure app setup

---

## 📊 What Makes This Production-Ready

✅ **Full-stack solution** — Mobile app + admin dashboard both included  
✅ **Real-time backend** — Firestore handles concurrent updates seamlessly  
✅ **Professional architecture** — Clean, testable, scales with team  
✅ **Image optimization** — Cloudinary CDN ensures fast mobile experience  
✅ **User-centric features** — Favorites, profiles, booking history  
✅ **Admin control** — Complete property & booking management  

---

## 🚀 For Real Estate Businesses

**Timeline:** MVP launch in **2-3 months**
- Week 1-2: Firebase & Firestore setup, property data import
- Week 3-4: Admin dashboard customization
- Week 5-6: User testing, refinements, launch

**Scaling:** The architecture supports:
- Thousands of properties
- Concurrent bookings
- Multiple property managers
- API integrations (payment processing, SMS notifications)

---

## 🛣️ Roadmap

- [ ] Payment integration (Stripe/PayPal)
- [ ] SMS/Email notifications for bookings
- [ ] Advanced search filters (area radius, price range slider)
- [ ] Property reviews and ratings
- [ ] Push notifications for new listings
- [ ] Multi-language support

---

## 📧 Contact

**Built by:** Anas  
**For inquiries or collaboration:** [Your contact info]

---

## 📄 License

This project is available for commercial and custom development. Reach out to discuss licensing or custom features.

---

**Ready to launch your real estate platform?** This is a proven, complete solution. Let's discuss your specific needs.
