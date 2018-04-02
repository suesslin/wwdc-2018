let capacitor = Capacitor(capacity: 10)
let coil = Coil(windings: 1000, area: 25e-4, length: 5e-2)
let circuit = Circuit(voltage: 230, current: 5, capacitor: capacitor, coil: coil)
/*:
 [Previous](@previous)
 
 ## The Right Circuit
 
 ### Setup
 We have a charged capacitor that acts as a power supply (as mentioned in the playground
 page for the left circuit) and a coil.
 
 This setup with the charged capacitor is of great importance for our wave functions.
 Let's see what happens, by having a look at the graph of the capacitor's current once more.
 Please turn it on, if it doesn't show.
 */

for n in stride(from: 0.0, to: 5.0, by: 0.1) {
    circuit.getCapacitorCurrent(t: Time(n))
}

/*:
 ### To 1/4th period: Flowing Current to the other plate
 Since our charged capacitor acts as a power supply, electrons now move
 in the conductor toward the coil, this current we call
 "discharge current". Once they reach it, a magnetic field is building up,
 due to a rule of physics. Remember that one of the plates of the
 capacitor is charged, the other not, leading to that tension that
 causes the discharge current.
 What comes into play now, is *self-inductance*. The rule is, when a
 magnetic field changes, a conductor (here the coil) self-inducts,
 which means, current flows. This current flows in the opposite
 direction of the current that caused it, which is reasoned by the
 *[rule of Lenz](https://en.wikipedia.org/wiki/Lenz%27s_law)*
 
 (This isn't too important for our functions, since all it does is slow
 down the growth of the current, since the self-inducted current
 flows in the opposite direction, you can imagine these electrons
 "collide" with the electrons of the current caused by the capacitor).
 
 ### 1/4th - 1/2th period: Inductance current causes smooth fade to 0
 
 At some point, the electrons reached the other plate of the capacitor
 and the discharge current falls. But the falling of this current leads,
 once again, to a change of the magnetic field, which then leads to
 self-inductance one more time. This self-inductance also works with the
 rule of Lenz, but this time not in the "opposite" way, but now it
 wants to preserve the magnetic field, hence does the inductive current
 flow the same direction as our previous discharge current.
 The inductance current therefore is the reason that the current doesn't
 fall back to zero all of a sudden, but instead slowly decrase until it's 0.
 
 ### The 2nd half of a period: All over again, but opposite direction
 Now the capacitor is charged the opposite way, and all of this starts over, but also,
 in the opposite direction, which can be seen in the sine curve.
 */

