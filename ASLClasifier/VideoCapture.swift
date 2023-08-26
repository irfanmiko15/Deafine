//
//  VideoCapture.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//


import Foundation
import AVFoundation
import UIKit

class VideoCapture: NSObject {
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    let predictor = Predictor()
    
    override init() {
        super.init()
        
        // prepare the input capture device
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        // put input in capture session
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        captureSession.addInput(input)
        
        // handle video output
        captureSession.addOutput(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
    }
    
    func startCaptureSession() {
        captureSession.startRunning()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQUeue"))
    }
    
}

extension VideoCapture : AVCaptureVideoDataOutputSampleBufferDelegate {
    func rotate(_ sampleBuffer: CMSampleBuffer) -> CVPixelBuffer? {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return nil
            }
            var newPixelBuffer: CVPixelBuffer?
            let error = CVPixelBufferCreate(kCFAllocatorDefault,
                                            CVPixelBufferGetHeight(pixelBuffer),
                                            CVPixelBufferGetWidth(pixelBuffer),
                                            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                            nil,
                                            &newPixelBuffer)
            guard error == kCVReturnSuccess else {
                return nil
            }
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(.right)
            let context = CIContext(options: nil)
            context.render(ciImage, to: newPixelBuffer!)
            return newPixelBuffer
        }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        predictor.estimation(sampleBuffer: sampleBuffer)
    }
}
