import Foundation

/// Traditional way
func respondsTo(comparison: () -> Bool) {
    if comparison() {
        print("It was true")
    } else {
        print("It was false")
    }
}

respondsTo(comparison: {2 < 1})
respondsTo { 2 > 1 }

/// @autoclosureway
func autoRespondsTo(comparison: @autoclosure () -> Bool) {
    if comparison() {
        print("It was true")
    } else {
        print("It was false")
    }
}

// Much more clean API
autoRespondsTo(comparison: 2>1)
