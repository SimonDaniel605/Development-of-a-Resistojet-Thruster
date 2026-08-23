/*
 * pins.h
 *
 *  Created on: Apr 20, 2026
 *      Author: Simon
 */

#ifndef INC_PINS_H_
#define INC_PINS_H_

#include "main.h"

/* Heater pin */
#define HEATER_Port			GPIOD
#define HEATER_Pin          GPIO_PIN_6

/* Valve pins */
#define VALVE1_Port     	GPIOA
#define VALVE1_Pin          GPIO_PIN_12

/* ADC pins */
#define LOADCELL_Port    	GPIOA
#define LOADCELL_Pin      	GPIO_PIN_0

#define THERMISTOR_Port    	GPIOA
#define THERMISTOR_Pin      GPIO_PIN_1

#define LOADCELL_CHANNEL  	ADC_CHANNEL_0
#define THERMISTOR_CHANNEL  ADC_CHANNEL_1

#endif /* INC_PINS_H_ */
