'''
DESCRIPTION:
pytexipymymy connects to an inprocess ipython kernel, executes
notebook code, and displays the results automatically in a LaTeX
buffer.

INSTALL:
(pymacs-load "/usr/share/emacs23/site-lisp/pytexipymymy")
(global-set-key [f7] 'pytexipymymy-run-py-code)

When you are in \begin{lstlisting} and \end{lstlisting} blocks, hit
f7 and all code in that block will be sent to a ipython kernel and
the result will be displayed underneath.

Results will be placed in \begin{verbatim}, \end{verbatim} blocks.
The assumption is there is a single space between output block and the
lstlisting block.

TODO: It appears there can be only one inprocess kernel, multiple
InProcessKernel() calls return the same object. As a side effect of
this, variables created in one buffer are seen from a different
buffer.

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

def get_block_content(start_tag, end_tag):
    remember_where = lisp.point()
    block_end = lisp.search_forward(end_tag)
    block_begin = lisp.search_backward(start_tag)
    content = lisp.buffer_substring(block_begin, block_end)
    content = re.sub("\\\\begin{lstlisting}.*?\]","",content)
    content = re.sub("\\\\end{lstlisting}","",content)
    lisp.goto_char(remember_where)
    return block_begin, block_end, content
    
def run_py_code():
    remember_where = lisp.point()
    block_begin,block_end,content = get_block_content("\\begin{lstlisting}","\\end{lstlisting}")
    kernel = get_kernel_pointer(lisp.buffer_name())
    with capture_output() as io:
        kernel.shell.run_cell(content)
    result = str(io.stdout)
    display_results(block_end, result)
    lisp.goto_char(remember_where)    

def display_results(end_block, res):
    lisp.goto_char(end_block)
    lisp.forward_line(2)
    lisp.beginning_of_line()
    verb_line_b = lisp.point()
    lisp.end_of_line()
    verb_line_e = lisp.point()
    verb_line = lisp.buffer_substring(verb_line_b, verb_line_e)
    if "\\begin{verbatim}" in verb_line:
        verb_begin,verb_end,content = get_block_content("\\begin{verbatim}","\\end{verbatim}")
        lisp.delete_region(verb_begin, verb_end)
        lisp.goto_char(verb_begin)
    lisp.insert("\\begin{verbatim}\n")
    lisp.insert(res)
    lisp.insert("\\end{verbatim}")
                

interactions[run_py_code] = ''
