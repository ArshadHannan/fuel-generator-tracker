# Fuel Tracker

A Flutter app for tracking diesel generator fuel usage and runtime during power outages. Built on Firebase/Firestore for persistence.

## Scenario

A factory operates multiple diesel generators during power outages. Each generator has a unique name/code, a fuel tank capacity, and a fuel consumption rate (liters/hour). The app tracks runtime hours and fuel added per generator to calculate remaining fuel, forecast refueling needs, and generate usage reports.

## Features

- **Generators** — add, view, update, and delete generators (name, location, tank capacity, usage rate)
- **Runtime logging** — log hours run per generator per day; blocks logging more hours than the generator's current fuel can sustain
- **Fuel logging** — log liters refueled and price per liter per generator per day; remembers the last price entered; blocks adding more liters than the tank has room for
- **Remaining fuel** — calculated live (not stored) from tank capacity, usage rate, logged runtime, and logged refuels: `capacity − (Σ runtime hours × usage rate) + Σ liters added`
- **Reports** — per-generator usage report: estimated vs. actual fuel consumption rate, and a running fuel-balance table by date. Exportable as PDF
- **App info** — app name, version, and build number read at runtime via `package_info_plus` (not hardcoded)

## Tech stack

- Flutter / Dart
- Firebase (Cloud Firestore) for data persistence, with security rules validating schema per collection
- `package_info_plus` — runtime app metadata
- `pdf` / `printing` — PDF report generation and sharing

## Firestore data model

- `generators` — `name`, `location`, `fuelCapacity`, `fuelUsage`, `createdDate`, `createdAt`
- `runtime_logs` — `generatorId`, `generatorName`, `date`, `hours`, `createdAt`
- `fuel_logs` — `generatorId`, `generatorName`, `date`, `liters`, `pricePerLiter`, `createdAt`

Security rules (`firestore.rules`) restrict writes to these three collections with per-field type/shape validation; all other paths are denied by default.

## Getting started

```
flutter pub get
flutter run
```

Firebase config (`google-services.json`, `firebase_options.dart`) is already committed and points at the project's Firestore instance — no additional setup needed to run the app.

To deploy rule changes:

```
firebase deploy --only firestore:rules --project fuel-tracker-1d754
```
