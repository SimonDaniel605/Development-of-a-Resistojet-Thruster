/*
 * usb.c
 *
 *  Created on: Aug 31, 2026
 *      Author: Simon
 */

#include "usb.h"
#include "usbd_cdc_if.h"
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#define USB_RX_BUFFER_SIZE 128

static char usbRxBuffer[USB_RX_BUFFER_SIZE];
static volatile uint8_t usbCommandReady = 0;

void USB_Transmit(const char *fmt, ...)
{
  static char buf[512];

  va_list ap;
  va_start(ap, fmt);
  int n = vsnprintf(buf, sizeof(buf), fmt, ap);
  va_end(ap);

  if (n < 0) return;
  if (n >= (int)sizeof(buf)) n = (int)sizeof(buf) - 1;

  (void)CDC_Transmit_FS((uint8_t*)buf, (uint16_t)n);
}

void USB_Receive(uint8_t *data, uint32_t length)
{
    if (length >= USB_RX_BUFFER_SIZE)
        length = USB_RX_BUFFER_SIZE - 1;

    memcpy(usbRxBuffer, data, length);
    usbRxBuffer[length] = '\0';

    usbCommandReady = 1;
}

void USB_ProcessCommand(void)
{
    if (!usbCommandReady)
        return;

    usbCommandReady = 0;

    if (strcmp(usbRxBuffer, "STATUS") == 0)
    {
        USB_Transmit("Thruster status requested\r\n");
    }
    else if (strcmp(usbRxBuffer, "START") == 0)
    {
        USB_Transmit("START command received\r\n");
    }
    else if (strcmp(usbRxBuffer, "STOP") == 0)
    {
        USB_Transmit("STOP command received\r\n");
    }
    else
    {
        USB_Transmit("Unknown command: %s\r\n", usbRxBuffer);
    }
}
