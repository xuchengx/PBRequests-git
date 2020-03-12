#!/usr/bin/python
# -*- coding: UTF-8 -*-

import requests
import time
import datetime
import threading
from google.protobuf.json_format import MessageToJson, Parse
from multi_eta_struct_pb2 import Response


url = 'http://192.168.145.80:8088/bmw/v1/calc/pbmultieta'

data_path = "pb_request_binnar.txt"

def GetBinaryData(data_path):
	f = open(data_path, 'rb')
	data = f.read()
	f.close()
	return data

def PostRespons(url, data):
	r = requests.post(url,data)
	return r


def SingleRequest():
	data = GetBinaryData(data_path)
	return PostRespons(url, data)
	

def MultiRequests(file_handle):
	respons_max = 10000000
	i = 0
	data = GetRequestData()
	while i < respons_max:
		r = PostRespons(url, data)
		if r.status_code != 200:
			print("code is %d,index is %d"%(r.status_code, i))
			break;
		#print(r.status_code)
		i = i + 1
		time.sleep(0.1)
	string = "set max is "+ str(respons_max) +"!" + "end index is " + str(i)
	file_handle.write(string)
	
def ThreadFunc(threadName, delay):
	now = time.strftime("%Y-%m-%d-%H_%M_%S",time.localtime(time.time())) 
	file_name = now +".txt"
	file_handle = open(file_name,'w')
	MultiRequests(file_handle)
	file_handle.close()


class myThread (threading.Thread):
	def __init__(self, threadID, name, counter):
		threading.Thread.__init__(self)
		self.threadID = threadID
		self.name = name
		self.counter = counter
	def run(self):
		print ("开始线程：" + self.name)
		ThreadFunc(self.name, self.counter)
		print ("退出线程：" + self.name)

def MultiRequest():
	thread_index = 0 
	thread_num = 8
	thread_list = list()
	while thread_index < thread_num:
		name = "Thread-"+ str(thread_index)
		print(name)
		thread = myThread(thread_index, name, thread_index)
		thread.start()
		thread_list.append(thread)
		thread_index = thread_index + 1
		time.sleep(2)
	
	for thread in thread_list:
		thread.join()

	
def PBStringToJson(pb_string):
	response_data = Response()
	response_data.ParseFromString(pb_string)
	json_data =  MessageToJson(response_data,True,True)
	return json_data
	
#发出请求并且展示结果
def RequestAndShowResult():
	req = SingleRequest()
	json_string = PBStringToJson(req.content)
	SaveStringToFile("./result_json.txt",json_string, "w")
	print(json_string)


def SaveStringToFile(file_name, string,mode):
	f = open(file_name,mode)
	f.write(string)
	f.close()
	
	
def Test():
	binary_str = GetBinaryData("./result_binary.txt")
	jdata = PBStringToJson(binary_str)
	print(jdata)
	
if __name__ == "__main__":
	RequestAndShowResult()
	
	
	
	
	
	
	
	
	
	
	