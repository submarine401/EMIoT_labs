#include "battery_voc.h"


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
    static int c_nom = 3200;
    tmpsoc -= (((tmpcurrent + prev_i_batt) * SIM_STEP) / (2 * 3600 * c_nom)); // 3600 * Cnom, mAh to mAs cause [sim step] = [s]
    prev_i_batt = tmpcurrent; // Update

    // Each instant the battery self-discharge a bit
    tmpsoc = (1.0 - SELFDISCH_FACTOR) * tmpsoc;
	cout << "tmpsoc:: " << tmpsoc << endl;
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
    //v_oc.write(2.97*exp(0.2777*tmpsoc)-0.6055*exp(-21.42*tmpsoc));   // EXPONENTIAL with 2 terms: a*exp(b*x) + c*exp(d*x)
    v_oc.write(1.759*pow(tmpsoc,3)-2.849*pow(tmpsoc,2)+2.336*tmpsoc+2.746);   // POLYNOMIAL 3rd degree: p1*x^3 + p2*x^2 + p3*x + p4
    //v_oc.write(9971/(pow(tmpsoc,4)-1222*pow(tmpsoc,3)+2306*pow(mpsoc,2)-2138*tmpsoc+3559));   // RATIONAL function: (p1) / (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
	//v_oc.write(2*tmpsoc+2.5);   // simple linear test function
	//v_oc.write(0);   // simple linear test function

    // SOC and battery internal resistance relationship
    //r_s.write(TO-BE-FILLED); // clean template
    //r_s.write(0.1239*exp(-1.55*tmpsoc)+0.007535*exp(1.52*tmpsoc)); // EXPONENTIAL with 2 terms: a*exp(b*x) + c*exp(d*x)
    r_s.write(-0.00002833*pow(tmpsoc,3)+0.000136*pow(tmpsoc,2)-0.0001806*tmpsoc+0.0001353);   // POLYNOMIAL 3rd degree: p1*x^3 + p2*x^2 + p3*x + p4
    //r_s.write(-0.1488*pow(tmpsoc,0.2192)+0.2031);   // POWER with 2 terms: a*x^b+c
    //r_s.write((0.0814*pow(tmpsoc,2)-0.04988*tmpsoc+0.05289)/(pow(tmpsoc,2)+0.002758*tmpsoc+0.4128));   // RATIONAL function: (p1*x^2 + p2*x + p3) / (x^2 + q1*x + q2)
	//r_s.write(0.1263); // test constant resistance

    // When the battery SOC decreases under 1%, the simulation stops.	
    if(tmpsoc <= 0.01)
    {
        cout << "SOC is less than or equal to 1%:" << " @" << sc_time_stamp() << endl;
        sc_stop();
    }
}
