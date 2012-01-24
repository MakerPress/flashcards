ArrayList flashcards;
ArrayList hotspots;

int idx = 0;
int fontSize = 24;
boolean show_answer = false;

void setup() {
  size(600,200);
  textFont (createFont("", fontSize), fontSize);
  flashcards = new ArrayList();
  hotspots = new ArrayList();
  hotspots.add (new Hotspot ("left","data/arrow1_w.png", 10, 160));
  hotspots.add (new Hotspot ("check","data/check.png", 94, 160));
  hotspots.add (new Hotspot ("right","data/arrow1_e.png", 52 , 160));
}


void center_text (String s, int y) {
   int x = (int) (width - textWidth(s))/2; //Centers the text on the x-axis
   text(s,x,y, -width/2); 
}

void draw() {
  background(220,204,170);
  try {
     Flashcard c = (Flashcard) flashcards.get(idx);
     center_text(c.question,50);     
     if (show_answer) {
        center_text(c.answer,100);
     }     
  } catch (Exception e) {
    //Do nothing
  }    
  // Display controls
  for(int i=0; i < hotspots.size(); i++) {
     Hotspot h = (Hotspot) hotspots.get(i);
     h.draw_hotspot();
  }
  
}


void mouseClicked() {
  // LOOP THROUGH THE CONTROLS AND SEE IF THEY CLICKED A BUTTON
  for(int i=0; i < hotspots.size(); i++) {
     Hotspot h = (Hotspot) hotspots.get(i);
     if (h.detect_collision(mouseX, mouseY)) {
       if (h.hotspot_name.equals("left")) {
          idx -= 1;
          show_answer = false;
          if (idx < 0) {
            idx = flashcards.size() - 1;
          }
       }
       if (h.hotspot_name.equals("right")) {
          idx += 1;
          show_answer = false;
          if (idx == flashcards.size()) {
             idx = 0;
           }
       }
       if (h.hotspot_name.equals("check")) {
          show_answer = !show_answer;
       }         
     }
  }
}


void buildFromXML(String xml) {
   XMLElement data = XMLElement.parse(xml);
   XMLElement[] xml = data.getChildren();
   for(int p=0, end=xml.length; p<end; p++) {
      flashcards.add(new Flashcard(xml[p].getStringAttribute("question"), xml[p].getStringAttribute("answer"))); 
    }
    redraw(); 
}


/*
|| Super simple classs to define a fashcard.  It consists for a type
|| and some text
*/
class Flashcard {
  String question;
  String answer;
  
  Flashcard (String _question, String _answer) {
    question = _question;
    answer = _answer;  
  }
}

class Hotspot {
  
  float x, y, w, h;
  String hotspot_name;

  PImage img;
  
  Hotspot (String _hotspot_name, String _image_name, int _x, int _y) {
    hotspot_name = _hotspot_name;
    x = _x;
    y = _y;
    //Now load the image itself
    img = loadImage(_image_name);
    w = 32;
    h = 32;
  }
  
  void draw_hotspot() {
    image(img,x,y);
  }
  

  //Determines is a particular x,y coordinate is within the box
  boolean detect_collision(float cx, float cy) {
     boolean retVal = false;
     if ( (cx > x ) && (cx < (x+w)) && (cy > y) && (cy < (y+h))) {
        retVal= true;
      }
     return retVal;
  }    
}  
  

