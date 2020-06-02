class GlyphShape {

    int codePoint;
    PFont font;
    String str;

    GlyphShape(int _codePoint, PFont _font) {
        this.codePoint = _codePoint;
        this.font = _font;
        this.str = new String(intToBytes(codePoint), utf16);
    }

    void draw(int x, int y, int z) {
        textFont(font, fontSize);
        text(str, x * fontSize, y * fontSize, z * fontSize);
    }
}
