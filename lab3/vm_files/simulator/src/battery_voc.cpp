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
    v_oc.write(3.3*exp(0.2125*tmpsoc)-2.566*exp(-60.34*tmpsoc));   // EXPONENTIAL with 2 terms: a*exp(b*x) + c*exp(d*x)
    //v_oc.write(1.1668*pow(tmpsoc,3)-2.415*pow(tmpsoc,2)+1.759*tmpsoc+3.178);   // POLYNOMIAL 3rd degree: p1*x^3 + p2*x^2 + p3*x + p4
    //v_oc.write(9968/(pow(tmpsoc,4)-949.7*pow(tmpsoc,3)+1504*pow(tmpsoc,2)-1273*tmpsoc+3100));   // RATIONAL function: (p1) / (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)

    // SOC and battery internal resistance relationship
    //r_s.write(TO-BE-FILLED); // clean template
    r_s.write(0.1278*exp(-1.55*tmpsoc)-0.00777*exp(1.52*tmpsoc)); // EXPONENTIAL with 2 terms: a*exp(b*x) + c*exp(d*x)
    //r_s.write(-0.02833*pow(tmpsoc,3)+0.136*pow(tmpsoc,2)-0.1806*tmpsoc+0.1353);   // POLYNOMIAL 3rd degree: p1*x^3 + p2*x^2 + p3*x + p4
    //r_s.write(-0.1534*pow(tmpsoc,0.2192)+0.2094);   // POWER with 2 terms: a*x^b+c
    //r_s.write((0.08647*pow(tmpsoc,2)+0.1084*tmpsoc+0.6484)/(pow(tmpsoc,2)+3.54*tmpsoc+8.647));   // RATIONAL function: (p1*x^2 + p2*x + p3) / (x^2 + q1*x + q2)

    // When the battery SOC decreases under 1%, the simulation stops.	
    if(tmpsoc <= 0.01)
    {
        cout << "SOC is less than or equal to 1%:" << " @" << sc_time_stamp() << endl;
        sc_stop();
    }
}
