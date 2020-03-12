#include "creat_pb_func.h"
#include "multi_eta_struct.pb.h"

struct TestPoint
{
	double x;
	double y;
};

void SetWayPointInfo(MultiEtaInfo::Request& _pb_data)
{
	/*添加途经点信息*/

	struct WayPointInfo
	{
		int link_id;
		int index;
		TestPoint on_link_point;
	};

	std::vector<WayPointInfo> way_point_info;
	WayPointInfo temp[] = {
		{ 40386696, 0, { 118.11116, 40.19738 } },
		{ 40386695, 1, { 118.11116, 40.19738 } },
		{ 40386695, 2, { 118.11116, 40.19738 } },
		{ 40386696, 3, { 118.11116, 40.19738 } }
	};
	for (int index = 0; index < 4; ++index)
	{
		way_point_info.push_back(temp[index]);
	}

	for (int index = 0; index < way_point_info.size(); index++)
	{
		MultiEtaInfo::RouteLocation* pway_point = _pb_data.add_rppoint();
		MultiEtaInfo::Point* pway_point_onlink = new MultiEtaInfo::Point;
		pway_point_onlink->set_x(way_point_info[index].on_link_point.x);
		pway_point_onlink->set_y(way_point_info[index].on_link_point.y);
		pway_point->set_allocated_on_link_point(pway_point_onlink);
		pway_point->set_link_id(way_point_info[index].link_id);

		_pb_data.add_linkidx(way_point_info[index].index);
	}
}

void SetRpLinksInfo(MultiEtaInfo::Request& _pb_data)
{
	struct TrafficInfo
	{
		int type;
		int speed;
		int status;
	};
	struct LinkInfoSt
	{
		int link_id;
		int link_reversed;
		TrafficInfo traffic_array[4];
	};
	/*添加link信息*/
	LinkInfoSt links_array[4] = {
		{ 40386696, 1, { { 1, 400, 3 }, { 2, 300, 3 }, { 3, 200, 3 }, { 4, 100, 3 } } },
		{ 40386695, 0, { { 1, 400, 3 }, { 2, 300, 3 }, { 3, 200, 3 }, { 4, 100, 3 } } },
		{ 40386695, 0, { { 1, 400, 3 }, { 2, 300, 3 }, { 3, 200, 3 }, { 4, 100, 3 } } },
		{ 40386696, 0, { { 1, 400, 3 }, { 2, 300, 3 }, { 3, 200, 3 }, { 4, 100, 3 } } } };
	for (int links_index = 0; links_index < 4; links_index++)
	{
		MultiEtaInfo::LinkInfo* plink_info = _pb_data.add_rplinks();
		plink_info->set_link_id(links_array[links_index].link_id);
		plink_info->set_reversed(links_array[links_index].link_reversed);
		for (int traffic_index = 0; traffic_index < 4; ++traffic_index)
		{
			MultiEtaInfo::TrafficInfo* ptraffic_info = plink_info->add_traffics();
			ptraffic_info->set_type(links_array[links_index].traffic_array[traffic_index].type);
			ptraffic_info->set_speed(links_array[links_index].traffic_array[traffic_index].speed);
			ptraffic_info->set_status(links_array[links_index].traffic_array[traffic_index].status);
		}
	}
}
/*****************************************************************************
* @brief : 创建二进制PB格式数据
* @author : xucx
* @date : 2020/3/5 14:01
* @version : ver 1.0
* @inparam : 无
* @outparam :
* _pb_data：生成的pb数据
* @return :无
* @function name:CreatTestPBData
*****************************************************************************/
struct TestRouteLocation
{
	int link_id;
	TestPoint on_link_point;
};

void SetTestRouteLoaction(const TestRouteLocation& _source, MultiEtaInfo::RouteLocation* _p_route_location)
{
	MultiEtaInfo::Point* porigin_point = new MultiEtaInfo::Point;
	porigin_point->set_x(_source.on_link_point.x);
	porigin_point->set_y(_source.on_link_point.y);
	_p_route_location->set_allocated_on_link_point(porigin_point);
	_p_route_location->set_link_id(_source.link_id);
}

void CreatBinaryTestPBData(std::string& _pb_data_binary)
{
	MultiEtaInfo::Request pb_data;
	/*定义起点数据*/
	TestRouteLocation origin_data = { 40386696, { 118.11116, 40.19738 } };
	MultiEtaInfo::RouteLocation* porigin = new MultiEtaInfo::RouteLocation;
	/*设置起点数据*/
	SetTestRouteLoaction(origin_data, porigin);
	pb_data.set_allocated_origin(porigin);

	/*定义终点数据*/
	TestRouteLocation destination_data = { 40386696, { 118.11116, 40.19738 } };
	MultiEtaInfo::RouteLocation* destination = new MultiEtaInfo::RouteLocation;
	/*设置终点数据*/
	SetTestRouteLoaction(destination_data, destination);
	pb_data.set_allocated_destination(destination);

	/*设置数据版本*/
	std::string data_version = "19Q1M2";
	pb_data.set_map_db_version(data_version);

	SetWayPointInfo(pb_data);

	SetRpLinksInfo(pb_data);

	_pb_data_binary = pb_data.SerializeAsString();

}

void CreatPBFile()
{
	std::string binary_pb_data;

	CreatBinaryTestPBData(binary_pb_data);

	std::string file_name = "./pb_request_binnar.txt";

	FILE* file_handle = fopen(file_name.c_str(), "wb");

	fwrite(binary_pb_data.c_str(), 1, binary_pb_data.size(), file_handle);

	fclose(file_handle);
}