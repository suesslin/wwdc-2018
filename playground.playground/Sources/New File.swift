import UIKit

public typealias Current         = Double // In A (Ampère)
public typealias Voltage         = Double // In V (Volt)
public typealias Time            = Double // In min (Minutes)
public typealias AngularVelocity = Double
public typealias Inductance      = Double // In H (Henry)
public typealias Capacity        = Double // In F (Farrad)
public typealias Area            = Double // In m^2 (Square meters)
public typealias Length          = Double // In m (Meters)
public typealias Resistance      = Double // IN Ohm

public let mu0 = 4 * Double.pi * 10e-7
public let e = 1.6e-19

public func getT(L: Inductance, C: Capacity) -> Double {
    return 2 * Double.pi * sqrt(L * C)
}

public func getL(A: Area, l: Length, n: Double) -> Inductance {
    return mu0 * A * ((n * n) / 2)
}

//var getOmega = { T in
//    return 2 * Double.pi / T
//}

public struct Circuit {
    public var voltage:   Double
    public var current:   Double
    
    public var capacitor: Capacitor
    public var coil:      Coil
    
    public init(voltage: Double, current: Double, capacitor: Capacitor, coil: Coil) {
        self.voltage = voltage
        self.current = current
        self.capacitor = capacitor
        self.coil = coil
    }
    
    public func getCapacitorVoltage(t: Time) -> Voltage {
        return capacitor.getUc(U0: self.voltage, t: t, omega: self.capacitor.getOmega(L: self.coil.L))
    }
    
    public func getCapacitorCurrent(t: Time) -> Current {
        return capacitor.getIc(I0: self.current, t: t, omega: self.capacitor.getOmega(L: self.coil.L))
    }
}

public struct Capacitor {
    public var capacity: Double
    
    public init(capacity: Double) {
        self.capacity = capacity
    }
    
    public func getOmega(L: Inductance) -> AngularVelocity {
        return 2 * Double.pi / getT(L: L, C: self.capacity)
    }
    
    public func getUc(U0: Voltage, t: Time, omega: AngularVelocity) -> Voltage {
        return U0 * cos(t * omega)
    }
    
    public func getIc(I0: Current, t: Time, omega: AngularVelocity) -> Current {
        return I0 * sin(t * omega)
    }
}

public struct Coil {
    public var windings: Double
    public var area:     Area
    public var length:   Length
    
    public init(windings: Double, area: Double, length: Double) {
        self.windings = windings
        self.area     = area
        self.length   = length
    }
    
    public var L: Inductance {
        return getL(A: self.area, l: self.length, n: self.windings)
    }
}

public typealias DoubleFunc = (Double) -> Double

public func getGraph(function: DoubleFunc?, xStr: String, yStr: String, width: Int, height: Int) -> UIView {
    let frameSpace = 70
    let labelWidth = 50
    
    let smallCanvasHeight = height - frameSpace
    let smallCanvasWidth = width - frameSpace
    
    let wholeCanvas = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    wholeCanvas.translatesAutoresizingMaskIntoConstraints = false
    wholeCanvas.backgroundColor = .gray
    
    let canvas = UIView(frame: CGRect(
        x: width/2 - smallCanvasWidth / 2,
        y: height/2 - smallCanvasHeight / 2,
        width: smallCanvasWidth,
        height: smallCanvasHeight)
    )
    canvas.backgroundColor = .white
    canvas.translatesAutoresizingMaskIntoConstraints = false
    
    let midAxis = UIView(frame: CGRect(x: 0, y: CGFloat(smallCanvasHeight / 2), width: canvas.frame.width, height: 1))
    midAxis.backgroundColor = .lightGray
    canvas.addSubview(midAxis)
    
    // Axis
    
    let xAxis = UIView(frame: CGRect(x: canvas.frame.minX, y: CGFloat((frameSpace / 2) + smallCanvasHeight), width: canvas.frame.width, height: 2))
    xAxis.backgroundColor = .black
    
    let yAxis = UIView(frame: CGRect(x: frameSpace/2 - 2, y: frameSpace/2, width: 2, height: smallCanvasHeight + 2))
    yAxis.backgroundColor = .black
    
    // Labels
    
    let xLabel = UILabel(frame: CGRect(x: frameSpace/2 + smallCanvasWidth - labelWidth, y: frameSpace/2 + 3 + smallCanvasHeight, width: labelWidth, height: 9))
    xLabel.textColor = .black
    xLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
    xLabel.text = xStr
    xLabel.textAlignment = .right
    
    let yLabel = UILabel(frame: CGRect(x: frameSpace/2 - labelWidth    - 3, y: frameSpace/2, width: labelWidth, height: 9))
    yLabel.text = yStr
    yLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
    yLabel.textColor = .black
    yLabel.textAlignment = .right
    
    wholeCanvas.addSubview(canvas)
    wholeCanvas.addSubview(xAxis)
    wholeCanvas.addSubview(yAxis)
    
    wholeCanvas.addSubview(xLabel)
    wholeCanvas.addSubview(yLabel)
    
    // Small Canvas
    
    if function != nil {
        let voltages = stride(from: 0.0, to: 50.0, by: 0.1).map { function!($0) }
        let sorted = voltages.sorted()
        
        let (min, max) = (sorted.first!, sorted.last!)
        let difference = sqrt(min * min) + max // How much between the max and min
        let yFactor = Double(smallCanvasHeight) / difference // Multiply factor for the value of a point
        
        var size = Double(smallCanvasWidth) / Double(voltages.count) // The allowed size per point
        
        voltages.enumerated().forEach { val in
            let y = Double(val.element) * yFactor
            let point = UIView(frame: CGRect(x: Double(val.offset) * size, y: Double(smallCanvasHeight/2) - y, width: size, height: size))
            point.backgroundColor = .red
            canvas.addSubview(point)
        }
    }
    
    return wholeCanvas
}

