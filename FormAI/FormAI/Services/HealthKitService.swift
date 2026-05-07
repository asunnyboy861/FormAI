import Foundation
import HealthKit

@Observable
final class HealthKitService {
    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }
    var isAuthorized: Bool = false
    var sleepHours: Double?
    var hrv: Double?
    var restingHR: Double?

    private let healthStore = HKHealthStore()

    func requestAuthorization() async -> Bool {
        guard isAvailable else { return false }

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let restingHRType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!

        let typesToRead: Set<HKObjectType> = [sleepType, hrvType, restingHRType]

        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            isAuthorized = true
            await fetchLatestData()
            return true
        } catch {
            return false
        }
    }

    func fetchLatestData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchSleep() }
            group.addTask { await self.fetchHRV() }
            group.addTask { await self.fetchRestingHR() }
        }
    }

    private func fetchSleep() async {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -1, to: Date()), end: Date())
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 10, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else { return }
            let totalHours = samples.reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) / 3600 }
            DispatchQueue.main.async { self.sleepHours = totalHours }
        }
        healthStore.execute(query)
    }

    private func fetchHRV() async {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -1, to: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: hrvType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let value = result?.averageQuantity()?.doubleValue(for: HKUnit.secondUnit(with: .milli)) else { return }
            DispatchQueue.main.async { self.hrv = value }
        }
        healthStore.execute(query)
    }

    private func fetchRestingHR() async {
        guard let hrType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -1, to: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: hrType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let value = result?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) else { return }
            DispatchQueue.main.async { self.restingHR = value }
        }
        healthStore.execute(query)
    }
}
