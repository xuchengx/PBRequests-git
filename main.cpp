#include "creat_pb_func.h"
#include "request_pb_server.h"


int main()
{
	/*创建PB请求数据*/
	CreatPBFile();

	RequestServerAndShowResult();
		
	return 0;
}