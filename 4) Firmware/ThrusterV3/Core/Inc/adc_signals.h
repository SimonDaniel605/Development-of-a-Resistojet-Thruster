/*
 * adc_signals.h
 *
 *  Created on: Apr 20, 2026
 *      Author: Simon
 */

#ifndef INC_ADC_SIGNALS_H_
#define INC_ADC_SIGNALS_H_

#include <stdint.h>
#include <stdbool.h>

#define ADC_IDX_LOADCELL      0U
#define ADC_IDX_THERMISTOR    1U
#define ADC_BUF_LEN           2U

/* ---------- ADC ---------- */
float ADC_CountsToVolts(uint16_t counts, float vref);

/* ---------- Thermistor hardware config ---------- */
/*
 * Set these to match your actual divider.
 *
 * THERM_FIXED_RESISTOR_OHMS:
 *   The known resistor in the divider.
 *
 * THERMISTOR_TO_GND:
 *   true  -> fixed resistor to Vref, thermistor to GND
 *   false -> thermistor to Vref, fixed resistor to GND
 */
#define THERM_FIXED_RESISTOR_OHMS   10000.0f
#define THERMISTOR_TO_GND           true

float ADC_GetThermistorVoltage(const volatile uint16_t *buf, float vref);
float ADC_GetThermistorResistanceOhms(const volatile uint16_t *buf, float vref);
float ADC_GetThermistorTempC(const volatile uint16_t *buf, float vref);

/* ---------- Load cell calibration ---------- */
/*
 * Replace these with your actual calibration results.
 * Force_N = LOADCELL_FORCE_SLOPE_N_PER_V * Vout + LOADCELL_FORCE_OFFSET_N
 */
#define LOADCELL_ZERO_COUNTS     2048.0f   // counts at 0 N (x0)
#define LOADCELL_COUNTS_PER_N    100.0f    // counts (x1) per known force (F1): (x1-x0)/F1

float ADC_GetLoadCellVoltage(const volatile uint16_t *buf, float vref);
float ADC_GetLoadCellForceN(const volatile uint16_t *buf);


#endif /* INC_ADC_SIGNALS_H_ */
