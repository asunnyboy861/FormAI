# FormAI - iOS Development Guide

## Executive Summary

FormAI is an AI-adaptive workout coach for iOS that solves the #1 problem in fitness apps: static programs that don't adapt to daily readiness. Unlike competitors that offer either rigid preset plans (Strong, JEFIT) or black-box AI (Fitbod), FormAI delivers transparent, science-based adaptive training powered by a deterministic Readiness Engine — not an LLM.

**Target Audience**: US-based gym-goers and home lifters (25-45) who want smart, adaptive strength training without the complexity of hiring a personal trainer.

**Key Differentiators**:
- Daily Readiness Score (4-dimension: energy, sleep, soreness, motivation) drives automatic workout adjustments
- Transparent AI decisions — every adjustment shows "why" (unlike Fitbod's black box)
- Periodized training plans with Foundation → Build → Peak → Deload phases
- Deterministic algorithm (not LLM) ensures safe, science-based progression
- Zero-config onboarding — start training in under 30 seconds
- Optional HealthKit integration for enhanced recovery data

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| **Fitbod** ($12.99/mo) | AI-adaptive workouts, 900+ exercises, equipment-aware | Black-box algorithm, no transparency, expensive, no periodization | Transparent AI with reasoning, periodized plans, 46% cheaper |
| **Strong** ($4.99/mo) | Best-in-class logging, clean UI, Apple Watch sync | No AI adaptation, static plans, no readiness tracking | Full adaptive engine + readiness score + periodization |
| **JEFIT** ($12.99/mo) | 1400+ exercises, community templates, smartwatch | No dynamic programming, manual fatigue management, cluttered UI | AI-driven adjustment, zero-friction UX, clean interface |
| **Hevy** ($4.99/mo) | Free tier, social features, clean design | Simple algorithm, no readiness tracking, limited periodization | Readiness-driven adaptation + full periodization + PR tracking |
| **Nike Training Club** (Free) | Professional content, great video demos | Preset courses, no personalization, no adaptive AI | Fully personalized, adaptive, data-driven |
| **Flux Workouts** ($7.99/mo) | Auto-progression, iOS native | Limited features, no readiness score, small user base | More complete periodization + recovery integration |

## Apple Design Guidelines Compliance

- **HealthKit**: Request permission only when user enables HealthKit integration in Settings; never on first launch. Follow HIG privacy guidelines for health data.
- **Dark Mode Native**: Primary design targets dark mode (gym environment); full light mode support via semantic colors.
- **Accessibility**: Dynamic Type support, minimum 4.5:1 contrast ratio, VoiceOver labels on all interactive elements.
- **Tab Bar**: Standard 4-tab layout (Today, Workout, Plan, Progress) following HIG tab bar guidelines.
- **Haptics**: Use UIImpactFeedbackGenerator for key interactions (PR achieved, workout complete, readiness check).
- **Privacy**: All data stored locally via SwiftData; CloudKit sync optional; no third-party analytics.
- **SF Symbols**: Use system symbols for all icons; custom symbols only for brand-specific elements.

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), SwiftData (persistence), CloudKit (sync)
- **Architecture**: MVVM + @Observable
- **Minimum iOS**: 17.0
- **Data**: SwiftData (local default), CloudKit (optional iCloud sync)
- **Health**: HealthKit (optional, for sleep/HRV/resting HR data)
- **Charts**: Swift Charts (progress visualization)
- **Store**: StoreKit 2 (in-app purchases)
- **Haptics**: UIKit feedback generators

## Module Structure

```
FormAI/
├── FormAIApp.swift
├── Models/
│   ├── Exercise.swift
│   ├── WorkoutSession.swift
│   ├── ExerciseRecord.swift
│   ├── SetRecord.swift
│   ├── ReadinessScore.swift
│   ├── TrainingPlan.swift
│   ├── TrainingPhase.swift
│   └── Enums.swift
├── ViewModels/
│   ├── WorkoutViewModel.swift
│   ├── ReadinessViewModel.swift
│   ├── PlanViewModel.swift
│   ├── HistoryViewModel.swift
│   ├── ProgressViewModel.swift
│   └── PurchaseManager.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Today/
│   │   ├── TodayView.swift
│   │   ├── ReadinessCheckView.swift
│   │   └── TodaysWorkoutView.swift
│   ├── Workout/
│   │   ├── ActiveWorkoutView.swift
│   │   ├── ExerciseRowView.swift
│   │   └── SetInputView.swift
│   ├── Plan/
│   │   ├── PlanOverviewView.swift
│   │   └── PhaseDetailView.swift
│   ├── History/
│   │   ├── HistoryListView.swift
│   │   └── SessionDetailView.swift
│   ├── Progress/
│   │   ├── ProgressDashboardView.swift
│   │   └── ExerciseChartView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── ContactSupportView.swift
│   │   └── PaywallView.swift
│   └── Shared/
│       └── ReadinessGaugeView.swift
├── Services/
│   ├── AdaptiveProgressionService.swift
│   ├── ReadinessEngine.swift
│   ├── PlanGenerator.swift
│   ├── InjuryAdapter.swift
│   ├── HealthKitService.swift
│   ├── HapticService.swift
│   └── PurchaseManager.swift
└── Utilities/
    └── PreviewSampleData.swift
```

## Implementation Flow

1. Set up SwiftData models (Exercise, WorkoutSession, ExerciseRecord, SetRecord, ReadinessScore, TrainingPlan, TrainingPhase)
2. Implement ReadinessEngine (core scoring + adjustment logic)
3. Implement AdaptiveProgressionService (weight/rep/set/RPE suggestions)
4. Implement PlanGenerator (periodized plan creation)
5. Build OnboardingView (5-step quick setup)
6. Build TodayView + ReadinessCheckView (daily entry point)
7. Build ActiveWorkoutView + SetInputView (workout logging)
8. Build PlanOverviewView + PhaseDetailView (plan visualization)
9. Build ProgressDashboardView + ExerciseChartView (Swift Charts)
10. Build HistoryListView + SessionDetailView (workout history)
11. Implement HealthKitService (optional sleep/HRV/HR data)
12. Implement PurchaseManager (StoreKit 2 + PaywallView)
13. Build SettingsView + ContactSupportView
14. Integrate all views in TabView within FormAIApp.swift

## UI/UX Design Specifications

### Color Scheme
- **Primary**: Electric Blue (#0A84FF) — main actions, emphasis
- **Background Dark**: Deep Navy (#1C1C1E) — dark mode
- **Background Light**: Pure White (#FFFFFF) — light mode
- **Success**: Green (#30D158) — PR achieved, workout complete
- **Warning**: Orange (#FF9F0A) — moderate readiness, attention needed
- **Danger**: Red (#FF453A) — overtraining warning, pain marker
- **Recovery**: Purple (#BF5AF2) — deload, rest day

### Readiness Score Gradient
- 0-25: Red → Orange (rest needed)
- 25-50: Orange → Yellow (scale down)
- 50-75: Yellow → Green (maintain)
- 75-100: Green → Blue (scale up)

### Typography
- Large Title: SF Pro Rounded Bold 34pt
- Page Title: SF Pro Rounded Semibold 28pt
- Section Title: SF Pro Semibold 22pt
- Body: SF Pro Regular 17pt
- Caption: SF Pro Regular 14pt
- Numbers (weight/reps): SF Pro Rounded Bold 20pt
- Readiness Score: SF Pro Rounded Black 72pt

### Layout Rules
- Gym-first: large tap targets (min 44pt), high contrast
- iPad: max content width 720pt, centered
- Zero-friction: 30-second readiness check, one-tap workout start
- Transparency: every AI suggestion shows reasoning text

### Tab Bar
- Today (house icon): Readiness Check + Today's Workout
- Workout (dumbbell icon): Active Workout / Quick Start
- Plan (list icon): Periodization Overview / Future Schedule
- Progress (chart icon): Charts / PRs / Trends

## Code Generation Rules

- Single responsibility: one feature per module
- MVVM pattern: View + ViewModel per feature
- SwiftData @Model for all persistent entities
- All SwiftData attributes must be optional or have default values
- All SwiftData relationships must have inverse relationships
- @Observable macro for ViewModels (not ObservableObject)
- No code comments unless explicitly requested
- SF Symbols for all icons
- Semantic colors for dark/light mode support
- iPad layout: .frame(maxWidth: 720).frame(maxWidth: .infinity) for ScrollView content
- Never use .tabViewStyle(.sidebarAdaptable)

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.FormAI
2. Verify Deployment Target: iOS 17.0
3. Configure HealthKit capability + entitlements
4. Configure CloudKit capability + entitlements
5. Configure In-App Purchase capability
6. Add App Icon to Asset Catalog (1024x1024)
7. Build on iPhone XS Max simulator
8. Build on iPad Pro 13-inch (M4) simulator
9. Push to GitHub repository
10. Deploy policy pages to GitHub Pages
11. Generate App Store Connect metadata
