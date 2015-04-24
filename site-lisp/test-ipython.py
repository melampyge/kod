from IPython.testing.globalipapp import get_ipython
from IPython.utils.io import capture_output
ip = get_ipython()

def run_cell(cmd):
    with capture_output() as io:
        res = ip.run_cell(content)
        print 'suc', res.success
        print 'res', res.result
    res_out = io.stdout
    print 'res out', res_out

content = "print (111+222)"
run_cell(content)
content = "alsdkjflajksf"
run_cell(content)
