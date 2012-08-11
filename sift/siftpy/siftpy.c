#include "Python.h"

#include "sift.hpp"

extern "C" {

  //int _width=800;
  //int _height=640;
  int scale=3;
  int _width=640/scale;
  int _height=480/scale;
  VL::float_t _sigman = 0.500000;
  VL::float_t _sigma0 = 3.200000;
  int _O = 10;
  int _S = 1;
  int _omin = -1; 
  int _smin = -1;
  int _smax = 2;
  float threshold = 0.006667;
  float edgeThreshold = 1.3;

  static float pr(float x) {
    return round(x*100)/100;
  }
  
  //
  // sift()
  //
  static PyObject* py_sift(PyObject* self, PyObject* args)
  {
    // read input
    PyObject* seq;
    if(!PyArg_ParseTuple(args, "O", &seq)) return 0;
    seq = PySequence_Fast(seq, "argument must be iterable");
    int seqlen = PySequence_Fast_GET_SIZE(seq);
    VL::pixel_t* pic = new VL::pixel_t[seqlen];

    double *dbar = new double[seqlen];
    for(int i=0; i < seqlen; i++) {
        PyObject *fitem;
        PyObject *item = PySequence_Fast_GET_ITEM(seq, i);
        fitem = PyNumber_Float(item);
        pic[i] = PyFloat_AS_DOUBLE(fitem);
        //printf("%f\n",PyFloat_AS_DOUBLE(fitem));
        Py_DECREF(fitem);
    }
    Py_DECREF(seq);

    VL::Sift* sift = new VL::Sift(pic,_width,_height,_sigman,_sigma0, _O, _S, _omin, _smin, _smax);
    sift->detectKeypoints(threshold, edgeThreshold);

    // prepare return structure for that many keypoints
    PyObject* result = PyList_New(0);
    
	  for( VL::Sift::KeypointsConstIter iter = sift->keypointsBegin() ;
	       iter != sift->keypointsEnd() ; ++iter ) {
      
      // detect orientations
      VL::float_t angles [4] ;
      int nangles = sift->computeKeypointOrientations(angles, *iter) ;
      //printf ("nangles %d\n",nangles);

      for(int a = 0 ; a < nangles ; ++a) {
	    
        // compute descriptors
        PyObject* row = PyList_New(132);

        PyList_SetItem(row, 0, PyFloat_FromDouble(pr(iter->x)));
        PyList_SetItem(row, 1, PyFloat_FromDouble(pr(iter->y)));
        PyList_SetItem(row, 2, PyFloat_FromDouble(pr(iter->sigma)));
        PyList_SetItem(row, 3, PyFloat_FromDouble(pr(angles[a])));
      
        
        /* compute descriptor */
        VL::float_t descr_pt [128] ;
        sift->computeKeypointDescriptor(descr_pt, *iter, angles[a]) ;

        VL::uint8_t idescr_pt [128] ;
        for(int i = 0 ; i < 128 ; ++i)
          idescr_pt[i] = uint8_t(float_t(512) * descr_pt[i]) ;

        for (int j = 0;j<128;j++){
          PyList_SetItem(row, (4+j), PyFloat_FromDouble(uint32_t( idescr_pt[j] ))); 
        }
        
        PyList_Append(result, row); 
      }
      
    } // next keypoint
  
                             
    delete[] pic;
    delete sift;
       
    return Py_BuildValue("O", result);        
  }

  static PyMethodDef myModule_methods[] = {
    {"sift", py_sift, METH_VARARGS},
    {NULL, NULL}
  };

  void initsiftpy()
  {
    (void) Py_InitModule("siftpy", myModule_methods);
  }
}

#include "sift.cpp"
