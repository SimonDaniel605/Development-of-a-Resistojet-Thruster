/*
 * adc_signals.c
 *
 *  Created on: Apr 20, 2026
 *      Author: Simon
 */


#include "adc_signals.h"

/* Temperature lookup table from provided thermistor table.
 * Using nominal resistance column (Rst.) in ohms.
 * Range: -60 C to 150 C
 */
typedef struct
{
    float tempC;
    float resistanceOhms;
} ThermistorLUTPoint_t;

static const ThermistorLUTPoint_t thermLUT[] =
{
    { -60.0f, 600600.0f },
    { -59.0f, 563700.0f },
    { -58.0f, 529400.0f },
    { -57.0f, 497400.0f },
    { -56.0f, 467700.0f },
    { -55.0f, 440000.0f },
    { -54.0f, 414200.0f },
    { -53.0f, 390000.0f },
    { -52.0f, 367500.0f },
    { -51.0f, 346500.0f },
    { -50.0f, 326900.0f },
    { -49.0f, 308500.0f },
    { -48.0f, 291300.0f },
    { -47.0f, 275200.0f },
    { -46.0f, 260100.0f },
    { -45.0f, 246000.0f },
    { -44.0f, 232800.0f },
    { -43.0f, 220300.0f },
    { -42.0f, 208700.0f },
    { -41.0f, 197700.0f },
    { -40.0f, 187400.0f },
    { -39.0f, 177500.0f },
    { -38.0f, 168200.0f },
    { -37.0f, 159400.0f },
    { -36.0f, 151100.0f },
    { -35.0f, 143400.0f },
    { -34.0f, 136100.0f },
    { -33.0f, 129200.0f },
    { -32.0f, 122800.0f },
    { -31.0f, 116700.0f },
    { -30.0f, 110900.0f },
    { -29.0f, 105400.0f },
    { -28.0f, 100100.0f },
    { -27.0f, 95220.0f },
    { -26.0f, 90570.0f },
    { -25.0f, 86180.0f },
    { -24.0f, 82040.0f },
    { -23.0f, 78130.0f },
    { -22.0f, 74440.0f },
    { -21.0f, 70940.0f },
    { -20.0f, 67640.0f },
    { -19.0f, 64440.0f },
    { -18.0f, 61420.0f },
    { -17.0f, 58570.0f },
    { -16.0f, 55870.0f },
    { -15.0f, 53310.0f },
    { -14.0f, 50880.0f },
    { -13.0f, 48590.0f },
    { -12.0f, 46410.0f },
    { -11.0f, 44350.0f },
    { -10.0f, 42390.0f },
    {  -9.0f, 40500.0f },
    {  -8.0f, 38700.0f },
    {  -7.0f, 37000.0f },
    {  -6.0f, 35380.0f },
    {  -5.0f, 33850.0f },
    {  -4.0f, 32390.0f },
    {  -3.0f, 31000.0f },
    {  -2.0f, 29690.0f },
    {  -1.0f, 28440.0f },
    {   0.0f, 27250.0f },
    {   1.0f, 26100.0f },
    {   2.0f, 25000.0f },
    {   3.0f, 23960.0f },
    {   4.0f, 22970.0f },
    {   5.0f, 22030.0f },
    {   6.0f, 21130.0f },
    {   7.0f, 20280.0f },
    {   8.0f, 19460.0f },
    {   9.0f, 18690.0f },
    {  10.0f, 17950.0f },
    {  11.0f, 17230.0f },
    {  12.0f, 16550.0f },
    {  13.0f, 15900.0f },
    {  14.0f, 15270.0f },
    {  15.0f, 14680.0f },
    {  16.0f, 14110.0f },
    {  17.0f, 13570.0f },
    {  18.0f, 13050.0f },
    {  19.0f, 12560.0f },
    {  20.0f, 12090.0f },
    {  21.0f, 11630.0f },
    {  22.0f, 11200.0f },
    {  23.0f, 10780.0f },
    {  24.0f, 10380.0f },
    {  25.0f, 10000.0f },
    {  26.0f, 9633.0f },
    {  27.0f, 9281.0f },
    {  28.0f, 8945.0f },
    {  29.0f, 8623.0f },
    {  30.0f, 8314.0f },
    {  31.0f, 8016.0f },
    {  32.0f, 7730.0f },
    {  33.0f, 7456.0f },
    {  34.0f, 7193.0f },
    {  35.0f, 6941.0f },
    {  36.0f, 6700.0f },
    {  37.0f, 6468.0f },
    {  38.0f, 6246.0f },
    {  39.0f, 6033.0f },
    {  40.0f, 5829.0f },
    {  41.0f, 5630.0f },
    {  42.0f, 5440.0f },
    {  43.0f, 5257.0f },
    {  44.0f, 5081.0f },
    {  45.0f, 4912.0f },
    {  46.0f, 4750.0f },
    {  47.0f, 4594.0f },
    {  48.0f, 4444.0f },
    {  49.0f, 4300.0f },
    {  50.0f, 4162.0f },
    {  51.0f, 4027.0f },
    {  52.0f, 3897.0f },
    {  53.0f, 3773.0f },
    {  54.0f, 3653.0f },
    {  55.0f, 3537.0f },
    {  56.0f, 3426.0f },
    {  57.0f, 3319.0f },
    {  58.0f, 3216.0f },
    {  59.0f, 3117.0f },
    {  60.0f, 3022.0f },
    {  61.0f, 2929.0f },
    {  62.0f, 2839.0f },
    {  63.0f, 2753.0f },
    {  64.0f, 2670.0f },
    {  65.0f, 2589.0f },
    {  66.0f, 2512.0f },
    {  67.0f, 2438.0f },
    {  68.0f, 2366.0f },
    {  69.0f, 2296.0f },
    {  70.0f, 2229.0f },
    {  71.0f, 2164.0f },
    {  72.0f, 2101.0f },
    {  73.0f, 2040.0f },
    {  74.0f, 1981.0f },
    {  75.0f, 1925.0f },
    {  76.0f, 1870.0f },
    {  77.0f, 1817.0f },
    {  78.0f, 1766.0f },
    {  79.0f, 1716.0f },
    {  80.0f, 1669.0f },
    {  81.0f, 1622.0f },
    {  82.0f, 1577.0f },
    {  83.0f, 1534.0f },
    {  84.0f, 1492.0f },
    {  85.0f, 1451.0f },
    {  86.0f, 1412.0f },
    {  87.0f, 1374.0f },
    {  88.0f, 1337.0f },
    {  89.0f, 1301.0f },
    {  90.0f, 1266.0f },
    {  91.0f, 1233.0f },
    {  92.0f, 1200.0f },
    {  93.0f, 1169.0f },
    {  94.0f, 1138.0f },
    {  95.0f, 1108.0f },
    {  96.0f, 1080.0f },
    {  97.0f, 1052.0f },
    {  98.0f, 1025.0f },
    {  99.0f, 999.0f  },
    { 100.0f, 973.7f  },
    { 101.0f, 949.0f  },
    { 102.0f, 925.0f  },
    { 103.0f, 901.8f  },
    { 104.0f, 879.3f  },
    { 105.0f, 857.4f  },
    { 106.0f, 836.3f  },
    { 107.0f, 815.7f  },
    { 108.0f, 795.8f  },
    { 109.0f, 776.4f  },
    { 110.0f, 757.6f  },
    { 111.0f, 739.2f  },
    { 112.0f, 721.4f  },
    { 113.0f, 704.1f  },
    { 114.0f, 687.3f  },
    { 115.0f, 671.0f  },
    { 116.0f, 655.2f  },
    { 117.0f, 639.8f  },
    { 118.0f, 624.8f  },
    { 119.0f, 610.3f  },
    { 120.0f, 596.1f  },
    { 121.0f, 582.3f  },
    { 122.0f, 568.9f  },
    { 123.0f, 555.9f  },
    { 124.0f, 543.2f  },
    { 125.0f, 530.9f  },
    { 126.0f, 518.9f  },
    { 127.0f, 507.2f  },
    { 128.0f, 495.9f  },
    { 129.0f, 484.9f  },
    { 130.0f, 474.1f  },
    { 131.0f, 463.6f  },
    { 132.0f, 453.4f  },
    { 133.0f, 443.5f  },
    { 134.0f, 433.8f  },
    { 135.0f, 424.3f  },
    { 136.0f, 415.2f  },
    { 137.0f, 406.2f  },
    { 138.0f, 397.5f  },
    { 139.0f, 389.0f  },
    { 140.0f, 380.8f  },
    { 141.0f, 372.7f  },
    { 142.0f, 364.8f  },
    { 143.0f, 357.2f  },
    { 144.0f, 349.7f  },
    { 145.0f, 342.4f  },
    { 146.0f, 335.3f  },
    { 147.0f, 328.4f  },
    { 148.0f, 321.7f  },
    { 149.0f, 315.1f  },
    { 150.0f, 308.7f  }
};

#define THERM_LUT_SIZE   (sizeof(thermLUT) / sizeof(thermLUT[0]))

static float interpolateTempFromResistance(float resistanceOhms)
{
    if (resistanceOhms >= thermLUT[0].resistanceOhms)
    {
        return thermLUT[0].tempC;
    }

    if (resistanceOhms <= thermLUT[THERM_LUT_SIZE - 1U].resistanceOhms)
    {
        return thermLUT[THERM_LUT_SIZE - 1U].tempC;
    }

    for (uint32_t i = 0; i < (THERM_LUT_SIZE - 1U); i++)
    {
        float r1 = thermLUT[i].resistanceOhms;
        float r2 = thermLUT[i + 1U].resistanceOhms;
        float t1 = thermLUT[i].tempC;
        float t2 = thermLUT[i + 1U].tempC;

        if ((resistanceOhms <= r1) && (resistanceOhms >= r2))
        {
            float frac = (resistanceOhms - r1) / (r2 - r1);
            return t1 + frac * (t2 - t1);
        }
    }

    return -999.0f;
}

float ADC_CountsToVolts(uint16_t counts, float vref)
{
    return ((float)counts * vref) / 4095.0f;
}

float ADC_GetThermistorVoltage(const volatile uint16_t *buf, float vref)
{
    return ADC_CountsToVolts(buf[ADC_IDX_THERMISTOR], vref);
}

float ADC_GetLoadCellVoltage(const volatile uint16_t *buf, float vref)
{
    return ADC_CountsToVolts(buf[ADC_IDX_LOADCELL], vref);
}

float ADC_GetThermistorResistanceOhms(const volatile uint16_t *buf, float vref)
{
    float vTherm = ADC_GetThermistorVoltage(buf, vref);

    if (vTherm <= 0.0f)
    {
        return thermLUT[THERM_LUT_SIZE - 1U].resistanceOhms;
    }

    if (vTherm >= vref)
    {
        return thermLUT[0].resistanceOhms;
    }

    if (THERMISTOR_TO_GND)
    {
        /* Vref -- Rfixed -- ADC node -- Thermistor -- GND */
        return THERM_FIXED_RESISTOR_OHMS * vTherm / (vref - vTherm);
    }
    else
    {
        /* Vref -- Thermistor -- ADC node -- Rfixed -- GND */
        return THERM_FIXED_RESISTOR_OHMS * (vref - vTherm) / vTherm;
    }
}

float ADC_GetThermistorTempC(const volatile uint16_t *buf, float vref)
{
    float rTherm = ADC_GetThermistorResistanceOhms(buf, vref);
    return interpolateTempFromResistance(rTherm);
}

float ADC_GetLoadCellForceN(const volatile uint16_t *buf)
{
    float counts = (float)buf[ADC_IDX_LOADCELL];
    return (counts - LOADCELL_ZERO_COUNTS) / LOADCELL_COUNTS_PER_N;
}
