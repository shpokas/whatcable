import XCTest
@testable import WhatCableCore

/// Unit tests for TRMTransport model.
final class TRMTransportTests: XCTestCase {

    // MARK: - Basic properties

    func testIsRestrictedWhenStateIs2() {
        let t = makeTRM(state: 2, transportRestricted: nil)
        XCTAssertTrue(t.isRestricted)
    }

    func testIsRestrictedWhenTransportRestrictedTrue() {
        let t = makeTRM(state: nil, transportRestricted: true)
        XCTAssertTrue(t.isRestricted)
    }

    func testNotRestrictedWhenStateIs0() {
        let t = makeTRM(state: 0, transportRestricted: false)
        XCTAssertFalse(t.isRestricted)
    }

    func testNotRestrictedWhenAllNil() {
        let t = makeTRM(state: nil, transportRestricted: nil)
        XCTAssertFalse(t.isRestricted)
    }

    // MARK: - Summary label

    func testSummaryLabelWithStateDescription() {
        let t = makeTRM(transportType: "USB2", stateDescription: "Limited")
        XCTAssertEqual(t.summaryLabel, "USB2: Limited")
    }

    func testSummaryLabelFallsBackToSupervised() {
        let t = makeTRM(transportType: "DisplayPort", stateDescription: nil, transportSupervised: true)
        XCTAssertEqual(t.summaryLabel, "DisplayPort: Supervised")
    }

    func testSummaryLabelFallsBackToUnknown() {
        let t = makeTRM(transportType: "CIO", stateDescription: nil, transportSupervised: nil)
        XCTAssertEqual(t.summaryLabel, "CIO: Unknown")
    }

    // MARK: - Equatable / Hashable

    func testEquatable() {
        let a = makeTRM(id: 1, state: 2)
        let b = makeTRM(id: 1, state: 2)
        XCTAssertEqual(a, b)
    }

    func testNotEqualWhenStateDiffers() {
        let a = makeTRM(id: 1, state: 0)
        let b = makeTRM(id: 1, state: 2)
        XCTAssertNotEqual(a, b)
    }

    func testHashable() {
        let a = makeTRM(id: 1, transportType: "USB2")
        let b = makeTRM(id: 2, transportType: "DisplayPort")
        let set: Set<TRMTransport> = [a, b, a]
        XCTAssertEqual(set.count, 2)
    }

    // MARK: - Full init preserves all fields

    func testFullInit() {
        let t = TRMTransport(
            id: 42,
            portKey: "0/2",
            transportType: "USB2",
            state: 2,
            stateDescription: "Limited",
            transportRestricted: true,
            transportSupervised: true,
            identificationRestricted: false,
            deviceLocked: false,
            relaxedPeriod: true,
            gracePeriodReason: 4,
            gracePeriodReasonDescription: "Device Unlocked",
            profile: 2,
            profileDescription: "Ask for New Accessories",
            cacheMiss: false
        )
        XCTAssertEqual(t.id, 42)
        XCTAssertEqual(t.portKey, "0/2")
        XCTAssertEqual(t.transportType, "USB2")
        XCTAssertEqual(t.state, 2)
        XCTAssertEqual(t.stateDescription, "Limited")
        XCTAssertEqual(t.transportRestricted, true)
        XCTAssertEqual(t.transportSupervised, true)
        XCTAssertEqual(t.identificationRestricted, false)
        XCTAssertEqual(t.deviceLocked, false)
        XCTAssertEqual(t.relaxedPeriod, true)
        XCTAssertEqual(t.gracePeriodReason, 4)
        XCTAssertEqual(t.gracePeriodReasonDescription, "Device Unlocked")
        XCTAssertEqual(t.profile, 2)
        XCTAssertEqual(t.profileDescription, "Ask for New Accessories")
        XCTAssertEqual(t.cacheMiss, false)
    }

    func testMinimalInit() {
        let t = TRMTransport(
            id: 1,
            portKey: "0/4",
            transportType: "DisplayPort",
            state: nil,
            stateDescription: nil,
            transportRestricted: nil,
            transportSupervised: false,
            identificationRestricted: nil,
            deviceLocked: nil,
            relaxedPeriod: nil,
            gracePeriodReason: nil,
            gracePeriodReasonDescription: nil,
            profile: nil,
            profileDescription: nil,
            cacheMiss: nil
        )
        XCTAssertNil(t.state)
        XCTAssertNil(t.stateDescription)
        XCTAssertFalse(t.isRestricted)
        XCTAssertEqual(t.transportSupervised, false)
    }

    // MARK: - CableSnapshot backward compatibility

    func testCableSnapshotDefaultsToEmptyTRM() {
        let snapshot = CableSnapshot(
            ports: [], powerSources: [], identities: [],
            usbDevices: [], adapter: nil
        )
        XCTAssertTrue(snapshot.trmTransports.isEmpty)
    }

    // MARK: - Helpers

    private func makeTRM(
        id: UInt64 = 1,
        portKey: String = "0/2",
        transportType: String = "USB2",
        state: Int? = nil,
        stateDescription: String? = nil,
        transportRestricted: Bool? = nil,
        transportSupervised: Bool? = nil
    ) -> TRMTransport {
        TRMTransport(
            id: id,
            portKey: portKey,
            transportType: transportType,
            state: state,
            stateDescription: stateDescription,
            transportRestricted: transportRestricted,
            transportSupervised: transportSupervised,
            identificationRestricted: nil,
            deviceLocked: nil,
            relaxedPeriod: nil,
            gracePeriodReason: nil,
            gracePeriodReasonDescription: nil,
            profile: nil,
            profileDescription: nil,
            cacheMiss: nil
        )
    }
}
