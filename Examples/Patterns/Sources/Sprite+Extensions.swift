//
//  File.swift
//
//
//  Created by Heliodoro Tejedor Navarro on 14/3/24.
//

internal import Playdate

extension Sprite {
    init(bitmapPath: StaticString) {
        let bitmap = Graphics.loadBitmap(path: bitmapPath)
        self.init(bitmap: bitmap)
    }
    
    init(bitmap: LCDBitmap) {
        var width: Int32 = 0
        var height: Int32 = 0
        Graphics.getBitmapData(
            bitmap: bitmap.unsafelyUnwrapped,
            width: &width,
            height: &height,
            rowbytes: nil,
            mask: nil,
            data: nil)
        let bounds = PDRect(x: 0, y: 0, width: Float(width), height: Float(height))
        
        self.init()
        self.setImage(image: bitmap)
        self.bounds = bounds
        self.collideRect = bounds
    }
}
