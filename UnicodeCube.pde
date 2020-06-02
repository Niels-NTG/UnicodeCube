import peasy.*;
import java.awt.Font;
import java.nio.charset.Charset;
import java.nio.ByteBuffer;

ArrayList<PFont> fontList = new ArrayList<PFont>();
ArrayList<GlyphShape> shapeList = new ArrayList<GlyphShape>();
float fontSize = 64f;

int codePointMax = 0x1f9ff; // 🧿
int cubeDimension = (int)Math.cbrt(codePointMax);

Charset utf32;

PeasyCam cam;

void setup() {
    size(1200, 1200, P3D);

    utf32 = Charset.availableCharsets().get("UTF-32");

    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(5000);
    cam.setWheelScale(0.2);
    cam.lookAt((float)cubeDimension / 2f, (float)cubeDimension / 2f, (float)cubeDimension / 2f);


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

    println(fontList.size());

    for (int codePoint = 0; codePoint < codePointMax; ++codePoint) {

        PFont font = findCompatibleFont(codePoint);
        if (font != null) {
            shapeList.add(new GlyphShape(codePoint, font));
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
                new String(intToBytes(codePoint), utf32)
            ) == -1
        ) {
            return font;
        }

    }
    return null;
}

void draw() {
    background(255);
    noStroke();
    fill(0);

    int x = 0;
    int y = 0;
    int z = 0;

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
            fill(
                map(x, 0, cubeDimension, 0, 255),
                map(y, 0, cubeDimension, 0, 255),
                map(z, 0, cubeDimension, 0, 255)
            );
            shapeList.get(i).draw(x, y, z);
        }

    }

}

byte[] intToBytes(int x) {
    byte[] bytes = new byte[] {
        (byte)(x >>> 24),
        (byte)(x >>> 16),
        (byte)(x >>> 8),
        (byte)x
    };

    return bytes;
}
