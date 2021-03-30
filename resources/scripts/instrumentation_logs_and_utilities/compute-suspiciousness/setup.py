import setuptools

setuptools.setup(
    name='compute-suspiciousness',
    version='1.0',
    author='Austin Mordahl',
    author_email='austin.mordahl@utdallas.edu',
    description='Utility to compute suspiciousness of data structures.',
    packages=setuptools.find_packages(),
    install_requires=['tqdm','Levenshtein'],
    entry_points={
        'console_script': [
            'compute-suspiciousness = compute_suspiciousness.__main__:main'
        ],
    }
)

