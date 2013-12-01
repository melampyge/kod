'''
INSTALL:

(pymacs-load "/usr/share/emacs23/site-lisp/pytexipymymy")
(global-set-key [f7] 'pytexipymymy-run-py-code)

When you are in \begin{lstlisting} and \end{lstlisting} blocks, hit
f7 and all code in that block will be sent to a ipython kernel and
the result will be displayed. 

'''

from __future__ import print_function
from StringIO import StringIO
from IPython.kernel.inprocess.blocking import BlockingInProcessKernelClient
from IPython.kernel.inprocess.manager import InProcessKernelManager
from IPython.kernel.inprocess.ipkernel import InProcessKernel
from IPython.utils.io import capture_output

from Pymacs import lisp
import re, sys
interactions = {}
kernels = {}

def get_kernel_pointer(buffer):
    lisp.message("getting kernel for " + buffer)
    if buffer not in kernels:
        lisp.message("creating new " + buffer)
        km = InProcessKernelManager()
        km.start_kernel()
        kc = BlockingInProcessKernelClient(kernel=km.kernel)
        kc.start_channels()
        kernel = InProcessKernel()
        kernels[buffer] = kernel
    return kernels[buffer]
        

def run_py_code():
    lisp.message("buffer file name " + lisp.buffer_file_name())
    lisp.message("buffer  name " + lisp.buffer_name())
    remember_where = lisp.point()
    b = lisp.search_forward("\\end{lstlisting}")
    e = lisp.search_backward("\\begin{lstlisting}")
    content = lisp.buffer_substring(b, e)
    content = re.sub("\\\\begin{lstlisting}.*?\]","",content)
    content = re.sub("\\\\end{lstlisting}","",content)
    
    kernel = get_kernel_pointer(lisp.buffer_name())
    with capture_output() as io:
        kernel.shell.run_cell(content)
    lisp.message(str(io.stdout))
    lisp.goto_char(remember_where)

interactions[run_py_code] = ''
