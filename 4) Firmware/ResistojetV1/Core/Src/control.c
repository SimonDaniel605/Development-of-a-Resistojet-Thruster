/*
 * control.c
 *
 *  Created on: Aug 31, 2026
 *      Author: Simon
 */

#include "control.h"

typedef enum
{
    MODE_EXPERIMENTAL,
    MODE_MANUAL,
    MODE_RESTRICTED_MANUAL
} ThrusterMode_t;

typedef enum
{
    STATE_UNLOADED,
    STATE_LOADED,
    STATE_SETTLING,
    STATE_PRIMING,
    STATE_PRIMED,
    STATE_FIRING,
    STATE_ABORT
} ThrusterState_t;


float plenumTempSetpoint = 0.0f;
float chamberTempSetpoint = 0.0f;
float plenumTargetTemp = 0.0f;
float plenumTargetPressure = 0.0f;


void thrusterStateHandler(void){
	switch(thrusterState){

	}
}

void thrusterModeHandler(void){

}

void PIDFunc(void){

}
