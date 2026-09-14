/*
 * control.h
 *
 *  Created on: Aug 31, 2026
 *      Author: Simon
 */

#ifndef INC_CONTROL_H_
#define INC_CONTROL_H_

typedef enum
{
    MODE_EXPERIMENTAL,
    MODE_MANUAL,
    MODE_RESTRICTED_MANUAL
} ThrusterMode_t;

typedef enum
{
    STATE_LOADED,
    STATE_UNLOADED,
    STATE_SETTLING,
	STATE_SETTLED,
    STATE_PRIMING,
    STATE_PRIMED,
    STATE_FIRING,
    STATE_ABORT
} ThrusterState_t;

void PIDFunc(void);
void settlingFunc(void);
void primingFunc(void);
void firingFunc(void);
const char *thrusterModeToString(ThrusterMode_t mode);
const char *thrusterStateToString(ThrusterState_t state);
void thrusterModeHandler(void);
void thrusterStateHandler(void);

#endif /* INC_CONTROL_H_ */
