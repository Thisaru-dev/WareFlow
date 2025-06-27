# 🏗️ WareFlow System Architecture

This document outlines the high-level architecture of the WareFlow app.

## 🧰 Tech Stack
- **Frontend:** Flutter
- **Backend:** Firebase Firestore, Firebase Authentication
- **State Management:** Provider
- **Database Model:** Firestore Collections & Documents

## 🧱 Main Collections

- `users`: user profile info including role & companyId
- `companies`: stores company profiles
- `items`: inventory items
- `suppliers`: linked to items
- `purchaseOrders`, `salesOrders`: for order flow
- `grns`, `returns`, `dispatches`: flow tracking

## 🔄 Data Flow

1. User logs in → Authenticated with Firebase
2. User selects company (if linked to multiple)
3. Role-based dashboard loads relevant data from Firestore
4. All create/update/delete actions are real-time via Firestore SDK

## 🛡️ Security

- Firebase Auth for identity
- Firestore security rules for role- and company-based access
