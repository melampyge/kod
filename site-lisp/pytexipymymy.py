from Pymacs import lisp
interactions = {}

def run_py_code():
    b = lisp.search_forward("\\end{lstlisting}")
    e = lisp.search_backward("\\begin{lstlisting}")
    content = lisp.buffer_substring(b, e)
    lisp.message(content)

interactions[run_py_code] = ''
