import Foundation
import UIKit
import PlaygroundSupport

let capacitor = Capacitor(capacity: 10)
let coil = Coil(windings: 1000, area: 25e-4, length: 5e-2)
let circuit = Circuit(voltage: 230, current: 5, capacitor: capacitor, coil: coil)
/*:
 The code above initializes our circuit. We supply 230 Volts, the standard of Germany, as *voltage U*,
 as well as ... Ampere as *current I* and implement a *capacitor* with 10 Henry as *Capacity C* and
 a *5cm long coil (length l)* with *1000 windings (windings n)* that takes in *25 square cenimeters (surface A)*.
 
 What follows now is the measuring of the capacitor's voltage and current. Since I couldn't manage to finish the app in time, I've also added an alternative variant that embeds
 the playground's functionality. Feel free to play around with the functionality of the
 app that's there. The alternative variant follows after the following code.
 */

// For a concept that allows to edit values.
let controller = GraphController()
PlaygroundPage.current.liveView = controller

/*:

 **Tasks**:
 * Uncomment the following block of code
 * Click on "Show Result" for the line that displays the capacitor and display it as a graph.
 * Now start executing the playground and see the graph shape over time.
 */

var timeToMeasureInSec = 5.0 // What timeframe should be captured
var spaceBetweenRecord = 0.1 // The time in seconds
var currentTime = 0.0        // Start time/current time; please set to 0.0

//PlaygroundPage.current.needsIndefiniteExecution = true
//Timer.scheduledTimer(withTimeInterval: spaceBetweenRecord, repeats: true, block: { timer in
//    if currentTime >= timeToMeasureInSec { timer.invalidate() } // Condition when to stop
//    circuit.getCapacitorVoltage(t: currentTime)
//
//    currentTime += timer.timeInterval
//})
/*:
 The values for this graph are taken in 5 seconds, each value recorded after a 10th of a second has passed. This can also be done for capacitor's current, the function has to be changed for that.
 The resulting graphs should be a cosine for the voltage and a sine for the current.
 
 The following two graphs should look about the same as the ones you have measured.
 *Note, if the graphs do not show, they have to be turned on.*
*/

for n in stride(from: 0.0, to: timeToMeasureInSec, by: spaceBetweenRecord) {
    circuit.getCapacitorVoltage(t: Time(n))
}

for n in stride(from: 0.0, to: timeToMeasureInSec, by: spaceBetweenRecord) {
    circuit.getCapacitorCurrent(t: Time(n))
}


/*:
 ### Question:
 The question is, why these graphs look the way they do. Worth noting is, that we presuppose that
 we are in an ideal/optimal environment where no energy is converted due to friction. Hence do these graphs
 keep on reaching the same minima and maxima. In a real world, the amplitudes would come closer together until
 they are a line.
 
 Let's understand why the graphs look as they do, starting with understanding the [left circuit](Left)
 */
