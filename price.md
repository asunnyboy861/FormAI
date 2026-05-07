# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: FormAI Pro
- **Group ID**: FormAI_Pro

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Pro
- **Product ID**: `com.zzoutuo.FormAI.monthly`
- **Price**: $6.99 per month
- **Display Name**: FormAI Pro Monthly
- **Description**: Full adaptive coaching, monthly
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Pro
- **Product ID**: `com.zzoutuo.FormAI.yearly`
- **Price**: $49.99 per year (40% savings vs monthly)
- **Display Name**: FormAI Pro Yearly
- **Description**: Full adaptive coaching, yearly
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.FormAI.lifetime`
- **Price**: $99.99 one-time
- **Display Name**: FormAI Pro Lifetime
- **Description**: All Pro features, forever
- **Note**: Allowed because all AI features use local deterministic algorithms with zero API cost

## Free Tier (Forever)

| Feature | Free | Pro |
|---------|------|-----|
| Workout logging (sets/reps/weight) | ✅ | ✅ |
| Basic progressive overload suggestions | ✅ | ✅ |
| Workout history | ✅ | ✅ |
| Custom exercises | ✅ | ✅ |
| 3 training templates | ✅ | ✅ |
| iCloud sync | ✅ | ✅ |
| Apple Fitness integration | ✅ | ✅ |
| Daily Readiness Check | ❌ | ✅ |
| AI adaptive adjustments | ❌ | ✅ |
| Periodized plan generation | ❌ | ✅ |
| Injury/pain exercise substitution | ❌ | ✅ |
| Progress charts & analysis | ❌ | ✅ |
| PR tracking & milestones | ❌ | ✅ |
| Unlimited training templates | ❌ | ✅ |
| Data export (CSV/JSON) | ❌ | ✅ |

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to monthly)

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented

## Competitive Price Comparison

| App | Free Tier | Monthly | Yearly | Lifetime | FormAI Advantage |
|-----|-----------|---------|--------|----------|------------------|
| Fitbod | 7-day trial | $12.99/mo | $79.99/yr | ❌ | 46% cheaper + lifetime option |
| Strong | Limited | $4.99/mo | $29.99/yr | ❌ | AI adaptive + readiness |
| Hevy | Yes | $4.99/mo | $39.99/yr | ❌ | Readiness + periodization |
| JEFIT | With ads | $12.99/mo | $69.99/yr | ❌ | 46% cheaper + AI adaptive |
| **FormAI** | **Yes** | **$6.99/mo** | **$49.99/yr** | **$99.99** | **Only app with lifetime + AI adaptive** |
