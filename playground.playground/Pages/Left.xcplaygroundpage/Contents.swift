import Darwin
import PlaygroundSupport

/*:
 [Previous](@previous)
 
 ## The Left Circuit
 Since there are two circuits, the left side is of great importance.
 For quick readers, see the summary at the bottom!
 
 As just seen, the left side consists of a sole power supply for the voltage, and our capacitor.
 Since the Capacitor has a Capacity, which is defined by electric charge Q divided by voltage (in other
 words, charge per voltage), it can be charged until it's full.
 
 We'll use that to our advantage now. The right circuit will use the capacitor as a power supply and
 also as a kind of "recharger". Now it might slowly seem plausible, why the graph for the capacitor's
 voltage and current were wave functions (cosine and sine). Power supply and charge back... seems
 like a cycle!
 
 There's a formula for charging the capacitor with a voltage. We will not use it, since Swift
 does not offer the needed precision natively. It looks like this:
 ![Formula for seeing the voltage of a condensator in the process of charging](formula.png)
 
 Or in code:
*/

func getUcAtCharging(U: Voltage, t: Time, R: Resistance, C: Capacity) -> Voltage {
    let exponent = t/(R*C)
    return U * (1 - pow((-e), -exponent))
}

/*:
 To the right side of this playground, you can now see an animation of how the Capacitor
 is charged.
 Note, how electrons move from the negative pole (-) to the positive pole (+), since
 we look at electrons, this is visualized in the *electric current direction*.
*/

PlaygroundSupport.PlaygroundPage.current.liveView = getScene()


/*:
 ## Summary of the left circuit
 All we need the left circuit for, is to charge the Capacitor, since the capacitor will serve
 as our power supply in the right circuit.
*/

