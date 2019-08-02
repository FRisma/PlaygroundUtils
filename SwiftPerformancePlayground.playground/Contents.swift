import UIKit

func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}

func averageTimeAfterRunning(times: Int, operation: ()->()) -> Double {
    var accum = 0.0
    for _ in 1...times { accum = timeElapsedInSecondsWhenRunningCode { operation() } }
    return accum/Double(times)
}

let myName: [String] = ["Franco", "Emilio", "Risma"]
let namesArray: [String] = ["Emilia", "Marina", "Pedro", "Rocío", "Franco", "Emilio", "Risma"]

func calculate() -> [String] {
    return namesArray.filter { !myName.contains($0) }
}

func calculate2() -> [String] {
    var result = [String]()
    var match: Bool = false
    for name in namesArray {
        for anotherName in myName {
            if name == anotherName {
                match = true
                break
            }
            match = false
        }
        if match == false {
            result.append(name)
        }
    }
    return result
}

print(averageTimeAfterRunning(times: 100, operation: {
    calculate()
}))

print(averageTimeAfterRunning(times: 100, operation: {
    calculate2()
}))
