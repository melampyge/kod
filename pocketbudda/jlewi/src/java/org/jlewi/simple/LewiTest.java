package org.jlewi.simple;

import org.testng.annotations.Test;
import java.math.BigInteger;
import java.util.ArrayList;

public class LewiTest   {

  @Test
  public void testT() {
    Lewi l = new Lewi();
    ArrayList r = l.calc("24.04.1973");
    assert r.get(0).equals((Integer)22);
    for (Object i:r) {
      System.out.println("i=" + (Integer)i);
    }
  }      
  
  @Test
  public void testShake() {
    System.out.println ("--------");
    Lewi l = new Lewi();
    ArrayList r = l.calc("23.04.1564");
    for (Object i:r) {
      System.out.println("i=" + (Integer)i);
    }
  }   
}

