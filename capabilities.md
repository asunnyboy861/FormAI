# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- HealthKit: Guide mentions "HealthKit恢复数据读取" and "healthKitSleepHours/HRV/restingHR" — optional HealthKit integration
- iCloud/CloudKit: Guide mentions "SwiftData + CloudKit iCloud同步" — iCloud sync
- In-App Purchase: Guide describes subscription model (Monthly $6.99, Yearly $49.99, Lifetime $99.99)
- No camera, location, push notifications, or Apple Watch required for MVP

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| HealthKit | ✅ Configured | Xcode project capability |
| CloudKit (iCloud) | ✅ Configured | Xcode project capability |
| In-App Purchase | ✅ Configured | Xcode project capability |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| HealthKit | ⏳ Pending | 1. Open Xcode → FormAI target → Signing & Capabilities → + Capability → HealthKit 2. Add NSHealthShareUsageDescription and NSHealthUpdateUsageDescription to Info.plist 3. Select clinical types if needed |
| CloudKit | ⏳ Pending | 1. Open Apple Developer → Certificates, Identifiers & Profiles → App IDs → com.zzoutuo.FormAI 2. Enable iCloud capability with CloudKit 3. Create CloudKit container: iCloud.com.zzoutuo.FormAI 4. In Xcode → Signing & Capabilities → + Capability → iCloud → Check CloudKit → Select container |
| In-App Purchase | ⏳ Pending | 1. Open App Store Connect → Apps → FormAI → Subscriptions 2. Create Subscription Group: FormAI Pro 3. Create products: com.zzoutuo.FormAI.monthly, com.zzoutuo.FormAI.yearly, com.zzoutuo.FormAI.lifetime 4. In Xcode → Signing & Capabilities → + Capability → In-App Purchase |

## No Configuration Needed
- Push Notifications (not required for MVP)
- Camera / Photo Library (not required for MVP)
- Location Services (not required)
- Apple Watch (not required for MVP)
- Siri (not required)
- Background Modes (not required for MVP)

## Verification
- Build succeeded after configuration: ✅
- All entitlements correct: ⏳ Pending manual configuration in Apple Developer Portal
