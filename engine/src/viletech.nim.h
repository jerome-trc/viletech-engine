#pragma once

#include <stdint.h>

typedef struct n_Core n_Core;

extern n_Core* cx;

void n_cx_init(void);

void n_activateMouse(void);
void n_deactivateMouse(void);

void n_printVer(void);
