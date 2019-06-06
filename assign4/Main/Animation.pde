// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int c;

  Animation(String imagePrefix, int count, int size) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + (i+1) + ".png";
      images[i] = loadImage(filename);
      images[i].resize(0, size);
    }
  }

  void display(float xpos, float ypos) {
    c++;
    if (c % 5 == 0) {
      frame = (frame+1) % imageCount;
    }
    image(images[frame], xpos, ypos);
  }

  int getWidth() {
    return images[0].width;
  }
}
