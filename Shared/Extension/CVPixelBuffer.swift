//
//  CVPixelBuffer.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 02.04.2022.
//

import AVFoundation
import UIKit
import ImageIO

extension CVPixelBuffer {
    
    static func open(source: CGImageSource) -> CVPixelBuffer? {
        let cfAuxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(
            source,
            0,
            kCGImageAuxiliaryDataTypeDisparity
        )
        
        guard let auxDataInfo = cfAuxDataInfo as? [AnyHashable: Any] else {
            return nil
        }

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
        guard
            let properties = cfProperties as? [CFString: Any],
            let orientationValue = properties[kCGImagePropertyOrientation] as? UInt32,
            let orientation = CGImagePropertyOrientation(rawValue: orientationValue)
        else {
            return nil
        }

        guard var depthData = try? AVDepthData(fromDictionaryRepresentation: auxDataInfo) else { return nil }

        if depthData.depthDataType != kCVPixelFormatType_DisparityFloat32 {
            depthData = depthData.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
        }

        return depthData.applyingExifOrientation(orientation).depthDataMap
    }
    
    func depthImage() -> CGImage? {
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let length = height * width
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 4 * length)
        
        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(self), to: UnsafeMutablePointer<Float>.self)
        
        var i = 0
        var minValue: Float = 1000_000_000
        var maxValue: Float = -minValue
        
        
        while i < length {
            let pixel = floatBuffer[i]
            if !pixel.isNaN {
                if pixel < minValue {
                    minValue = pixel
                }

                if pixel > maxValue {
                    maxValue = pixel
                }
            }
            i += 1
        }

        let delta = maxValue - minValue
        
        i = 0

        let module = Float((1 << 16) - 1)
        let bMask: UInt16 = (1 << 8) - 1
        
        var j = 0
        
        while i < length {
            let pixel = floatBuffer[i]

            let w0: UInt8
            let w1: UInt8

            if !pixel.isNaN && delta > 0 {
                let normal = (pixel - minValue) / delta
                let word = UInt16(module * normal)
                w0 = UInt8(word >> 8)
                w1 = UInt8(word & bMask)
            } else {
                w0 = 255
                w1 = 255
            }
            
            buffer[j] = w0
            buffer[j + 1] = w1
            buffer[j + 2] = 0
            buffer[j + 3] = 0
            
            i += 1
            j += 4
        }
        
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

        let data = Data(buffer: buffer)
        guard let providerRef = CGDataProvider(data: NSData(data: data)) else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let image = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: 4 * width,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
            )
            else { return nil }

        buffer.deallocate()
        
        return image
    }
    
}
