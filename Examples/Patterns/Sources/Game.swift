internal import Playdate

struct Game {
    var sprites: [Sprite]
    var invertedSprite: Sprite
    
    init() {
        let pattern1: LCDPattern = (
            0xF0, 0xF0, 0xF0, 0xF0, 0x0F, 0x0F, 0x0F, 0x0F,
            0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
        )
        let pattern2: LCDPattern = (
            0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA,
            0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
        )

        let colorStyles: [ColorStyle] = [
            .solid(.colorBlack),
            .solid(.colorWhite),
            .pattern(pattern1),
            .pattern(pattern2)
        ]

        let widthStep = Display.width / Int32(colorStyles.count)
        var sprites: [Sprite] = []
        for (index, colorStyle) in colorStyles.enumerated() {
            let bitmap = Graphics.newBitmap(width: widthStep, height: Display.height, colorStyle: colorStyle)
            let newSprite = Sprite(bitmap: bitmap)
            newSprite.moveTo(x: (Float(index) + 0.5) * Float(widthStep), y: Float(Display.height) / 2)
            newSprite.addSprite()
            sprites.append(newSprite)
        }
        self.sprites = sprites

        let bitmap = Graphics.newBitmap(width: Display.width / 3, height: Display.height / 3, colorStyle: .solid(.colorClear))
        let newSprite = Sprite(bitmap: bitmap)
        newSprite.moveTo(x: Float(Display.width) / 2, y: Float(Display.height) / 2)
        newSprite.addSprite()
        self.invertedSprite = newSprite
    }
    
    mutating func updateGame() {
        let onlyMillis = System.currentTimeMilliseconds % 1000
        let startAngle = Float(onlyMillis) * 360.0 / 1000.0
        let endAngle = Float(onlyMillis + 500) * 360.0 / 1000.0
        let x = Int32(invertedSprite.bounds.width / 2)
        let y = Int32(invertedSprite.bounds.height / 2)
        invertedSprite.withImage {
            Graphics.fillRect(x: x - 25, y: y - 25, width: 50, height: 50, colorStyle: .solid(.colorClear))
            Graphics.fillEllipse(x: x - 25, y: y - 25, width: 50, height: 50, startAngle: startAngle, endAngle: endAngle, colorStyle: .solid(.colorBlack))
        }
        Sprite.updateAndDrawSprites()
    }
}
