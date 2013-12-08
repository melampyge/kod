'''
DESCRIPTION:

pytexipy-notebook connects to an inprocess ipython kernel, executes
notebook code, and displays the results automatically in a LaTeX
buffer.

EMACS INSTALL:

(pymacs-load "/usr/share/emacs23/site-lisp/pytexipy-notebook")
(global-set-key [f1] 'pytexipy-notebook-run-py-code) ; choose any key you like

Add this to your (custom-set-variables

'(preview-LaTeX-command (quote ("%`%l -shell-escape \"\\nonstopmode\\nofiles\\PassOptionsToPackage{"
("," . preview-required-option-list) "}{preview}\\AtBeginDocument{\\ifx\\ifPreview\\undefined"
preview-default-preamble "\\fi}\"%' %t")))

When you are in \begin{minted}{python} and \end{minted} blocks, hit f1
and all code in that block will be sent to a ipython kernel and the
result will be displayed underneath. If we are on
\inputminted{python}{file.py} block, Python code will be loaded from
script filename found between curly braces.

Results will be placed in \begin{verbatim}, \end{verbatim} blocks
right next to the code, with one space in between. If a verbatim blocks
already exists there, it will be refreshed. If not, it will be added.

LIMITATIONS:

* For now, there is one kernel per Emacs session.

'''

from __future__ import print_function
from StringIO import StringIO
from IPython.kernel.inprocess.blocking import BlockingInProcessKernelClient
from IPython.kernel.inprocess.manager import InProcessKernelManager
from IPython.kernel.inprocess.ipkernel import InProcessKernel
from IPython.core.interactiveshell import InteractiveShell
from IPython.utils.io import capture_output

from Pymacs import lisp
import re, sys, time, os
interactions = {}
kernels = {}

def decorated_run_code(fn):
    def new_run_code(*args, **kwargs):
        res = fn(*args, **kwargs)
        setattr(args[0], "last_known_outflag", res)
        return res
    return new_run_code

# wrapping run_code method inside InteractiveShell, we trap the return
# code here which is 1 for failure, 0 for good, there was no other
# way to sense an error for its callers. _get_exc_info is no good,
# because it will keep returning the same errors until the next error
# resets its state. 
InteractiveShell.run_code = decorated_run_code(InteractiveShell.run_code)    

def get_kernel_pointer(buffer):
    lisp.message("getting kernel for " + buffer)
    if buffer not in kernels:
        lisp.message("creating new " + buffer)
        km = InProcessKernelManager()
        km.start_kernel()
        kc = BlockingInProcessKernelClient(kernel=km.kernel)
        kc.start_channels()
        kernel = InProcessKernel()
        kernels[buffer] = (kc,kernel,kernel.shell.get_ipython())
        # run this so that plt, np pointers are ready
        kc.shell_channel.execute('%pylab inline')
    return kernels[buffer]

def get_block_content(start_tag, end_tag):
    remember_where = lisp.point()
    block_end = lisp.search_forward(end_tag)
    block_begin = lisp.search_backward(start_tag)
    content = lisp.buffer_substring(block_begin, block_end)
    content = re.sub("\\\\begin{minted}{python}","",content)
    content = re.sub("\\\\end{minted}","",content)
    lisp.goto_char(remember_where)
    return block_begin, block_end, content

def get_buffer_content_prev(bend):
    where_am_i = lisp.point()
    lisp.beginning_of_buffer(); st = lisp.point()
    s = lisp.buffer_substring(st,bend)
    lisp.goto_char(where_am_i)
    return s

def run_py_code():
    remember_where = lisp.point()
    # check if the line contains \inputminted
    lisp.beginning_of_line()
    l1 = lisp.point()
    lisp.end_of_line()
    l2 = lisp.point()
    line = lisp.buffer_substring(l1,l2)
    # if code comes from file
    if "\\inputminted" in line:
        lisp.message(line)
        py_file = re.search("\{python\}\{(.*?)\}", line).groups(1)[0]
        # get code content from file
        curr_dir = os.path.dirname(lisp.buffer_file_name())
        content = open(curr_dir + "/" + py_file).read()
        block_end = l2 # end of block happens to be end of include file line
        lisp.goto_char(remember_where)
    else:
        # get code content from latex
        block_begin,block_end,content = get_block_content("\\begin{minted}","\\end{minted}")

    # we have code content at this point

    # scan content to find plt.plot(). if there is, scan buffer
    # previous to *here* to determine order of _this_ plt.plot(), and
    # give it an appropiate index that will be appended to the end of
    # the .png image file, i.e. [buffer name]_[index].png. plt.plot()
    # commands will be replaced by the corresponding plt.savefig
    # command.
    
    bc = get_buffer_content_prev(block_begin)
    fout = open("/tmp/out", "w")
    fout.write(bc); fout.close()
    plt_count_before = len(re.findall('plt\.plot\(\)',bc))
    lisp.message("plts before="+str(plt_count_before))
                
    (kc,kernel,ip) = get_kernel_pointer(lisp.buffer_name())
    start = time.time()
    res = ''
    with capture_output() as io:
        ip.run_cell(content)
    res = io.stdout
    if kernel.shell.last_known_outflag:
        etype, value, tb = kernel.shell._get_exc_info()
        res = str(etype) + " " + str(value)  + "\n"        
    elapsed = (time.time() - start)
    # replace this unnecessary message so output becomes blank
    if res and len(res) > 0:  # if result not empty
        res = res.replace("Populating the interactive namespace from numpy and matplotlib\n","")
        display_results(block_end, res) # display it
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
    res=res.replace("\r","")
    lisp.insert("\\begin{verbatim}\n")
    lisp.insert(res)
    lisp.insert("\\end{verbatim}")

interactions[run_py_code] = ''
