# MVP Build Plan (8 Weeks)

## Vision

Life Admin Autopilot helps people stay on top of recurring life obligations with low mental overhead.

## Product boundaries

### In scope

- Recurring life cycles and deadlines
- Document and process guidance
- Subscription oversight and renewal alerts
- Policy-based reminder and escalation rules
- Sync handoff to external execution tools (Apple Reminders/Calendar first)

### Out of scope for MVP

- Generic task manager functionality
- Full investment or accounting workflows
- Heavy social network features

## Delivery phases

### Week 1 — Foundation

- Finalize IA and core cycle taxonomy
- Define Firestore schema + security assumptions
- Implement authentication shell (anonymous, Google, email)

### Week 2 — Core cycle engine

- Cycle CRUD
- Recurrence + lead-time reminder logic
- Dashboard sections (Overdue, Soon, Upcoming)

### Week 3 — Document module

- Document templates (passport, driver license, tax cycle)
- Due-date timeline views
- Required artifact checklist

### Week 4 — Subscription module

- Manual subscription creation/editing
- Renewal and trial-expiry reminders
- Cancellation action templates

### Week 5 — Policy engine v1

- Rule builder with template presets
- Trigger-action execution (local + cloud assisted)
- Criticality and escalation levels

### Week 6 — Integrations + reminders

- Apple Reminders sync adapter
- Calendar event suggestion flow
- Push notification routing strategy

### Week 7 — Medical bill + relationship cadence (light)

- Medical bill case tracker and status timeline
- Relationship cadence entity with reminder intervals
- QA hardening for core data paths

### Week 8 — Stabilize and beta

- Edge case handling
- Crash/performance pass
- Beta checklist and analytics instrumentation

## Release criteria

- User can onboard anonymously and later link account
- User can create at least 3 cycle types and receive reminders
- Rule engine applies at least one trigger-action policy per cycle
- Subscription cycle reminders and dashboard statuses are reliable
