import peasy.*;
import java.awt.Font;
import java.nio.charset.Charset;

ArrayList<PFont> fontList = new ArrayList<PFont>();
ArrayList<GlyphShape> shapeList = new ArrayList<GlyphShape>();
float fontSize = 64f;

int codePointMax = 0x10000; // 𐀀
int cubeDimension = (int)Math.cbrt(codePointMax);

PeasyCam cam;

void setup() {
    size(1200, 1200, P3D);


    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(5000);
    cam.setWheelScale(0.2);
    cam.lookAt((double)cubeDimension / 2d, (double)cubeDimension / 2d, (double)cubeDimension / 2d);

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
                new String(new int[]{codePoint}, 0, 1)
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
