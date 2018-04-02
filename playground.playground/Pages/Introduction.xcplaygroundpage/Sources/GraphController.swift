import UIKit

public class GraphController: UIViewController {
    
    var circuit = Circuit(
        voltage: 230,
        current: 5,
        capacitor: Capacitor(capacity: 10),
        coil: Coil(windings: 300, area: 3, length: 10)
    )
    
    var graphView: UIView = {
        let gv = UIView()
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.backgroundColor = .green
        gv.layer.cornerRadius = 5
        return gv
    }()
    
    let navigationButton: CustomButton = {
        let b = CustomButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.textLabel.text = "Edit Values"
        b.addTarget(self, action: #selector(naviAction), for: .touchUpInside)
        return b
    }()
    
    let capacitorAlert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Change values of", preferredStyle: .actionSheet)
        let act1 = UIAlertAction(title: "Length", style: .default, handler: { alert in
        })
        let act2 = UIAlertAction(title: "Windings", style: .default, handler: { alert in
        })
        let act3 = UIAlertAction(title: "Coils", style: .default, handler: { alert in
        })
        let act4 = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
        })
        
        [act1, act2, act3, act4].forEach { alert.addAction($0) }
        return alert
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let spacingAround: CGFloat = 20
        
                graphView = getGraph(
                    function: circuit.getCapacitorVoltage,
                    xStr: "t in s",
                    yStr: "U in V",
                    width: Int(view.frame.width - (spacingAround * 2)),
                    height: Int(view.frame.height - spacingAround - 70)
                )
        
        view.addSubview(graphView)
        view.addSubview(navigationButton)
        
        
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacingAround),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacingAround),
            graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacingAround),
            
            navigationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            navigationButton.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -10),
            navigationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacingAround),
            navigationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacingAround)
            ])
        
        view.backgroundColor = .black
    }
    
    func changeVal(value: inout Double, onlyVal: Double, text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.text = String(onlyVal)
        })
        
        let act1 = UIAlertAction(title: "Update", style: .default, handler: { action in
            let str = (alert.textFields![0] as! UITextField).text!
            
            let fmt = NumberFormatter()
            let num = fmt.number(from: str)
            if num != nil {
                print(num!.doubleValue)
            }
        })
        
        let act2 = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
        })
        
        [act1, act2].forEach { alert.addAction($0) }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func naviAction(_ sender: CustomButton) {
        
        
        let nav = UIAlertController(title: nil, message: "What do you want to change?", preferredStyle: .actionSheet)
        
        let act1 = UIAlertAction(title: "Capacitor", style: .default, handler: { alert in
            let capMenu = UIAlertController(title: nil, message: "Change values of Coil", preferredStyle: .actionSheet)
            let act1 = UIAlertAction(title: "Capacity", style: .default, handler: { alert in
                self.changeVal(value: &self.circuit.capacitor.capacity, onlyVal: self.circuit.capacitor.capacity, text: "Update Capacity")
            })
            let act2 = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
            })
            
            [act1, act2].forEach { capMenu.addAction($0) }
            self.present(capMenu, animated: true, completion: nil)
        })
        nav.addAction(act1)
        
        let act2 = UIAlertAction(title: "Coil", style: .default, handler: { alert in
            let coilMenu = UIAlertController(title: nil, message: "Change values of Coil", preferredStyle: .actionSheet)
            let act1 = UIAlertAction(title: "Length", style: .default, handler: { alert in
                self.changeVal(value: &self.circuit.coil.length, onlyVal: self.circuit.coil.length, text: "Update Length")
            })
            let act2 = UIAlertAction(title: "Windings", style: .default, handler: { alert in
                self.changeVal(value: &self.circuit.coil.windings, onlyVal: self.circuit.coil.windings, text: "Update Windings")
            })
            let act3 = UIAlertAction(title: "Area", style: .default, handler: { alert in
                self.changeVal(value: &self.circuit.coil.area, onlyVal: self.circuit.coil.area, text: "Update Area")
            })
            let act4 = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
            })
            
            [act1, act2, act3, act4].forEach { coilMenu.addAction($0) }
            self.present(coilMenu, animated: true, completion: nil)
        })
        
        nav.addAction(act2)
        
        let act3 = UIAlertAction(title: "Voltage", style: .default, handler: { alert in
            self.changeVal(value: &self.circuit.voltage, onlyVal: self.circuit.voltage, text: "Update Voltage")
        })
        
        nav.addAction(act3)
        
        let act4 = UIAlertAction(title: "Current", style: .default, handler: { alert in
            self.changeVal(value: &self.circuit.current, onlyVal: self.circuit.current, text: "Update Current")
        })
        
        nav.addAction(act4)
        
        let act5 = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
        })
        
        nav.addAction(act5)
        
        self.present(nav, animated: true, completion: nil)
    }
    
}

public class CustomButton: UIButton {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        
        layer.cornerRadius = 5
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
