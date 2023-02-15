#include "bus.h"

//#define ONE_PANEL
//#define TWO_PANELS
#define THREE_PANELS

void bus::set_attributes() {}

void bus::initialize() {}

void bus::processing()
{
    // Compute total current consumption
    double tot_consumed = i_mcu.read() + i_rf.read()
                          + i_air_quality_sensor.read()
                          + i_methane_sensor.read()
                          + i_temperature_sensor.read()
                          + i_mic_click_sensor.read()
                          ;

    #ifdef ONE_PANEL
    double tot_scavenged = real_i_pv.read();
    #endif
    #ifdef TWO_PANELS
    double tot_scavenged = real_i_pv1.read() + real_i_pv2.read();
    #endif
    #ifdef THREE_PANELS
    double tot_scavenged = real_i_pv1.read() + real_i_pv2.read() + real_i_pv3.read();
    #endif

    double tot_requested = tot_consumed - tot_scavenged;

    i_tot.write(tot_requested); // tot_requested >= 0 ? pow_from_battery : pow_to_battery
}
