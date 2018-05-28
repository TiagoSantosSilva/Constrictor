////
////  UIView+ConstrictorTests.swift
////  ConstrictorTests
////
////  Created by Pedro Carrasco on 23/05/2018.
////  Copyright © 2018 Pedro Carrasco. All rights reserved.
////

import XCTest
@testable import Constrictor

class UIViewConstrictorTests: XCTestCase, ConstraintTestable {

    // MARK: Constants
    enum Constants {

        static let constant: CGFloat = 50.0
        static let multiplier: CGFloat = 0.5
    }

    // MARK: Properties
    var viewController: UIViewController!
    var aView: UIView!
    var bView: UIView!

    // MARK: Lifecycle
    override func setUp() {
        super.setUp()

        aView = UIView()
        bView = UIView()

        viewController = UIViewController()
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {

        aView = nil
        bView = nil

        super.tearDown()
    }

    // MARK: Test - constrict(_ relation: NSLayoutRelation = .equal, to item: Constrictable? = nil, ...
    func testConstrictAtEdges() {

        // Setup
        viewController.view.addSubview(aView)
        aView.constrict(.top, to: viewController, attribute: .top, constant: Constants.constant)
            .constrict(.bottom, to: viewController, attribute: .bottom, multiplier: Constants.multiplier)
            .constrict(.trailing, relation: .greaterThanOrEqual, to: viewController, attribute: .trailing)
            .constrict(.leading, to: viewController, attribute: .leading)

        // Tests
        XCTAssertEqual(viewController.view.constraints.count, 4)

        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
        let leadingConstraints = viewController.view.findConstraints(for: .leading, relatedTo: aView)
        let trailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: aView)

        XCTAssertEqual(topConstraints.count, 1)
        XCTAssertEqual(bottomConstraints.count, 1)
        XCTAssertEqual(leadingConstraints.count, 1)
        XCTAssertEqual(trailingConstraints.count, 1)

        guard let topConstraint = topConstraints.first,
            let bottomConstraint = bottomConstraints.first,
            let leadingConstraint = leadingConstraints.first,
            let trailingConstraint = trailingConstraints.first
            else { return XCTFail() }

        testConstraint(topConstraint, constant: Constants.constant)
        testConstraint(bottomConstraint, multiplier: Constants.multiplier)
        testConstraint(leadingConstraint)
        testConstraint(trailingConstraint, relation: .greaterThanOrEqual)
    }

    func testConstrictAtEdgesGuides() {

        // Setup
        viewController.view.addSubview(aView)
        aView.constrict(.topGuide, to: viewController, attribute: .top)
            .constrict(.bottomGuide, to: viewController, attribute: .bottom)
            .constrict(.trailingGuide, to: viewController, attribute: .trailing)
            .constrict(.leadingGuide, to: viewController, attribute: .leading)

        // Tests
        XCTAssertEqual(viewController.view.constraints.count, 4)

        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
        let leadingConstraints = viewController.view.findConstraints(for: .leading, relatedTo: aView)
        let trailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: aView)

        XCTAssertEqual(topConstraints.count, 1)
        XCTAssertEqual(bottomConstraints.count, 1)
        XCTAssertEqual(leadingConstraints.count, 1)
        XCTAssertEqual(trailingConstraints.count, 1)

        guard let topConstraint = topConstraints.first,
            let bottomConstraint = bottomConstraints.first,
            let leadingConstraint = leadingConstraints.first,
            let trailingConstraint = trailingConstraints.first
            else { return XCTFail() }

        testConstraint(topConstraint)
        testConstraint(bottomConstraint)
        testConstraint(leadingConstraint)
        testConstraint(trailingConstraint)
    }

    func testConstrictAtTwoViewsCenterWidthHeight() {

        // Setup aView
        viewController.view.addSubview(aView)
        aView.constrict(.centerX, to: viewController, attribute: .centerX, constant: Constants.constant)
            .constrict(.centerY, to: viewController, attribute: .centerY)
            .constrict(.width, constant: Constants.constant)
            .constrict(.height, constant: Constants.constant)

        // Setup bView
        viewController.view.addSubview(bView)
        bView.constrict(.centerY, to: aView, attribute: .centerY)
            .constrict(.width, to: aView, attribute: .width)
            .constrict(.height, constant: Constants.constant)
            .constrict(.trailing, relation: .greaterThanOrEqual, to: aView, attribute: .leading, constant: Constants.constant)

        // Test aView
        XCTAssertEqual(viewController.view.constraints.count, 5)

        let centerXConstraints = viewController.view.findConstraints(for: .centerX, relatedTo: aView)
        let centerYConstraints = viewController.view.findConstraints(for: .centerY, relatedTo: aView)
        let widthConstraints = aView.findConstraints(for: .width, at: .secondItem)
        let heightConstraints = aView.findConstraints(for: .height, at: .secondItem)
        
        XCTAssertEqual(centerXConstraints.count, 1)
        XCTAssertEqual(centerYConstraints.count, 1)
        XCTAssertEqual(widthConstraints.count, 1)
        XCTAssertEqual(heightConstraints.count, 1)

        guard let centerXConstraint = centerXConstraints.first,
            let centerYConstraint = centerYConstraints.first,
            let widthConstraint = widthConstraints.first,
            let heightConstraint = heightConstraints.first
            else { return XCTFail() }

        testConstraint(centerXConstraint, constant: Constants.constant)
        testConstraint(centerYConstraint)
        testConstraint(widthConstraint, constant: Constants.constant)
        testConstraint(heightConstraint, constant: Constants.constant)

        // Test bView
        let bCenterYConstraints = viewController.view.findConstraints(for: .centerY, relatedTo: bView)
        let bWidthConstraints = viewController.view.findConstraints(for: .width, relatedTo: bView, at: .firstItem)
        let bHeightConstraints = bView.findConstraints(for: .height, at: .secondItem)
        let bTrailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: bView)

        XCTAssertEqual(bCenterYConstraints.count, 1)
        XCTAssertEqual(bWidthConstraints.count, 1)
        XCTAssertEqual(bHeightConstraints.count, 1)
        XCTAssertEqual(bTrailingConstraints.count, 1)

        guard let bCenterYConstraint = bCenterYConstraints.first,
            let bWidthConstraint = bWidthConstraints.first,
            let bHeightConstraint = bHeightConstraints.first,
            let bTrailingConstraint = bTrailingConstraints.first
            else { return XCTFail() }

        testConstraint(bCenterYConstraint)
        testConstraint(bWidthConstraint)
        testConstraint(bHeightConstraint, constant: Constants.constant)
        testConstraint(bTrailingConstraint, constant: -Constants.constant, relation: .greaterThanOrEqual)
    }
    
    func testConstrictAtTwoViewsCenterWidthHeightWithGuides() {
        
        // Setup aView
        viewController.view.addSubview(aView)
        aView.constrict(.centerX, to: viewController, attribute: .centerXGuide)
            .constrict(.centerY, to: viewController, attribute: .centerY)
            .constrict(.width, constant: Constants.constant)
            .constrict(.height, constant: Constants.constant)
        
        // Setup bView
        viewController.view.addSubview(bView)
        bView.constrict(.centerY, to: aView, attribute: .centerY)
            .constrict(.width, to: aView, attribute: .width)
            .constrict(.height, constant: Constants.constant)
            .constrict(.trailing, relation: .greaterThanOrEqual, to: aView, attribute: .leading, constant: Constants.constant)

        // Test aView

        let centerXConstraints = viewController.view.findConstraints(for: .centerX, relatedTo: aView)
        let centerYConstraints = viewController.view.findConstraints(for: .centerY, relatedTo: aView)
        let widthConstraints = aView.findConstraints(for: .width, at: .secondItem)
        let heightConstraints = aView.findConstraints(for: .height, at: .secondItem)
        
        XCTAssertEqual(centerXConstraints.count, 1)
        XCTAssertEqual(centerYConstraints.count, 1)
        XCTAssertEqual(widthConstraints.count, 1)
        XCTAssertEqual(heightConstraints.count, 1)
        
        guard let centerXConstraint = centerXConstraints.first,
            let centerYConstraint = centerYConstraints.first,
            let widthConstraint = widthConstraints.first,
            let heightConstraint = heightConstraints.first
            else { return XCTFail() }
        
        testConstraint(centerXConstraint)
        testConstraint(centerYConstraint)
        testConstraint(widthConstraint, constant: Constants.constant)
        testConstraint(heightConstraint, constant: Constants.constant)
        
        // Test bView
        let bCenterYConstraints = viewController.view.findConstraints(for: .centerY, relatedTo: bView)
        let bWidthConstraints = viewController.view.findConstraints(for: .width, relatedTo: bView, at: .firstItem)
        let bHeightConstraints = bView.findConstraints(for: .height, at: .secondItem)
        let bTrailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: bView)
        
        XCTAssertEqual(bCenterYConstraints.count, 1)
        XCTAssertEqual(bWidthConstraints.count, 1)
        XCTAssertEqual(bHeightConstraints.count, 1)
        XCTAssertEqual(bTrailingConstraints.count, 1)
        
        guard let bCenterYConstraint = bCenterYConstraints.first,
            let bWidthConstraint = bWidthConstraints.first,
            let bHeightConstraint = bHeightConstraints.first,
            let bTrailingConstraint = bTrailingConstraints.first
            else { return XCTFail() }
        
        testConstraint(bCenterYConstraint)
        testConstraint(bWidthConstraint)
        testConstraint(bHeightConstraint, constant: Constants.constant)
        testConstraint(bTrailingConstraint, constant: -Constants.constant, relation: .greaterThanOrEqual)
    }

    // MARK: Test - constrictToContainer(_ selfAttribute: NSLayoutAttribute, ...
    func testConstrictToContainerAtTopBottomConstant() {

        // Setup
        viewController.view.addSubview(aView)
        aView.constrictToViewController(viewController, attributes: .top, .bottom, constant: Constants.constant)

        // Tests
        XCTAssertEqual(viewController.view.constraints.count, 2)

        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)

        XCTAssertEqual(topConstraints.count, 1)
        XCTAssertEqual(bottomConstraints.count, 1)

        guard let topConstraint = topConstraints.first,
            let bottomConstraint = bottomConstraints.first else { return XCTFail() }

        testConstraint(topConstraint, constant: Constants.constant)
        testConstraint(bottomConstraint, constant: -Constants.constant)
    }
    
//    func testConstrictToContainerAtTopBottom() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        aView.constrictToViewController(viewController, attributes: .topGuide, .leadingGuide)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, 2)
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//        let leadingConstraints = viewController.view.findConstraints(for: .leading, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//        XCTAssertEqual(leadingConstraints.count, 1)
//
//        XCTAssertEqual(topConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first, let leadingConstraint = leadingConstraints.first  else { return XCTFail() }
//
//        testConstraint(topConstraint)
//        testConstraint(leadingConstraint)
//    }
//}




//
//    func testConstrictToContainerAtTopBottomWithConstant() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        aView.constrictToContainer(attributes: .top, .bottom, constant: Constants.constant)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, expectedConstraintCount(based: 2, isInContainer: true))
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//        XCTAssertEqual(bottomConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first,
//            let bottomConstraint = bottomConstraints.first else { return XCTFail() }
//
//        testConstraint(topConstraint, constant: Constants.constant)
//        testConstraint(bottomConstraint, constant: -Constants.constant)
//    }
//
//    func testConstrictToContainerAtTopBottomTrailingWithRelation() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        aView.constrictToContainer(attributes: .top, .bottom, .trailing, relation: .lessThanOrEqual)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, expectedConstraintCount(based: 3, isInContainer: true))
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
//        let trailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//        XCTAssertEqual(bottomConstraints.count, 1)
//        XCTAssertEqual(trailingConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first,
//            let bottomConstraint = bottomConstraints.first,
//            let trailingConstraint = trailingConstraints.first
//            else { return XCTFail() }
//
//        testConstraint(topConstraint, relation: .lessThanOrEqual)
//        testConstraint(bottomConstraint, relation: .lessThanOrEqual)
//        testConstraint(trailingConstraint, relation: .lessThanOrEqual)
//    }
//
//    func testConstrictToContainerAtTopBottomTrailingLeadingWithMultiplier() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        aView.constrictToContainer(attributes: .top, .bottom, .trailing, .leading, multiplier: Constants.multiplier)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, expectedConstraintCount(based: 4, isInContainer: true))
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
//        let trailingConstraints = viewController.view.findConstraints(for: .trailing, relatedTo: aView)
//        let leadingConstraints = viewController.view.findConstraints(for: .leading, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//        XCTAssertEqual(bottomConstraints.count, 1)
//        XCTAssertEqual(trailingConstraints.count, 1)
//        XCTAssertEqual(leadingConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first,
//            let bottomConstraint = bottomConstraints.first,
//            let trailingConstraint = trailingConstraints.first,
//            let leadingConstraint = leadingConstraints.first
//            else { return XCTFail() }
//
//        testConstraint(topConstraint, multiplier: Constants.multiplier)
//        testConstraint(bottomConstraint, multiplier: Constants.multiplier)
//        testConstraint(trailingConstraint, multiplier: Constants.multiplier)
//        testConstraint(leadingConstraint, multiplier: Constants.multiplier)
//    }
//
//    // MARK: Test - constrict(attributes: NSLayoutAttribute ..., ..., to view: UIView?, ...
//    func testConstrictAttributesToViewAtTop() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        viewController.view.addSubview(bView)
//        aView.constrict(attributes: .top, to: bView)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, expectedConstraintCount(based: 1))
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first else { return XCTFail() }
//
//        testConstraint(topConstraint)
//    }
//
//    func testConstrictAttributesToViewAtTopBottomWithMultiplier() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        viewController.view.addSubview(bView)
//        aView.constrict(attributes: .top, .bottom , to: bView, multiplier: Constants.multiplier)
//
//        // Tests
//        XCTAssertEqual(viewController.view.constraints.count, expectedConstraintCount(based: 2))
//
//        let topConstraints = viewController.view.findConstraints(for: .top, relatedTo: aView)
//        let bottomConstraints = viewController.view.findConstraints(for: .bottom, relatedTo: aView)
//
//        XCTAssertEqual(topConstraints.count, 1)
//        XCTAssertEqual(bottomConstraints.count, 1)
//
//        guard let topConstraint = topConstraints.first,
//            let bottomConstraint = bottomConstraints.first
//            else { return XCTFail() }
//
//        testConstraint(topConstraint, multiplier: Constants.multiplier)
//        testConstraint(bottomConstraint, multiplier: Constants.multiplier)
//    }
//
//    func testConstrictAttributesToViewAtWidthHeightWithConstantsRelation() {
//
//        // Setup
//        viewController.view.addSubview(aView)
//        viewController.view.addSubview(bView)
//        aView.constrict(attributes: .width, .height, relation: .greaterThanOrEqual, constant: Constants.constant)
//
//        // Tests
//        XCTAssertEqual(aView.constraints.count, expectedConstraintCount(based: 2))
//
//        let widthConstraints = aView.findConstraints(for: .width, at: .secondItem)
//        let heightConstraints = aView.findConstraints(for: .height, at: .secondItem)
//
//        XCTAssertEqual(widthConstraints.count, 1)
//        XCTAssertEqual(heightConstraints.count, 1)
//
//        guard let widthConstraint = widthConstraints.first,
//            let heightConstraint = heightConstraints.first
//            else { return XCTFail() }
//
//        testConstraint(widthConstraint, constant: Constants.constant, relation: .greaterThanOrEqual)
//        testConstraint(heightConstraint, constant: Constants.constant, relation: .greaterThanOrEqual)
//    }
//}
}
