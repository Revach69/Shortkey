//
//  ActionsManagerTests.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import XCTest
@testable import Spellify

final class ActionsManagerTests: XCTestCase {
    
    var sut: ActionsManager!
    var testDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: "ActionsManagerTests")!
        testDefaults.removePersistentDomain(forName: "ActionsManagerTests")
        sut = ActionsManager(defaults: testDefaults)
    }
    
    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "ActionsManagerTests")
        sut = nil
        testDefaults = nil
        super.tearDown()
    }
    
    // MARK: - Default Actions Tests
    
    func test_init_createsDefaultActions_onFirstLaunch() {
        XCTAssertEqual(sut.actions.count, 2)
        XCTAssertEqual(sut.actions[0].name, "Fix Grammar")
        XCTAssertEqual(sut.actions[1].name, "Translate to Spanish")
    }
    
    // MARK: - Add Tests
    
    func test_add_appendsActionToList() {
        let newAction = SpellAction(name: "Test Action", prompt: "Test prompt")
        
        sut.add(newAction)
        
        XCTAssertEqual(sut.actions.count, 3)
        XCTAssertEqual(sut.actions.last?.name, "Test Action")
    }
    
    func test_add_persistsToDefaults() {
        let newAction = SpellAction(name: "Persisted Action", prompt: "Prompt")
        
        sut.add(newAction)
        
        // Create new manager with same defaults
        let newManager = ActionsManager(defaults: testDefaults)
        
        XCTAssertEqual(newManager.actions.count, 3)
        XCTAssertEqual(newManager.actions.last?.name, "Persisted Action")
    }
    
    // MARK: - Update Tests
    
    func test_update_modifiesExistingAction() {
        var action = sut.actions[0]
        action.name = "Updated Name"
        action.prompt = "Updated Prompt"
        
        sut.update(action)
        
        XCTAssertEqual(sut.actions[0].name, "Updated Name")
        XCTAssertEqual(sut.actions[0].prompt, "Updated Prompt")
    }
    
    func test_update_doesNothing_whenActionNotFound() {
        let unknownAction = SpellAction(name: "Unknown", prompt: "Prompt")
        let originalCount = sut.actions.count
        
        sut.update(unknownAction)
        
        XCTAssertEqual(sut.actions.count, originalCount)
    }
    
    // MARK: - Delete Tests
    
    func test_delete_removesActionFromList() {
        let actionToDelete = sut.actions[0]
        
        sut.delete(actionToDelete)
        
        XCTAssertEqual(sut.actions.count, 1)
        XCTAssertFalse(sut.actions.contains(where: { $0.id == actionToDelete.id }))
    }
    
    func test_deleteAtOffsets_removesCorrectAction() {
        let firstActionId = sut.actions[0].id
        
        sut.delete(at: IndexSet(integer: 0))
        
        XCTAssertEqual(sut.actions.count, 1)
        XCTAssertFalse(sut.actions.contains(where: { $0.id == firstActionId }))
    }
    
    // MARK: - Move Tests
    
    func test_move_reordersActions() {
        let firstAction = sut.actions[0]
        let secondAction = sut.actions[1]
        
        sut.move(from: IndexSet(integer: 0), to: 2)
        
        XCTAssertEqual(sut.actions[0].id, secondAction.id)
        XCTAssertEqual(sut.actions[1].id, firstAction.id)
    }
}


