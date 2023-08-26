//
//  DetectionController.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//


import UIKit
import AVFoundation
import SwiftUI
import AudioToolbox

class DetectionController : UIViewController {
     var classificationViewModel = ClassificationViewModel()
    
    let videoCapture = VideoCapture()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var pointsLayer = CAShapeLayer()
    
    var isActionDetected: Bool = false
    var result:[Result]=[]
    
    var actionLabel: String?
    var confidenceLabel: Double?
  
    var didReceiveArray: (([Result]) -> Void)?
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupValue()
        setupVideoPreview()
        videoCapture.predictor.delegate = self
      
    }

    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
    private func setupValue(){
        let controller = UIHostingController(rootView: LivePreviewView(vm: self.classificationViewModel))
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
   
    func reset(){
        result=[]
        self.didReceiveArray?(result)
    }
    
    func deleteLast(){
        if(result.count>0){
            result.removeLast()
            self.didReceiveArray?(result)
        }
    
    }
    
    func addResult(res:Result){
        if(result.count==0){
            if(res.label != "my"){
                result.append(res)
            }
        }
        else{
            var isNotFound = true
            for x in result{
                if(res.label == x.label ){
                    isNotFound = false
                }
            }
            if isNotFound == true{
                result.append(res)
            }
        }
       
        self.didReceiveArray?(result)
    }
    
}

extension DetectionController : PredictorDelegate {
   
    
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else {
            return
        }
        
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        let combinedPath = CGMutablePath()
        
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointsLayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
    
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
       
        DispatchQueue.main.async {
            if confidence>=0.9{
                self.actionLabel=action
                self.confidenceLabel = confidence
               
                self.addResult(res: Result(label: action, prediction: confidence))

            }
            
        }
        
        
    }
    
    
}


struct DetectionView: UIViewControllerRepresentable {
    
    var configurator: ((DetectionController) -> Void)?
    var removeLast: ((DetectionController) -> Void)?

    
    var didReceiveArray: (([Result]) -> Void)
    
    func makeUIViewController(context: Context) -> some UIViewController {
       
        let viewController = DetectionController()
        viewController.didReceiveArray = didReceiveArray
        configurator?(viewController)
        removeLast?(viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
