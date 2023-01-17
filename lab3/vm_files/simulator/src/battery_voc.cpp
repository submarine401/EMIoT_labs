#include "battery_voc.h"
#include "math.h"


void battery_voc::set_attributes()
{
    v_oc.set_timestep(SIM_STEP, sc_core::SC_SEC);
    r_s.set_timestep(SIM_STEP, sc_core::SC_SEC);
    soc.set_timestep(SIM_STEP, sc_core::SC_SEC);
    r_s.set_delay(1);
    soc.set_delay(1);
}

void battery_voc::initialize() {}

void battery_voc::processing()
{
    double tmpcurrent; // Battery current, if negative, the battery is charged 
    
    // Read input current
    tmpcurrent = i.read(); // Battery current, if negative, the battery is charged 

    /* 
    Compute actual state-of-charge solving the integral:
    SOC_t = SOC_{t-1} - \int^{t}_{-inf} i(\tau) / C d\tau
    */
    const int c_nom = 3200;   // mAh
    tmpsoc -= (((tmpcurrent + prev_i_batt) * SIM_STEP) / (2 * 3600 * c_nom)); // 3600 * Cnom, mAh to mAs cause [sim step] = [s]
    prev_i_batt = tmpcurrent; // Update

    // Each instant the battery self-discharge a bit
    tmpsoc = (1.0 - SELFDISCH_FACTOR) * tmpsoc;

    // Output the battery SOC
    if(tmpsoc >= 1) // Not let the SOC overflow
    {
        soc.write(1);
        tmpsoc = 1;
    }
    else
    {
        soc.write(tmpsoc);
    }

    // SOC and battery Voc relationship
    //v_oc.write(TO-BE-FILLED);   // clean template
    v_oc.write(3.3*exp(0.2125*tmpsoc)-2.566*exp(-60.34*tmpsoc));   // EMPONENTIAL with 2 terms
    //v_oc.write(1.1668*pow(tmpsoc,3)-2.415*pow(tmpsoc,2)-2.566*tmpsoc-60.34);   // POLYNOMIAL 3rd degree p1*x^3 + p2*x^2 + p3*x + p4
    //v_oc.write(387.5/(pow(tmpsoc,4)-1.163*pow(tmpsoc,3)-2.094*pow(tmpsoc,2)-4.697*tmpsoc+106.4));   // RATIONAL function: (p1) / (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)

    // SOC and battery internal resistance relationship
    //r_s.write(TO-BE-FILLED); // Place interpolated funct here
    r_s.write(0.1239*exp(-1.55*tmpsoc)+0.007535*exp(1.52*tmpsoc)); // EXPONENTIAL with 2 terms: a*exp(b*x) + c*exp(d*x)
    //r_s.write(-0.02748*pow(tmpsoc,3)+0.1318*pow(tmpsoc,2)-0.1751*tmpsoc+0.1312);   // POLYNOMIAL 3rd degree: p1*x^3 + p2*x^2 + p3*x + p4
    //r_s.write(-0.1488*pow(tmpsoc,0.2192)+0.2031);   // POWER with 2 terms: a*x^b+c
    //r_s.write((0.0814*pow(tmpsoc,2)-0.04988*tmpsoc+0.05289)/(pow(tmpsoc,2)+0.002758*tmpsoc+0.4128));   // RATIONAL function: (p1*x^2 + p2*x + p3) / (x^2 + q1*x + q2)

    // When the battery SOC decreases under 1%, the simulation stops.	
    if(tmpsoc <= 0.01)
    {
        cout << "SOC is less than or equal to 1%:" << " @" << sc_time_stamp() << endl;
        sc_stop();
    }
}
