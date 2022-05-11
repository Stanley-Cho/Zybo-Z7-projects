#include "video_capture/video_capture.h"
#include "display_ctrl/display_ctrl.h"
#include "intc/intc.h"
#include <stdio.h>
#include "math.h"
#include <stdlib.h>
#include "xparameters.h"
#include "xil_printf.h"
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#define DYNCLK_BASEADDR 		XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR
#define VDMA_ID 				XPAR_AXIVDMA_0_DEVICE_ID
#define HDMI_OUT_VTC_ID 		XPAR_V_TC_1_DEVICE_ID
#define HDMI_IN_VTC_ID 			XPAR_V_TC_0_DEVICE_ID
#define HDMI_IN_GPIO_ID 		XPAR_AXI_GPIO_0_DEVICE_ID
#define HDMI_IN_VTC_IRPT_ID 	XPAR_FABRIC_V_TC_0_IRQ_INTR
#define HDMI_IN_GPIO_IRPT_ID 	XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#define MAX_FRAME (1920*1080*3)
#define MAX_STRIDE (1920 * 3)
 //////////////// Configure the Video capture driver to start streaming on signal ////////////////////////
#define DETECT_START 1
//////////////////////////////////////////////////////////////////////////////////////////////////////////
DisplayCtrl dispCtrl;
XAxiVdma vdma;
VideoCapture videoCapt;
INTC intc;
/////////////////////////// Framebuffers for video data ///////////////////////////////////////////////////
u8 frameBuf[DISPLAY_NUM_FRAMES][MAX_FRAME] __attribute__((aligned(0x20)));
u8 *pFrames[DISPLAY_NUM_FRAMES];            //array of pointers to the frame buffers
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Interrupt vector table ///////////////////////////////////////////////////
const ivt_t ivt[] = {
	videoGpioIvt(HDMI_IN_GPIO_IRPT_ID, &videoCapt),
	videoVtcIvt(HDMI_IN_VTC_IRPT_ID, &(videoCapt.vtc))
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int main(void)
{
	////////////////////////////////////////////////////////////////////////
	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;
	////////////////////////////////////////////////////////////////////////
	xil_printf("************  INITIALIZING ... ************\n\r");
	 //////////////// Initialize an array of pointers to the 3 frame buffers ////////////////////
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}
	//////////////////  Initialize VDMA driver ///////////////////////////////////////////////////
	vdmaConfig = XAxiVdma_LookupConfig(VDMA_ID);
	if (!vdmaConfig)
	{
		return XST_FAILURE;
	}
	Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	//////////////////// Initialize the Display controller and start ///////////////////////////
	Status = DisplayInitialize(&dispCtrl, &vdma, HDMI_OUT_VTC_ID, DYNCLK_BASEADDR, pFrames, MAX_STRIDE);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	/////////////////////// Initialize the Interrupt controller and start ////////////////////////


	Status = fnInitInterruptController(&intc);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	fnEnableInterrupts(&intc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));

	///////////////////////// Initialize the Video Capture device ////////////////////////////////
	Status = VideoInitialize(&videoCapt, &intc, &vdma, HDMI_IN_GPIO_ID, HDMI_IN_VTC_ID, HDMI_IN_VTC_IRPT_ID, pFrames, MAX_STRIDE, DETECT_START);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	//////////////////////////////////////////////
	DisplaySetMode(&dispCtrl, &VMODE_1920x1080);
	DisplayStart(&dispCtrl);
	//////////////////////////////////////////////
	xil_printf("************  RUNNING ... ************\n\r");
	return 0;
}
