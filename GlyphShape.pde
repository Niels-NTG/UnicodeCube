class GlyphShape {

    int codePoint;
    PFont font;
    String str;

    private PVector objectToCameraProjection;
    private PVector upVector;
    private float angle = 0;

    GlyphShape(int _codePoint, PFont _font) {
        this.codePoint = _codePoint;
        this.font = _font;
        this.str = new String(new int[]{codePoint}, 0, 1);
    }

    void draw(int x, int y, int z, float[] cameraPosition) {
        textFont(font, fontSize);

        pushMatrix();
        // translate(x * fontSize, y * fontSize, z * fontSize);

        objectToCameraProjection = new PVector(
            cameraPosition[0] - x * fontSize,
            0,
            cameraPosition[2] - z * fontSize
        );
        objectToCameraProjection.normalize();
        upVector = new PVector();
        PVector.cross(lookAtVector, objectToCameraProjection, upVector);
        angle = PVector.dot(lookAtVector, objectToCameraProjection);

        rotate(acos(angle), upVector.x, upVector.y, upVector.z);

        popMatrix();
        text(str, x * fontSize, y * fontSize, z * fontSize);

    }
}
