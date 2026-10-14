"""Run with mqit-env's Python. No network, Azure account, or quantum hardware."""
import sys
from importlib.metadata import version

import ipykernel
import ipywidgets as widgets
import matplotlib
import numpy as np
from IPython.core.interactiveshell import InteractiveShell

shell = InteractiveShell.instance()
result = shell.run_cell('from qdk import qsharp')
if not result.success:
    raise RuntimeError('Q# import failed')
result = shell.run_cell('''%%qsharp
operation MQITSmokeTest() : Result {
    use q = Qubit();
    X(q);
    return MResetZ(q);
}
MQITSmokeTest()
''')
if not result.success or str(result.result) != 'One':
    raise RuntimeError(f'Q# execution failed: {result.error_in_exec}, result={result.result}')
radio = widgets.RadioButtons(options=['a', 'b'], value=None)
changes = []
radio.observe(lambda change: changes.append(change['new']), names='value')
radio.value = 'b'
if changes != ['b']:
    raise RuntimeError('Widget callbacks failed')
radio.close()
if not np.allclose(np.eye(2) @ np.array([1, 0]), [1, 0]):
    raise RuntimeError('NumPy smoke test failed')
print(f'Python: {sys.executable}')
for package in ('ipython', 'ipykernel', 'ipywidgets', 'qsharp', 'qdk', 'numpy', 'matplotlib'):
    print(f'{package}: {version(package)}')
print('Python/QDK smoke test passed. Check frontend widget rendering in testQ.ipynb next.')
