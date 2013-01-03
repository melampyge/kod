package org.jlewi.simple;

import java.util.HashMap;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import org.jlewi.simple.alg.Zodiac;
import swisseph.*;

public class Lewi
{  
  String POINTER[] = new String[36];
  String[] POINTER_BASE = new String[36];    
  HashMap map = new HashMap();
    
  public Lewi() {                
    for (int i=0;i<36;i++) {
      POINTER_BASE[i]="";
    }
    POINTER_BASE[6] = "STAR";
    POINTER_BASE[9] = "SQUARE";
    POINTER_BASE[12] = "TRIANGLE";
    POINTER_BASE[18] = "HELIX";
    POINTER_BASE[24] = "TRIANGLE";
    POINTER_BASE[27] = "SQUARE";
    POINTER_BASE[30] = "STAR";

    addCode(SweConst.SE_MOON, "TICK", SweConst.SE_SUN, 245);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_MERCURY, 145);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_VENUS, 146);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_MARS, 147);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_JUPITER , 148);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_SATURN , 149);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_URANUS, 150);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_NEPTUNE, 151);
    addCode(SweConst.SE_MOON , "TICK", SweConst.SE_PLUTO, 254);

    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_SUN, 246);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_MERCURY, 152);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_VENUS, 153);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_MARS, 154);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_JUPITER, 155);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_SATURN, 156);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_URANUS, 157);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_NEPTUNE, 158);
    addCode(SweConst.SE_MOON , "TRIANGLE", SweConst.SE_PLUTO, 255);

    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_SUN, 246);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_MERCURY, 152);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_VENUS, 153);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_MARS, 154);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_JUPITER, 155);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_SATURN, 156);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_URANUS, 157);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_NEPTUNE, 158);
    addCode(SweConst.SE_MOON , "STAR", SweConst.SE_PLUTO, 255);

    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_SUN, 247);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_MERCURY, 159);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_VENUS, 160);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_MARS, 161);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_JUPITER, 162);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_SATURN, 163);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_URANUS, 164);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_NEPTUNE, 165);
    addCode(SweConst.SE_MOON , "SQUARE", SweConst.SE_PLUTO, 256);
        
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_SUN, 247);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_MERCURY, 159);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_VENUS, 160);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_MARS, 161);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_JUPITER, 162);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_SATURN, 163);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_URANUS, 164);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_NEPTUNE, 165);
    addCode(SweConst.SE_MOON , "HELIX", SweConst.SE_PLUTO, 256);
        
    addCode(SweConst.SE_URANUS , "TICK", SweConst.SE_NEPTUNE, 242);
    addCode(SweConst.SE_URANUS , "TICK", SweConst.SE_PLUTO, 272);

    addCode(SweConst.SE_URANUS , "TRIANGLE", SweConst.SE_NEPTUNE, 243);
    addCode(SweConst.SE_URANUS , "TRIANGLE", SweConst.SE_PLUTO, 273);

    addCode(SweConst.SE_URANUS , "STAR", SweConst.SE_NEPTUNE, 243);
    addCode(SweConst.SE_URANUS , "STAR", SweConst.SE_PLUTO, 273);

    addCode(SweConst.SE_URANUS , "SQUARE", SweConst.SE_NEPTUNE, 244);
    addCode(SweConst.SE_URANUS , "SQUARE", SweConst.SE_PLUTO, 274);
                
    addCode(SweConst.SE_URANUS , "HELIX", SweConst.SE_NEPTUNE, 244);
    addCode(SweConst.SE_URANUS , "HELIX", SweConst.SE_PLUTO, 274);

    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_MERCURY, 166);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_VENUS, 167);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_MARS, 168);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_JUPITER, 169);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_SATURN, 170);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_URANUS, 171);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_NEPTUNE, 172);
    addCode(SweConst.SE_SUN , "TICK", SweConst.SE_PLUTO, 251);
        
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_VENUS, 248);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_MARS, 173);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_JUPITER, 174);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_SATURN, 175);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_URANUS, 176);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_NEPTUNE, 177);
    addCode(SweConst.SE_SUN , "TRIANGLE", SweConst.SE_PLUTO, 252);
        
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_VENUS, 248);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_MARS, 173);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_JUPITER, 174);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_SATURN, 175);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_URANUS, 176);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_NEPTUNE, 177);
    addCode(SweConst.SE_SUN , "STAR", SweConst.SE_PLUTO, 252);
        
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_MARS, 178);
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_JUPITER, 179);
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_SATURN, 180);
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_URANUS, 181);
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_NEPTUNE, 182);
    addCode(SweConst.SE_SUN , "SQUARE", SweConst.SE_PLUTO, 253);
        
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_MARS, 178);
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_JUPITER, 179);
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_SATURN, 180);
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_URANUS, 181);
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_NEPTUNE, 182);
    addCode(SweConst.SE_SUN , "HELIX", SweConst.SE_PLUTO, 253);

    addCode(SweConst.SE_SATURN , "TICK", SweConst.SE_URANUS, 236);
    addCode(SweConst.SE_SATURN , "TICK", SweConst.SE_NEPTUNE, 237);
    addCode(SweConst.SE_SATURN , "TICK", SweConst.SE_PLUTO, 269);
        
    addCode(SweConst.SE_SATURN , "TRIANGLE", SweConst.SE_URANUS, 238);
    addCode(SweConst.SE_SATURN , "TRIANGLE", SweConst.SE_NEPTUNE, 239);
    addCode(SweConst.SE_SATURN , "TRIANGLE", SweConst.SE_PLUTO, 270);

    addCode(SweConst.SE_SATURN , "STAR", SweConst.SE_URANUS, 238);
    addCode(SweConst.SE_SATURN , "STAR", SweConst.SE_NEPTUNE, 239);
    addCode(SweConst.SE_SATURN , "STAR", SweConst.SE_PLUTO, 270);

    addCode(SweConst.SE_SATURN , "SQUARE", SweConst.SE_URANUS, 240);
    addCode(SweConst.SE_SATURN , "SQUARE", SweConst.SE_NEPTUNE, 241);
    addCode(SweConst.SE_SATURN , "SQUARE", SweConst.SE_PLUTO, 271);

    addCode(SweConst.SE_SATURN , "HELIX", SweConst.SE_URANUS, 240);
    addCode(SweConst.SE_SATURN , "HELIX", SweConst.SE_NEPTUNE, 241);
    addCode(SweConst.SE_SATURN , "HELIX", SweConst.SE_PLUTO, 271);

    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_VENUS, 183);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_MARS, 184);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_JUPITER, 185);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_SATURN, 186);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_URANUS, 187);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_NEPTUNE, 188);
    addCode(SweConst.SE_MERCURY , "TICK", SweConst.SE_PLUTO, 257);       

    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_VENUS, 189);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_MARS, 190);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_JUPITER, 191);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_SATURN, 192);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_URANUS, 193);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_NEPTUNE, 194);
    addCode(SweConst.SE_MERCURY , "TRIANGLE", SweConst.SE_PLUTO, 258);       

    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_VENUS, 189);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_MARS, 190);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_JUPITER, 191);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_SATURN, 192);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_URANUS, 193);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_NEPTUNE, 194);
    addCode(SweConst.SE_MERCURY , "STAR", SweConst.SE_PLUTO, 258);       

    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_MARS, 195);
    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_JUPITER, 196);
    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_SATURN, 197);
    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_URANUS, 198);
    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_NEPTUNE, 199);
    addCode(SweConst.SE_MERCURY , "SQUARE", SweConst.SE_PLUTO, 259);       

    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_MARS, 195);
    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_JUPITER, 196);
    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_SATURN, 197);
    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_URANUS, 198);
    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_NEPTUNE, 199);
    addCode(SweConst.SE_MERCURY , "HELIX", SweConst.SE_PLUTO, 259);       

    addCode(SweConst.SE_JUPITER , "TICK", SweConst.SE_SATURN , 227);
    addCode(SweConst.SE_JUPITER , "TICK", SweConst.SE_URANUS , 228);
    addCode(SweConst.SE_JUPITER , "TICK", SweConst.SE_NEPTUNE , 229);
    addCode(SweConst.SE_JUPITER , "TICK", SweConst.SE_PLUTO , 266);
        
    addCode(SweConst.SE_JUPITER , "TRIANGLE", SweConst.SE_SATURN , 230);
    addCode(SweConst.SE_JUPITER , "TRIANGLE", SweConst.SE_URANUS , 231);
    addCode(SweConst.SE_JUPITER , "TRIANGLE", SweConst.SE_NEPTUNE , 232);
    addCode(SweConst.SE_JUPITER , "TRIANGLE", SweConst.SE_PLUTO , 267);
        
    addCode(SweConst.SE_JUPITER , "STAR", SweConst.SE_SATURN , 230);
    addCode(SweConst.SE_JUPITER , "STAR", SweConst.SE_URANUS , 231);
    addCode(SweConst.SE_JUPITER , "STAR", SweConst.SE_NEPTUNE , 232);
    addCode(SweConst.SE_JUPITER , "STAR", SweConst.SE_PLUTO , 267);

    addCode(SweConst.SE_JUPITER , "SQUARE", SweConst.SE_SATURN , 233);
    addCode(SweConst.SE_JUPITER , "SQUARE", SweConst.SE_URANUS , 234);
    addCode(SweConst.SE_JUPITER , "SQUARE", SweConst.SE_NEPTUNE , 235);
    addCode(SweConst.SE_JUPITER , "SQUARE", SweConst.SE_PLUTO , 268);

    addCode(SweConst.SE_JUPITER , "HELIX", SweConst.SE_SATURN , 233);
    addCode(SweConst.SE_JUPITER , "HELIX", SweConst.SE_URANUS , 234);
    addCode(SweConst.SE_JUPITER , "HELIX", SweConst.SE_NEPTUNE , 235);
    addCode(SweConst.SE_JUPITER , "HELIX", SweConst.SE_PLUTO , 268);

    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_MARS, 200);
    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_JUPITER, 201);
    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_SATURN, 202);
    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_URANUS, 203);
    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_NEPTUNE, 204);
    addCode(SweConst.SE_VENUS , "TICK", SweConst.SE_PLUTO, 260);       

    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_MARS, 205);
    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_JUPITER, 206);
    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_SATURN, 207);
    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_URANUS, 208);
    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_NEPTUNE, 209);
    addCode(SweConst.SE_VENUS , "TRIANGLE", SweConst.SE_PLUTO, 261); 

    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_MARS, 205);
    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_JUPITER, 206);
    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_SATURN, 207);
    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_URANUS, 208);
    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_NEPTUNE, 209);
    addCode(SweConst.SE_VENUS , "STAR", SweConst.SE_PLUTO, 261); 

    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_MARS, 210);
    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_JUPITER, 211);
    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_SATURN, 212);
    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_URANUS, 213);
    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_NEPTUNE, 214);
    addCode(SweConst.SE_VENUS , "SQUARE", SweConst.SE_PLUTO, 262); 

    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_MARS, 210);
    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_JUPITER, 211);
    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_SATURN, 212);
    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_URANUS, 213);
    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_NEPTUNE, 214);
    addCode(SweConst.SE_VENUS , "HELIX", SweConst.SE_PLUTO, 262); 

    addCode(SweConst.SE_MARS , "TICK", SweConst.SE_JUPITER, 215);
    addCode(SweConst.SE_MARS , "TICK", SweConst.SE_SATURN, 216);
    addCode(SweConst.SE_MARS , "TICK", SweConst.SE_URANUS, 217);
    addCode(SweConst.SE_MARS , "TICK", SweConst.SE_NEPTUNE, 218);
    addCode(SweConst.SE_MARS , "TICK", SweConst.SE_PLUTO, 263); 
        
    addCode(SweConst.SE_MARS , "TRIANGLE", SweConst.SE_JUPITER, 219);
    addCode(SweConst.SE_MARS , "TRIANGLE", SweConst.SE_SATURN, 220);
    addCode(SweConst.SE_MARS , "TRIANGLE", SweConst.SE_URANUS, 221);
    addCode(SweConst.SE_MARS , "TRIANGLE", SweConst.SE_NEPTUNE, 222);
    addCode(SweConst.SE_MARS , "TRIANGLE", SweConst.SE_PLUTO, 264); 

    addCode(SweConst.SE_MARS , "STAR", SweConst.SE_JUPITER, 219);
    addCode(SweConst.SE_MARS , "STAR", SweConst.SE_SATURN, 220);
    addCode(SweConst.SE_MARS , "STAR", SweConst.SE_URANUS, 221);
    addCode(SweConst.SE_MARS , "STAR", SweConst.SE_NEPTUNE, 222);
    addCode(SweConst.SE_MARS , "STAR", SweConst.SE_PLUTO, 263); 

    addCode(SweConst.SE_MARS , "SQUARE", SweConst.SE_JUPITER, 223);
    addCode(SweConst.SE_MARS , "SQUARE", SweConst.SE_SATURN, 224);
    addCode(SweConst.SE_MARS , "SQUARE", SweConst.SE_URANUS, 225);
    addCode(SweConst.SE_MARS , "SQUARE", SweConst.SE_NEPTUNE, 226);
    addCode(SweConst.SE_MARS , "SQUARE", SweConst.SE_PLUTO, 265); 

    addCode(SweConst.SE_MARS , "HELIX", SweConst.SE_JUPITER, 223);
    addCode(SweConst.SE_MARS , "HELIX", SweConst.SE_SATURN, 224);
    addCode(SweConst.SE_MARS , "HELIX", SweConst.SE_URANUS, 225);
    addCode(SweConst.SE_MARS , "HELIX", SweConst.SE_NEPTUNE, 226);
    addCode(SweConst.SE_MARS , "HELIX", SweConst.SE_PLUTO, 265); 

    addCode(SweConst.SE_NEPTUNE , "TICK", SweConst.SE_PLUTO , 275);

    addCode(SweConst.SE_NEPTUNE , "TRIANGLE", SweConst.SE_PLUTO , 276);

    addCode(SweConst.SE_NEPTUNE , "STAR", SweConst.SE_PLUTO , 276);

    addCode(SweConst.SE_NEPTUNE , "SQUARE", SweConst.SE_PLUTO , 277);

    addCode(SweConst.SE_NEPTUNE , "HELIX", SweConst.SE_PLUTO , 277);
  }

  public void addCode(int p1, String angle, int p2, int code) {
    String key = p1+"-"+angle+"-"+p2;
    map.put(key, code);
  }
    
  public int getCode(int p1, String angle, int p2) {
    String key = p1+"-"+angle+"-"+p2;
    if (map.get(key) != null) {
      return (Integer)map.get(key);
    }
    return -1;
  }
    
  /**
   * Based on the location of the planets, calculates the list of
   * Lewi paragraphs
   *
   * @param planets as an <code>int[]</code> of 36 elements, the wheel array
   * whose elements contain the code for the planet if there is a planet there.
   * @return an <code>int[]</code> unpredefined length array containing codes
   * for this person 
   */
  public ArrayList calc (ArrayList[] wheel) {        
    assert wheel.length == 36;
        
    ArrayList traits = new ArrayList();

    // the tricky part of this loop is that we must check all possible
    // matchings of the wheel, with every other wheel sign, while
    // checking our angle mapping (POINTER) table. However, one more
    // gotcha is that every *cell* of the wheel can carry more than one planet!
    // therefore *another* double loop is needed inside right before we
    // check mapping, and that is looping over all possible planets of
    // outer cell with every other planet of the inner cell! Damn! :)        
    for (int outer=0;outer<36;outer++) {

      // instead of trying to remember to measure distances between
      // signs (STAR is 4 after SQUARE, etc), we simply *rotate* the
      // sign wheel so that it matches the outer cell we are looking
      // at. This way, our index access becomes much simpler - we use
      // the same index to access the inner cell and the angle (STAR, SQAURE)
      // information
      rearrangePointerWheel(outer);
            
      for (int inn=0;inn<36;inn++) {

        ArrayList cellOuter = (ArrayList)wheel[outer];
        ArrayList cellInner = (ArrayList)wheel[inn];
                
        if (cellOuter != null) // null means no planet at that cell
          for (int r=0; r < cellOuter.size() ; r++) {
            Object oo = cellOuter.get(r);
            int cOuter = ((Integer)oo).intValue();
                                
            if (cellInner != null) // null means no planet at that cell
              for (int k=0; k<cellInner.size(); k++) {
                Object oi = cellInner.get(k);
                int cInner = ((Integer)oi).intValue();
                        
                int code = getCode(cOuter,
                                   POINTER[inn],
                                   cInner);

                if (code != -1) {
                  traits.add(code);
                }                        
              }
          }

      }
    }


    // Not done yet! Now we must do the TICK matches, that is
    // if more than one planet is in a cell, than all those planets
    // must be matched against eachother one-by-one. In Lewi table
    // these internal mappings are shown with TICK sign

    for (int k=0;k<wheel.length;k++) {

      ArrayList cell = (ArrayList)wheel[k];

      if (cell!=null) 
        for (int i=0;i<cell.size();i++) {
          for (int j=0;j<cell.size();j++) {
            if (i!=j) {
              Object ii = cell.get(i);
              Object jj = cell.get(j);
              int iii = ((Integer)ii).intValue();
              int jjj = ((Integer)jj).intValue();

              int code = getCode(iii,
                                 "TICK",
                                 jjj);

              if (code != -1) {
                traits.add(code);
              }                                                                
            }
          }
        }
    }
        
    return traits;
        
  }


  public void rearrangePointerWheel(int offset) {
    for (int i=0;i<36;i++) {
      POINTER[i]="";
    }
                
    for (int i=0;i<36;i++) {
      if (!POINTER_BASE[i].equals("")) {
        int newIndex =  mod(offset+i, 36);
        POINTER[newIndex] = POINTER_BASE[i];
      }
    }

  }

  static int[] calcLewi(String date) {
      Lewi l = new Lewi();
      ArrayList ll = l.calc(date);
      int[] res = new int[ll.size()];
      for (int i=0;i<ll.size();i++){
	  res[i] = ((Integer)ll.get(i)).intValue();
      }
      return res;
  }
    
  /**
   * Based on birthdate, calculates the Lewi paragraph numbers
   *
   * @param date a <code>String</code> value
   * @return an <code>int[]</code> value
   */
  public ArrayList calc(String date) {
    Zodiac l = new Zodiac();

    int[] decans = l.decans(date);
    assert decans.length == 10;

    ArrayList[] planetWheel = new ArrayList[36];

    // the wheel is a list of lists
    for (int i=0;i<decans.length;i++) {
      ArrayList obj = planetWheel[decans[i]-1];
      ArrayList list ;
      if (obj != null) {
        list = (ArrayList)obj;
      } else {
        list = new ArrayList();
        planetWheel[decans[i]-1] = list;
      }

      list.add(i);
    }

    ArrayList traits = calc(planetWheel);
        
    //
    // One more thing... From the combination of
    // sun and moon sign comes the major character trait
    //
    int sun = l.sign(SweConst.SE_SUN, date);
    int moon = l.sign(SweConst.SE_MOON, date);        
        
    int major = sun * 12 + (moon+1);
    traits.add(major);

    // Done. Sort and return
    Collections.sort(traits);
    return traits;
  }

  /**
   * Describe <code>mod</code> method here.
   *
   * @param a an <code>int</code> value
   * @param b an <code>int</code> value
   * @return an <code>int</code> value
   */
  public int mod(int a, int b) {
    int x = a/b;
    return a-(x*36);
  }    


}
