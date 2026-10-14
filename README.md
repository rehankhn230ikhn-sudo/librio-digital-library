# 📚 LIBRIO — Digital Library & Manga Management Platform

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)

**LIBRIO** is a modern, responsive, glassmorphic web application for managing community digital libraries, books, manga, and reading materials. Powered by **Supabase Auth** and **PostgreSQL**, it offers seamless account management, role-based access control (RBAC), catalog browsing, community announcements, event calendars, and user book requests.

---

## 📑 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Architecture](#-project-architecture)
- [Directory Structure](#-directory-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Configure Supabase](#2-configure-supabase)
  - [3. Run the Database Schema](#3-run-the-database-schema)
  - [4. Update API Configuration](#4-update-api-configuration)
  - [5. Run Locally](#5-run-locally)
- [Admin Privileges Setup](#-admin-privileges-setup)
- [Database Schema & Security (RLS)](#-database-schema--security-rls)
- [Current Scope & Roadmap](#-current-scope--roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 🔐 Authentication & Role-Based Access Control
- **Supabase Authentication**: Secure user sign-up, login, and session persistence.
- **Automated Profile Creation**: PostgreSQL trigger creates a profile upon user registration.
- **Role System**: Supports standard `user` and privileged `admin` roles.
- **Dynamic UI**: Admin controls and management panels are conditionally rendered based on verified account roles.

### 📖 Digital Library & Manga Reader
- **Dual Content Types**: Organized sections for both standard books and Japanese manga.
- **In-App PDF Viewer**: Built-in modal reader to preview and read uploaded documents directly in the browser, with an "Open in new tab" option.
- **Live Search & Filter**: Real-time filtering by title, author, and genre/category with interactive category chips.
- **Dashboard Overview**: Metrics displaying total book count, active announcements, scheduled events, and recent additions.

### 📢 Community & Engagement
- **Announcements**: Broadcast board for library news and updates published by administrators.
- **Events Calendar**: Community events listings with details and dates.
- **Book Request Pipeline**: Registered members can request new acquisitions; users can monitor request status (`pending`, `approved`, `rejected`).

### 🛠️ Administration Panel
- Add new books & manga with cover images, descriptions, categories, and multiple PDF attachments.
- Manage and curate the entire catalog from a centralized table with quick actions.
- Publish and broadcast announcements and community events.
- Review, approve, or reject user book requests.

### 🎨 Design & Experience
- **Glassmorphism Aesthetic**: Modern glass styling, warm ambient background gradients, and smooth typography.
- **Dark / Light Mode**: Instant theme toggle with local memory persistence.
- **Fully Responsive**: Optimized for desktop monitors, tablets, and mobile screens.

---

## 🛠 Tech Stack

- **Frontend**:
  - Semantic **HTML5** & modern **CSS3** (CSS Variables, Flexbox, CSS Grid, Glassmorphism)
  - Vanilla **JavaScript (ES6+)**
  - **IndexedDB**: High-performance client-side storage for local offline reading and document caching
- **Backend & Database**:
  - **Supabase** (BaaS)
  - **PostgreSQL 15+** with Row Level Security (RLS) policies
  - **Supabase JS Client v2** (loaded via CDN)

---

## 📁 Directory Structure

```text
librio-multifile/
├── css/
│   └── style.css            # Glassmorphism styling, dark/light theme, responsive grid
├── js/
│   ├── app.js               # Application logic, UI controllers, IndexedDB, auth state
│   └── config.js            # Supabase API URL and Anon/Publishable key configuration
├── index.html               # Single-page web application structure and modals
├── supabase-schema.sql      # Database tables, triggers, and Row Level Security policies
├── .gitignore               # Standard Git ignore rules
└── README.md                # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

- A modern web browser (Chrome, Firefox, Edge, Safari).
- A local HTTP server (such as **VS Code Live Server**, `python -m http.server`, or Node's `npx serve`).
- A free account at [Supabase](https://supabase.com).

> [!IMPORTANT]
> Because LIBRIO uses ES modules, IndexedDB, and Supabase Auth callbacks, do **not** open `index.html` directly using the `file://` protocol. Always serve it through a local web server (`http://localhost:...`).

---

### 1. Clone the Repository

```bash
git clone https://github.com/rehankhn230ikhn-sudo/librio-digital-library.git
cd librio-digital-library
```

---

### 2. Configure Supabase

1. Go to [Supabase](https://supabase.com) and create a new project.
2. Navigate to **Project Settings → API**.
3. Copy your:
   - **Project URL**
   - **anon / public key**

> [!WARNING]
> Never expose your `service_role` or secret keys in front-end client code. Use only the `anon` / public key.

---

### 3. Run the Database Schema

1. In your Supabase Dashboard, open the **SQL Editor** from the left navigation bar.
2. Open the file [`supabase-schema.sql`](file:///supabase-schema.sql) from this repository.
3. Paste the contents into the SQL Editor and click **Run**.
4. This script sets up:
   - `public.profiles` table with automatic user creation trigger (`handle_new_user`).
   - `public.books` table for shared digital library records.
   - `public.announcements` table for news broadcasts.
   - `public.events` table for community schedule.
   - `public.book_requests` table with status workflow.
   - **Row Level Security (RLS)** policies on all tables.

---

### 4. Update API Configuration

Open [`js/config.js`](file:///js/config.js) in your editor and enter your Supabase credentials:

```javascript
// js/config.js
const SUPABASE_URL = "https://your-project-id.supabase.co";
const SUPABASE_ANON_KEY = "your-anon-publishable-key-here";
```

In your Supabase Dashboard under **Authentication → URL Configuration**:
- Set **Site URL** to your local dev address (e.g., `http://localhost:5500` or `http://127.0.0.1:5500`).
- Add any deployed URLs to **Redirect URLs**.

---

### 5. Run Locally

You can launch a local server using any of the following tools:

#### Using VS Code:
- Install the **Live Server** extension.
- Right-click `index.html` and select **Open with Live Server**.

#### Using Python:
```bash
# Python 3
python -m http.server 5500
```
Open [http://localhost:5500](http://localhost:5500) in your browser.

#### Using Node.js:
```bash
npx serve .
```

---

## 👑 Admin Privileges Setup

By default, any new account registered is assigned the standard `user` role. To promote an account to **Administrator**:

1. Register an account on your LIBRIO website with your preferred admin email.
2. Confirm the account email if email confirmations are enabled in your Supabase project.
3. Go to the **SQL Editor** in the Supabase Dashboard and run:

```sql
UPDATE public.profiles
SET role = 'admin'
WHERE id = (
  SELECT id FROM auth.users WHERE email = 'your-admin@email.com'
);
```

4. Sign out and log back in on the LIBRIO website. The **Admin** tab and management controls will now be unlocked!

---

## 🛡 Database Schema & Security (RLS)

All database tables are guarded with **Row Level Security**:

| Table | Read Access | Write / Management Access |
| :--- | :--- | :--- |
| `profiles` | Users can read their own profile (`auth.uid() = id`) | Users can update their own profile name |
| `books` | Authenticated users can view all books | Only verified administrators (`role = 'admin'`) |
| `announcements` | Authenticated users can read announcements | Only verified administrators |
| `events` | Authenticated users can view events | Only verified administrators |
| `book_requests` | Users view their own; Admins view all | Users insert own requests; Admins update status |

---

## 🔮 Current Scope & Roadmap

- [x] Responsive glassmorphic UI with light/dark modes
- [x] Supabase Auth authentication and session management
- [x] Client-side IndexedDB document reader & cover image storage
- [x] Book, Manga, Announcement, Event, and Request UI management
- [x] PostgreSQL database schema with RLS and admin policies
- [ ] Direct synchronization of uploaded PDF files with **Supabase Storage Buckets**
- [ ] Real-time database subscription (`supabase.channel`) for announcements and event updates
- [ ] User reading history, bookmarks, and favorite shelves

---

## 🤝 Contributing

Contributions, feedback, and feature requests are welcome!

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.
#   l i b r i o - d i g i t a l - l i b r a r y  
 