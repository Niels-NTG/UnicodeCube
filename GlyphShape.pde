class GlyphShape {

    int codePoint;
    PFont font;
    String str;
    int unicodeBlockNumber;

    private PVector objectToCameraProjection;
    private PVector upVector;
    private float angle = 0;

    GlyphShape(int _codePoint, int _unicodeBlockNumber, PFont _font) {
        this.codePoint = _codePoint;
        this.font = _font;
        this.str = new String(new int[]{codePoint}, 0, 1);
        this.unicodeBlockNumber = _unicodeBlockNumber;
    }

    void draw(int x, int y, int z, float[] cameraPosition) {
        textFont(font);
        fill(
            unicodeBlockNumber % 2 == 0 ?
                1f / (float)codeBlockCount * unicodeBlockNumber :
                1f - (1f / (float)codeBlockCount * unicodeBlockNumber),
            1f, 1f
        );

        pushMatrix();
        translate(x * glyphShapeSize, y * glyphShapeSize, z * glyphShapeSize);

        objectToCameraProjection = new PVector(
            cameraPosition[0] - x * glyphShapeSize,
            0,
            cameraPosition[2] - z * glyphShapeSize
        );
        objectToCameraProjection.normalize();
        upVector = new PVector();
        PVector.cross(lookAtVector, objectToCameraProjection, upVector);
        angle = PVector.dot(lookAtVector, objectToCameraProjection);

        rotate(acos(angle), upVector.x, upVector.y, upVector.z);

        text(str, 0, 0, 0);
        popMatrix();

    }
}
