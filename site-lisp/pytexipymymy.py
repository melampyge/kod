from Pymacs import lisp
import re
interactions = {}

def run_py_code():
    b = lisp.search_forward("\\end{lstlisting}")
    e = lisp.search_backward("\\begin{lstlisting}")
    content = lisp.buffer_substring(b, e)
    content = re.sub("\\\\begin{lstlisting}.*?\]","",content)
    content = re.sub("\\\\end{lstlisting}","",content)
    lisp.message(content)
    

interactions[run_py_code] = ''
