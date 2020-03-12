#include "request_pb_server.h"
#include <Python.h>

/*请求服务并将结果存入文件*/
bool RequestServerAndShowResult()
{
	Py_Initialize();//使用python之前，要调用Py_Initialize();这个函数进行初始化
	if (!Py_IsInitialized())
	{
		printf("初始化失败！");
		return false;
	}
	PyRun_SimpleString("import sys");
	PyRun_SimpleString("sys.path.append('../../')");//这一步很重要，修改Python路径

	PyObject * pModule = NULL;//声明变量
	pModule = PyImport_ImportModule("request_and_analysis_response");//这里是要调用的文件名hello.py
	if (pModule == NULL)
	{
		cout << "没找到" << endl;
		return false;
	}
	PyObject * pFunc1 = NULL;// 声明变量
	pFunc1 = PyObject_GetAttrString(pModule, "RequestAndShowResult");//这里是要调用的函数名
	PyObject* pRet = PyEval_CallObject(pFunc1, NULL);//调用无参数无返回值的python函数
	Py_Finalize(); // 与初始化对应
	return true;
}

/*请求服务并将结果存入文件*/
bool RequestServerSaveResultToFile()
{
	Py_Initialize();//使用python之前，要调用Py_Initialize();这个函数进行初始化
	if (!Py_IsInitialized())
	{
		printf("初始化失败！");
		return false;
	}
	PyRun_SimpleString("import sys");
	PyRun_SimpleString("sys.path.append('../../')");//这一步很重要，修改Python路径

	PyObject * pModule = NULL;//声明变量
	pModule = PyImport_ImportModule("mytest");//这里是要调用的文件名hello.py
	if (pModule == NULL)
	{
		cout << "没找到" << endl;
		return false;
	}
	PyObject * pFunc1 = NULL;// 声明变量
	pFunc1 = PyObject_GetAttrString(pModule, "SingleRequest");//这里是要调用的函数名
	PyObject* pRet = PyEval_CallObject(pFunc1, NULL);//调用无参数无返回值的python函数
	int code = 0;
	PyArg_Parse(pRet, "i", &code);
	if (code != 200)
	{
		return false;
	}
	PyObject* pFunc2 = PyObject_GetAttrString(pModule, "SaveTofile");//这里是要调用的函数名
	PyEval_CallObject(pFunc2, NULL);//调用无参数无返回值的python函数
	Py_Finalize(); // 与初始化对应
	return true;
}
