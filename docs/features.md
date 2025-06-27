# 🌟 Features of WareFlow

**WareFlow** is a role-based warehouse and inventory management mobile app designed for businesses that distribute goods across multiple locations. Built using **Flutter** and **Firebase**, it ensures streamlined stock control, order handling, and user management.

---

## 👥 User Management

- ✅ **Invitation-based Registration**: Only admins can invite users by email; users set their password via a secure link.
- 👑 **Role-Based Access Control**:
  - **Admin**: Full access to all features, company setup, user management.
  - **Warehouse Staff**: Inventory control, stock receiving, item requests.
  - **Sales Staff**: Sales order handling, returns, dispatch access.
- 🏢 **Multi-Company Support**: Users can belong to multiple companies and switch between them.

---

## 📦 Inventory Management

- 📋 Add, update, or delete items with categories and supplier linkage.
- 📍 Warehouse-based stock tracking to manage inventory location-wise.
- 🔎 Stock availability check before creating orders.

---

## 🤝 Supplier Management

- 🧾 Add suppliers and associate them with items.
- 📥 Enable staff to request new items (admin approval required).
- 📧 Automatic invoice generation and email to suppliers upon approval.

---

## 📑 Purchase Order Workflow

- 🛒 Create and send purchase orders to suppliers.
- ✅ Record goods received (GRN - Goods Received Note).
- 🔁 Handle purchase returns (based on failed quality checks).
- 📊 Track order status: *Pending*, *Partially Received*, *Completed*.

---

## 🛍️ Sales Order Workflow

- 📝 Create and manage customer orders.
- 🧾 Generate invoices (admin approval optional).
- 🚚 Dispatch tracking with linked packages.
- 🔁 Manage sales returns with reasons and item conditions.

---

## 🔄 Returns Management

- 📂 Unified Return Page with two tabs:
  - **Purchase Returns** – from suppliers (QC failed)
  - **Sales Returns** – from customers
- 🛠 Item-based return forms with notes and quantity fields.

---

## 🚚 Dispatch & Packaging

- 📦 Assign multiple items to a package.
- ➕ Link dispatch info to packages.
- 🗂 View package contents and dispatch history.

---

## 📊 Reporting & Analytics *(Coming Soon)*

- 📈 Sales trends & order statistics.
- 🧮 Stock level and movement reports.
- 🔁 Return rate and frequency dashboards.

---

## 🛡️ Security & Access

- 🔐 Firebase Authentication
- 🔐 Firestore Security Rules for role- and company-based access
- 🔒 Password reset & account protection

---

## 📱 Tech Stack

- **Frontend**: Flutter + Provider
- **Backend**: Firebase Firestore & Authentication
- **Database**: Firestore NoSQL
- **State Management**: Provider
