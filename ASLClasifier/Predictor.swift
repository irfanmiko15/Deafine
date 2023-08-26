//
//  Predictor.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//

import Foundation
import Vision
import CoreImage

protocol PredictorDelegate: AnyObject {
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints: [CGPoint])
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double)
}

class Predictor {
    
    weak var delegate: PredictorDelegate?
    
    let predictionWindowSize = 60
    var posesWindow: [VNHumanHandPoseObservation] = []
    
    init() {
        posesWindow.reserveCapacity(predictionWindowSize)
    }
    
    
    func estimation(sampleBuffer: CMSampleBuffer) {
//        let exifOrientation = exifOrientationFromDeviceOrientation()
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up,options: [:])
        
        let request = VNDetectHumanHandPoseRequest(completionHandler: bodyPoseHandler)
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("unable to perform the request \(error)")
        }
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanHandPoseObservation] else { return }
        
        observations.forEach {
            processObservation(observation: $0)
        }
        
        if let result = observations.first {
            storeObservation(result)
            
            labelActionType()
        }
    }
    
    func storeObservation(_ observation: VNHumanHandPoseObservation) {
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst()
        }
        
        posesWindow.append(observation)
    }
    
    func labelActionType() {
        guard let exerciseClassifier = try? TuliHandFinal(configuration: MLModelConfiguration()),
            let poseMultiArray = prepareInputWithObservation(posesWindow),
            let prediction = try? exerciseClassifier.prediction(poses: poseMultiArray)
        else { return }
        
        let label = prediction.label
        let confidence = prediction.labelProbabilities[label] ?? 0
        
        delegate?.predictor(self, didLabelAction: label, with: confidence)
    }
    
    func prepareInputWithObservation(_ observations: [VNHumanHandPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        let observationsNeeded = 60
        
        var multiArrayBuffer = [MLMultiArray]()
        
        for frameIndex in 0 ..< min(numAvailableFrames, observationsNeeded) {
            let pose = observations[frameIndex]
            
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }
        
        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [1, 3, 21], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }
        
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    func processObservation(observation: VNHumanHandPoseObservation) {
        do {
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            let displayedPoints = recognizedPoints.map {
                CGPoint(x: $0.value.x, y: 1 -  $0.value.y)
            }
            
            delegate?.predictor(self, didFindNewRecognizedPoints: displayedPoints)
        } catch {
            print("Error processing observation \(error)")
        }
    }
}
