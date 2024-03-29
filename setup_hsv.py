from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext

ext_modules = [Extension("hsv", ["hsv.pyx"],
                         extra_compile_args=["/Qpar", "/fp:fast", "/O2", "/Oy", "/Ot"], language="c")]

setup(
  name="HSV",
  cmdclass={"build_ext": build_ext},
  ext_modules=ext_modules,
)

ext_modules = [Extension("testing", ["testing.pyx"],
                         extra_compile_args=["/Qpar", "/fp:fast", "/O2", "/Oy", "/Ot"], language="c")]

setup(
  name="TESTING",
  cmdclass={"build_ext": build_ext},
  ext_modules=ext_modules,
)