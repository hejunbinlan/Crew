
#if os(iOS)
    import UIKit
    public typealias View = UIView
    public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
    import AppKit
    public typealias View = NSView
    public typealias LayoutPriority = NSLayoutPriority
#endif


infix operator ~ { associativity left precedence 160 }
infix operator ! { associativity left precedence 100 }
infix operator << { associativity right precedence 90 }

public typealias AutoLayoutLeftItem = (item: AnyObject, attribute: NSLayoutAttribute)
public typealias AutoLayoutRightItem = (item: AnyObject, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat)


public func ~(item: View, rhs: NSLayoutAttribute) -> AutoLayoutLeftItem {
    return (item, rhs)
}

public func ~(item: View, rhs: NSLayoutAttribute) -> AutoLayoutRightItem {
    return (item, rhs, 1, 0)
}

#if os(iOS)

public func ~(item: UILayoutSupport, rhs: NSLayoutAttribute) -> AutoLayoutLeftItem {
    return (item, rhs)
}

public func ~(item: UILayoutSupport, rhs: NSLayoutAttribute) -> AutoLayoutRightItem {
    return (item, rhs, 1, 0)
}

#endif

public func *(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier * rhs, lhs.constant)
}

public func /(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier / rhs, lhs.constant)
}

public func +(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier, lhs.constant + rhs)
}

public func -(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return lhs + -rhs
}

// build NSLayoutConstraint


public func ==(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .Equal, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

public func <=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .LessThanOrEqual, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

public func >=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .GreaterThanOrEqual, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

public func ==(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: rhs)
    }
}

// set priority

public func !(lhs: () -> NSLayoutConstraint, priority: LayoutPriority) -> () -> NSLayoutConstraint {
    return {
        let c = lhs()
        c.priority = priority
        return c
    }
}

// add constrains

public func <<(lhs: View, rhs: () -> NSLayoutConstraint) {
    lhs.addConstraint(rhs())
}

public func <<(lhs: View, rhs: () -> [NSLayoutConstraint]) {
    lhs.addConstraints(rhs())
}

// view extension

extension View {
    func add(block: () -> NSLayoutConstraint) {
        addConstraint(block())
    }
}
