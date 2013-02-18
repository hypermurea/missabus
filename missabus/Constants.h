//
//  Constants.h
//  missabus
//
//  Created by Jaakko Santala on 2/18/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#ifndef missabus_Constants_h
#define missabus_Constants_h

#define DEVELOPMENT

#ifdef DEVELOPMENT
	#define SERVER_URL @"http://localhost:8080/hslpush/"
#else
	#define SERVER_URL @"http://hslpush.cloudfoundry.com/"
#endif

#endif
