/*
 * pwm.c
 *
 *  Created on: Apr 20, 2026
 *      Author: Simon
 */

#include "main.h"
#include "pwm.h"
#include "pins.h"

extern TIM_HandleTypeDef htim2;
/* 0..100% */
static volatile uint8_t heaterDuty = 0;
static volatile uint8_t valveDuty  = 0;

/* 0..99 */
static volatile uint32_t pwmCounter = 0;

static inline void gpio_set(GPIO_TypeDef *port, uint16_t pin)
{
    port->BSRR = pin;
}

static inline void gpio_reset(GPIO_TypeDef *port, uint16_t pin)
{
    port->BSRR = ((uint32_t)pin << 16U);
}

void SoftPWM_Init(void)
{
    heaterDuty = 0;
    valveDuty  = 0;
    pwmCounter = 0;

    gpio_reset(HEATER_Port, HEATER_Pin);
    gpio_reset(VALVE1_Port, VALVE1_Pin);
}

void SoftPWM_Start(void)
{
    HAL_TIM_Base_Start_IT(&htim2);
}

void SoftPWM_SetHeaterDuty(uint8_t duty_percent)
{
    if (duty_percent > 100U) duty_percent = 100U;
    heaterDuty = duty_percent;
}

void SoftPWM_SetValveDuty(uint8_t duty_percent)
{
    if (duty_percent > 100U) duty_percent = 100U;
    valveDuty = duty_percent;
}

uint8_t SoftPWM_GetHeaterDuty(void)
{
    return heaterDuty;
}

uint8_t SoftPWM_GetValveDuty(void)
{
    return valveDuty;
}

void SoftPWM_Tick(void)
{
    uint32_t heaterOnCounts = ((uint32_t)heaterDuty * SOFT_PWM_STEPS) / 100U;
    uint32_t valveOnCounts  = ((uint32_t)valveDuty  * SOFT_PWM_STEPS) / 100U;

    if (++pwmCounter >= SOFT_PWM_STEPS)
    {
        pwmCounter = 0;
    }

    /* Heater output */
    if (heaterDuty >= 100U)
    {
        gpio_set(HEATER_Port, HEATER_Pin);
    }
    else if (heaterDuty == 0U)
    {
        gpio_reset(HEATER_Port, HEATER_Pin);
    }
    else if (pwmCounter < heaterOnCounts)
    {
        gpio_set(HEATER_Port, HEATER_Pin);
    }
    else
    {
        gpio_reset(HEATER_Port, HEATER_Pin);
    }

    /* Valve output */
    if (valveDuty >= 100U)
    {
        gpio_set(VALVE1_Port, VALVE1_Pin);
    }
    else if (valveDuty == 0U)
    {
        gpio_reset(VALVE1_Port, VALVE1_Pin);
    }
    else if (pwmCounter < valveOnCounts)
    {
        gpio_set(VALVE1_Port, VALVE1_Pin);
    }
    else
    {
        gpio_reset(VALVE1_Port, VALVE1_Pin);
    }
}
