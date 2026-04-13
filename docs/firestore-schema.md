# Firestore Schema (MVP Draft)

All user data is scoped under `/users/{uid}`.

## Collections

### `/users/{uid}`

- `createdAt: Timestamp`
- `updatedAt: Timestamp`
- `displayName: String?`
- `email: String?`
- `primaryAuthProvider: String` (`anonymous`, `google`, `password`)

### `/users/{uid}/cycles/{cycleId}`

- `title: String`
- `type: String` (`document`, `tax`, `subscription`, `medical_bill`, `relationship`, `custom`)
- `status: String` (`active`, `paused`, `completed`)
- `criticality: String` (`low`, `medium`, `high`, `urgent`)
- `nextDueDate: Timestamp`
- `recurrenceRule: Map`
  - `intervalUnit: String` (`day`, `week`, `month`, `year`)
  - `intervalValue: Number`
- `leadTimesDays: Array<Number>`
- `ownerUid: String`
- `notes: String?`
- `createdAt: Timestamp`
- `updatedAt: Timestamp`

### `/users/{uid}/documents/{documentId}`

- `cycleId: String`
- `documentType: String`
- `issuingAuthority: String?`
- `issueDate: Timestamp?`
- `expiryDate: Timestamp?`
- `requiredItems: Array<String>`
- `storageRef: String?` (Cloud Storage path when enabled)
- `createdAt: Timestamp`
- `updatedAt: Timestamp`

### `/users/{uid}/subscriptions/{subscriptionId}`

- `name: String`
- `billingAmount: Number`
- `billingCurrency: String`
- `billingCadence: String` (`weekly`, `monthly`, `yearly`)
- `renewalDate: Timestamp`
- `trialEndsAt: Timestamp?`
- `cancellationUrl: String?`
- `status: String` (`active`, `pending_cancel`, `cancelled`)
- `createdAt: Timestamp`
- `updatedAt: Timestamp`

### `/users/{uid}/rules/{ruleId}`

- `name: String`
- `enabled: Boolean`
- `triggerType: String` (`due_in_days`, `overdue`, `status_changed`)
- `triggerConfig: Map`
- `actionType: String` (`push_notify`, `create_integration_task`, `escalate`)
- `actionConfig: Map`
- `priority: Number`
- `createdAt: Timestamp`
- `updatedAt: Timestamp`

### `/users/{uid}/integrationTasks/{taskId}`

- `provider: String` (`apple_reminders`, `apple_calendar`)
- `externalId: String?`
- `sourceType: String` (`cycle`, `subscription`, `medical_bill`, `relationship`)
- `sourceId: String`
- `payload: Map`
- `status: String` (`queued`, `synced`, `failed`)
- `lastError: String?`
- `createdAt: Timestamp`
- `updatedAt: Timestamp`

### `/users/{uid}/reminders/{reminderId}`

- `sourceType: String`
- `sourceId: String`
- `scheduledAt: Timestamp`
- `deliveredAt: Timestamp?`
- `channel: String` (`push`, `in_app`)
- `status: String` (`scheduled`, `delivered`, `failed`, `dismissed`)
- `createdAt: Timestamp`
