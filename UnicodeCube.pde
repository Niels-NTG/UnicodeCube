import peasy.*;
import java.awt.Font;
import java.util.Calendar;
import java.lang.Character.UnicodeBlock;

ArrayList<PFont> fontList = new ArrayList<PFont>();
ArrayList<GlyphShape> shapeList = new ArrayList<GlyphShape>();
float fontSize = 64f;
float glyphShapeSize = 128f;

int codePointMax = 0x10000; // 𐀀
int codeBlockCount;
int cubeDimension = (int)Math.cbrt(codePointMax);

PeasyCam cam;
PVector lookAtVector;

void setup() {
    size(1200, 1200, P3D);

    noStroke();
    colorMode(HSB, 1f, 1f, 1f);

    cam = new PeasyCam(this, cubeDimension * glyphShapeSize * 1.5);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(cubeDimension * glyphShapeSize * 2f);
    cam.setWheelScale(0.01);
    cam.setResetOnDoubleClick(false);
    cam.lookAt((float)cubeDimension * glyphShapeSize / 2f, (float)cubeDimension * glyphShapeSize / 2f, (float)cubeDimension * glyphShapeSize / 2f);

    lookAtVector = new PVector(0, 0, 1);

    File dir = new File(sketchPath() + "/data/fonts/");
    File[] listOfFiles = dir.listFiles();
    for (File file : listOfFiles) {
        if (file.isFile()) {
            String fileName = file.getName();
            if (fileName.lastIndexOf(".ttf") != -1 || fileName.lastIndexOf(".otf") != -1) {
                fontList.add(createFont("fonts/" + fileName, fontSize));
            }
        }
    }

    UnicodeBlock lastCodeBlock = UnicodeBlock.of(0x0);
    UnicodeBlock currentCodeBlock  = lastCodeBlock;
    codeBlockCount = 0;
    for (int codePoint = 0; codePoint < codePointMax; ++codePoint) {

        PFont font = findCompatibleFont(codePoint);
        if (font != null) {

            currentCodeBlock = UnicodeBlock.of(codePoint);

            shapeList.add(new GlyphShape(codePoint, codeBlockCount, font));

            if (currentCodeBlock != lastCodeBlock) {
                codeBlockCount++;
                lastCodeBlock = currentCodeBlock;
            }
        } else {
            shapeList.add(null);
        }

    }
}

PFont findCompatibleFont(int codePoint) {
    for (PFont font : fontList) {

        Font nativeFont = (Font)font.getNative();

        if (
            nativeFont.canDisplayUpTo(
                new String(new int[]{codePoint}, 0, 1)
            ) == -1
        ) {
            return font;
        }

    }
    return null;
}

void draw() {
    clear();

    int x = 0;
    int y = 0;
    int z = 0;

    float[] cameraPosition = cam.getPosition();

    for (int i = 0; i < codePointMax; i++) {

        x++;
        if (x > cubeDimension) {
            x = 0;
            y++;
        }
        if (y > cubeDimension) {
            y = 0;
            z++;
        }

        if (shapeList.get(i) != null) {
            shapeList.get(i).draw(x, y, z, cameraPosition);
        }

    }

}

void keyReleased() {
    if (key == 's' || key == 'S') {
        saveFrame(timestamp()+"_####.png");
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
