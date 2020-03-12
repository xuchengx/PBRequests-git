#!/usr/bin/python
# -*- coding: UTF-8 -*-


py_source = ".\\multi_eta_struct_pb2.py"

py_dest = "..\\..\\..\\..\\"

import os
if __name__ == "__main__":
	os.system("protoc --python_out=./ multi_eta_struct.proto")
	os.system("protoc --cpp_out=./ multi_eta_struct.proto")
	os.system("copy %s %s"% (py_source, py_dest))