//
//  ViewController.swift
//  PDFDemoProject
//
//  Created by Admin on 10/22/19.
//  Copyright © 2019 com.myorg.in. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    
    @IBOutlet weak var pdfTableView: UITableView!
    var cellData = ["Akshay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 1...100 {
            cellData.append("Akshay \(index)")
        }
        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = cellData[indexPath.row]
        return cell
    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
      
        guard let pdfData = pdfTableView.convertToPDF() else{
            return
        }
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Dicrectory Path: \(documentsPath)")
        
            try! pdfData.write(to: URL(fileURLWithPath: "\(documentsPath)/file.pdf"))
    }
    
}



extension UITableView {
   @objc func convertToPDF() -> Data? {
        let priorBounds = self.bounds
        setBoundsForAllItems()
        self.layoutIfNeeded()
        let pdfData = createPDF()
        self.bounds = priorBounds
        return pdfData.copy() as? Data
    }

    private func getContentFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
    }

    private func createPDF() -> NSMutableData {
        let pdfPageBounds: CGRect = getContentFrame()
        let pdfData: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        self.scalesLargeContentImage = true
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()
        return pdfData
    }

    private func setBoundsForAllItems() {
        if self.isEndOfTheScroll() {
            self.bounds = getContentFrame()
        } else {
            self.bounds = getContentFrame()
            self.reloadData()
        }
    }

    private func isEndOfTheScroll() -> Bool  {
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        return distanceFromBottom < frame.size.height
    }
}
