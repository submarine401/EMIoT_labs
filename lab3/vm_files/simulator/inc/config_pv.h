#define TRACE_PERIOD 900
#define SIZE_PV 4 
static const double G[SIZE_PV] = {250, 500, 750, 1000};
static const double I_MPP[SIZE_PV] = {13.667, 28.1109, 41.2965, 57.1429};
//static const double V_MPP[SIZE_PV] = {2.9027, 2.9891, 3.1715, 3.1533};

//======ALTERNATIVE CONFIGURATIONS (SERUES/PARALLEL)=====

//MPP voltage with two panels in series
static const double V_MPP[SIZE_PV] = {5.8054, 5.9782, 6.343, 6.3066};

//MPP current with two panels in parallel
//static const double I_MPP[SIZE_PV] = {27.334, 56.2218, 82.593, 114.2858};
