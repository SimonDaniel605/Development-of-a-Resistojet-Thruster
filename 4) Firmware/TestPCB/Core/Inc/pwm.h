/*
 * pwm.h
 *
 *  Created on: Apr 20, 2026
 *      Author: Simon
 */

#ifndef INC_PWM_H_
#define INC_PWM_H_

#include <stdint.h>
#define SOFT_PWM_STEPS   100000U   /* 100 steps -> 1 kHz PWM from 100 kHz timer tick */

void SoftPWM_Init(void);
void SoftPWM_Start(void);

void SoftPWM_SetHeaterDuty(uint8_t duty_percent);
void SoftPWM_SetValveDuty(uint8_t duty_percent);

uint8_t SoftPWM_GetHeaterDuty(void);
uint8_t SoftPWM_GetValveDuty(void);

/* Call this from HAL_TIM_PeriodElapsedCallback() */
void SoftPWM_Tick(void);

#endif /* INC_PWM_H_ */
