# Vigil

Vigil is a modern, high-performance personal finance and budget tracking application built entirely with **SwiftUI** and **Modular MVVM Architecture**. It provides a seamless user experience for managing expenses, setting budget limits, and visualizing financial data securely using **SwiftData**.

---

## 🚀 Key Features

* **Secure Access:** Protect sensitive financial data with native Face ID and custom PIN lock authentication.
* **Dynamic Dashboard:** Get a quick, comprehensive overview of total monthly spending and recent transactions at a glance.
* **Smart Budgeting:** Set, manage, and monitor custom budget limits for specific categories (e.g., Food, Transport, Shopping) with visual progress tracking.
* **Visual Analytics:** Interactive Pie and Bar charts to break down spending by category, providing actionable financial insights.
* **Transaction Management:** Easily log, categorize, and track daily expenses with a clean and intuitive user interface.

---

## 🛠 Technical Stack & Architecture

This project is built with industry-standard practices to ensure scalability, maintainability, and clean code separation.

* **Architecture: Modular MVVM** (Model-View-ViewModel) ensuring high testability and strict separation of concerns across different app features.
* **UI Framework: SwiftUI** utilizing declarative UI paradigms and the native Apple **Charts** framework for data visualization.
* **Local Database: SwiftData** for modern, efficient, and robust persistent storage of user transactions and budget configurations.
* **Security: LocalAuthentication** framework integration for biometric (Face ID/Touch ID) unlocks.
* **UI/UX Enhancements:** * **Native Dark Mode:** Fully optimized premium dark theme.
  * **Smooth State Transitions:** Clean visual feedback during data entry and navigation.

---

## 📸 Screenshots

| Security / PIN | Dashboard | Budget Tracker | Visual Analytics |
|---|---|---|---|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-22 at 00 23 09" src="https://github.com/user-attachments/assets/301d3331-b109-4bf9-9baa-e85589814df6" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-22 at 00 23 17" src="https://github.com/user-attachments/assets/116be655-8ca4-4688-bc16-cf9226abaac1" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-22 at 00 23 30" src="https://github.com/user-attachments/assets/80fe1a4f-e94c-4e92-a147-40fde5f233f0" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-22 at 00 23 38" src="https://github.com/user-attachments/assets/0ceedf9f-dd5b-452a-ab02-de2ab90db997" /> |

---

## ⚙️ Installation

1. Clone the repo: `git clone https://github.com/kiyotaka-kirito/Vigil.git`
2. Open `Vigil.xcodeproj` in Xcode 15 or later.
3. Select an iOS 17.0+ Simulator (e.g., iPhone 15 Pro).
4. Build and Run the project (`Cmd + R`).
