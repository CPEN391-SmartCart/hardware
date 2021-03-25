/*
 * sections_request.h
 *
 *  Created on: Mar 24, 2021
 *      Author: Amr
 */

#ifndef REQUESTS_SECTIONS_REQUEST_H_
#define REQUESTS_SECTIONS_REQUEST_H_


#define SECTIONS_SCRIPT_CMD_FORMAT "store_id = %d, dofile(requestSections.lua)"

struct Section {
	int id;
	double x;
	double y;
	double width;
	double height;
	int colour;
	char* key;
};

struct Section *getSectionsFromResponse(char *response);
struct Section *requestSections(int store_id);


#endif /* REQUESTS_SECTIONS_REQUEST_H_ */
