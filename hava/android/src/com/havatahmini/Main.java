package com.havatahmini;

import android.app.Activity;
import android.webkit.WebViewClient;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.BufferedReader;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.webkit.WebView;
import java.io.FileInputStream;
import android.content.Context;
import java.io.FileOutputStream;
import java.util.HashMap;
import android.content.Intent;
import android.view.View;
import android.widget.Button;
import android.os.Bundle;

public class Main extends Activity {
  WebView view;
        
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);   
    setContentView(R.layout.main);
    view = (WebView) findViewById(R.id.main);
    view.getSettings().setJavaScriptEnabled(true);
    view.setWebViewClient(new WebViewClient() {  
        @Override  
        public boolean shouldOverrideUrlLoading(WebView view, String url)  
        {
          view.loadUrl(url);  
          return true;  
        }  
      }); 
    view.loadUrl("http://havatahminlerim.appspot.com/mweb/index.html");
  }
  
  
}