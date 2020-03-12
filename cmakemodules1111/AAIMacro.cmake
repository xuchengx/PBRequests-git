MACRO(AA_Server_CORE Module_NAME)

        SET(TARGET_NAME ${Module_NAME} )
        SET(TARGET_TARGETNAME ${Module_NAME} )
 		INCLUDE_DIRECTORIES("../include")

MESSAGE(STATUS ${TARGET_TARGETNAME})
MESSAGE(STATUS ${TARGET_SRC})
MESSAGE(STATUS ${TARGET_H})

		IF   (IS_DYNAMIC_DB_CORE)
			ADD_LIBRARY(${TARGET_TARGETNAME} SHARED ${TARGET_SRC} ${TARGET_H})
		ELSE (IS_DYNAMIC_DB_CORE)
			ADD_LIBRARY(${TARGET_TARGETNAME} STATIC ${TARGET_SRC} ${TARGET_H})
		ENDIF(IS_DYNAMIC_DB_CORE)
		
		Install(TARGETS ${TARGET_TARGETNAME} 
				ARCHIVE DESTINATION ${ThirdParty_PATH}/core/lib
				LIBRARY DESTINATION ${ThirdParty_PATH}/core/lib
				RUNTIME DESTINATION ${ThirdParty_PATH}/core/bin
				)
				
		set_target_properties(${TARGET_TARGETNAME} PROPERTIES FOLDER "core")	
		
ENDMACRO(AA_Server_CORE)

MACRO(AA_Engine_Function Module_NAME)

        SET(TARGET_NAME ${Module_NAME} )
        SET(TARGET_TARGETNAME ${Module_NAME} )
 		INCLUDE_DIRECTORIES("../include")



IF (${CMAKE_BUILD_TYPE} STREQUAL "RELEASE" OR ${CMAKE_BUILD_TYPE} STREQUAL "Release")
	IF (WIN32)
		include_directories(${ThirdParty_PATH}/route_engine/navicore-x64-std/include)
		link_directories(${ThirdParty_PATH}/route_engine/navicore-x64-std/lib/Release)
	ELSE()
		include_directories(${ThirdParty_PATH}/route_engine/navicore-linux_x64-std/include)
		link_directories(${ThirdParty_PATH}/route_engine/navicore-linux_x64-std/lib/Release)
	ENDIF()

ELSE()
	IF (WIN32)
		include_directories(${ThirdParty_PATH}/route_engine/navicore-x64-std_debug/include)
		link_directories(${ThirdParty_PATH}/route_engine/navicore-x64-std_debug/lib/Debug)
	ELSE()
		include_directories(${ThirdParty_PATH}/route_engine/navicore-linux_x64-std_debug/include)
		link_directories(${ThirdParty_PATH}/route_engine/navicore-linux_x64-std_debug/lib/Debug)
	ENDIF()
ENDIF()



		IF   (IS_DYNAMIC_DB_CORE)
			ADD_LIBRARY(${TARGET_TARGETNAME} SHARED ${TARGET_SRC} ${TARGET_H})
		ELSE (IS_DYNAMIC_DB_CORE)
			ADD_LIBRARY(${TARGET_TARGETNAME} STATIC ${TARGET_SRC} ${TARGET_H})
		ENDIF(IS_DYNAMIC_DB_CORE)
		
if(WIN32)
	LINK_DIRECTORIES(
			 ${OUTPUT_LIBDIR}
					)
else(WIN32)


link_directories("/usr/local/lib"
"/usr/lib"
 ${OUTPUT_LIBDIR}
)

endif(WIN32)





				
		set_target_properties(${TARGET_TARGETNAME} PROPERTIES FOLDER "engine")	
	

		IF(WIN32)
		add_definitions(
		-DSERVER_DEBUG
		-DAMD64
		-D_CONSOLE
		-DWIN32
		-D_WINX32_
		-DMAPBAR_LOG_LEVEL=3
		-DNETNAVI_TMC_MODULE
		-DPTW32_STATIC_LIB
		-DNAVI_CORE_TRUNK
		-DUSE_GUIDANCE_V3
		-DNETNAVI_SUPPORT_PEDESTRIAN
		)
		ELSE(WIN32)
			add_definitions(
				-DAMD64
				-DNAVI_CORE_TRUNK
				-DLINUX
		  
				-DMAPBAR_LINUX_X64
				-DMAPBAR_OS_UNIX
				-DUSE_GUIDANCE_V3
				-DNETNAVI_SUPPORT_PEDESTRIAN
			)
		Endif(WIN32)
	
ENDMACRO(AA_Engine_Function)

MACRO(ADD_Raw_Engine)

INCLUDE_DIRECTORIES("../include"
${PROJECT_SOURCE_DIR}/include
${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ti-shared-code-lib/include
${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib/ncserver-extend
${PROJECT_SOURCE_DIR}/server/route-server_v${RouteServerVersion}
${PROJECT_SOURCE_DIR}/server/route-server_v${RouteServerVersion}/src
${PROJECT_SOURCE_DIR}/server/route-server_v${RouteServerVersion}/src/traffic
)

link_directories(
	${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib
	${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ti-shared-code-lib/lib
	${ThirdParty_PATH}/thrift/lib
	${ThirdParty_PATH}/OpenSSL/lib
	)	

add_definitions(
-DROUTE_SERVERVERSION=${RouteServerVersion}
)
MESSAGE(STATUS ${CMAKE_BUILD_TYPE})
 
IF (${CMAKE_BUILD_TYPE} STREQUAL "RELEASE" OR ${CMAKE_BUILD_TYPE} STREQUAL "Release")
	IF (WIN32)
		include_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-x64-std/include
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib)
		link_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-x64-std/lib/Release
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib)
	ELSE()
		include_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std/include
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib
			${ThirdParty_PATH}/protobuf3_1_0/release/linux/include)
		link_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std/lib/Release
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib
			${ThirdParty_PATH}/protobuf3_1_0/release/linux/lib)
		MESSAGE(STATUS ${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std/include)
		
	ENDIF()
ELSE()
	IF (WIN32)
		include_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-x64-std_debug/include
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib
			${ThirdParty_PATH}/protobuf3_1_0/debug/windows/include)
		link_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-x64-std_debug/lib/Debug
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib
			${ThirdParty_PATH}/protobuf3_1_0/debug/windows/lib)
	ELSE()
		include_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std_debug/include
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib)
		link_directories(${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std_debug/lib/Debug
			${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/ncserver-lib)
		MESSAGE(STATUS ${ThirdParty_PATH}/route_engine_v${RouteServerVersion}/navicore-linux_x64-std_debug/include)
	ENDIF()
ENDIF()

if(WIN32)
LINK_DIRECTORIES(
		 ${OUTPUT_LIBDIR}
				)
endif(WIN32)

if(LINUX_x64)

link_directories("/usr/local/lib"
"/usr/lib"
 ${OUTPUT_LIBDIR}
)

endif()
		
		

#find_package(Boost REQUIRED COMPONENTS
# filesystem
# system
#)

#if(NOT Boost_FOUND)
#    message("Not found Boost")
#else(NOT Boost_FOUND)
#	include_directories(${Boost_INCLUDE_DIR})
#	LINK_DIRECTORIES(
#		  ${Boost_LIBRARY_DIRS}
#				)
#endif()
		
		
ENDMACRO(ADD_Raw_Engine)


MACRO(Server_Executabl Exec_NAME)
    
	SET(TARGET_NAME ${Exec_NAME} )
    SET(TARGET_TARGETNAME ${Exec_NAME} )
 
	LINK_DIRECTORIES( ${ThirdParty_PATH}/core/lib
						${PROJECT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE})

	ADD_EXECUTABLE(${TARGET_TARGETNAME}  ${TARGET_SRC} ${TARGET_H})
	
	set_target_properties(${TARGET_TARGETNAME} PROPERTIES FOLDER "server")	

ENDMACRO(Server_Executabl)


MACRO(Server_Test Exec_NAME)
    
	SET(TARGET_NAME ${Exec_NAME} )
    SET(TARGET_TARGETNAME ${Exec_NAME} )
 
	LINK_DIRECTORIES( ${ThirdParty_PATH}/core/lib
						${PROJECT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE})

	ADD_EXECUTABLE(${TARGET_TARGETNAME}  ${TARGET_SRC} ${TARGET_H})
	
	set_target_properties(${TARGET_TARGETNAME} PROPERTIES FOLDER "test")	

ENDMACRO(Server_Test)