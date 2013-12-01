'''
DESCRIPTION:
pytexipymymy connects to an inprocess ipython kernel, executes
notebook code, and displays the results automatically in a LaTeX
buffer.

INSTALL:
(pymacs-load "/usr/share/emacs23/site-lisp/pytexipymymy")
(global-set-key [f1] 'pytexipymymy-run-py-code)

When you are in \begin{lstlisting} and \end{lstlisting} blocks, hit
f1 and all code in that block will be sent to a ipython kernel and
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
import re, sys, time, os
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
    # check if the line contains \lstinputlisting
    lisp.beginning_of_line()
    l1 = lisp.point()
    lisp.end_of_line()
    l2 = lisp.point()
    line = lisp.buffer_substring(l1,l2)
    # if code comes from file
    if "\\lstinputlisting" in line:
        lisp.message(line)
        py_file = re.search("\{(.*?)\}", line).groups(1)[0]
        # get code content from file
        curr_dir = os.path.dirname(lisp.buffer_file_name())
        content = open(curr_dir + "/" + py_file).read()
        block_end = l2 # end of block happens to be end of include file line
        lisp.goto_char(remember_where)
    else:
        # get code content from latex
        block_begin,block_end,content = get_block_content("\\begin{lstlisting}","\\end{lstlisting}")
        
    kernel = get_kernel_pointer(lisp.buffer_name())
    with capture_output() as io:        
        start = time.time()
        kernel.shell.run_cell(content)
        elapsed = (time.time() - start)
    result = str(io.stdout)
    if len(result) > 0: # if result not empty
        display_results(block_end, result) # display it
    lisp.goto_char(remember_where)
    lisp.message("Ran in " + str(elapsed) + " seconds")

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
    else:
        lisp.backward_line_nomark(1)
        lisp.insert("\n")
    lisp.insert("\\begin{verbatim}\n")
    lisp.insert(res)
    lisp.insert("\\end{verbatim}")

def run_all_py():
    pass

interactions[run_py_code] = ''
