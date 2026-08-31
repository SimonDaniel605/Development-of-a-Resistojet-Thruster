/*
 * pins.h
 *
 *  Created on: Aug 26, 2026
 *      Author: Simon
 */

#ifndef INC_PINS_H_
#define INC_PINS_H_

#include "main.h"

/* Valve pins */
#define FILL_VALVE_Port         GPIOB
#define FILL_VALVE_Pin          GPIO_PIN_3
#define PLENUM_VALVE_Port       GPIOB
#define PLENUM_VALVE_Pin        GPIO_PIN_4
#define CHAMBER_VALVE_Port      GPIOB
#define CHAMBER_VALVE_Pin       GPIO_PIN_5

/* Debug LED pins */
#define LED1_Port               GPIOB
#define LED1_Pin                GPIO_PIN_11
#define LED2_Port               GPIOB
#define LED2_Pin                GPIO_PIN_12

/* Heater PWM channels */
#define HEATER1_Port            GPIOB
#define HEATER1_Pin             GPIO_PIN_6
#define HEATER1_CHANNEL         TIM_CHANNEL_1
#define HEATER2_Port            GPIOB
#define HEATER2_Pin             GPIO_PIN_7
#define HEATER2_CHANNEL         TIM_CHANNEL_2

/* ADC pins */
#define ADC1_THERMISTOR_INDEX   0
#define ADC1_PRESSURE1_INDEX    1
#define ADC1_LOADCELL_INDEX     2
#define ADC1_PRESSURE3_INDEX    3
#define ADC2_PRESSURE2_INDEX    0

#define THERMISTOR_Port         GPIOA
#define THERMISTOR_Pin          GPIO_PIN_0
#define PRESSURE1_Port          GPIOA
#define PRESSURE1_Pin           GPIO_PIN_1
#define LOADCELL_Port           GPIOA
#define LOADCELL_Pin            GPIO_PIN_2
#define PRESSURE3_Port          GPIOA
#define PRESSURE3_Pin           GPIO_PIN_3
#define PRESSURE2_Port          GPIOA
#define PRESSURE2_Pin           GPIO_PIN_4

/* ADS131M04 pins */
#define ADS_SCLK_Port           GPIOA
#define ADS_SCLK_Pin            GPIO_PIN_5
#define ADS_MISO_Port           GPIOA
#define ADS_MISO_Pin            GPIO_PIN_6
#define ADS_MOSI_Port           GPIOA
#define ADS_MOSI_Pin            GPIO_PIN_7

#define ADS_DRDY_Port           GPIOB
#define ADS_DRDY_Pin            GPIO_PIN_0
#define ADS_CS_Port             GPIOB
#define ADS_CS_Pin              GPIO_PIN_1
#define ADS_RESET_Port          GPIOB
#define ADS_RESET_Pin           GPIO_PIN_2

#define ADS_CLKIN_Port          GPIOB
#define ADS_CLKIN_Pin           GPIO_PIN_10
#define ADS_CLKIN_CHANNEL       TIM_CHANNEL_3

#endif /* INC_PINS_H_ */
