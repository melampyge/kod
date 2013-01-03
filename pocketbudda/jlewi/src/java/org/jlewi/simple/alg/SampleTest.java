package org.jlewi.simple.alg;

import org.testng.annotations.*;

import swisseph.*;
import java.io.RandomAccessFile;
import java.io.File;
import java.io.BufferedReader;
import java.io.InputStreamReader;

import java.net.URL;
import java.io.FileOutputStream;
import java.io.Writer;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.DataInputStream;
import java.util.Date;

public class SampleTest   {

    
  @Test
  public void testXy() throws Exception{
    SwissEph e = new SwissEph();
  }

  @Test
  public void testXX() {
    Zodiac l = new Zodiac();
    assert 1 == l.decanWithinSign(0, "24.04.1973");
  }

  @Test
  public void testPlanets() {
    Zodiac l = new Zodiac();
    int i[] = l.decans("24.04.1973");
    assert i[1] == 29;
  }

  @Test
  public void testLewi() {
    Zodiac l = new Zodiac();
    int i;

    //4
    i = l.decan(0, "24.4.1973");
    assert 4 == i;
        
    //29
    i = l.decan(1, "24.4.1973");
    assert 29 == i;

    //1
    i = l.decan(2, "24.4.1973");
    assert 1 == i;

    //4
    i = l.decan(3, "24.4.1973");
    assert 4 == i;

    //32
    i = l.decan(4, "24.4.1973");
    assert 32 == i;

  }
    
}

