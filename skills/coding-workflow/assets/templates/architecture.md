# Project Architecture

## Overview

[Project description and core functionality]

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14+ (App Router) + TypeScript + Tailwind CSS |
| Backend | Next.js API Routes |
| Database | [PostgreSQL/Supabase/etc.] |
| Auth | [Supabase Auth/NextAuth/etc.] |

---

## Directory Structure

```
/
├── CLAUDE.md              # Project instructions for agents
├── task.json              # Task definitions
├── progress.txt           # Development history
├── init.sh                # Setup script
├── architecture.md        # This file
├── src/
│   ├── app/               # Next.js App Router pages
│   │   ├── api/           # API routes
│   │   └── (routes)/      # Page components
│   ├── components/        # Reusable components
│   │   ├── ui/            # Base UI components
│   │   └── features/      # Feature-specific components
│   ├── lib/               # Utilities and helpers
│   │   ├── db/            # Database access layer
│   │   └── utils.ts       # General utilities
│   ├── hooks/             # Custom React hooks
│   └── types/             # TypeScript type definitions
└── public/                # Static assets
```

---

## Data Model

[Database schema diagrams and entity relationships]

---

## API Design

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/resource | List resources |
| POST | /api/resource | Create resource |
| GET | /api/resource/:id | Get single resource |
| PATCH | /api/resource/:id | Update resource |
| DELETE | /api/resource/:id | Delete resource |

---

## Key Design Decisions

1. **[Decision 1]**: [Rationale]
2. **[Decision 2]**: [Rationale]

---

## Environment Variables

```env
# Required
DATABASE_URL=
NEXT_PUBLIC_API_URL=

# Optional
DEBUG=
```
