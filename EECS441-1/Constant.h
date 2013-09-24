//
//  Constant.h
//  SoapBox
//
//  Created by Gregoire on 9/21/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef SoapBox_Constant_h
#define SoapBox_Constant_h

#define DEVICEHEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICEWIDTH [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad

#endif
