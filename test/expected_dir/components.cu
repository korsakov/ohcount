cuda	code	#include <unistd.h>
cuda	code	#include <error.h>
cuda	code	#include <stdio.h>
cuda	code	#include <stdlib.h>
cuda	code	#include <errno.h>
cuda	code	#include <assert.h>
cuda	blank	
cuda	code	#include "components.h"
cuda	code	#include "common.h"
cuda	blank	
cuda	code	#define THREADS 256
cuda	blank	
cuda	comment	/* Store 3 RGB float components */
cuda	code	__device__ void storeComponents(float *d_r, float *d_g, float *d_b, float r, float g, float b, int pos)
cuda	code	{
cuda	code	    d_r[pos] = (r/255.0f) - 0.5f;
cuda	code	    d_g[pos] = (g/255.0f) - 0.5f;
cuda	code	    d_b[pos] = (b/255.0f) - 0.5f;
cuda	code	}
cuda	blank	
cuda	comment	/* Store 3 RGB intege components */
cuda	code	__device__ void storeComponents(int *d_r, int *d_g, int *d_b, int r, int g, int b, int pos)
cuda	code	{
cuda	code	    d_r[pos] = r - 128;
cuda	code	    d_g[pos] = g - 128;
cuda	code	    d_b[pos] = b - 128;
cuda	code	}
cuda	blank	
cuda	comment	/* Store float component */
cuda	code	__device__ void storeComponent(float *d_c, float c, int pos)
cuda	code	{
cuda	code	    d_c[pos] = (c/255.0f) - 0.5f;
cuda	code	}
cuda	blank	
cuda	comment	/* Store integer component */
cuda	code	__device__ void storeComponent(int *d_c, int c, int pos)
cuda	code	{
cuda	code	    d_c[pos] = c - 128;
cuda	code	}
cuda	blank	
cuda	comment	/* Copy img src data into three separated component buffers */
cuda	code	template<typename T>
cuda	code	__global__ void c_CopySrcToComponents(T *d_r, T *d_g, T *d_b, 
cuda	code	                                  unsigned char * d_src, 
cuda	code	                                  int pixels)
cuda	code	{
cuda	code	    int x  = threadIdx.x;
cuda	code	    int gX = blockDim.x*blockIdx.x;
cuda	blank	
cuda	code	    __shared__ unsigned char sData[THREADS*3];
cuda	blank	
cuda	comment	/* Copy data to shared mem by 4bytes other checks are not necessary, since d_src buffer is aligned to sharedDataSize */
cuda	code	    if ( (x*4) < THREADS*3 ) {
cuda	code	        float *s = (float *)d_src;
cuda	code	        float *d = (float *)sData;
cuda	code	        d[x] = s[((gX*3)>>2) + x];
cuda	code	    }
cuda	code	    __syncthreads();
cuda	blank	
cuda	code	    T r, g, b;
cuda	blank	
cuda	code	    int offset = x*3;
cuda	code	    r = (T)(sData[offset]);
cuda	code	    g = (T)(sData[offset+1]);
cuda	code	    b = (T)(sData[offset+2]);
cuda	blank	
cuda	code	    int globalOutputPosition = gX + x;
cuda	code	    if (globalOutputPosition < pixels) {
cuda	code	        storeComponents(d_r, d_g, d_b, r, g, b, globalOutputPosition);
cuda	code	    }
cuda	code	}
cuda	blank	
cuda	comment	/* Copy img src data into three separated component buffers */
cuda	code	template<typename T>
cuda	code	__global__ void c_CopySrcToComponent(T *d_c, unsigned char * d_src, int pixels)
cuda	code	{
cuda	code	    int x  = threadIdx.x;
cuda	code	    int gX = blockDim.x*blockIdx.x;
cuda	blank	
cuda	code	    __shared__ unsigned char sData[THREADS];
cuda	blank	
cuda	comment	/* Copy data to shared mem by 4bytes other checks are not necessary, since d_src buffer is aligned to sharedDataSize */
cuda	code	    if ( (x*4) < THREADS) {
cuda	code	        float *s = (float *)d_src;
cuda	code	        float *d = (float *)sData;
cuda	code	        d[x] = s[(gX>>2) + x];
cuda	code	    }
cuda	code	    __syncthreads();
cuda	blank	
cuda	code	    T c;
cuda	blank	
cuda	code	    c = (T)(sData[x]);
cuda	blank	
cuda	code	    int globalOutputPosition = gX + x;
cuda	code	    if (globalOutputPosition < pixels) {
cuda	code	        storeComponent(d_c, c, globalOutputPosition);
cuda	code	    }
cuda	code	}
cuda	blank	
cuda	blank	
cuda	comment	/* Separate compoents of 8bit RGB source image */
cuda	code	template<typename T>
cuda	code	void rgbToComponents(T *d_r, T *d_g, T *d_b, unsigned char * src, int width, int height)
cuda	code	{
cuda	code	    unsigned char * d_src;
cuda	code	    int pixels      = width*height;
cuda	code	    int alignedSize =  DIVANDRND(width*height, THREADS) * THREADS * 3; //aligned to thread block size -- THREADS
cuda	blank	
cuda	comment	    /* Alloc d_src buffer */
cuda	code	    cudaMalloc((void **)&d_src, alignedSize);
cuda	code	    cudaCheckAsyncError("Cuda malloc")
cuda	code	    cudaMemset(d_src, 0, alignedSize);
cuda	blank	
cuda	comment	     /* Copy data to device */
cuda	code	    cudaMemcpy(d_src, src, pixels*3, cudaMemcpyHostToDevice);
cuda	code	    cudaCheckError("Copy data to device")
cuda	blank	
cuda	comment	/* Kernel */
cuda	code	    dim3 threads(THREADS);
cuda	code	    dim3 grid(alignedSize/(THREADS*3));
cuda	code	    assert(alignedSize%(THREADS*3) == 0);
cuda	code	    c_CopySrcToComponents<<<grid, threads>>>(d_r, d_g, d_b, d_src, pixels);
cuda	code	    cudaCheckAsyncError("CopySrcToComponents kernel")
cuda	blank	
cuda	comment	/* Free Memory */
cuda	code	    cudaFree(d_src);
cuda	code	    cudaCheckAsyncError("Free memory")
cuda	code	}
cuda	code	template void rgbToComponents<float>(float *d_r, float *d_g, float *d_b, unsigned char * src, int width, int height);
cuda	code	template void rgbToComponents<int>(int *d_r, int *d_g, int *d_b, unsigned char * src, int width, int height);
cuda	blank	
cuda	blank	
cuda	comment	/* Copy a 8bit source image data into a color compoment of type T */
cuda	code	template<typename T>
cuda	code	void bwToComponent(T *d_c, unsigned char * src, int width, int height)
cuda	code	{
cuda	code	    unsigned char * d_src;
cuda	code	    int pixels      = width*height;
cuda	code	    int alignedSize =  DIVANDRND(pixels, THREADS) * THREADS; //aligned to thread block size -- THREADS
cuda	blank	
cuda	comment	/* Alloc d_src buffer */
cuda	code	    cudaMalloc((void **)&d_src, alignedSize);
cuda	code	    cudaCheckAsyncError("Cuda malloc")
cuda	code	    cudaMemset(d_src, 0, alignedSize);
cuda	blank	
cuda	comment	/* Copy data to device */
cuda	code	    cudaMemcpy(d_src, src, pixels, cudaMemcpyHostToDevice);
cuda	code	    cudaCheckError("Copy data to device")
cuda	blank	
cuda	comment	/* Kernel */
cuda	code	    dim3 threads(THREADS);
cuda	code	    dim3 grid(alignedSize/(THREADS));
cuda	code	    assert(alignedSize%(THREADS) == 0);
cuda	code	    c_CopySrcToComponent<<<grid, threads>>>(d_c, d_src, pixels);
cuda	code	    cudaCheckAsyncError("CopySrcToComponent kernel")
cuda	blank	
cuda	comment	/* Free Memory */
cuda	code	    cudaFree(d_src);
cuda	code	    cudaCheckAsyncError("Free memory")
cuda	code	}
cuda	blank	
cuda	code	template void bwToComponent<float>(float *d_c, unsigned char *src, int width, int height);
cuda	code	template void bwToComponent<int>(int *d_c, unsigned char *src, int width, int height);
