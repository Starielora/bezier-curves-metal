//
//  MVP.h
//  Bezier3D
//
//  Created by Patryk Edyko on 27/07/2021.
//

#ifndef MVP_h
#define MVP_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 model;
    matrix_float4x4 view;
    matrix_float4x4 projection;
} MVPMatrices;

#endif /* MVP_h */
