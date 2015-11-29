#include "Python.h"

#include "sift.hpp"

extern "C" {
  
  //
  // sift()
  //
  static PyObject* py_sift(PyObject* self, PyObject* args)
  {
    char *filename;
    if (!PyArg_ParseTuple(args, "s", &filename)) {
      return NULL;
    }
    //printf ("%s",
    Py_RETURN_NONE;
  }

  static PyMethodDef myModule_methods[] = {
    {"sift", py_sift, METH_VARARGS},
    {NULL, NULL}
  };

  void initsiftpy1()
  {
    (void) Py_InitModule("siftpy1", myModule_methods);
  }
}

#include "sift.cpp"
