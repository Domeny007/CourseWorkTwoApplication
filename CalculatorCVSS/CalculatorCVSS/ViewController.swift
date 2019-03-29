//
//  ViewController.swift
//  CalculatorCVSS
//
//  Created by Азат Алекбаев on 15/02/2019.
//  Copyright © 2019 Азат Алекбаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var localObtain: UIButton!
    @IBOutlet weak var adjacentObtain: UIButton!
    @IBOutlet weak var networkObtain: UIButton!
    
    @IBOutlet weak var highAC: UIButton!
    @IBOutlet weak var midAC: UIButton!
    @IBOutlet weak var lowAC: UIButton!
    
    @IBOutlet weak var multAu: UIButton!
    @IBOutlet weak var singleAu: UIButton!
    @IBOutlet weak var noneAu: UIButton!
    
    @IBOutlet weak var noneC: UIButton!
    @IBOutlet weak var partC: UIButton!
    @IBOutlet weak var allC: UIButton!
    
    @IBOutlet weak var noneI: UIButton!
    @IBOutlet weak var partI: UIButton!
    @IBOutlet weak var allI: UIButton!
    
    @IBOutlet weak var noneA: UIButton!
    @IBOutlet weak var partA: UIButton!
    @IBOutlet weak var allP: UIButton!
    
    var av:Double = 0
    var ac:Double = 0
    var au:Double = 0
    
    var c:Double = 0
    var i:Double = 0
    var a:Double = 0
    
    var temp: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func localAvPressed(_ sender: UIButton) {
        
        av = 0.395
        
        localObtain.tintColor = .red
        
    }
    
    @IBAction func adjacentAvPressed(_ sender: UIButton) {
        
        av = 0.646
        
        adjacentObtain.tintColor = .red
        
    }
    
    @IBAction func networkAvPressed(_ sender: UIButton) {
        
        av = 1.0
        
        networkObtain.tintColor = .red
        
    }
    
    @IBAction func highAcPressed(_ sender: UIButton) {
        
        ac = 0.35
        
        highAC.tintColor = .red
        
        
    }
    
    @IBAction func midAcPressed(_ sender: UIButton) {
        
        ac = 0.61
        
        midAC.tintColor = .red
        
    }
    
    @IBAction func lowAcPressed(_ sender: UIButton) {
        
        ac = 0.71
        
        lowAC.tintColor = .red
        
    }
    
    @IBAction func multAuPressed(_ sender: UIButton) {
        
        au = 0.45
        
        multAu.tintColor = .red
        
    }
    
    @IBAction func singleAuPressed(_ sender: UIButton) {
        
        au = 0.56
        
        singleAu.tintColor = .red
        
        
    }
    
    @IBAction func noneAuPressed(_ sender: UIButton) {
        
        au = 0.704
        noneAu.tintColor = .red
    }
    
    @IBAction func noneCPressed(_ sender: UIButton) {
        
        c = 0.0
        noneC.tintColor = .red
        
    }
    
    @IBAction func partCPressed(_ sender: UIButton) {
        
        c = 0.275
        
        partC.tintColor = .red
        
    }
    
    @IBAction func fullCPressed(_ sender: UIButton) {
        
        c = 0.660
        
        allC.tintColor = .red
        
    }
    
    @IBAction func noneIPressed(_ sender: UIButton) {
        
        i = 0.0
        
        noneI.tintColor = .red
        
    }
    
    @IBAction func partIPressed(_ sender: UIButton) {
        
        i = 0.275
        
        partI.tintColor = .red
        
    }
    
    @IBAction func fullIPressed(_ sender: UIButton) {
        
        i = 0.660
        
        allI.tintColor = .red
        
    }
    
    @IBAction func noneAPressed(_ sender: UIButton) {
        
        a = 0.0
        
        noneA.tintColor = .red
        
    }
    
    @IBAction func partAPressed(_ sender: UIButton) {
        a = 0.275
        
        partA.tintColor = .red
    }
    
    @IBAction func fullAPressed(_ sender: UIButton) {
        
        a = 0.660
        
        allP.tintColor = .red
        
    }
    
    @IBAction func calculateResult(_ sender: UIButton) {
        let impact = 10.41*(1-(1-c)*(1-i)*(1-a))
        let exploitability = 20*av*ac*au
        if (impact == 0) {
            temp = 0
        } else {
            temp = 1.176
        }
        
        let baseScore = (((0.6*impact) + (0.4*exploitability) - 1.5)*temp)
        let roundedBaseScore = Double(round(10*baseScore)/10)
        
        resultLabel.text = resultLabel.text! + String(format: "%f", roundedBaseScore)
    }
    
}
