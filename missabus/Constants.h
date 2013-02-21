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
	#define SERVER_URL @"http://localhost:8080/hslpush"
#else
	#define SERVER_URL @"http://hslpush.cloudfoundry.com"
#endif

#define REITTIOPAS_API_URL @"http://api.reittiopas.fi/hsl/prod"
#define REITTIOPAS_USER @"hslpusher"
#define REITTIOPAS_PWD @"hpHalvatLapparit1"

// Images recovered from http://www.poikkeusinfo.fi/pinfo/public/images/iconit/juna.png etc.
#define BUS_IMAGE @"tbussi_iso.png"
#define TRAM_IMAGE @"traitio_iso.png"
#define METRO_IMAGE @"tmetro_iso.png"
#define FERRY_IMAGE @"tlautta_iso.png"
#define TRAIN_IMAGE @"tjuna_iso.png"

#endif
