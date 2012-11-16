package SIunits



end SIunits;







package Modelica

  package Thermal

    package HeatTransfer

      model ThermalConductor "Lumped thermal element transporting heat without storing it"
        extends Interfaces.Element1D;
        parameter Real G "Constant thermal conductance of material";
      equation
        Q_flow = G * dT;
      end ThermalConductor;

      model TemperatureSensor "Absolute temperature sensor in Kelvin"
        Modelica.Blocks.Interfaces.RealOutput T;
        Interfaces.HeatPort_a port;
      equation
        T.signal = port.T;
        port.Q_flow = 0;
      end TemperatureSensor;

      model RelTemperatureSensor "Relative Temperature sensor"
        extends Modelica.Icons.TranslationalSensor;
        Interfaces.HeatPort_a port_a;
        Interfaces.HeatPort_b port_b;
        Modelica.Blocks.Interfaces.RealOutput T_rel;
      equation
        T_rel.signal = port_a.T - port_b.T;
        0 = port_a.Q_flow;
        0 = port_b.Q_flow;
      end RelTemperatureSensor;

      model PrescribedTemperature "Variable temperature boundary condition in Kelvin"
        Interfaces.HeatPort_b port;
        Modelica.Blocks.Interfaces.RealInput T;
      equation
        port.T = T.signal;
      end PrescribedTemperature;

      model PrescribedHeatFlow "Prescribed heat flow boundary condition"
        parameter Real T_ref = (273.15 + 20) "Reference temperature";
        parameter Real alpha = 0 "Temperature coefficient of heat flow rate";
        Interfaces.HeatPort_b port;
        Modelica.Blocks.Interfaces.RealInput Q_flow;
      equation
        port.Q_flow =  -Q_flow.signal * (1 + alpha * (port.T - T_ref));
      end PrescribedHeatFlow;

      package Interfaces

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Real T "Port temperature";
          flow Real Q_flow "Heat flow rate (positive if flowing from outside into the component)";
        end HeatPort;

        connector HeatPort_b "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"
          extends HeatPort;
        end HeatPort_b;

        connector HeatPort_a "Thermal port for 1-dim. heat transfer (filled rectangular icon)"
          extends HeatPort;
        end HeatPort_a;

        partial model Element1D "Partial heat transfer element with two HeatPort connectors that does not store energy"
          Real Q_flow "Heat flow rate from port_a -> port_b";
          Real dT "port_a.T - port_b.T";
        public
          HeatPort_a port_a;
          HeatPort_b port_b;
        equation
          dT = port_a.T - port_b.T;
          port_a.Q_flow = Q_flow;
          port_b.Q_flow =  -Q_flow;
        end Element1D;

      end Interfaces;

      model HeatFlowSensor "Heat flow rate sensor"
        extends Modelica.Icons.RotationalSensor;
        Interfaces.HeatPort_a port_a;
        Interfaces.HeatPort_b port_b;
        Modelica.Blocks.Interfaces.RealOutput Q_flow "Heat flow from port_a to port_b";
      equation
        port_a.T = port_b.T;
        port_a.Q_flow + port_b.Q_flow = 0;
        Q_flow.signal = port_a.Q_flow;
      end HeatFlowSensor;

      model HeatCapacitor "Lumped thermal element storing heat"
        parameter Real C "Heat capacity of part (= cp*m)";
        parameter Real steadyStateStart = 0 "true, if component shall start in steady state";
        parameter Real T_start = 293.15 "Initial temperature of part (in Kelvin)";
        Real T(final start = T_start, final fixed = true) "Temperature of part";
        Interfaces.HeatPort_a port;
      equation
        T = port.T;
        C * der(T) = port.Q_flow;
      initial equation
        if steadyStateStart > 0.0 then
          der(T) = 0;
        else
          T = port.T;
        end if;
      end HeatCapacitor;

      model FixedTemperature "Fixed temperature boundary condition in Kelvin"
        parameter Real T "Fixed temperature at port";
        Interfaces.HeatPort_b port;
      equation
        port.T = T;
      end FixedTemperature;

      model FixedHeatFlow "Fixed heat flow boundary condition"
        parameter Real Q_flow "Fixed heat flow rate at port";
        parameter Real T_ref = (273.15 + 20) "Reference temperature";
        parameter Real alpha = 0 "Temperature coefficient of heat flow rate";
        Interfaces.HeatPort_b port;
      equation
        port.Q_flow =  -Q_flow * (1 + alpha * (port.T - T_ref));
      end FixedHeatFlow;

      model Convection "Lumped thermal element for heat convection"
        Real Q_flow "Heat flow rate from solid -> fluid";
        Real dT "= solid.T - fluid.T";
        Interfaces.HeatPort_a solid;
        Interfaces.HeatPort_b fluid;
        Modelica.Blocks.Interfaces.RealInput Gc "Signal representing the convective thermal conductance in [W/K]";
      equation
        dT = solid.T - fluid.T;
        solid.Q_flow = Q_flow;
        fluid.Q_flow =  -Q_flow;
        Q_flow = Gc.signal * dT;
      end Convection;

      package Celsius

        model ToKelvin "Conversion model from °Celsius to Kelvin.signal"
          Modelica.Blocks.Interfaces.RealInput Celsius;
          Modelica.Blocks.Interfaces.RealOutput Kelvin;
        equation
          Kelvin.signal = (273.15 + Celsius.signal);
        end ToKelvin;

        model TemperatureSensor "Absolute temperature sensor in °Celsius"
          Modelica.Blocks.Interfaces.RealOutput T;
          Interfaces.HeatPort_a port;
        equation
          T.signal = (-273.15 + port.T);
          port.Q_flow = 0;
        end TemperatureSensor;

        model PrescribedTemperature "Variable temperature boundary condition in °Celsius"
          Interfaces.HeatPort_b port;
          Modelica.Blocks.Interfaces.RealInput T;
        equation
          port.T = (273.15 + T.signal);
        end PrescribedTemperature;

        model FromKelvin "Conversion from Kelvin.signal to °Celsius"
          Modelica.Blocks.Interfaces.RealInput Kelvin;
          Modelica.Blocks.Interfaces.RealOutput Celsius;
        equation
          Celsius.signal = (-273.15 + Kelvin.signal);
        end FromKelvin;

        model FixedTemperature "Fixed temperature boundary condition in degree Celsius"
          parameter Real T "Fixed Temperature at the port";
          Interfaces.HeatPort_b port;
        equation
          port.T = (273.15 + T);
        end FixedTemperature;

      end Celsius;

      model BodyRadiation "Lumped thermal element for radiation heat transfer"
        extends Interfaces.Element1D;
        parameter Real Gr "Net radiation conductance between two surfaces (see docu)";
      equation
        Q_flow = Gr * Coselica.Constants.sigma * (port_a.T ^ 4 - port_b.T ^ 4);
      end BodyRadiation;

    end HeatTransfer;

  end Thermal;

  package Mechanics

    package Translational

      model SpringDamper "Linear 1D translational spring and damper in parallel"
        extends Interfaces.Compliant;
        parameter Real s_rel0 = 0 "unstretched spring length";
        parameter Real c = 1 "spring constant";
        parameter Real d = 1 "damping constant";
        Real v_rel "relative velocity between flange_a and flange_b";
      equation
        v_rel = der(s_rel);
        f = c * (s_rel - s_rel0) + d * v_rel;
      end SpringDamper;

      model Spring "Linear 1D translational spring"
        extends Interfaces.Compliant;
        parameter Real s_rel0 = 0 "unstretched spring length";
        parameter Real c = 1 "spring constant ";
      equation
        f = c * (s_rel - s_rel0);
      end Spring;

      model SlidingMass "Sliding mass with inertia"
        extends Interfaces.Rigid;
        parameter Real m = 1 "mass of the sliding mass";
        Real v "absolute velocity of component";
        Real a "absolute acceleration of component";
      equation
        v = der(s);
        a = der(v);
        m * a = flange_a.f + flange_b.f;
      end SlidingMass;

      model Rod "Rod without inertia"
        extends Interfaces.Rigid;
      equation
        0 = flange_a.f + flange_b.f;
      end Rod;

      package Interfaces

        partial model Rigid "Rigid connection of two translational 1D flanges "
          Real s "absolute position of center of component (s = flange_a.s + L/2 = flange_b.s - L/2)";
          parameter Real L = 0 "length of component from left flange to right flange (= flange_b.s - flange_a.s)";
          Flange_a flange_a "(left) driving flange (flange axis directed INTO cut plane, i. e. from left to right)";
          Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane, i. e. from right to left)";
        equation
          flange_a.s = s - L / 2;
          flange_b.s = s + L / 2;
        end Rigid;

        connector Flange_b "right 1D translational flange (flange axis directed OUT OF cut plane)"
          Real s "absolute position of flange";
          flow Real f "cut force directed into flange";
        end Flange_b;

        connector Flange_a "(left) 1D translational flange (flange axis directed INTO cut plane, e. g. from left to right)"
          Real s "absolute position of flange";
          flow Real f "cut force directed into flange";
        end Flange_a;

        partial model Compliant "Compliant connection of two translational 1D flanges"
          Flange_a flange_a "(left) driving flange (flange axis directed INTO cut plane, e. g. from left to right)";
          Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
          Real s_rel "relative distance (= flange_b.s - flange_a.s)";
          Real f "forcee between flanges (positive in direction of flange axis R)";
        equation
          s_rel = flange_b.s - flange_a.s;
          flange_b.f = f;
          flange_a.f =  -f;
        end Compliant;

      end Interfaces;

      model Force "External force acting on a drive train element as input signal"
        Interfaces.Flange_b flange_b;
        Modelica.Blocks.Interfaces.RealInput f "driving force as input signal";
      equation
        flange_b.f =  -f.signal;
      end Force;

      model Fixed "Fixed flange"
        parameter Real s0 = 0 "fixed offset position of housing";
        Interfaces.Flange_b flange_b;
      equation
        flange_b.s = s0;
      end Fixed;

      model Damper "Linear 1D translational damper"
        extends Interfaces.Compliant;
        parameter Real d = 0 "damping constant [N/ (m/s)]";
        Real v_rel "relative velocity between flange_a and flange_b";
      equation
        v_rel = der(s_rel);
        f = d * v_rel;
      end Damper;

      model Accelerate "Forced movement of a.signal flange according to an acceleration signal"
        parameter Real s_start = 0 "Start position";
        parameter Real v_start = 0 "Start velocity";
        Real v(final start = v_start, final fixed = true) "absolute velocity of flange_b";
        Real s(final start = s_start, final fixed = true) "absolute position of flange_b";
        Modelica.Blocks.Interfaces.RealInput a "absolute acceleration of flange as input signal";
        Interfaces.Flange_b flange_b;
      equation
        s = flange_b.s;
        v = der(s);
        a.signal = der(v);
      end Accelerate;

    end Translational;

    package Rotational

      model TorqueStep "Constant torque, not dependent on speed"
        extends Modelica.Mechanics.Rotational.Interfaces.PartialSpeedDependentTorque;
        parameter Real stepTorque = 1 "height of torque step (if negative, torque is acting as load)";
        parameter Real offsetTorque = 0 "offset of torque";
        parameter Real startTime = 0 "output = offset for time < startTime";
      equation
        tau =  -offsetTorque - (if time < startTime then 0 else stepTorque);
      end TorqueStep;

      model Torque "Input signal acting as external torque on a flange"
        Modelica.Blocks.Interfaces.RealInput tau "Torque driving the flange ";
        Interfaces.Flange_b flange_b "(Right) flange";
        Interfaces.Flange_a bearing;
      equation
        flange_b.tau =  -tau.signal;
        if false then
          bearing.phi = 0;
        else
          bearing.tau = tau.signal;
        end if;
      end Torque;

      model Torque2 "Input signal acting as torque on two flanges"
        extends Interfaces.TwoFlanges;
        Modelica.Blocks.Interfaces.RealInput tau "Torque driving the two flanges ";
      equation
        flange_a.tau = tau.signal;
        flange_b.tau =  -tau.signal;
      end Torque2;

      model SpringDamper "Linear 1D rotational spring and damper in parallel"
        extends Interfaces.Compliant;
        parameter Real c "Spring constant";
        parameter Real phi_rel0 = 0 "Unstretched spring angle";
        parameter Real d = 0 "Damping constant";
        Real w_rel "Relative angular velocity between flange_b and flange_a";
      equation
        w_rel = der(phi_rel);
        tau = c * (phi_rel - phi_rel0) + d * w_rel;
      end SpringDamper;

      model Spring "Linear 1D rotational spring"
        extends Interfaces.Compliant;
        parameter Real c "Spring constant";
        parameter Real phi_rel0 = 0 "Unstretched spring angle";
      equation
        tau = c * (phi_rel - phi_rel0);
      end Spring;

      package Sensors

        model TorqueSensor "Ideal sensor to measure the torque between two flanges (= flange_a.tau)"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a;
          Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealOutput tau "Torque in flange flange_a and flange_b (= flange_a.tau = -flange_b.tau)";
        equation
          flange_a.phi = flange_b.phi;
          flange_a.tau = tau.signal;
          flange_b.tau =  -tau.signal;
        end TorqueSensor;

        model SpeedSensor "Ideal sensor to measure the absolute flange angular velocity"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "flange to be measured";
          Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange";
        equation
          w.signal = der(flange_a.phi);
          0 = flange_a.tau;
        end SpeedSensor;

        model RelSpeedSensor "Ideal sensor to measure the relative angular velocity between two flanges"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "driving flange (flange axis directed INTO cut plane)";
          Interfaces.Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
          Real phi_rel "Relative angle between two flanges (flange_b.phi - flange_a.phi)";
          Modelica.Blocks.Interfaces.RealOutput w_rel "Relative angular velocity between two flanges (= der(flange_b.phi) - der(flange_a.phi)";
        equation
          phi_rel = flange_b.phi - flange_a.phi;
          w_rel.signal = der(phi_rel);
          0 = flange_a.tau;
          0 = flange_b.tau;
        end RelSpeedSensor;

        model RelAngleSensor "Ideal sensor to measure the relative angle between two flanges"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "driving flange (flange axis directed INTO cut plane)";
          Interfaces.Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
          Modelica.Blocks.Interfaces.RealOutput phi_rel "Relative angle between two flanges (= flange_b.phi - flange_a.phi)";
        equation
          phi_rel.signal = flange_b.phi - flange_a.phi;
          0 = flange_a.tau;
          0 = flange_b.tau;
        end RelAngleSensor;

        model RelAccSensor "Ideal sensor to measure the relative angular acceleration between two flanges"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "driving flange (flange axis directed INTO cut plane)";
          Interfaces.Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
          Real phi_rel "Relative angle between two flanges (flange_b.phi - flange_a.phi)";
          Real w_rel "Relative angular velocity between two flanges";
          Modelica.Blocks.Interfaces.RealOutput a_rel "Relative angular acceleration between two flanges";
        equation
          phi_rel = flange_b.phi - flange_a.phi;
          w_rel = der(phi_rel);
          a_rel.signal = der(w_rel);
          0 = flange_a.tau;
          0 = flange_b.tau;
        end RelAccSensor;

        model AngleSensor "Ideal sensor to measure the absolute flange angle"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "flange to be measured";
          Modelica.Blocks.Interfaces.RealOutput phi "Absolute angle of flange";
        equation
          phi.signal = flange_a.phi;
          0 = flange_a.tau;
        end AngleSensor;

        model AccSensor "Ideal sensor to measure the absolute flange angular acceleration"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Flange_a flange_a "flange to be measured";
          Real w "Absolute angular velocity of flange";
          Modelica.Blocks.Interfaces.RealOutput a "Absolute angular acceleration of flange";
        equation
          w = der(flange_a.phi);
          a.signal = der(w);
          0 = flange_a.tau;
        end AccSensor;

      end Sensors;

      model QuadraticSpeedDependentTorque "Quadratic dependency of torque versus speed"
        extends Modelica.Mechanics.Rotational.Interfaces.PartialSpeedDependentTorque;
        parameter Real tau_nominal "nominal torque (if negative, torque is acting as load)";
        parameter Real TorqueDirection = 1 "same direction of torque in both directions of rotation";
        parameter Real w_nominal "nominal speed";
      equation
        if TorqueDirection > 0 then
          tau =  -tau_nominal * (w / w_nominal) ^ 2;
        else
          tau =  -tau_nominal * smooth(1, if w >= 0 then (w / w_nominal) ^ 2 else  -(w / w_nominal) ^ 2);
        end if;
      end QuadraticSpeedDependentTorque;

      model LinearSpeedDependentTorque "Linear dependency of torque versus speed"
        extends Modelica.Mechanics.Rotational.Interfaces.PartialSpeedDependentTorque;
        parameter Real tau_nominal "nominal torque (if negative, torque is acting as load)";
        parameter Real TorqueDirection = 1 "same direction of torque in both directions of rotation";
        parameter Real w_nominal "nominal speed";
      equation
        if TorqueDirection > 0 then
          tau =  -tau_nominal * abs(w / w_nominal);
        else
          tau =  -(tau_nominal * w) / w_nominal;
        end if;
      end LinearSpeedDependentTorque;

      package Interfaces

        partial model TwoFlangesAndBearing "Base class for a equation-based component with two rotational 1D flanges and one rotational 1D bearing flange"
          extends Bearing;
          Real phi_a;
          Real phi_b;
        equation
          if false then
            bearing.phi = 0;
          else
            bearing.tau = tau_support;
          end if;
          0 = flange_a.tau + flange_b.tau + tau_support;
          phi_a = flange_a.phi - bearing.phi;
          phi_b = flange_b.phi - bearing.phi;
        end TwoFlangesAndBearing;

        partial model TwoFlanges "Base class for a component with two rotational 1D flanges"
          Flange_a flange_a;
          Flange_b flange_b;
        end TwoFlanges;

        partial model Rigid "Base class for the rigid connection of two rotational 1D flanges"
          Real phi "Absolute rotation angle of component (= flange_a.phi = flange_b.phi)";
          Flange_a flange_a "(left) driving flange (flange axis directed INTO cut plane)";
          Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
        equation
          flange_a.phi = phi;
          flange_b.phi = phi;
        end Rigid;

        partial model PartialSpeedDependentTorque "Partial model of a torque acting at the flange (accelerates the flange)"
          Real w = der(flange.phi) "Angular velocity at flange";
          Real tau = flange.tau "accelerating torque acting at flange";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange on which torque is acting";
          Modelica.Mechanics.Rotational.Interfaces.Flange_a bearing "Bearing at which the reaction torque (i.e., -flange.tau) is acting";
        equation
          if false then
            bearing.phi = 0;
          else
            bearing.tau =  -flange.tau;
          end if;
        end PartialSpeedDependentTorque;

        connector Flange_b "1D rotational flange (non-filled square icon)"
          Real phi "Absolute rotation angle of flange";
          flow Real tau "Cut torque in the flange";
        end Flange_b;

        connector Flange_a "1D rotational flange (filled square icon)"
          Real phi "Absolute rotation angle of flange";
          flow Real tau "Cut torque in the flange";
        end Flange_a;

        partial model Compliant "Base class for the compliant connection of two rotational 1D flanges"
          Real phi_rel(start = 0) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
          Real tau "Torque between flanges (= flange_b.tau)";
          Flange_a flange_a "(left) driving flange (flange axis directed INTO cut plane)";
          Flange_b flange_b "(right) driven flange (flange axis directed OUT OF cut plane)";
        equation
          phi_rel = flange_b.phi - flange_a.phi;
          flange_b.tau = tau;
          flange_a.tau =  -tau;
        end Compliant;

        partial model Bearing "Base class for interface classes with bearing connector"
          extends TwoFlanges;
          Real tau_support;
          Flange_a bearing;
        end Bearing;

      end Interfaces;

      model Inertia "1D-rotational component with inertia"
        parameter Real J = 1 "Moment of inertia";
        Real w "Absolute angular velocity of component";
        Real a "Absolute angular acceleration of component";
        extends Interfaces.Rigid;
      equation
        w = der(phi);
        a = der(w);
        J * a = flange_a.tau + flange_b.tau;
      end Inertia;

      model IdealPlanetary "Ideal planetary gear box"
        parameter Real ratio = 100 / 50 "number of ring_teeth/sun_teeth (e.g. ratio=100/50)";
        Interfaces.Flange_a sun "sun flange (flange axis directed INTO cut plane)";
        Interfaces.Flange_a carrier "carrier flange (flange axis directed INTO cut plane)";
        Interfaces.Flange_b ring "ring flange (flange axis directed OUT OF cut plane)";
      equation
        (1 + ratio) * carrier.phi = sun.phi + ratio * ring.phi;
        ring.tau = ratio * sun.tau;
        carrier.tau =  -(1 + ratio) * sun.tau;
      end IdealPlanetary;

      model IdealGearR2T "Gearbox transforming rotational into translational motion"
        parameter Real ratio = 1 "transmission ratio (flange_a.phi/flange_b.s)";
        Real tau_support;
        Real f_support;
        Interfaces.Flange_a flange_a;
        Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
        Interfaces.Flange_a bearingR;
        Translational.Interfaces.Flange_a bearingT;
      equation
        flange_a.phi - bearingR.phi = ratio * (flange_b.s - bearingT.s);
        0 = ratio * flange_a.tau + flange_b.f;
        0 = flange_a.tau + tau_support;
        0 = flange_b.f + f_support;
        if false then
          bearingR.phi = 0;
        else
          bearingR.tau = tau_support;
        end if;
        if false then
          bearingT.s = 0;
        else
          bearingT.f = f_support;
        end if;
      end IdealGearR2T;

      model IdealGear "Ideal gear without inertia"
        extends Interfaces.TwoFlangesAndBearing;
        parameter Real ratio = 1 "Transmission ratio (flange_a.phi/flange_b.phi)";
      equation
        phi_a = ratio * phi_b;
        0 = ratio * flange_a.tau + flange_b.tau;
      end IdealGear;

      model Fixed "Flange fixed in housing at a given angle"
        parameter Real phi0 = 0 "Fixed offset angle of housing";
        Interfaces.Flange_b flange_b "(right) flange fixed in housing";
      equation
        flange_b.phi = phi0;
      end Fixed;

      model ElastoBacklash "Backlash connected in series to linear spring and damper (backlash is modeled with elasticity)"
        extends Interfaces.Compliant;
        parameter Real b = 0 "Total backlash";
        parameter Real c = 100000.0 "Spring constant (c > 0 required)";
        parameter Real phi_rel0 = 0 "Unstretched spring angle";
        parameter Real d = 0 "Damping constant";
        Real w_rel "Relative angular velocity between flange_b and flange_a";
      protected
        Real b2 = b / 2;
        constant Real b_min = 1e-10 "minimum backlash";
      equation
        w_rel = der(phi_rel);
        tau = if b2 > b_min then if phi_rel > b2 then c * (phi_rel - phi_rel0 - b2) + d * w_rel else if phi_rel <  -b2 then c * (phi_rel - phi_rel0 + b2) + d * w_rel else 0 else c * (phi_rel - phi_rel0) + d * w_rel;
      end ElastoBacklash;

      model Damper "Linear 1D rotational damper"
        extends Interfaces.Compliant;
        parameter Real d = 0 "Damping constant";
        Real w_rel "Relative angular velocity between flange_b and flange_a";
      equation
        w_rel = der(phi_rel);
        tau = d * w_rel;
      end Damper;

      model ConstantTorque "Constant torque, not dependent on speed"
        extends Modelica.Mechanics.Rotational.Interfaces.PartialSpeedDependentTorque;
        parameter Real tau_constant "constant torque (if negative, torque is acting as load)";
      equation
        tau =  -tau_constant;
      end ConstantTorque;

      model ConstantSpeed "Constant speed, not dependent on torque"
        extends Modelica.Mechanics.Rotational.Interfaces.PartialSpeedDependentTorque;
        parameter Real w_fixed "fixed speed (if negative, torque is acting as load)";
      equation
        w = w_fixed;
      end ConstantSpeed;

      model Accelerate "Forced movement of a.signal flange according to an acceleration signal"
        parameter Real phi_start = 0 "Start angle";
        parameter Real w_start = 0 "Start angular velocity";
        Real phi(final start = phi_start, final fixed = true) "absolute rotation angle of flange flange_b";
        Real w(final start = w_start, final fixed = true) "absolute angular velocity of flange flange_b";
        Real tau_support "Support torque";
        Interfaces.Flange_b flange_b;
        Blocks.Interfaces.RealInput a "absolute angular acceleration of flange_b as input signal";
        Interfaces.Flange_a bearing;
      equation
        0 = flange_b.tau + tau_support;
        if false then
          bearing.phi = 0;
        else
          bearing.tau = tau_support;
        end if;
        phi = flange_b.phi;
        w = der(phi);
        a.signal = der(w);
      end Accelerate;

    end Rotational;

  end Mechanics;

  package Icons

    partial model TranslationalSensor "Icon representing translational measurement device"
    end TranslationalSensor;

    partial model RotationalSensor "Icon representing rotational measurement device"
    end RotationalSensor;

  end Icons;

  package Electrical

    package Analog

      package Sources

        model StepVoltage "Step voltage source"
          parameter Real V = 1 "Height of step";
          extends Interfaces.VoltageSource;
          Modelica.Blocks.Sources.Step signalSource(final offset = offset, final startTime = startTime, height = V);
        equation
          v = signalSource.y.signal;
        end StepVoltage;

        model StepCurrent "Step current source"
          parameter Real I = 1 "Height of step";
          extends Interfaces.CurrentSource;
          Modelica.Blocks.Sources.Step signalSource(final offset = offset, final startTime = startTime, height = I);
        equation
          i = signalSource.y.signal;
        end StepCurrent;

        model SineVoltage "Sine voltage source"
          parameter Real V = 1 "Amplitude of sine wave";
          parameter Real phase = 0 "Phase of sine wave";
          parameter Real freqHz = 1 "Frequency of sine wave";
          extends Interfaces.VoltageSource;
          Modelica.Blocks.Sources.Sine signalSource(final offset = offset, final startTime = startTime, amplitude = V, freqHz = freqHz, phase = phase);
        equation
          v = signalSource.y.signal;
        end SineVoltage;

        model SineCurrent "Sine current source"
          parameter Real I = 1 "Amplitude of sine wave";
          parameter Real phase = 0 "Phase of sine wave";
          parameter Real freqHz = 1 "Frequency of sine wave";
          extends Interfaces.CurrentSource;
          Modelica.Blocks.Sources.Sine signalSource(final offset = offset, final startTime = startTime, amplitude = I, freqHz = freqHz, phase = phase);
        equation
          i = signalSource.y.signal;
        end SineCurrent;

        model SignalVoltage "Generic voltage source using the input signal as source voltage"
          Interfaces.PositivePin p;
          Interfaces.NegativePin n;
          Modelica.Blocks.Interfaces.RealInput v "Voltage between pin p and n  as input signal";
          Real i "Current flowing from pin p to pin n";
        equation
          v.signal = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
        end SignalVoltage;

        model SignalCurrent "Generic current source using the input signal as source current"
          Interfaces.PositivePin p;
          Interfaces.NegativePin n;
          Real v "Voltage drop between the two pins (= p.v - n.v)";
          Modelica.Blocks.Interfaces.RealInput i "Current flowing from pin p to pin n as input signal";
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i.signal = p.i;
        end SignalCurrent;

        model SawToothVoltage "Saw tooth voltage source"
          parameter Real V = 1 "Amplitude of saw tooth";
          parameter Real period = 1 "Time for one period";
          extends Interfaces.VoltageSource;
          Coselica.Blocks.Sources.SawTooth signalSource(final offset = offset, final startTime = startTime, amplitude = V, period = period);
        equation
          v = signalSource.y.signal;
        end SawToothVoltage;

        model SawToothCurrent "Saw tooth current source"
          parameter Real I = 1 "Amplitude of saw tooth";
          parameter Real period = 1 "Time for one period";
          extends Interfaces.CurrentSource;
          Coselica.Blocks.Sources.SawTooth signalSource(final offset = offset, final startTime = startTime, amplitude = I, period = period);
        equation
          i = signalSource.y.signal;
        end SawToothCurrent;

        model RampVoltage "Ramp voltage source"
          parameter Real V = 1 "Height of ramp";
          parameter Real duration = 2 "Duration of ramp";
          extends Interfaces.VoltageSource;
          Modelica.Blocks.Sources.Ramp signalSource(final offset = offset, final startTime = startTime, height = V, duration = duration);
        equation
          v = signalSource.y.signal;
        end RampVoltage;

        model RampCurrent "Ramp current source"
          parameter Real I = 1 "Height of ramp";
          parameter Real duration = 2 "Duration of ramp";
          extends Interfaces.CurrentSource;
          Modelica.Blocks.Sources.Ramp signalSource(final offset = offset, final startTime = startTime, height = I, duration = duration);
        equation
          i = signalSource.y.signal;
        end RampCurrent;

        model PulseVoltage "Pulse voltage source"
          parameter Real V = 1 "Amplitude of pulse";
          parameter Real width = 50 "Width of pulse in % of period";
          parameter Real period = 1 "Time for one period";
          extends Interfaces.VoltageSource;
          Coselica.Blocks.Sources.Pulse signalSource(final offset = offset, final startTime = startTime, amplitude = V, width = width, period = period);
        equation
          v = signalSource.y.signal;
        end PulseVoltage;

        model PulseCurrent "Pulse current source"
          parameter Real I = 1 "Amplitude of pulse";
          parameter Real width = 50 "Width of pulse in % of period";
          parameter Real period = 1 "Time for one period";
          extends Interfaces.CurrentSource;
          Coselica.Blocks.Sources.Pulse signalSource(final offset = offset, final startTime = startTime, amplitude = I, width = width, period = period);
        equation
          i = signalSource.y.signal;
        end PulseCurrent;

        model ConstantVoltage "Source for constant voltage"
          parameter Real V = 1 "Value of constant voltage";
          extends Interfaces.OnePort;
        equation
          v = V;
        end ConstantVoltage;

        model ConstantCurrent "Source for constant current"
          parameter Real I = 1 "Value of constant current";
          extends Interfaces.OnePort;
        equation
          i = I;
        end ConstantCurrent;

      end Sources;

      package Sensors

        model VoltageSensor "Sensor to measure the voltage between two pins"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.PositivePin p "positive pin";
          Interfaces.NegativePin n "negative pin";
          Modelica.Blocks.Interfaces.RealOutput v "Voltage between pin p and n (= p.v - n.v) as output signal";
        equation
          p.i = 0;
          n.i = 0;
          v.signal = p.v - n.v;
        end VoltageSensor;

        model PotentialSensor "Sensor to measure the potential"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.PositivePin p "pin to be measured";
          Modelica.Blocks.Interfaces.RealOutput phi "Absolute voltage potential as output signal";
        equation
          p.i = 0;
          phi.signal = p.v;
        end PotentialSensor;

        model CurrentSensor "Sensor to measure the current in a branch"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.PositivePin p "positive pin";
          Interfaces.NegativePin n "negative pin";
          Modelica.Blocks.Interfaces.RealOutput i "current in the branch from p to n as output signal";
        equation
          p.v = n.v;
          p.i = i.signal;
          n.i =  -i.signal;
        end CurrentSensor;

      end Sensors;

      package Semiconductors

        model PNP "Simple BJT according to Ebers-Moll"
          parameter Real Bf = 50 "Forward beta";
          parameter Real Br = 0.1 "Reverse beta";
          parameter Real Is = 1e-16 "Transport saturation current";
          parameter Real Vak = 0.02 "Early voltage (inverse), 1/Volt";
          parameter Real Tauf = 1.2e-10 "Ideal forward transit time";
          parameter Real Taur = 1 / 200000000.0 "Ideal reverse transit time";
          parameter Real Ccs = 1 / 1000000000000.0 "Collector-substrat(ground) cap.";
          parameter Real Cje = 4e-13 "Base-emitter zero bias depletion cap.";
          parameter Real Cjc = 5e-13 "Base-coll. zero bias depletion cap.";
          parameter Real Phie = 0.8 "Base-emitter diffusion voltage";
          parameter Real Me = 0.4 "Base-emitter gradation exponent";
          parameter Real Phic = 0.8 "Base-collector diffusion voltage";
          parameter Real Mc = 0.333 "Base-collector gradation exponent";
          parameter Real Gbc = 1 / 1e+15 "Base-collector conductance";
          parameter Real Gbe = 1 / 1e+15 "Base-emitter conductance";
          parameter Real Vt = 0.02585 "Voltage equivalent of temperature";
          parameter Real EMin =  -100 "if x < EMin, the exp(x) function is linearized";
          parameter Real EMax = 40 "if x > EMax, the exp(x) function is linearized";
        protected
          Real vbc;
          Real vbe;
          Real qbk;
          Real ibc;
          Real ibe;
          Real cbc;
          Real cbe;
          Real ExMin;
          Real ExMax;
          Real Capcje;
          Real Capcjc;
          function pow "Just a helper function for x^y"
            input Real x;
            input Real y;
            Real z;
          algorithm
            z:=x ^ y;
          end pow;
        public
          Modelica.Electrical.Analog.Interfaces.Pin C "Collector";
          Modelica.Electrical.Analog.Interfaces.Pin B "Base";
          Modelica.Electrical.Analog.Interfaces.Pin E "Emitter";
        equation
          ExMin = exp(EMin);
          ExMax = exp(EMax);
          vbc = C.v - B.v;
          vbe = E.v - B.v;
          qbk = 1 - vbc * Vak;
          ibc = if vbc / Vt < EMin then Is * (ExMin * (vbc / Vt - EMin + 1) - 1) + vbc * Gbc else if vbc / Vt > EMax then Is * (ExMax * (vbc / Vt - EMax + 1) - 1) + vbc * Gbc else Is * (exp(vbc / Vt) - 1) + vbc * Gbc;
          ibe = if vbe / Vt < EMin then Is * (ExMin * (vbe / Vt - EMin + 1) - 1) + vbe * Gbe else if vbe / Vt > EMax then Is * (ExMax * (vbe / Vt - EMax + 1) - 1) + vbe * Gbe else Is * (exp(vbe / Vt) - 1) + vbe * Gbe;
          Capcjc = if vbc / Phic > 0 then Cjc * (1 + (Mc * vbc) / Phic) else Cjc * ((1 - vbc / Phic)^(-Mc));
          Capcje = if vbe / Phie > 0 then Cje * (1 + (Me * vbe) / Phie) else Cje * ((1 - vbe / Phie)^(-Me));
          cbc = if vbc / Vt < EMin then (Taur * Is) / Vt * ExMin * (vbc / Vt - EMin + 1) + Capcjc else if vbc / Vt > EMax then (Taur * Is) / Vt * ExMax * (vbc / Vt - EMax + 1) + Capcjc else (Taur * Is) / Vt * exp(vbc / Vt) + Capcjc;
          cbe = if vbe / Vt < EMin then (Tauf * Is) / Vt * ExMin * (vbe / Vt - EMin + 1) + Capcje else if vbe / Vt > EMax then (Tauf * Is) / Vt * ExMax * (vbe / Vt - EMax + 1) + Capcje else (Tauf * Is) / Vt * exp(vbe / Vt) + Capcje;
          C.i =  -((ibe - ibc) * qbk - ibc / Br - cbc * der(vbc) - Ccs * der(C.v));
          B.i =  -(ibe / Bf + ibc / Br + cbe * der(vbe) + cbc * der(vbc));
          E.i =  -B.i - C.i + Ccs * der(C.v);
        end PNP;

        model PMOS "Simple MOS Transistor"
          Interfaces.Pin D "Drain";
          Interfaces.Pin G "Gate";
          Interfaces.Pin S "Source";
          Interfaces.Pin B "Bulk";
          parameter Real W = 2e-05 "Width";
          parameter Real L = 6e-06 "Length";
          parameter Real Beta = 1.05e-05 "Transconductance parameter";
          parameter Real Vt =  -1.0 "Zero bias threshold voltage";
          parameter Real K2 = 0.41 "Bulk threshold parameter";
          parameter Real K5 = 0.839 "Reduction of pinch-off region";
          parameter Real dW =  -2.5e-06 "Narrowing of channel";
          parameter Real dL =  -2.1e-06 "Shortening of channel";
          parameter Real RDS = 10000000.0 "Drain-Source-Resistance";
        protected
          Real v;
          Real uds;
          Real ubs;
          Real ugst;
          Real ud;
          Real us;
          Real id;
          Real gds;
        equation
          gds = if RDS < 1e-20 and RDS >  -1e-20 then 1e+20 else 1 / RDS;
          v = (Beta * (W + dW)) / (L + dL);
          ud = if D.v > S.v then S.v else D.v;
          us = if D.v > S.v then D.v else S.v;
          uds = ud - us;
          ubs = if B.v < us then 0 else B.v - us;
          ugst = (G.v - us - Vt + K2 * ubs) * K5;
          id = if ugst >= 0 then v * uds * gds else if ugst < uds then  -v * uds * (ugst - uds / 2 - gds) else  -v * ((ugst * ugst) / 2 - uds * gds);
          G.i = 0;
          D.i = if D.v > S.v then  -id else id;
          S.i = if D.v > S.v then id else  -id;
          B.i = 0;
        end PMOS;

        model NPN "Simple BJT according to Ebers-Moll"
          parameter Real Bf = 50 "Forward beta";
          parameter Real Br = 0.1 "Reverse beta";
          parameter Real Is = 1e-16 "Transport saturation current";
          parameter Real Vak = 0.02 "Early voltage (inverse), 1/Volt";
          parameter Real Tauf = 1.2e-10 "Ideal forward transit time";
          parameter Real Taur = 1 / 200000000.0 "Ideal reverse transit time";
          parameter Real Ccs = 1 / 1000000000000.0 "Collector-substrat(ground) cap.";
          parameter Real Cje = 4e-13 "Base-emitter zero bias depletion cap.";
          parameter Real Cjc = 5e-13 "Base-coll. zero bias depletion cap.";
          parameter Real Phie = 0.8 "Base-emitter diffusion voltage";
          parameter Real Me = 0.4 "Base-emitter gradation exponent";
          parameter Real Phic = 0.8 "Base-collector diffusion voltage";
          parameter Real Mc = 0.333 "Base-collector gradation exponent";
          parameter Real Gbc = 1 / 1e+15 "Base-collector conductance";
          parameter Real Gbe = 1 / 1e+15 "Base-emitter conductance";
          parameter Real Vt = 0.02585 "Voltage equivalent of temperature";
          parameter Real EMin =  -100 "if x < EMin, the exp(x) function is linearized";
          parameter Real EMax = 40 "if x > EMax, the exp(x) function is linearized";
        protected
          Real vbc;
          Real vbe;
          Real qbk;
          Real ibc;
          Real ibe;
          Real cbc;
          Real cbe;
          Real ExMin;
          Real ExMax;
          Real Capcje;
          Real Capcjc;
          function pow "Just a helper function for x^y"
            input Real x;
            input Real y;
            Real z;
          algorithm
            z:=x ^ y;
          end pow;
        public
          Modelica.Electrical.Analog.Interfaces.Pin C "Collector";
          Modelica.Electrical.Analog.Interfaces.Pin B "Base";
          Modelica.Electrical.Analog.Interfaces.Pin E "Emitter";
        equation
          ExMin = exp(EMin);
          ExMax = exp(EMax);
          vbc = B.v - C.v;
          vbe = B.v - E.v;
          qbk = 1 - vbc * Vak;
          ibc = if vbc / Vt < EMin then Is * (ExMin * (vbc / Vt - EMin + 1) - 1) + vbc * Gbc else if vbc / Vt > EMax then Is * (ExMax * (vbc / Vt - EMax + 1) - 1) + vbc * Gbc else Is * (exp(vbc / Vt) - 1) + vbc * Gbc;
          ibe = if vbe / Vt < EMin then Is * (ExMin * (vbe / Vt - EMin + 1) - 1) + vbe * Gbe else if vbe / Vt > EMax then Is * (ExMax * (vbe / Vt - EMax + 1) - 1) + vbe * Gbe else Is * (exp(vbe / Vt) - 1) + vbe * Gbe;
          Capcjc = if vbc / Phic > 0 then Cjc * (1 + (Mc * vbc) / Phic) else Cjc * ((1 - vbc / Phic)^(-Mc));
          Capcje = if vbe / Phie > 0 then Cje * (1 + (Me * vbe) / Phie) else Cje * ((1 - vbe / Phie)^(-Me));
          cbc = if vbc / Vt < EMin then (Taur * Is) / Vt * ExMin * (vbc / Vt - EMin + 1) + Capcjc else if vbc / Vt > EMax then (Taur * Is) / Vt * ExMax * (vbc / Vt - EMax + 1) + Capcjc else (Taur * Is) / Vt * exp(vbc / Vt) + Capcjc;
          cbe = if vbe / Vt < EMin then (Tauf * Is) / Vt * ExMin * (vbe / Vt - EMin + 1) + Capcje else if vbe / Vt > EMax then (Tauf * Is) / Vt * ExMax * (vbe / Vt - EMax + 1) + Capcje else (Tauf * Is) / Vt * exp(vbe / Vt) + Capcje;
          C.i = (ibe - ibc) * qbk - ibc / Br - cbc * der(vbc) + Ccs * der(C.v);
          B.i = ibe / Bf + ibc / Br + cbc * der(vbc) + cbe * der(vbe);
          E.i =  -B.i - C.i + Ccs * der(C.v);
        end NPN;

        model NMOS "Simple MOS Transistor"
          Interfaces.Pin D "Drain";
          Interfaces.Pin G "Gate";
          Interfaces.Pin S "Source";
          Interfaces.Pin B "Bulk";
          parameter Real W = 2e-05 "Width";
          parameter Real L = 6e-06 "Length";
          parameter Real Beta = 4.1e-05 "Transconductance parameter";
          parameter Real Vt = 0.8 "Zero bias threshold voltage";
          parameter Real K2 = 1.144 "Bulk threshold parameter";
          parameter Real K5 = 0.7311 "Reduction of pinch-off region";
          parameter Real dW =  -2.5e-06 "narrowing of channel";
          parameter Real dL =  -1.5e-06 "shortening of channel";
          parameter Real RDS = 10000000.0 "Drain-Source-Resistance";
        protected
          Real v;
          Real uds;
          Real ubs;
          Real ugst;
          Real ud;
          Real us;
          Real id;
          Real gds;
        equation
          gds = if RDS < 1e-20 and RDS >  -1e-20 then 1e+20 else 1 / RDS;
          v = (Beta * (W + dW)) / (L + dL);
          ud = if D.v < S.v then S.v else D.v;
          us = if D.v < S.v then D.v else S.v;
          uds = ud - us;
          ubs = if B.v > us then 0 else B.v - us;
          ugst = (G.v - us - Vt + K2 * ubs) * K5;
          id = if ugst <= 0 then v * uds * gds else if ugst > uds then v * uds * (ugst - uds / 2 + gds) else v * ((ugst * ugst) / 2 + uds * gds);
          G.i = 0;
          D.i = if D.v < S.v then  -id else id;
          S.i = if D.v < S.v then id else  -id;
          B.i = 0;
        end NMOS;

        model Diode "Simple diode"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real Ids = 1e-06 "Saturation current";
          parameter Real Vt = 0.04 "Voltage equivalent of temperature (kT/qn)";
          parameter Real Maxexp = 15 "Max. exponent for linear continuation";
          parameter Real R = 100000000.0 "Parallel ohmic resistance";
        equation
          i = if v / Vt > Maxexp then Ids * (exp(Maxexp) * (1 + v / Vt - Maxexp) - 1) + v / R else Ids * (exp(v / Vt) - 1) + v / R;
        end Diode;

      end Semiconductors;

      package Interfaces

        partial model VoltageSource "Interface for voltage sources"
          extends OnePort;
          parameter Real offset = 0 "Voltage offset";
          parameter Real startTime = 0 "Time offset";
        end VoltageSource;

        partial model TwoPort "Component with two electrical ports, including current"
          Real v1 "Voltage drop over the left port";
          Real v2 "Voltage drop over the right port";
          Real i1 "Current flowing from pos. to neg. pin of the left port";
          Real i2 "Current flowing from pos. to neg. pin of the right port";
          PositivePin p1 "Positive pin of the left port";
          NegativePin n1 "Negative pin of the left port";
          PositivePin p2 "Positive pin of the right port";
          NegativePin n2 "Negative pin of the right port";
        equation
          v1 = p1.v - n1.v;
          v2 = p2.v - n2.v;
          0 = p1.i + n1.i;
          0 = p2.i + n2.i;
          i1 = p1.i;
          i2 = p2.i;
        end TwoPort;

        connector PositivePin "Positive pin of an electric component"
          Real v "Potential at the pin";
          flow Real i "Current flowing into the pin";
        end PositivePin;

        connector Pin "Pin of an electrical component"
          Real v "Potential at the pin";
          flow Real i "Current flowing into the pin";
        end Pin;

        partial model OnePort "Component with two electrical pins p and n and current i from p to n"
          Real v "Voltage drop between the two pins (= p.v - n.v)";
          Real i "Current flowing from pin p to pin n";
          PositivePin p;
          NegativePin n;
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
        end OnePort;

        connector NegativePin "Negative pin of an electric component"
          Real v "Potential at the pin";
          flow Real i "Current flowing into the pin";
        end NegativePin;

        partial model CurrentSource "Interface for current sources"
          extends OnePort;
          parameter Real offset = 0 "Current offset";
          parameter Real startTime = 0 "Time offset";
        end CurrentSource;

      end Interfaces;

      package Ideal

        model Short "Short cut branch"
          extends Interfaces.OnePort;
        equation
          v = 0;
        end Short;

        model Idle "Idle branch"
          extends Interfaces.OnePort;
        equation
          i = 0;
        end Idle;

        model IdealTransformer "Ideal electrical transformer"
          extends Interfaces.TwoPort;
          parameter Real n = 1 "Turns ratio";
        equation
          v1 = n * v2;
          i2 =  -n * i1;
        end IdealTransformer;

        model IdealOpeningSwitch "Ideal electrical opener"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real Ron = 1e-05 "Closed switch resistance";
          parameter Real Goff = 1e-05 "Opened switch conductance";
          Modelica.Blocks.Interfaces.RealInput control "true => switch open, false => p--n connected";
        protected
          Real s "Auxiliary variable";
        equation
          v = s * (if (control.signal > 0.0) then 1 else Ron);
          i = s * (if (control.signal > 0.0) then Goff else 1);
        end IdealOpeningSwitch;

        model IdealGyrator "Ideal gyrator"
          extends Interfaces.TwoPort;
          parameter Real G = 1 "Gyration conductance";
        equation
          i1 = G * v2;
          i2 =  -G * v1;
        end IdealGyrator;

        model IdealClosingSwitch "Ideal electrical closer"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real Ron = 1e-05 "Closed switch resistance";
          parameter Real Goff = 1e-05 "Opened switch conductance";
          Modelica.Blocks.Interfaces.RealInput control "true => p--n connected, false => switch open";
        protected
          Real s "Auxiliary variable";
        equation
          v = s * (if (control.signal > 0.0) then Ron else 1);
          i = s * (if (control.signal > 0.0) then 1 else Goff);
        end IdealClosingSwitch;

      end Ideal;

      package Basic

        model VCV "Linear voltage-controlled voltage source"
          extends Interfaces.TwoPort;
          parameter Real gain = 1 "Voltage gain";
        equation
          v2 = v1 * gain;
          i1 = 0;
        end VCV;

        model VCC "Linear voltage-controlled current source"
          extends Interfaces.TwoPort;
          parameter Real transConductance = 1 "Transconductance";
        equation
          i2 = v1 * transConductance;
          i1 = 0;
        end VCC;

        model VariableResistor "Ideal linear electrical resistor with variable resistance"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          Modelica.Blocks.Interfaces.RealInput R;
        equation
          v = R.signal * i;
        end VariableResistor;

        model VariableConductor "Ideal linear electrical conductor with variable conductance"
          extends Interfaces.OnePort;
          Modelica.Blocks.Interfaces.RealInput G;
        equation
          i = G.signal * v;
        end VariableConductor;

        model VariableInductor "Ideal linear electrical inductor with variable inductance"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          Modelica.Blocks.Interfaces.RealInput L;
          Real Psi;
          parameter Real Lmin = Coselica.Constants.eps;
        equation
          //assert(L.signal >= 0, "Inductance L_ (= " + String(L.signal) + ") has to be >= 0!");
          Psi = noEvent(max(L.signal, Lmin)) * i;
          v = der(Psi);
        end VariableInductor;

        model VariableCapacitor "Ideal linear electrical capacitor with variable capacitance"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          Modelica.Blocks.Interfaces.RealInput C;
          parameter Real Cmin = Coselica.Constants.eps;
          Real Q;
        equation
          //assert(C.signal >= 0, "Capacitance C.signal (= " + String(C.signal) + ") has to be >= 0!");
          Q = noEvent(max(C.signal, Cmin)) * v;
          i = der(Q);
        end VariableCapacitor;

        model Transformer "Transformer with two ports"
          extends Interfaces.TwoPort;
          parameter Real L1 = 1 "Primary inductance";
          parameter Real L2 = 1 "Secondary inductance";
          parameter Real M = 1 "Coupling inductance";
        equation
          v1 = L1 * der(i1) + M * der(i2);
          v2 = M * der(i1) + L2 * der(i2);
        end Transformer;

        model Resistor "Ideal linear electrical resistor"
          extends Interfaces.OnePort;
          parameter Real R = 1 "Resistance";
        equation
          R * i = v;
        end Resistor;

        model Conductor "Ideal linear electrical conductor"
          extends Interfaces.OnePort;
          parameter Real G = 1 "Conductance";
        equation
          i = G * v;
        end Conductor;

        model OpAmp "Simple nonideal model of an OpAmp with limitation"
          parameter Real Slope = 1 "Slope of the out.v/vin characteristic at vin=0";
          Modelica.Electrical.Analog.Interfaces.PositivePin in_p "Positive pin of the input port";
          Modelica.Electrical.Analog.Interfaces.NegativePin in_n "Negative pin of the input port";
          Modelica.Electrical.Analog.Interfaces.PositivePin out "Output pin";
          Modelica.Electrical.Analog.Interfaces.PositivePin VMax "Positive output voltage limitation";
          Modelica.Electrical.Analog.Interfaces.NegativePin VMin "Negative output voltage limitation";
          Real vin "input voltagae";
        protected
          Real f "auxiliary variable";
          Real absSlope;
        equation
          in_p.i = 0;
          in_n.i = 0;
          VMax.i = 0;
          VMin.i = 0;
          vin = in_p.v - in_n.v;
          f = 2 / (VMax.v - VMin.v);
          absSlope = if Slope < 0 then  -Slope else Slope;
          out.v = (VMax.v + VMin.v) / 2 + (absSlope * vin) / (1 + absSlope * noEvent(if f * vin < 0 then  -f * vin else f * vin));
        end OpAmp;

        model Inductor "Ideal linear electrical inductor"
          extends Interfaces.OnePort;
          parameter Real L = 1 "Inductance";
        equation
          L * der(i) = v;
        end Inductor;

        model HeatingResistor "Temperature dependent electrical resistor"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real R_ref = 1 "Resistance at temperature T_ref";
          parameter Real T_ref = 300 "Reference temperature";
          parameter Real alpha = 0 "Temperature coefficient of resistance";
          Real R "Resistance = R_ref*(1 + alpha*(heatPort.T - T_ref));";
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort;
        equation
          v = R * i;
          if true then
            R = R_ref * (1 + alpha * (heatPort.T - T_ref));
            heatPort.Q_flow =  -v * i;
          else
            R = R_ref;
            heatPort.T = T_ref;
          end if;
        end HeatingResistor;

        model Gyrator "Gyrator"
          extends Interfaces.TwoPort;
          parameter Real G1 = 1 "Gyration conductance";
          parameter Real G2 = 1 "Gyration conductance";
        equation
          i1 = G2 * v2;
          i2 =  -G1 * v1;
        end Gyrator;

        model Ground "Ground node"
          Interfaces.Pin p;
        equation
          p.v = 0;
        end Ground;

        model EMF "Electromotoric force (electric/mechanic transformer)"
          parameter Real k = 1 "Transformation coefficient";
          Real v "Voltage drop between the two pins";
          Real i "Current flowing from positive to negative pin";
          Real w "Angular velocity of flange_b";
          Interfaces.PositivePin p;
          Interfaces.NegativePin n;
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          w = der(flange_b.phi);
          k * w = v;
          flange_b.tau =  -k * i;
        end EMF;

        model CCV "Linear current-controlled voltage source"
          extends Interfaces.TwoPort;
          parameter Real transResistance = 1 "Transresistance";
        equation
          v2 = i1 * transResistance;
          v1 = 0;
        end CCV;

        model CCC "Linear current-controlled current source"
          extends Interfaces.TwoPort;
          parameter Real gain = 1 "Current gain";
        equation
          i2 = i1 * gain;
          v1 = 0;
        end CCC;

        model Capacitor "Ideal linear electrical capacitor"
          extends Interfaces.OnePort;
          parameter Real C = 1 "Capacitance";
        equation
          i = C * der(v);
        end Capacitor;

      end Basic;

    end Analog;

  end Electrical;

  package Blocks

    package Sources

      model Step "Generate step signal of type Real"
        parameter Real height = 1 "Height of step";
        extends Interfaces.SignalSource;
      equation
        y.signal = offset + (if time < startTime then 0 else height);
      end Step;

      model Sine "Generate sine signal"
        parameter Real amplitude = 1 "Amplitude of sine wave";
        parameter Real freqHz = 1 "Frequency of sine wave";
        parameter Real phase = 0 "Phase of sine wave";
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      protected
        constant Real pi = Coselica.Constants.pi;
      equation
        y.signal = offset + (if time < startTime then 0 else amplitude * sin(2 * pi * freqHz * (time - startTime) + phase));
      end Sine;

      model SawTooth "Generate saw tooth signal"
        parameter Real amplitude = 1 "Amplitude of saw tooth";
        parameter Real period = 1 "Time for one period";
        parameter Real offset = 0 "Offset of output signals";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      protected
        Real T0(final start = startTime) "Start time of current period";
      equation
        der( T0 ) = 0;
        when time > T0 + period then
          reinit( T0, time );
        end when;
        y.signal = offset + (if time < startTime then 0 else amplitude / period * (time - T0));
      end SawTooth;

      model Ramp "Generate ramp signal"
        parameter Real height = 1 "Height of ramps";
        parameter Real duration = 2 "Durations of ramp";
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      equation
        y.signal = offset + (if time < startTime then 0 else if time < startTime + duration then ((time - startTime) * height) / duration else height);
      end Ramp;

      model Pulse "Generate pulse signal of type Real"
        parameter Real amplitude = 1 "Amplitude of pulse";
        parameter Real width = 50 "Width of pulse in % of periods";
        parameter Real period = 1 "Time for one period";
        parameter Real offset = 0 "Offset of output signals";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Modelica.Blocks.Interfaces.SO;
      protected
        Real T0(final start = startTime) "Start time of current period";
        Real T_width = (period * width) / 100;
      equation
        der( T0 ) = 0;
        when time > T0 + period then
          reinit( T0, time );
        end when;
        y.signal = offset + (if time < startTime then 0 elseif time >= T0 + T_width then 0 else amplitude);
      end Pulse;

      model ExpSine "Generate exponentially damped sine signal"
        parameter Real amplitude = 1 "Amplitude of sine wave";
        parameter Real freqHz = 2 "Frequency of sine wave";
        parameter Real phase = 0 "Phase of sine wave";
        parameter Real damping = 1 "Damping coefficient of sine wave";
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      protected
        constant Real pi = Coselica.Constants.pi;
      equation
        y.signal = offset + (if time < startTime then 0 else amplitude * exp( -(time - startTime) * damping) * sin(2 * pi * freqHz * (time - startTime) + phase));
      end ExpSine;

      model Exponentials "Generate a rising and falling exponential signal"
        parameter Real outMax = 1 "Height of output for infinite riseTime";
        parameter Real riseTime = 0.5 "Rise time";
        parameter Real riseTimeConst = 0.1 "Rise time constant";
        parameter Real fallTimeConst = riseTimeConst "Fall time constant";
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      protected
        Real y_riseTime;
      equation
        y_riseTime = outMax * (1 - exp( -riseTime / riseTimeConst));
        y.signal = offset + (if time < startTime then 0 else if time < startTime + riseTime then outMax * (1 - exp( -(time - startTime) / riseTimeConst)) else y_riseTime * exp( -(time - startTime - riseTime) / fallTimeConst));
      end Exponentials;

      model Constant "Generate constant signal of type Real"
        parameter Real k = 1 "Constant output value";
        extends Interfaces.SO;
      equation
        y.signal = k;
      end Constant;

      model Clock "Generate actual time signal "
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Interfaces.SO;
      equation
        y.signal = offset + (if time < startTime then 0 else time - startTime);
      end Clock;

    end Sources;

    package Nonlinear

      model Limiter "Limit the range of a signal"
        parameter Real uMax = 1 "Upper limits of input signals";
        parameter Real uMin =  -uMax "Lower limits of input signals";
        extends Interfaces.SISO;
      equation
        y.signal = if u.signal > uMax then uMax else if u.signal < uMin then uMin else u.signal;
      end Limiter;

      model DeadZone "Provide a region of zero output"
        parameter Real uMax = 1 "Upper limits of dead zones";
        parameter Real uMin =  -uMax "Lower limits of dead zones";
        extends Interfaces.SISO;
      equation
        y.signal = if u.signal > uMax then u.signal - uMax else if u.signal < uMin then u.signal - uMin else 0;
      end DeadZone;

    end Nonlinear;

    package Math

      model Tan "Output the tangent of the input"
        extends Interfaces.SISO;
      equation
        y.signal = tan(u.signal);
      end Tan;

      model Tanh "Output the hyperbolic tangent of the input"
        extends Interfaces.SISO;
      equation
        y.signal = tanh(u.signal);
      end Tanh;

      model Sqrt "Output the square root of the input (input >= 0 required)"
        extends Interfaces.SISO;
      equation
        y.signal = sqrt(u.signal);
      end Sqrt;

      model Sin "Output the sine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = sin(u.signal);
      end Sin;

      model Sinh "Output the hyperbolic sine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = sinh(u.signal);
      end Sinh;

      model Sign "Output the sign of the input"
        extends Interfaces.SISO;
      equation
        y.signal = sign(u.signal);
      end Sign;

      model Product "Output product of the two inputs"
        extends Interfaces.SI2SO;
      equation
        y.signal = u1.signal * u2.signal;
      end Product;

      model Min "Pass through the smallest signal"
        extends Interfaces.SI2SO;
      equation
        y.signal = min(u1.signal, u2.signal);
      end Min;

      model Max "Pass through the largest signal"
        extends Interfaces.SI2SO;
      equation
        y.signal = max(u1.signal, u2.signal);
      end Max;

      model Log "Output the natural (base e) logarithm of the input (input > 0 required)"
        extends Interfaces.SISO;
      equation
        y.signal = log(u.signal);
      end Log;

      model Log10 "Output the base 10 logarithm of the input (input > 0 required)"
        extends Interfaces.SISO;
      equation
        y.signal = log10(u.signal);
      end Log10;

      model Gain "Output the product of a gain value with the input signal"
        parameter Real k = 1 "Gain value multiplied with input signal";
      public
        Interfaces.RealInput u "Input signal connector";
        Interfaces.RealOutput y "Output signal connector";
      equation
        y.signal = k * u.signal;
      end Gain;

      model Feedback "Output difference between commanded and feedback input"
        input Interfaces.RealInput u1;
        input Interfaces.RealInput u2;
        output Interfaces.RealOutput y;
      equation
        y.signal = u1.signal - u2.signal;
      end Feedback;

      model Exp "Output the exponential (base e) of the input"
        extends Interfaces.SISO;
      equation
        y.signal = exp(u.signal);
      end Exp;

      model Division "Output first input divided by second input"
        extends Interfaces.SI2SO;
      equation
        y.signal = u1.signal / u2.signal;
      end Division;

      model Cos "Output the cosine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = cos(u.signal);
      end Cos;

      model Cosh "Output the hyperbolic cosine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = (exp(u.signal) + exp( - u.signal)) / 2;
      end Cosh;

      model Atan "Output the arc tangent of the input"
        extends Interfaces.SISO;
      equation
        y.signal = atan(u.signal);
      end Atan;

      model Asin "Output the arc sine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = asin(u.signal);
      end Asin;

      model Add "Output the sum of the two inputs"
        extends Interfaces.SI2SO;
        parameter Real k1 = 1 "Gain of upper input";
        parameter Real k2 = 1 "Gain of lower input";
      equation
        y.signal = k1 * u1.signal + k2 * u2.signal;
      end Add;

      model Add3 "Output the sum of the three inputs"
        extends Interfaces.BlockIcon;
        parameter Real k1 = 1 "Gain of upper input";
        parameter Real k2 = 1 "Gain of middle input";
        parameter Real k3 = 1 "Gain of lower input";
        input Interfaces.RealInput u1 "Connector 1 of Real input signals";
        input Interfaces.RealInput u2 "Connector 2 of Real input signals";
        input Interfaces.RealInput u3 "Connector 3 of Real input signals";
        output Interfaces.RealOutput y "Connector of Real output signals";
      equation
        y.signal = k1 * u1.signal + k2 * u2.signal + k3 * u3.signal;
      end Add3;

      model Acos "Output the arc cosine of the input"
        extends Interfaces.SISO;
      equation
        y.signal = acos(u.signal);
      end Acos;

      model Abs "Output the absolute value of the input"
        extends Interfaces.SISO;
      equation
        y.signal = abs(u.signal);
      end Abs;

    end Math;

    package Interfaces

      partial model SVcontrol "Single-Variable continuous controller"
        extends BlockIcon;
        RealInput u_s "Connector of setpoint input signal";
        RealInput u_m "Connector of measurement input signal";
        RealOutput y "Connector of actuator output signal";
      end SVcontrol;

      partial model SO "Single Output continuous control block"
        extends BlockIcon;
        RealOutput y "Connector of Real output signal";
      end SO;

      partial model SISO "Single Input Single Output continuous control block"
        extends BlockIcon;
        RealInput u "Connector of Real input signal";
        RealOutput y "Connector of Real output signal";
      end SISO;

      partial model SIMO "Single Input Multiple Output continuous control block"
        extends BlockIcon;
        parameter Integer nout = 1 "Number of outputs";
        RealInput u "Connector of Real input signal";
        RealOutput y[nout] "Connector of Real output signals";
      end SIMO;

      partial model SI2SO "2 Single Input / 1 Single Output continuous control block"
        extends BlockIcon;
        RealInput u1 "Connector of Real input signal 1";
        RealInput u2 "Connector of Real input signal 2";
        RealOutput y "Connector of Real output signal";
      end SI2SO;

      partial model SignalSource "Base class for continuous signal source"
        extends SO;
        parameter Real offset = 0 "offset of output signal";
        parameter Real startTime = 0 "output = offset for time < startTime";
      end SignalSource;

      connector RealOutput
        Real signal;
      end RealOutput;

      connector RealInput
        Real signal;
      end RealInput;

      partial model MISO "Multiple Input Single Output continuous control block"
        extends BlockIcon;
        parameter Integer nin = 1 "Number of inputs";
        RealInput u[nin] "Connector of Real input signals";
        RealOutput y "Connector of Real output signal";
      end MISO;

      partial model MI2MO "2 Multiple Input / Multiple Output continuous control block"
        extends BlockIcon;
        parameter Integer n = 1 "Dimension of input and output vectors.";
        RealInput u1[n] "Connector 1 of Real input signals";
        RealInput u2[n] "Connector 2 of Real input signals";
        RealOutput y[n] "Connector of Real output signals";
      end MI2MO;

      partial model BlockIcon "Basic graphical layout of continuous block"
      end BlockIcon;

    end Interfaces;

    package Continuous

      model SecondOrder "Second order transfer function model (= 2 poles)"
        parameter Real k = 1 "Gain";
        parameter Real w = 1 "Angular frequency";
        parameter Real D = 1 "Damping";
        extends Interfaces.SISO;
        Real yd "Derivative of y.signal";
      equation
        der(y.signal) = yd;
        der(yd) = w * (w * (k * u.signal - y.signal) - 2 * D * yd);
      end SecondOrder;

      model PID "PID-controller in additive description form"
        extends Interfaces.SISO;
        parameter Real k = 1 "Gain";
        parameter Real Ti = 0.5 "Time Constant of Integrator";
        parameter Real Td = 0.1 "Time Constant of Derivative block";
        parameter Real Nd = 10 "The higher Nd, the more ideal the derivative block";
        Blocks.Math.Gain P "Proportional part of PID controller";
        Blocks.Continuous.Integrator I(k = 1 / Ti) "Integral part of PID controller";
        Blocks.Continuous.Derivative D(k = Td, T = if Td / Nd >= 100 * Coselica.Constants.eps then Td / Nd else 100 * Coselica.Constants.eps) "Derivative part of PID controller";
        Blocks.Math.Gain Gain(k = k) "Gain of PID controller";
        Blocks.Math.Add3 Add;
      equation
        connect(P.y,Add.u1);
        connect(I.y,Add.u2);
        connect(D.y,Add.u3);
        connect(Add.y,Gain.u);
        connect(y,Gain.y);
        connect(u,I.u);
        connect(u,P.u);
        connect(u,D.u);
      end PID;

      model PI "Proportional-Integral controller"
        parameter Real k = 1 "Gain";
        parameter Real T = 1 "Time Constant (T>0 required)";
        extends Interfaces.SISO;
        Real x "State of block";
      equation
        der(x) = u.signal / T;
        y.signal = k * (x + u.signal);
      end PI;

      model LimPID "PID controller with limited output, anti-windup compensation and setpoint weighting"
        extends Interfaces.SVcontrol;
        parameter Real k = 1 "Gain of PID block";
        parameter Real Ti = 0.5 "Time constant of Integrator block";
        parameter Real Td = 0.1 "Time constant of Derivative block";
        parameter Real yMax = 1 "Upper limit of output";
        parameter Real yMin =  -yMax "Lower limit of output";
        parameter Real wp = 1 "Set-point weight for Proportional model (0..1)";
        parameter Real wd = 0 "Set-point weight for Derivative model (0..1)";
        parameter Real Ni = 0.9 "Ni*Ti is time constant of anti-windup compensation";
        parameter Real Nd = 10 "The higher Nd, the more ideal the derivative block";
        Blocks.Nonlinear.Limiter limiter(uMax = yMax, uMin = yMin);
        Blocks.Math.Add addP(k1 = wp, k2 =  -1);
        Blocks.Math.Add addD(k1 = wd, k2 =  -1);
        Blocks.Math.Gain P;
        Blocks.Continuous.Integrator I(k = 1 / Ti);
        Blocks.Continuous.Derivative D(k = Td, T = if Td / Nd >= 1e-14 then Td / Nd else 1e-14);
        Blocks.Math.Gain gainPID(k = k);
        Blocks.Math.Add3 addPID;
        Blocks.Math.Add3 addI(k2 =  -1);
        Blocks.Math.Add addSat(k2 =  -1);
        Blocks.Math.Gain gainTrack(k = 1 / (k * Ni));
      equation
        //assert(yMax >= yMin, "PID: Limits must be consistent");
        connect(u_s,addP.u1);
        connect(u_m,addP.u2);
        connect(u_s,addD.u1);
        connect(u_m,addD.u2);
        connect(u_s,addI.u1);
        connect(u_m,addI.u2);
        connect(gainTrack.y,addI.u3);
        connect(addP.y,P.u);
        connect(addD.y,D.u);
        connect(addI.y,I.u);
        connect(P.y,addPID.u1);
        connect(D.y,addPID.u2);
        connect(I.y,addPID.u3);
        connect(addPID.y,gainPID.u);
        connect(gainPID.y,addSat.u2);
        connect(addSat.y,gainTrack.u);
        connect(gainPID.y,limiter.u);
        connect(limiter.y,y);
        connect(limiter.y,addSat.u1);
      end LimPID;

      model LimIntegrator "Integrator with limited values of the outputs"
        parameter Real k = 1 "Integrator gains";
        parameter Real outMax = 1 "Upper limits of outputs";
        parameter Real outMin =  -outMax "Lower limits of outputs";
        parameter Real y_start = 0 "Start values of integrators";
        extends Interfaces.SISO(y(signal(start = y_start, fixed = true)));
      equation
        der(y.signal) = if y.signal < outMin and u.signal < 0 or y.signal > outMax and u.signal > 0 then 0 else k * u.signal;
      end LimIntegrator;

      model Integrator "Output the integral of the input signals"
        parameter Real k = 1 "Integrator gains";
        parameter Real y_start = 0 "Start values of integrators";
        extends Interfaces.SISO(y(signal(start = y_start, fixed = true)));
      equation
        der(y.signal) = k * u.signal;
      end Integrator;

      model FirstOrder "First order transfer function model (= 1 pole)"
        parameter Real k = 1 "Gain";
        parameter Real T = 1 "Time Constant";
        extends Interfaces.SISO;
      equation
        der(y.signal) = (k * u.signal - y.signal) / T;
      end FirstOrder;

      model Der "Derivative of input (= analytic differentations)"
        extends Interfaces.SISO;
      equation
        y.signal = der(u.signal);
      end Der;

      model Derivative "Approximated derivative block"
        parameter Real k = 1 "Gains";
        parameter Real T = 0.01 "Time constants (T>0 required; T=0 is ideal derivative block)";
        extends Interfaces.SISO;
        Real x "State of block";
      equation
        der(x) = if noEvent(abs(k) >= Coselica.Constants.eps) then (u.signal - x) / T else 0;
        y.signal = if noEvent(abs(k) >= Coselica.Constants.eps) then k / T * (u.signal - x) else 0;
      end Derivative;

    end Continuous;

  end Blocks;

end Modelica;



package Coselica

  package Mechanics

    package Translational

      model Stop "Sliding mass with hard stop and Stribeck friction"
        extends MassWithFriction;
        parameter Real smax = 25 "right stop for (right end of) sliding mass";
        parameter Real smin =  -25 "left stop for (left end of) sliding mass";
      equation
        when s > smax - L / 2 then
            reinit(s, smax - L / 2 - Coselica.Constants.eps);
          reinit(v, if v > 0 then 0 else v);
          Sticking = if pre(Forward) > 0.5 and v > 0 or pre(StartFor) > 0.5 and v > 0 then 1 else pre(Sticking);
          Forward = if pre(Forward) > 0.5 and v > 0 then 0 else pre(Forward);
          StartFor = if pre(StartFor) > 0.5 and v > 0 then 0 else pre(StartFor);

        end when;
        when s < smin + L / 2 then
            reinit(s, smin + L / 2 + Coselica.Constants.eps);
          reinit(v, if v < 0 then 0 else v);
          Sticking = if pre(Backward) > 0.5 and v < 0 or pre(StartBack) > 0.5 and v < 0 then 1 else pre(Sticking);
          Backward = if pre(Backward) > 0.5 and v < 0 then 0 else pre(Backward);
          StartBack = if pre(StartBack) > 0.5 and v < 0 then 0 else pre(StartBack);

        end when;
      end Stop;

      model Speed "Forced movement of a flange according to a reference velocity"
        Real s_ref "reference position defined by time integration of input signal";
        Real s "absolute position of flange_b";
        Real v "absolute velocity of flange flange_b";
      public
        Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
        Modelica.Blocks.Interfaces.RealInput v_ref "reference velocity of flange as input signal";
      equation
        der(s_ref) = v_ref.signal;
        s = flange_b.s;
        v = der(s);
        v = v_ref.signal;
      end Speed;

      package Sources

        model Speed "Forced movement of a flange according to a reference speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialOneFlangeAndSupport(s(start = 0, fixed = true));
          Real v "Absolute velocity of flange_b";
          Modelica.Blocks.Interfaces.RealInput v_ref "reference speed of flange as input signal";
        equation
          v = der(s);
          v = v_ref.signal;
        end Speed;

        model Speed0 "Forced movement of a flange according to a reference velocity"
          Real s "absolute position of flange_b";
          Real v "absolute velocity of flange flange_b";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealInput v_ref "reference velocity of flange as input signal";
        equation
          s = flange_b.s;
          v = der(s);
          v = v_ref.signal;
        end Speed0;

        model QuadraticSpeedDependentForce "Quadratic dependency of force versus speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialForce;
          parameter Real f_nominal = 1 "Nominal force (if negative, force is acting as load)";
          parameter Real ForceDirection = 1 "Same direction of force in both directions of movement (1=yes,0=no)";
          parameter Real v_nominal = 1 "Nominal speed (> 0)";
          Real v "Velocity of flange with respect to support (= der(s))";
        equation
          v = der(s);
          if ForceDirection > 0 then
            f =  -f_nominal * (v / v_nominal) ^ 2;
          else
            f =  -f_nominal * (if v >= 0 then (v / v_nominal) ^ 2 else  -(v / v_nominal) ^ 2);
          end if;
        end QuadraticSpeedDependentForce;

        model Position "Forced movement of a flange according to a reference position"
          extends Coselica.Mechanics.Translational.Interfaces.PartialOneFlangeAndSupport;
          Modelica.Blocks.Interfaces.RealInput s_ref "reference position of flange as input signal";
        equation
          s = s_ref.signal;
        end Position;

        model Position0 "Forced movement of a flange according to a reference position"
          Real s "absolute position of flange_b";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealInput s_ref "reference position of flange as input signal";
        equation
          s = flange_b.s;
          s = s_ref.signal;
        end Position0;

        model LinearSpeedDependentForce "Linear dependency of force versus speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialForce;
          parameter Real f_nominal = 1 "Nominal force (if negative, force is acting as load)";
          parameter Real ForceDirection = 1 "Same direction of force in both directions of movement (1=yes,0=no)";
          parameter Real v_nominal = 1 "Nominal speed (> 0)";
          Real v "Velocity of flange with respect to support (= der(s))";
        equation
          v = der(s);
          if ForceDirection > 0 then
            f =  -f_nominal * abs(v / v_nominal);
          else
            f =  -f_nominal * v / v_nominal;
          end if;
        end LinearSpeedDependentForce;

        model ForceStep "Constant force, not dependent on speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialForce;
          parameter Real stepForce(start = 1) = 1 "Height of force step (if negative, force is acting as load)";
          parameter Real offsetForce(start = 0) = 0 "Offset of force";
          parameter Real startTime = 0 "Force = offset for time < startTime";
        equation
          f =  -offsetForce - (if time < startTime then 0 else stepForce);
        end ForceStep;

        model Force "External force acting on a drive train element as input signal"
          extends Interfaces.PartialOneFlangeAndSupport;
          Modelica.Blocks.Interfaces.RealInput f "driving force as input signal";
        equation
          flange.f =  -f.signal;
        end Force;

        model Force2 "Input signal acting as torque on two flanges"
          extends Translational.Interfaces.PartialTwoFlanges;
          Modelica.Blocks.Interfaces.RealInput f "driving force as input signal";
        equation
          flange_a.f = f.signal;
          flange_b.f =  -f.signal;
        end Force2;

        model Force0 "External force acting on a drive train element as input signal"
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealInput f "driving force as input signal";
        equation
          flange_b.f =  -f.signal;
        end Force0;

        model ConstantSpeed "Constant speed, not dependent on force"
          extends Coselica.Mechanics.Translational.Interfaces.PartialForce;
          parameter Real v_fixed = 1 "Fixed speed (if negative, force is acting as load)";
          Real v "Velocity of flange with respect to support (= der(s))";
        equation
          v = der(s);
          v = v_fixed;
        end ConstantSpeed;

        model ConstantForce "Constant force, not dependent on speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialForce;
          parameter Real f_constant = 1 "Nominal force (if negative, force is acting as load)";
        equation
          f =  -f_constant;
        end ConstantForce;

        model Accelerate "Forced movement of a flange according to an acceleration signal"
          extends Coselica.Mechanics.Translational.Interfaces.PartialOneFlangeAndSupport;
          Real v(start = 0, fixed = true) "Absolute velocity of flange_b";
          Real a "Absolute acceleration of flange_b";
          Modelica.Blocks.Interfaces.RealInput a_ref "absolute acceleration of flange as input signal";
        equation
          v = der(s);
          a = der(v);
          a = a_ref.signal;
        end Accelerate;

        model Accelerate0 "Forced movement of a.signal flange according to an acceleration signal"
          Real s "Absolute position of flange_b";
          Real v(start = 0, fixed = true) "Absolute velocity of flange_b";
          Real a "Absolute acceleration of flange_b";
          Modelica.Blocks.Interfaces.RealInput a_ref "Absolute acceleration of flange as input signal";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
        equation
          s = flange_b.s;
          v = der(s);
          a = der(v);
          a = a_ref.signal;
        end Accelerate0;

      end Sources;

      package Sensors

        model SpeedSensor "Ideal sensor to measure the absolute velocity"
          extends Coselica.Mechanics.Translational.Interfaces.PartialAbsoluteSensor;
          Modelica.Blocks.Interfaces.RealOutput v "Absolute velocity of flange as output signal";
        equation
          v.signal = der(flange.s);
        end SpeedSensor;

        model RelSpeedSensor "Ideal sensor to measure the relative speed"
          extends Coselica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
          Real s_rel "distance between the two flanges (flange_b.s - flange_a.s)";
          Modelica.Blocks.Interfaces.RealOutput v_rel "Relative velocity between two flanges  - der(flange_a.s)";
        equation
          s_rel = flange_b.s - flange_a.s;
          v_rel.signal = der(s_rel);
          0 = flange_a.f;
        end RelSpeedSensor;

        model RelPositionSensor "Ideal sensor to measure the relative position"
          extends Coselica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
          Modelica.Blocks.Interfaces.RealOutput s_rel "Distance between two flanges ";
        equation
          s_rel.signal = flange_b.s - flange_a.s;
          0 = flange_a.f;
        end RelPositionSensor;

        model RelAccSensor "Ideal sensor to measure the relative acceleration"
          extends Coselica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
          Real s_rel "distance between the two flanges (flange_b.s - flange_a.s)";
          Real v_rel "relative velocity between the two flanges (der(flange_b.s) - der(flange_a.s))";
          Modelica.Blocks.Interfaces.RealOutput a_rel "Relative acceleration between two flanges ";
        equation
          s_rel = flange_b.s - flange_a.s;
          v_rel = der(s_rel);
          a_rel.signal = der(v_rel);
          0 = flange_a.f;
        end RelAccSensor;

        model PowerSensor "Ideal sensor to measure the power.signal between two flanges (= flange_a.f*der(flange_a.s))"
          extends Coselica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
          Modelica.Blocks.Interfaces.RealOutput power "Power in flange flange_a";
        equation
          flange_a.s = flange_b.s;
          power.signal = flange_a.f * der(flange_a.s);
        end PowerSensor;

        model PositionSensor "Ideal sensor to measure the absolute position"
          extends Coselica.Mechanics.Translational.Interfaces.PartialAbsoluteSensor;
          Modelica.Blocks.Interfaces.RealOutput s "Absolute position of flange";
        equation
          s.signal = flange.s;
        end PositionSensor;

        model ForceSensor "Ideal sensor to measure the force between two flanges"
          extends Coselica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
          Modelica.Blocks.Interfaces.RealOutput f "force in flange_a and flange_b ";
        equation
          flange_a.s = flange_b.s;
          flange_a.f = f.signal;
        end ForceSensor;

        model AccSensor "Ideal sensor to measure the absolute acceleration"
          extends Coselica.Mechanics.Translational.Interfaces.PartialAbsoluteSensor;
          Real v "Absolute velocity of flange";
          Modelica.Blocks.Interfaces.RealOutput a "Absolute acceleration of flange as output signal";
        equation
          v = der(flange.s);
          a.signal = der(v);
        end AccSensor;

      end Sensors;

      model Position "Forced movement of a flange according to a reference position"
        Real s "absolute position of flange_b";
      public
        Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b;
        Modelica.Blocks.Interfaces.RealInput s_ref "reference position of flange as input signal";
      equation
        s = flange_b.s;
        s = s_ref.signal;
      end Position;

      model MassWithFriction "Sliding mass with Stribeck friction"
        extends Interfaces.FrictionBase;
        parameter Real m = 1 "mass of the sliding mass";
        Real v "absolute velocity of component";
        Real a "absolute acceleration of component";
        parameter Real F_prop = 1 "velocity dependent friction";
        parameter Real F_Coulomb = 5 "constant friction: Coulomb force";
        parameter Real F_Stribeck = 10 "Stribeck effect";
        parameter Real fexp = 2 "exponential decay of Stribeck effect";
      equation
        f0 = F_Coulomb + F_Stribeck;
        f0_max = f0;
        v = der(s);
        a = der(v);
        v_relfric = v;
        a_relfric = a;
        m * a = flange_a.f + flange_b.f - f;
        f = if Forward > 0.5 then F_prop * v_relfric + F_Coulomb + F_Stribeck * exp( -fexp * v_relfric) else if Backward > 0.5 then F_prop * v_relfric - F_Coulomb - F_Stribeck * exp(fexp * v_relfric) else if StartFor > 0.5 then F_prop * v_relfric + F_Coulomb + F_Stribeck * exp( -fexp * v_relfric) else if StartBack > 0.5 then F_prop * v_relfric - F_Coulomb - F_Stribeck * exp(fexp * v_relfric) else sa;
      end MassWithFriction;

      package Interfaces

        connector Support "Support/housing 1D translational flange"
          Real s "absolute position of flange";
          flow Real f "cut force directed into flange";
        end Support;

        partial model PartialTwoFlanges "Component with two translational 1D flanges "
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "(left) driving flange (flange axis directed in to cut plane, e. g. from left to right)";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b "(right) driven flange (flange axis directed out of cut plane)";
        end PartialTwoFlanges;

        partial model PartialRelativeSensor "Device to measure a single relative variable between two flanges"
          extends Modelica.Icons.TranslationalSensor;
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "(left) driving flange (flange axis directed in to cut plane, e. g. from left to right)";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b "(right) driven flange (flange axis directed out of cut plane)";
        equation
          0 = flange_a.f + flange_b.f;
        end PartialRelativeSensor;

        partial model PartialPulley "Partial model of a simple Pulley without mass and inertia (geometric constraint)"
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "Translational flange at center of pulley";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b1 "First translational driving flange of pulley";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b2 "Second translational driving flange of pulley";
          Real s "Position of pulley flange";
          Real s1 "Position of first driving flange";
          Real s2 "Position of second driving flange";
          parameter Real L = 0 "Geometric constraint L=(s1+s2)/2-s";
          Real force "Driving force(=tau/r) due to actuation of pulley";
        equation
          s = flange_a.s;
          s1 = flange_b1.s;
          s2 = flange_b2.s;
          L = (s1 + s2) / 2 - s;
          flange_b1.f = flange_b2.f + force;
          0 = flange_a.f + flange_b1.f + flange_b2.f;
        end PartialPulley;

        partial model PartialOneFlangeAndSupport "Partial model for a component with one translational 1-dim. shaft flange and a support used for textual modeling, i.e., for elementary models"
          Real s = flange.s - support.s "distance between flange and support (= flange.s - support.s)";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange "Flange of component";
          Support support "Support/housing of component";
        equation
          support.f =  -flange.f;
        end PartialOneFlangeAndSupport;

        partial model PartialMass "partial model sliding mass with inertia"
          extends Modelica.Mechanics.Translational.Interfaces.Rigid(s(start = s_start, fixed = if initType[1] > 0 then true else false));
          parameter Real m = 1 "Mass of the sliding mass";
          Real v(start = v_start, fixed = if initType[2] > 0 then true else false) "Absolute velocity of component";
          Real a "Absolute acceleration of component";
          Real force "External force accelerating sliding mass";
          parameter Real initType[2] = {0,0} "Type of initial value for [s,v] (0=guess,1=fixed)";
          parameter Real s_start = 0 "Initial value for absolute position of center of mass";
          parameter Real v_start = 0 "Initial value for absolute velocity of mass";
        equation
          v = der(s);
          a = der(v);
          m * a = flange_a.f + flange_b.f + force;
        end PartialMass;

        partial model PartialForce "Partial model of a force acting at the flange (accelerates the flange)"
          extends PartialOneFlangeAndSupport;
          Real f "Accelerating force acting at flange (= flange.f)";
        equation
          flange.f = f;
        end PartialForce;

        partial model PartialCompliantWithRelativeStates "Base model for the compliant connection of two translational 1-dim. shaft flanges where the relative position and relative velocities are used as states"
          Real s_rel(start = 0) "Relative distance (= flange_b.s - flange_a.s)";
          Real v_rel(start = 0) "Relative velocity (= der(s_rel))";
          Real f "Forces between flanges (= flange_b.f)";
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. translational component";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. transational component";
        equation
          s_rel = flange_b.s - flange_a.s;
          v_rel = der(s_rel);
          flange_b.f = f;
          flange_a.f =  -f;
        end PartialCompliantWithRelativeStates;

        partial model PartialAbsoluteSensor "Device to measure a single absolute flange variable"
          extends Modelica.Icons.TranslationalSensor;
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange "flange to be measured (flange axis directed in to cut plane, e. g. from left to right)";
        equation
          0 = flange.f;
        end PartialAbsoluteSensor;

        partial model FrictionBase "Base class of Coulomb friction elements"
          extends Modelica.Mechanics.Translational.Interfaces.Rigid;
          parameter Real mode_start = 0 "Initial sliding mode (-1=Backward,0=Sticking,1=Forward)";
          Real v_relfric "Relative angular velocity between frictional surfaces";
          Real a_relfric "Relative angular acceleration between frictional surfaces";
          Real f "Friction force (positive, if directed in opposite direction of v)";
          Real f0 "Friction force for v_rel=0 and start of forward sliding";
          Real f0_max "Maximum friction force for v_rel=0 and sticking";
          Real sa "Path parameter of friction characteristic f = f(a_relfric)";
          discrete Real Sticking(start = if abs(mode_start) < 1 then 1 else 0) "1, if w_rel = 0 and not sliding";
          discrete Real Forward(start = if mode_start >= 1 then 1 else 0) "1, if w_relfric > 0 (forward sliding)";
          discrete Real Backward(start = if mode_start <=  -1 then 1 else 0) "1, if w_rel < 0 (backward sliding)";
          discrete Real StartFor(start = 0, fixed = true) "1, if w_rel = 0 and start of forward sliding";
          discrete Real StartBack(start = 0, fixed = true) "1, if w_rel = 0 and start of backward sliding";
        equation
          when sa > f0_max then
              StartFor = if pre(Sticking) > 0.5 then 1 else pre(StartFor);
            Sticking = 0;

          end when;
          when sa <  -f0_max then
              StartBack = if pre(Sticking) > 0.5 then 1 else pre(StartBack);
            Sticking = 0;

          end when;
          when v_relfric > 0 then
              Forward = if pre(StartFor) > 0.5 then 1 else pre(Forward);
            StartFor = 0;

          end when;
          when v_relfric >= 0 then
              Sticking = if pre(Backward) > 0.5 or pre(StartBack) > 0.5 and a_relfric >= 0 then 1 else pre(Backward);
            Backward = 0;
            StartBack = if pre(StartBack) > 0.5 and a_relfric >= 0 then 0 else pre(StartBack);

          end when;
          when v_relfric < 0 then
              Backward = if pre(StartBack) > 0.5 then 1 else pre(Backward);
            StartBack = 0;

          end when;
          when v_relfric <= 0 then
              Sticking = if pre(Forward) > 0.5 or pre(StartFor) > 0.5 and a_relfric <= 0 then 1 else pre(Forward);
            Forward = 0;
            StartFor = if pre(StartFor) > 0.5 and a_relfric <= 0 then 0 else pre(StartFor);

          end when;
          when a_relfric <= 0 then
              Sticking = if pre(StartFor) > 0.5 and v_relfric <= 0 then 1 else pre(Sticking);
            StartFor = if pre(StartFor) > 0.5 and v_relfric <= 0 then 0 else pre(StartFor);

          end when;
          when a_relfric >= 0 then
              Sticking = if pre(StartBack) > 0.5 and v_relfric >= 0 then 1 else pre(Sticking);
            StartBack = if pre(StartBack) > 0.5 and v_relfric >= 0 then 0 else pre(StartBack);

          end when;
          a_relfric = if Forward > 0.5 then sa - f0 else if Backward > 0.5 then sa + f0 else if StartFor > 0.5 then sa - f0 else if StartBack > 0.5 then sa + f0 else 0;
        end FrictionBase;

      end Interfaces;

      package Components

        model Pulley "Simple Pulley (without mass and inertia; geometric constraint)"
          extends Coselica.Mechanics.Translational.Interfaces.PartialPulley;
        equation
          force = 0;
        end Pulley;

        model MassWithWeight "Sliding mass with inertia and gravitational force (=m*g)"
          extends Coselica.Mechanics.Translational.Interfaces.PartialMass;
        equation
          force = m * Coselica.Constants.g_n;
        end MassWithWeight;

        model Mass "Sliding mass with inertia"
          extends Coselica.Mechanics.Translational.Interfaces.PartialMass;
        equation
          force = 0;
        end Mass;

        model Lever "Lever assuming small angle deviation (without mass and inertia; geometric constraint)"
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "Flange in the middle of lever";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b1 "Flange at end of arm 1";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b2 "Flange at end of arm 2";
          parameter Real L1 = 1 "Length of arm 1 (>0)";
          parameter Real L2 = 1 "Length of arm 2 (>0)";
          Real s "Position of flange in the middle of lever";
          Real s1 "Position of flange at end of arm 1";
          Real s2 "Position of flange at end of arm 2";
          parameter Real L = 0 "Geometric constraint L=(L2*s1+L1*s2)/(L1+L2)-s";
        equation
          s = flange_a.s;
          s1 = flange_b1.s;
          s2 = flange_b2.s;
          L = (L2 * s1 + L1 * s2) / (L1 + L2) - s;
          0 = flange_a.f * L2 + flange_b1.f * (L1 + L2);
          0 = flange_a.f * L1 + flange_b2.f * (L1 + L2);
        end Lever;

        model Free "Flange moving freely (flange_a.f = 0)"
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "(left) driving flange (flange axis directed in to cut plane, e. g. from left to right)";
        equation
          flange_a.f = 0;
        end Free;

        model ElastoGap "1D translational spring damper combination with gap"
          extends Coselica.Mechanics.Translational.Interfaces.PartialCompliantWithRelativeStates;
          parameter Real c = 1 "Spring constant (c >= 0)";
          parameter Real d = 1 "Damping constant (d >= 0)";
          parameter Real s_rel0 = 0 "Unstretched spring length";
        protected
          Real f_c "Spring force";
          Real f_d2 "Unmodified damping force";
          Real f_d "Linear damping force which is limited by spring force (|f_d| <= |f_c|)";
        equation
          if s_rel > s_rel0 then
            f_c = 0;
            f_d2 = 0;
            f_d = 0;
          else
            f_c = c * (s_rel - s_rel0);
            f_d2 = d * v_rel;
            f_d = if f_d2 < f_c then f_c else if f_d2 >  -f_c then  -f_c else f_d2;
          end if;
          f = f_c + f_d;
        end ElastoGap;

        model ActuatedPulley "Actuated Pulley (without mass and inertia; geometric constraint)"
          extends Coselica.Mechanics.Translational.Interfaces.PartialPulley;
          Modelica.Mechanics.Rotational.Interfaces.Flange_a axle "Flange of pulley axle";
          parameter Real r = 1 "Radius of pulley (>0)";
        equation
          axle.tau = force * r;
          s2 - s = axle.phi * r;
        end ActuatedPulley;

      end Components;

    end Translational;

    package Rotational

      model Speed "Forced movement of a flange according to a reference angular velocity signal"
        Real phi_ref "reference angle defined by time integration of input signal";
        Real phi "absolute rotation angle of flange flange_b";
        Real w "absolute angular velocity of flange flange_b";
        Real tau_support "Support torque";
      public
        Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
        Modelica.Blocks.Interfaces.RealInput w_ref "Reference angular velocity of flange_b as input signal";
        Modelica.Mechanics.Rotational.Interfaces.Flange_a bearing;
      equation
        0 = flange_b.tau + tau_support;
        bearing.tau = tau_support;
        der(phi_ref) = w_ref.signal;
        phi = flange_b.phi;
        w = der(phi);
        w = w_ref.signal;
      end Speed;

      package Sources

        model TorqueStep "Constant torque, not dependent on speed"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTorque;
          parameter Real stepTorque(start = 1) = 1 "Height of torque step (if negative, torque is acting as load)";
          parameter Real offsetTorque(start = 0) = 0 "Offset of torque";
          parameter Real startTime = 0 "Torque = offset for time < startTime";
          Real tau "Accelerating torque acting at flange (= -flange.tau)";
        equation
          tau =  -flange.tau;
          tau = offsetTorque + (if time < startTime then 0 else stepTorque);
        end TorqueStep;

        model Torque "Input signal acting as external torque on a flange"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport;
          Modelica.Blocks.Interfaces.RealInput tau "Accelerating torque acting at flange ";
        equation
          flange.tau =  -tau.signal;
        end Torque;

        model Torque2 "Input signal acting as torque on two flanges"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
          Modelica.Blocks.Interfaces.RealInput tau "Torque driving the two flanges ";
        equation
          flange_a.tau = tau.signal;
          flange_b.tau =  -tau.signal;
        end Torque2;

        model Torque0 "Input signal acting as external torque on a flange"
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealInput tau "Accelerating torque acting at flange ";
        equation
          flange_b.tau =  -tau.signal;
        end Torque0;

        model Speed "Forced movement of a flange according to a reference angular velocity signal"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport;
          Real w "Angular velocity of flange with respect to support";
          Modelica.Blocks.Interfaces.RealInput w_ref "Reference angular velocity of flange with respect to support as input signal";
        equation
          w = der(phi);
          w = w_ref.signal;
        end Speed;

        model Speed0 "Forced movement of a flange according to a reference angular velocity signal"
          Real phi "absolute position of flange_b";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
          Real w "Angular velocity of flange with respect to support";
          Modelica.Blocks.Interfaces.RealInput w_ref "Reference angular velocity of flange with respect to support as input signal";
        equation
          phi = flange_b.phi;
          w = der(phi);
          w = w_ref.signal;
        end Speed0;

        model QuadraticSpeedDependentTorque "Quadratic dependency of torque versus speed"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTorque;
          parameter Real tau_nominal "Nominal torque (if negative, torque is acting as load)";
          parameter Boolean TorqueDirection = 1 "Same direction of torque in both directions of rotation (1=yes,0=no)";
          parameter Real w_nominal = 1 "Nominal speed (> 0)";
          Real w "Angular velocity of flange with respect to support (= der(phi))";
          Real tau "Accelerating torque acting at flange (= -flange.tau)";
        equation
          w = der(phi);
          tau =  -flange.tau;
          if TorqueDirection > 0 then
            tau = tau_nominal * (w / w_nominal) ^ 2;
          else
            tau = tau_nominal * (if w >= 0 then (w / w_nominal) ^ 2 else  -(w / w_nominal) ^ 2);
          end if;
        end QuadraticSpeedDependentTorque;

        model Position "Forced movement of a flange according to a reference angle signal"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport;
          Modelica.Blocks.Interfaces.RealInput phi_ref "Reference angle of flange with respect to support as input signal";
        equation
          phi = phi_ref.signal;
        end Position;

        model Position0 "Forced movement of a flange according to a reference angle signal"
          Real phi "absolute position of flange_b";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealInput phi_ref "Reference angle of flange with respect to support as input signal";
        equation
          phi = flange_b.phi;
          phi = phi_ref.signal;
        end Position0;

        model LinearSpeedDependentTorque "Linear dependency of torque versus speed"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTorque;
          parameter Real tau_nominal "Nominal torque (if negative, torque is acting as load)";
          parameter Real TorqueDirection = 1 "Same direction of torque in both directions of rotation (1=yes,0=no)";
          parameter Real w_nominal = 1 "Nominal speed (> 0)";
          Real w "Angular velocity of flange with respect to support (= der(phi))";
          Real tau "Accelerating torque acting at flange (= -flange.tau)";
        equation
          w = der(phi);
          tau =  -flange.tau;
          if TorqueDirection > 0 then
            tau = tau_nominal * abs(w / w_nominal);
          else
            tau = tau_nominal * w / w_nominal;
          end if;
        end LinearSpeedDependentTorque;

        model ConstantTorque "Constant torque, not dependent on speed"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTorque;
          parameter Real tau_constant "Constant torque (if negative, torque is acting as load)";
          Real tau "Accelerating torque acting at flange (= -flange.tau)";
        equation
          tau =  -flange.tau;
          tau = tau_constant;
        end ConstantTorque;

        model ConstantSpeed "Constant speed, not dependent on torque"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialTorque;
          Real w "Angular velocity of flange with respect to support (= der(phi))";
          parameter Real w_fixed "Fixed speed";
        equation
          w = der(phi);
          w = w_fixed;
        end ConstantSpeed;

        model Accelerate "Forced movement of a flange according to an acceleration signal"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport;
          Real w(start = 0, fixed = true) "Angular velocity of flange with respect to support";
          Real a "Angular acceleration of flange with respect to support";
          Modelica.Blocks.Interfaces.RealInput a_ref "Absolute angular acceleration of flange with respect to support as input signal";
        equation
          w = der(phi);
          a = der(w);
          a = a_ref.signal;
        end Accelerate;

        model Accelerate0 "Forced movement of a flange according to an acceleration signal"
          Real phi "absolute position of flange_b";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
          Real w(start = 0, fixed = true) "Angular velocity of flange with respect to support";
          Real a "Angular acceleration of flange with respect to support";
          Modelica.Blocks.Interfaces.RealInput a_ref "Absolute angular acceleration of flange with respect to support as input signal";
        equation
          phi = flange_b.phi;
          w = der(phi);
          a = der(w);
          a = a_ref.signal;
        end Accelerate0;

      end Sources;

      package Sensors

        model PowerSensor "Ideal sensor to measure the power.signal between two flanges (= flange_a.tau*der(flange_a.phi))"
          extends Modelica.Icons.RotationalSensor;
          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a;
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
          Modelica.Blocks.Interfaces.RealOutput power "Power in flange flange_a";
        equation
          flange_a.phi = flange_b.phi;
          0 = flange_a.tau + flange_b.tau;
          power.signal = flange_a.tau * der(flange_a.phi);
        end PowerSensor;

      end Sensors;

      model Position "Forced movement of a flange according to a reference angle signal"
        Modelica.Blocks.Interfaces.RealInput phi_ref "reference angle of flange_b as input signal";
        Real phi "absolute rotation angle of flange flange_b";
        Real tau_support "Support torque";
      public
        Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
        Modelica.Mechanics.Rotational.Interfaces.Flange_a bearing;
      equation
        0 = flange_b.tau + tau_support;
        bearing.tau = tau_support;
        phi = flange_b.phi;
        phi = phi_ref.signal;
      end Position;

      model OneWayClutch "Series connection of freewheel and clutch"
        extends Modelica.Mechanics.Rotational.Interfaces.Compliant;
        parameter Real mue_pos = 0.5 "positive sliding friction coefficient (w_rel>=0)";
        parameter Real peak = 1 "peak >= 1, peak*mue_pos = maximum value of mue for w_rel==0";
        parameter Real cgeo = 1 "cgeo >= 0, Geometry constant containing friction distribution assumption";
        parameter Real fn_max = 1 "fn_max >= 0, Maximum normal force";
        Real w_rel "Relative angular velocity (flange_b.w - flange_a.w)";
        Real a_rel "Relative angular acceleration (flange_b.a - flange_a.a)";
        Real fn "Normal force (fn=fn_max*inPort.signal)";
        discrete Real Sticking(start = if w_rel <= 0 then 1 else 0);
      protected
        Real tau0 "Friction torque for w=0 and sliding";
        Real tau0_max "Maximum friction torque for w=0 and locked";
        Real mue0 "Friction coefficient for w=0 and sliding";
        Real sa "path parameter of tau = f(a_rel) Friction characteristic";
        constant Real eps0 = 0.0001 "Relative hysteresis epsilon";
        Real tau0_max_low "lowest value for tau0_max";
        parameter Real peak2 = if peak >= 1 + eps0 then peak else 1 + eps0;
      public
        Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 ";
      equation
        mue0 = mue_pos;
        tau0_max_low = eps0 * mue0 * cgeo * fn_max;
        w_rel = der(phi_rel);
        a_rel = der(w_rel);
        fn = if f_normalized.signal <= 0 then 0 else fn_max * f_normalized.signal;
        tau0 = mue0 * cgeo * fn;
        tau0_max = if f_normalized.signal <= 0 then tau0_max_low else peak2 * tau0;
        when sa > tau0_max then
            Sticking = 0;
          reinit(tau, tau0);

        end when;
        when w_rel <= 0 then
            Sticking = if a_rel <= 0 then 1 else 0;

        end when;
        a_rel = if Sticking > 0.5 then 0 else sa - tau0;
        tau = if Sticking > 0.5 then sa else tau0;
      end OneWayClutch;

      package Interfaces

        connector Support "Support/housing of a 1-dim. rotational shaft"
          Real phi "Absolute rotation angle of the support/housing";
          flow Real tau "Reaction torque in the support/housing";
        end Support;

        partial model PartialTwoFlanges "Partial model for a component with two rotational 1-dim. shaft flanges"
          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Flange of right shaft";
        end PartialTwoFlanges;

        partial model PartialTorque "Partial model of a torque acting at the flange (accelerates the flange)"
          extends Coselica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport;
        end PartialTorque;

        partial model PartialOneFlangeAndSupport "Partial model for a component with one rotational 1-dim. shaft flange and a support used for textual modeling, i.e., for elementary models"
          Real phi = flange.phi - support.phi "distance between flange and support (= flange.phi - support.phi)";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Flange of shaft";
          Support support "Support/housing of component";
        equation
          support.tau =  -flange.tau;
        end PartialOneFlangeAndSupport;

        partial model PartialCompliantWithRelativeStates "Partial model for the compliant connection of two rotational 1-dim. shaft flanges where the relative angle and speed are used as preferred states"
          Real phi_rel(start = 0) "Relative rotation angle (= flange_b.phi - flange_a.phi)";
          Real w_rel(start = 0) "Relative angular velocity (= der(phi_rel))";
          Real a_rel(start = 0) "Relative angular acceleration (= der(w_rel))";
          Real tau "Torque between flanges (= flange_b.tau)";
          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. rotational component";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. rotational component";
        equation
          phi_rel = flange_b.phi - flange_a.phi;
          w_rel = der(phi_rel);
          a_rel = der(w_rel);
          flange_b.tau = tau;
          flange_a.tau =  -tau;
        end PartialCompliantWithRelativeStates;

        partial model FrictionBaseCompliant "Base class of Coulomb friction elements"
          extends Modelica.Mechanics.Rotational.Interfaces.Compliant;
          parameter Real mode_start = 0 "Initial sliding mode (-1=Backward,0=Sticking,1=Forward,2=Free)";
          Real w_relfric "Relative angular velocity between frictional surfaces";
          Real a_relfric "Relative angular acceleration between frictional surfaces";
          Real tau0 "Friction torque for w_rel=0 and start of forward sliding";
          Real tau0_max "Maximum friction torque for w_rel=0 and sticking";
          Real free "1, if frictional element is not active";
          Real sa "Path parameter of friction characteristic tau = f(a_relfric)";
          discrete Real Sticking(start = if abs(mode_start) < 1 then 1 else 0) "1, if w_rel = 0 and not sliding";
          discrete Real Forward(start = if mode_start >= 1 and mode_start < 2 then 1 else 0) "1, if w_relfric > 0 (forward sliding)";
          discrete Real Backward(start = if mode_start <=  -1 then 1 else 0) "1, if w_rel < 0 (backward sliding)";
          discrete Real StartFor(start = 0, fixed = true) "1, if w_rel = 0 and start of forward sliding";
          discrete Real StartBack(start = 0, fixed = true) "1, if w_rel = 0 and start of backward sliding";
          discrete Real Free(start = if mode_start >= 2 then 1 else 0) "1, Element is not active";
        equation
          when free > 0.5 then
              Free = 1;
            Sticking = 0;
            Forward = 0;
            Backward = 0;
            StartFor = 0;
            StartBack = 0;
          elsewhen free <= 0.5 then
            Sticking = if w_relfric >= 0 and w_relfric <= 0 then 1 else 0;
            Forward = if w_relfric > 0 then 1 else 0;
            Backward = if w_relfric < 0 then 1 else 0;
            Free = 0;
        elsewhen sa > tau0_max then
            StartFor = if pre(Sticking) > 0.5 then 1 else pre(StartFor);
            Sticking = 0;
        elsewhen sa <  -tau0_max then
            StartBack = if pre(Sticking) > 0.5 then 1 else pre(StartBack);
            Sticking = 0;
        elsewhen w_relfric > 0 then
            Forward = if pre(StartFor) > 0.5 then 1 else pre(Forward);
            StartFor = 0;
        elsewhen w_relfric >= 0 then
            Sticking = if pre(Backward) > 0.5 or pre(StartBack) > 0.5 and a_relfric >= 0 then 1 else pre(Sticking);
            Backward = 0;
            StartBack = if pre(StartBack) > 0.5 and a_relfric >= 0 then 0 else pre(StartBack);
        elsewhen w_relfric < 0 then
            Backward = if pre(StartBack) > 0.5 then 1 else pre(Backward);
            StartBack = 0;
        elsewhen w_relfric <= 0 then
            Sticking = if pre(Forward) > 0.5 or pre(StartFor) > 0.5 and a_relfric <= 0 then 1 else pre(Sticking);
            Forward = 0;
            StartFor = if pre(StartFor) > 0.5 and a_relfric <= 0 then 0 else pre(StartFor);
          end when;
          a_relfric = if Free > 0.5 then sa else if Forward > 0.5 then sa - tau0 else if Backward > 0.5 then sa + tau0 else if StartFor > 0.5 then sa - tau0 else if StartBack > 0.5 then sa + tau0 else 0;
        end FrictionBaseCompliant;

        partial model FrictionBaseBearing "Base class of Coulomb friction elements"
          extends Modelica.Mechanics.Rotational.Interfaces.TwoFlangesAndBearing;
          parameter Real mode_start = 0 "Initial sliding mode (-1=Backward,0=Sticking,1=Forward,2=Free)";
          Real w_relfric "Relative angular velocity between frictional surfaces";
          Real a_relfric "Relative angular acceleration between frictional surfaces";
          Real tau "Friction torque (positive, if directed in opposite direction of w_rel)";
          Real tau0 "Friction torque for w_rel=0 and start of forward sliding";
          Real tau0_max "Maximum friction torque for w_rel=0 and sticking";
          Real free "1, if frictional element is not active";
          Real sa "Path parameter of friction characteristic tau = f(a_relfric)";
          discrete Real Sticking(start = if abs(mode_start) < 1 then 1 else 0) "1, if w_rel = 0 and not sliding";
          discrete Real Forward(start = if mode_start >= 1 and mode_start < 2 then 1 else 0) "1, if w_relfric > 0 (forward sliding)";
          discrete Real Backward(start = if mode_start <=  -1 then 1 else 0) "1, if w_rel < 0 (backward sliding)";
          discrete Real StartFor(start = 0, fixed = true) "1, if w_rel = 0 and start of forward sliding";
          discrete Real StartBack(start = 0, fixed = true) "1, if w_rel = 0 and start of backward sliding";
          discrete Real Free(start = if mode_start >= 2 then 1 else 0) "1, Element is not active";
        equation
          when free > 0.5 then
              Free = 1;
            Sticking = 0;
            Forward = 0;
            Backward = 0;
            StartFor = 0;
            StartBack = 0;
          elsewhen free <= 0.5 then
            Sticking = if w_relfric >= 0 and w_relfric <= 0 then 1 else 0;
            Forward = if w_relfric > 0 then 1 else 0;
            Backward = if w_relfric < 0 then 1 else 0;
            Free = 0;
        elsewhen sa > tau0_max then
            StartFor = if pre(Sticking) > 0.5 then 1 else pre(StartFor);
            Sticking = 0;
        elsewhen sa <  -tau0_max then
            StartBack = if pre(Sticking) > 0.5 then 1 else pre(StartBack);
            Sticking = 0;
        elsewhen w_relfric > 0 then
            Forward = if pre(StartFor) > 0.5 then 1 else pre(Forward);
            StartFor = 0;
        elsewhen w_relfric >= 0 then
            Sticking = if pre(Backward) > 0.5 or pre(StartBack) > 0.5 and a_relfric >= 0 then 1 else pre(Sticking);
            Backward = 0;
            StartBack = if pre(StartBack) > 0.5 and a_relfric >= 0 then 0 else pre(StartBack);
        elsewhen w_relfric < 0 then
            Backward = if pre(StartBack) > 0.5 then 1 else pre(Backward);
            StartBack = 0;
        elsewhen w_relfric <= 0 then
            Sticking = if pre(Forward) > 0.5 or pre(StartFor) > 0.5 and a_relfric <= 0 then 1 else pre(Sticking);
            Forward = 0;
            StartFor = if pre(StartFor) > 0.5 and a_relfric <= 0 then 0 else pre(StartFor);
          end when;
          a_relfric = if Free > 0.5 then sa else if Forward > 0.5 then sa - tau0 else if Backward > 0.5 then sa + tau0 else if StartFor > 0.5 then sa - tau0 else if StartBack > 0.5 then sa + tau0 else 0;
        end FrictionBaseBearing;

      end Interfaces;

      model Freewheel "Ideal freewheel (flange_b.tau >= 0)"
        extends Modelica.Mechanics.Rotational.Interfaces.Compliant;
        Real w_rel "Relative angular velocity (flange_b.w - flange_a.w)";
        Real a_rel "Relative angular acceleration (flange_b.a - flange_a.a)";
        Real sa "path parameter of tau = f(a_rel) Freewheel characteristic";
        discrete Real Sticking(start = if w_rel > 0 then 0 else 1, fixed = true) "1, if w_rel = 0 and not sliding";
      equation
        w_rel = der(phi_rel);
        a_rel = der(w_rel);
        when sa > 0 then
            Sticking = 0;
          reinit(tau, 0);

        end when;
        when w_rel <= 0 then
            Sticking = if a_rel <= 0 then 1 else 0;

        end when;
        a_rel = if Sticking > 0.5 then 0 else sa;
        tau = if Sticking > 0.5 then sa else 0;
      end Freewheel;

      package Components

        model IdealDifferential "Ideal differential gear without inertia"
          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of driving shaft";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_left "Flange of left shaft";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_right "Flange of right shaft";
          parameter Real ratio = 1 "Transmission ratio (2*flange_a.phi/(flange_left.phi+flange_right.phi))";
        equation
          2 * flange_a.phi = ratio * (flange_left.phi + flange_right.phi);
          flange_a.tau * ratio =  -flange_left.tau;
          flange_left.tau = flange_right.tau;
        end IdealDifferential;

        model Free "Flange rotating freely (flange_a.tau = 0)"
          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Flange of left shaft";
        equation
          flange_a.tau = 0;
        end Free;

        model ElastoBacklash "Backlash connected in series to linear spring and damper (backlash is modeled with elasticity)"
          parameter Real c = 100000.0 "Spring constant (c > 0 required)";
          parameter Real d = 0 "Damping constant (d >= 0)";
          parameter Real b = 0 "Total backlash (b >= 0)";
          parameter Real phi_rel0 = 0 "Unstretched spring angle";
          extends Coselica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates;
        protected
          final parameter Real bMax = b / 2 "Backlash in range bMin <= phi_rel - phi_rel0 <= bMax";
          final parameter Real bMin =  -bMax "Backlash in range bMin <= phi_rel - phi_rel0 <= bMax";
          Real tau_c(start = if abs(b) <= bEps then c * phi_diff else if phi_diff > bMax then c * (phi_diff - bMax) else if phi_diff < bMin then c * (phi_diff - bMin) else 0, fixed = true);
          Real tau_d;
          Real phi_diff = phi_rel - phi_rel0;
          constant Real bEps = 1e-10 "minimum backlash";
        equation
          tau_c = if abs(b) <= bEps then c * phi_diff else if phi_diff > bMax then c * (phi_diff - bMax) else if phi_diff < bMin then c * (phi_diff - bMin) else 0;
          tau_d = d * w_rel;
          tau = if abs(b) <= bEps then tau_c + tau_d else if phi_diff > bMax then noEvent(if tau_c + tau_d <= 0 then 0 else tau_c + min(tau_c, tau_d)) else if phi_diff < bMin then noEvent(if tau_c + tau_d >= 0 then 0 else tau_c + max(tau_c, tau_d)) else 0;
        end ElastoBacklash;

        model Disc "1-dim. rotational rigid component without inertia, where right flange is rotated by a fixed angle with respect to left flange"
          extends Modelica.Mechanics.Rotational.Interfaces.TwoFlanges;
          parameter Real deltaPhi = 0 "Fixed rotation of left flange with respect to right flange (= flange_b.phi - flange_a.phi)";
          Real phi "Absolute rotation angle of component";
        equation
          flange_a.phi = phi - deltaPhi / 2;
          flange_b.phi = phi + deltaPhi / 2;
          0 = flange_a.tau + flange_b.tau;
        end Disc;

      end Components;

      model Clutch "Clutch based on Coulomb friction "
        extends Interfaces.FrictionBaseCompliant;
        parameter Real mue_pos = 0.5 "mue > 0, positive sliding friction coefficient (w_rel>=0)";
        parameter Real peak = 1 "peak >= 1, peak*mue_pos = maximum value of mue for w_rel==0";
        parameter Real cgeo = 1 "cgeo >= 0, Geometry constant containing friction distribution assumption";
        parameter Real fn_max = 1 "fn_max >= 0, Maximum normal force";
        Real w_rel "Relative angular velocity (flange_b.w - flange_a.w)";
        Real a_rel "Relative angular acceleration (flange_b.a - flange_a.a)";
        Real mue0 "Friction coefficient for w=0 and forward sliding";
        Real fn "Normal force (fn=fn_max*inPort.signal)";
        Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 ";
      equation
        mue0 = mue_pos;
        w_rel = der(phi_rel);
        a_rel = der(w_rel);
        w_relfric = w_rel;
        a_relfric = a_rel;
        fn = fn_max * f_normalized.signal;
        free = if fn <= 0 then 1 else 0;
        tau0 = mue0 * cgeo * fn;
        tau0_max = peak * tau0;
        tau = if Free > 0.5 then 0 else if Forward > 0.5 then tau0 else if Backward > 0.5 then  -tau0 else if StartFor > 0.5 then tau0 else if StartBack > 0.5 then  -tau0 else sa;
      end Clutch;

      model Brake "Brake based on Coulomb friction "
        extends Interfaces.FrictionBaseBearing;
        parameter Real mue_pos = 0.5 "mue > 0, positive sliding friction coefficient (w_rel>=0)";
        parameter Real peak = 1 "peak >= 1, peak*mue_pos = maximum value of mue for w_rel==0";
        parameter Real cgeo = 1 "cgeo >= 0, Geometry constant containing friction distribution assumption";
        parameter Real fn_max = 1 "fn_max >= 0, Maximum normal force";
        Real phi;
        Real w "Absolute angular velocity of flange_a and flange_b";
        Real a "Absolute angular acceleration of flange_a and flange_b";
        Real mue0 "Friction coefficient for w=0 and forward sliding";
        Real fn "Normal force (=fn_max*inPort.signal)";
        Modelica.Blocks.Interfaces.RealInput f_normalized "Normalized force signal 0..1 ";
      equation
        mue0 = mue_pos;
        phi = phi_a;
        phi = phi_b;
        w = der(phi);
        a = der(w);
        w_relfric = w;
        a_relfric = a;
        0 = flange_a.tau + flange_b.tau - tau;
        fn = fn_max * f_normalized.signal;
        tau0 = mue0 * cgeo * fn;
        tau0_max = peak * tau0;
        free = if fn <= 0 then 1 else 0;
        tau = if Free > 0.5 then 0 else if Forward > 0.5 then tau0 else if Backward > 0.5 then  -tau0 else if StartFor > 0.5 then tau0 else if StartBack > 0.5 then  -tau0 else sa;
      end Brake;

      model BearingFriction "Coulomb friction with Stribeck effect in bearings"
        extends Interfaces.FrictionBaseBearing;
        Real phi "Absolute angular position of flange_a and flange_b";
        Real w "Absolute angular velocity of flange_a and flange_b";
        Real a "Absolute angular acceleration of flange_a and flange_b";
        parameter Real Tau_prop = 1 "Angular velocity dependent friction";
        parameter Real Tau_Coulomb = 5 "Constant fricton: Coulomb torque";
        parameter Real Tau_Stribeck = 10 "Stribeck effect";
        parameter Real fexp = 2 "Exponential decay of Stribeck effect";
      equation
        free = 0;
        tau0 = Tau_Coulomb + Tau_Stribeck;
        tau0_max = tau0;
        phi = phi_a;
        phi = phi_b;
        w = der(phi);
        a = der(w);
        w_relfric = w;
        a_relfric = a;
        0 = flange_a.tau + flange_b.tau - tau;
        tau = if Free > 0.5 then 0 else if Forward > 0.5 then Tau_prop * w_relfric + Tau_Coulomb + Tau_Stribeck * exp( -fexp * w_relfric) else if Backward > 0.5 then Tau_prop * w_relfric - Tau_Coulomb - Tau_Stribeck * exp(fexp * w_relfric) else if StartFor > 0.5 then Tau_prop * w_relfric + Tau_Coulomb + Tau_Stribeck * exp( -fexp * w_relfric) else if StartBack > 0.5 then Tau_prop * w_relfric - Tau_Coulomb - Tau_Stribeck * exp(fexp * w_relfric) else sa;
      end BearingFriction;

    end Rotational;

    package Planar

      model World "World coordinate system with uniform gravity field"
        Interfaces.Frame_b frame_b "Coordinate system fixed in the origin of the world frame";
        parameter Real g = 9.81 "Constant gravity acceleration";
        parameter Real n[2] = {0, -1} "Direction of gravity resolved in world frame (gravity = g*n/length(n))";
      equation
        frame_b.r_0 = {0,0};
        frame_b.v_0 = {0,0};
        frame_b.a_0 =  -(g * n) / sqrt(n * n);
        frame_b.phi = 0;
        frame_b.w = 0;
        frame_b.z = 0;
      end World;

      package Sensors

        model RelVelocity "Measure the relative velocity of the origin of frame_b with respect to frame_a resolved in world frame"
          extends Interfaces.PartialRelativeVectorSensor;
        equation
          y.signal = frame_b.v_0 - frame_a.v_0;
        end RelVelocity;

        model RelVelocity2 "Measure the relative velocity of the origin of frame_b with respect to frame_a resolved in frame_resolve"
          extends Interfaces.PartialRelativeResolvedVectorSensor;
        equation
          y_0 = frame_b.v_0 - frame_a.v_0;
        end RelVelocity2;

        model RelPosition "Measure the relative position vector from the origin of frame_a to the origin of frame_b resolved in world frame"
          extends Interfaces.PartialRelativeVectorSensor;
        equation
          y.signal = frame_b.r_0 - frame_a.r_0;
        end RelPosition;

        model RelPosition2 "Measure the relative position vector from the origin of frame_a to the origin of frame_b resolved in frame_resolve"
          extends Interfaces.PartialRelativeResolvedVectorSensor;
        equation
          y_0 = frame_b.r_0 - frame_a.r_0;
        end RelPosition2;

        model RelAngularVelocity "Measure relative angular velocity (= frame_b.w - frame_a.w)"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput w_rel "Relative angular velocity ";
        equation
          frame_a.f = {0,0};
          frame_b.f = {0,0};
          frame_a.t = 0;
          frame_b.t = 0;
          w_rel.signal = frame_b.w - frame_a.w;
        end RelAngularVelocity;

        model RelAngularAcceleration "Measure relative angular acceleration (= frame_b.z - frame_a.z)"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput z_rel "Relative angular acceleration ";
        equation
          frame_a.f = {0,0};
          frame_b.f = {0,0};
          frame_a.t = 0;
          frame_b.t = 0;
          z_rel.signal = frame_b.z - frame_a.z;
        end RelAngularAcceleration;

        model RelAcceleration "Measure the relative acceleration of the origin of frame_b with respect to frame_a resolved in world frame"
          extends Interfaces.PartialRelativeVectorSensor;
        equation
          y.signal = frame_b.a_0 - frame_a.a_0;
        end RelAcceleration;

        model RelAcceleration2 "Measure the relative acceleration of the origin of frame_b with respect to frame_a resolved in frame_resolve"
          extends Interfaces.PartialRelativeResolvedVectorSensor;
        equation
          y_0 = frame_b.a_0 - frame_a.a_0;
        end RelAcceleration2;

        model Power "Measure power.signal flowing from frame_a to frame_b"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput power "Power at frame_a as output signal";
        equation
          frame_b.r_0 = frame_a.r_0;
          frame_b.v_0 = frame_a.v_0;
          frame_b.a_0 = frame_a.a_0;
          frame_b.phi = frame_a.phi;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t;
          power.signal = frame_a.f * frame_a.v_0 + frame_a.t * frame_a.w;
        end Power;

        model Distance "Measure the distance.signal between the origins of two frame connectors"
          extends Modelica.Icons.TranslationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput distance "Distance between the origin of frame_a and the origin of frame_b";
          parameter Real s_small = 1e-10 "Prevent zero-division if distance.signal between frame_a and frame_b is zero (s_small > 0)";
        protected
          Real r_rel_0[2] = frame_b.r_0 - frame_a.r_0 "Position vector from frame_a to frame_b resolved in world frame";
          Real L2 = r_rel_0 * r_rel_0;
          Real s_small2 = s_small * s_small;
        equation
          frame_a.f = {0,0};
          frame_b.f = {0,0};
          frame_a.t = 0;
          frame_b.t = 0;
          distance.signal = sqrt(L2);
        end Distance;

        model CutTorque "Measure cut torque.signal (= frame_a.t)"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque.signal";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque.signal";
          Modelica.Blocks.Interfaces.RealOutput torque "Cut torque resolved in frame_a/frame_b";
        equation
          frame_b.r_0 = frame_a.r_0;
          frame_b.v_0 = frame_a.v_0;
          frame_b.a_0 = frame_a.a_0;
          frame_b.phi = frame_a.phi;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t;
          torque.signal = frame_a.t;
        end CutTorque;

        model CutForce "Measure cut force.signal (= frame_a.f) resolved in world frame"
          extends Modelica.Icons.TranslationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force.signal and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force.signal and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput force[2] "Cut force  resolved in world frame";
        equation
          frame_b.r_0 = frame_a.r_0;
          frame_b.v_0 = frame_a.v_0;
          frame_b.a_0 = frame_a.a_0;
          frame_b.phi = frame_a.phi;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t;
          force.signal = frame_a.f;
        end CutForce;

        model CutForce2 "Measure cut force.signal (= frame_a.f) resolved in frame_resolve"
          extends Modelica.Icons.TranslationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force.signal and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force.signal and cut-torque";
          Interfaces.Frame_resolve frame_resolve "Cut force.signal is resolved in this frame";
          Modelica.Blocks.Interfaces.RealOutput force[2] "Cut force  resolved in frame_resolve";
        protected
          Real R_res[2,2] "Rotation matrix, describes rotation from world frame into frame_resolve";
        equation
          R_res[1,1] = cos(frame_resolve.phi);
          R_res[1,2] = sin(frame_resolve.phi);
          R_res[2,1] =  -sin(frame_resolve.phi);
          R_res[2,2] = cos(frame_resolve.phi);
          frame_resolve.f = {0,0};
          frame_resolve.t = 0;
          frame_b.r_0 = frame_a.r_0;
          frame_b.v_0 = frame_a.v_0;
          frame_b.a_0 = frame_a.a_0;
          frame_b.phi = frame_a.phi;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t;
          force.signal = R_res * frame_a.f;
        end CutForce2;

        model Angle "Measure angle.signal to rotate frame_a into frame_b (= frame_b.phi - frame_a.phi)"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system with one cut-force and cut-torque";
          Modelica.Blocks.Interfaces.RealOutput angle "Angle to rotate frame_a into frame_b ";
        equation
          frame_a.f = {0,0};
          frame_b.f = {0,0};
          frame_a.t = 0;
          frame_b.t = 0;
          angle.signal = frame_b.phi - frame_a.phi;
        end Angle;

        model AbsVelocity "Measure the absolute velocity vector of origin of frame_a resolved in world frame"
          extends Interfaces.PartialAbsoluteVectorSensor;
        equation
          y.signal = frame_a.v_0;
        end AbsVelocity;

        model AbsVelocity2 "Measure the absolute velocity vector of origin of frame_a resolved in frame_resolve"
          extends Interfaces.PartialAbsoluteResolvedVectorSensor;
        equation
          y_0 = frame_a.v_0;
        end AbsVelocity2;

        model AbsPosition "Measure the absolute position vector of origin of frame_a resolved in world frame"
          extends Interfaces.PartialAbsoluteVectorSensor;
        equation
          y.signal = frame_a.r_0;
        end AbsPosition;

        model AbsPosition2 "Measure the absolute position vector of origin of frame_a resolved in frame_resolve"
          extends Interfaces.PartialAbsoluteResolvedVectorSensor;
        equation
          y_0 = frame_a.r_0;
        end AbsPosition2;

        model AbsAngularVelocity "Measure absolute angular velocity (= frame_a.w)"
          extends Interfaces.PartialAbsoluteSensor;
        equation
          y.signal = frame_a.w;
        end AbsAngularVelocity;

        model AbsAngularAcceleration "Measure absolute angular acceleration (= frame_a.z)"
          extends Interfaces.PartialAbsoluteSensor;
        equation
          y.signal = frame_a.z;
        end AbsAngularAcceleration;

        model AbsAngle "Measure absolute angle to rotate world frame into frame_a"
          extends Interfaces.PartialAbsoluteSensor;
        equation
          y.signal = frame_a.phi;
        end AbsAngle;

        model AbsAcceleration "Measure the absolute acceleration vector of origin of frame_a resolved in world frame"
          extends Interfaces.PartialAbsoluteVectorSensor;
        equation
          y.signal = frame_a.a_0;
        end AbsAcceleration;

        model AbsAcceleration2 "Measure the absolute acceleration vector of origin of frame_a resolved in frame_resolve"
          extends Interfaces.PartialAbsoluteResolvedVectorSensor;
        equation
          y_0 = frame_a.a_0;
        end AbsAcceleration2;

      end Sensors;

      package Parts

        model PointMass "Rigid body where body rotation and inertia is neglected (no states)"
          Interfaces.Frame_a frame_a "Coordinate system fixed at center of mass point";
          parameter Real m = 1 "Mass of mass point (m > 0)";
          Real r_0[2](start = {0,0}) "Position vector from origin of world frame to origin of frame_a, resolved in world frame";
          Real v_0[2](start = {0,0}) "Absolute velocity of frame_a, resolved in world frame (= der(r_0))";
          Real a_0[2](start = {0,0}) "Absolute acceleration of frame_a resolved in world frame (= der(v_0))";
        equation
          frame_a.t = 0;
          r_0 = frame_a.r_0;
          v_0 = frame_a.v_0;
          a_0 = frame_a.a_0;
          frame_a.f = m * a_0;
        end PointMass;

        model FixedTranslation "Fixed translation of frame_b with respect to frame_a"
          Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque";
          parameter Real r[2] = {0,0} "Vector from frame_a to frame_b resolved in frame_a";
        protected
          Real r_0[2] "Vector from frame_a to frame_b resolved in world frame";
          Real w "Angular velocity of frame_a/frame_b";
          Real z "Angular acceleration of frame_a/frame_b";
          Real R_0[2,2] "Rotation matrix";
        equation
          R_0[1,1] = cos(frame_a.phi);
          R_0[1,2] =  -sin(frame_a.phi);
          R_0[2,1] = sin(frame_a.phi);
          R_0[2,2] = cos(frame_a.phi);
          r_0 = R_0 * r;
          w = frame_a.w;
          z = frame_a.z;
          frame_b.r_0 = frame_a.r_0 + r_0;
          frame_b.v_0 = frame_a.v_0 + w * { -r_0[2],r_0[1]};
          frame_b.a_0 = frame_a.a_0 + z * { -r_0[2],r_0[1]} - w * w * r_0;
          frame_b.phi = frame_a.phi;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t + r_0[1] * frame_b.f[2] - r_0[2] * frame_b.f[1];
        end FixedTranslation;

        model FixedRotation "Fixed translation followed by a fixed rotation of frame_b with respect to frame_a"
          Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque";
          parameter Real r[2] = {0,0} "Vector from frame_a to frame_b resolved in frame_a";
          parameter Real angle = 0 "Angle to rotate frame_a into frame_b";
        protected
          Real r_0[2] "Vector from frame_a to frame_b resolved in world frame";
          Real w "Angular velocity of frame_a/frame_b";
          Real z "Angular acceleration of frame_a/frame_b";
          Real R_0[2,2] "Rotation matrix";
        equation
          R_0[1,1] = cos(frame_a.phi);
          R_0[1,2] =  -sin(frame_a.phi);
          R_0[2,1] = sin(frame_a.phi);
          R_0[2,2] = cos(frame_a.phi);
          r_0 = R_0 * r;
          w = frame_a.w;
          z = frame_a.z;
          frame_b.r_0 = frame_a.r_0 + r_0;
          frame_b.v_0 = frame_a.v_0 + w * { -r_0[2],r_0[1]};
          frame_b.a_0 = frame_a.a_0 + z * { -r_0[2],r_0[1]} - w * w * r_0;
          frame_b.phi = frame_a.phi + angle;
          frame_b.w = frame_a.w;
          frame_b.z = frame_a.z;
          {0,0} = frame_a.f + frame_b.f;
          0 = frame_a.t + frame_b.t + r_0[1] * frame_b.f[2] - r_0[2] * frame_b.f[1];
        end FixedRotation;

        model Fixed "Frame fixed in the world frame at a given position (used for closing loops)"
          Interfaces.Frame_b frame_b "Coordinate system fixed in the world frame";
          parameter Real r[2] = {0,0} "Position vector from world frame to frame_b, resolved in world frame";
        equation
          frame_b.r_0 = r;
          frame_b.v_0 = {0,0};
          frame_b.a_0 = {0,0};
          frame_b.phi = 0;
          frame_b.w = 0;
          frame_b.z = 0;
        end Fixed;

        model BodyShape "Rigid body with mass, inertia tensor and two frame connectors (no states)"
          Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque";
          parameter Real r[2] = {0,0} "Vector from frame_a to frame_b resolved in frame_a";
          parameter Real r_CM[2] = {0,0} "Vector from frame_a to center of mass, resolved in frame_a";
          parameter Real m = 1 "Mass of rigid body (m >= 0)";
          parameter Real I = 0.001 "Inertia of rigid body (I >= 0)";
          parameter Real initType[6] = {0,0,0,0,0,0} "Type of initial value for [r_0,v_0,a_0,phi,w,z] (0=guess,1=fixed)";
          parameter Real r_0_start[2] = {0,0} "Initial values of frame_a.r_0 (position origin of frame_a resolved in world frame)";
          parameter Real v_0_start[2] = {0,0} "Initial values of velocity v = der(frame_a.r_0)";
          parameter Real a_0_start[2] = {0,0} "Initial values of acceleration a = der(v)";
          parameter Real phi_start = 0 "Initial value of angle phi to rotate world frame into frame_a";
          parameter Real w_start = 0 "Initial value of angular velocity w = der(phi) of frame_a";
          parameter Real z_start = 0 "Initial value of angular acceleration z = der(w) of frame_a";
          FixedTranslation frameTranslation(r = r);
          Body body(r_CM = r_CM, m = m, I = I, initType = initType, r_0_start = r_0_start, v_0_start = v_0_start, a_0_start = a_0_start, phi_start = phi_start, w_start = w_start, z_start = z_start);
        equation
          connect(frame_a,frameTranslation.frame_a);
          connect(frame_b,frameTranslation.frame_b);
          connect(frame_a,body.frame_a);
        end BodyShape;

        model Body "Rigid body with mass, inertia tensor and one frame connector (no states)"
          Interfaces.Frame_a frame_a "Coordinate system fixed at body";
          parameter Real r_CM[2] = {0,0} "Vector from frame_a to center of mass, resolved in frame_a";
          parameter Real m = 1 "Mass of rigid body (m >= 0)";
          parameter Real I = 0.001 "Inertia of rigid body (I >= 0)";
          parameter Real initType[6] = {0,0,0,0,0,0} "Type of initial value for [r_0,v_0,a_0,phi,w,z] (0=guess,1=fixed)";
          parameter Real r_0_start[2] = {0,0} "Initial values of frame_a.r_0 (position origin of frame_a resolved in world frame)";
          parameter Real v_0_start[2] = {0,0} "Initial values of velocity v = der(frame_a.r_0)";
          parameter Real a_0_start[2] = {0,0} "Initial values of acceleration a = der(v)";
          parameter Real phi_start = 0 "Initial value of angle phi to rotate world frame into frame_a";
          parameter Real w_start = 0 "Initial value of angular velocity w = der(phi) of frame_a";
          parameter Real z_start = 0 "Initial value of angular acceleration z = der(w) of frame_a";
        protected
          Real phi(start = phi_start, fixed = if initType[4] > 0 then true else false) "Angular position of frame_a";
          Real w(start = w_start, fixed = if initType[5] > 0 then true else false) "Angular velocity of frame_a";
          Real z(start = z_start, fixed = if initType[6] > 0 then true else false) "Angular acceleration of frame_a";
          Real r_0[2](start = r_0_start, fixed = if initType[1] > 0 then {true,true} else {false,false}) "Position of frame_a resolved in world frame";
          Real v_0[2](start = v_0_start, fixed = if initType[2] > 0 then {true,true} else {false,false}) "Velocity of frame_a resolved in world frame";
          Real a_0[2](start = a_0_start, fixed = if initType[3] > 0 then {true,true} else {false,false}) "Acceleration of frame_a resolved in world frame";
          Real r_CM_0[2] "Vector from frame_a to center of mass, resolved in world frame";
          Real f[2];
          Real t;
          Real R_0[2,2] "Rotation matrix";
        equation
          R_0[1,1] = cos(frame_a.phi);
          R_0[1,2] =  -sin(frame_a.phi);
          R_0[2,1] = sin(frame_a.phi);
          R_0[2,2] = cos(frame_a.phi);
          r_0 = frame_a.r_0;
          v_0 = frame_a.v_0;
          a_0 = frame_a.a_0;
          phi = frame_a.phi;
          w = frame_a.w;
          z = frame_a.z;
          f = frame_a.f;
          t = frame_a.t;
          r_CM_0 = R_0 * r_CM;
          f = m * (a_0 + z * { -r_CM_0[2],r_CM_0[1]} - w * w * r_CM_0);
          t = I * z + r_CM_0[1] * f[2] - r_CM_0[2] * f[1];
        end Body;

      end Parts;

      package LoopJoints

        model Revolute "Revolute joint used in loops (1 rotational degree-of-freedom, no states)"
          extends Internal.Revolute;
        end Revolute;

        model Prismatic "Prismatic joint used in loops (1 translational degree-of-freedom, no states)"
          extends Internal.Prismatic;
        end Prismatic;

        package Internal

          model Revolute "Revolute joint (1 rotational degree-of-freedom, no states)"
            Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque";
            Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque";
            parameter Real phi_offset = 0 "Relative angle offset (angle = phi + phi_offset)";
            Real phi "Relative rotation angle from frame_a to frame_b = phi + phi_offset";
            Real w "First derivative of angle phi (relative angular velocity)";
            Real z "Second derivative of angle phi (relative angular acceleration)";
            Real tau = 0 "Driving torque in direction of axis of rotation";
          equation
            frame_b.r_0 = frame_a.r_0;
            frame_b.v_0 = frame_a.v_0;
            frame_b.a_0 = frame_a.a_0;
            frame_b.phi = frame_a.phi + phi + phi_offset;
            frame_b.w = frame_a.w + w;
            frame_b.z = frame_a.z + z;
            {0,0} = frame_a.f + frame_b.f;
            0 = frame_a.t + frame_b.t;
            frame_a.t = tau;
          end Revolute;

          model Prismatic "Prismatic joint (1 translational degree-of-freedom, no states)"
            Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque";
            Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque";
            parameter Real n[2] = {1,0} "Axis of translation resolved in frame_a (= same as in frame_b)";
            parameter Real s_offset = 0 "Relative distance offset (distance between frame_a and frame_b = s_offset + s)";
            Real f = 0 "Actuation force in direction of joint axis";
            Real s "Relative distance between frame_a and frame_b = s + s_offset)";
            Real v "First derivative of s (relative velocity)";
            Real a "Second derivative of (relative accleration)";
          protected
            Real e[2] = n / sqrt(n * n) "Unit vector in direction of prismatic axis n, resolved in frame_a";
            Real r_0[2] "Vector from frame_a to frame_b resolved in frame_a";
            Real R_0[2,2] "Rotation matrix";
          equation
            R_0[1,1] = cos(frame_a.phi);
            R_0[1,2] =  -sin(frame_a.phi);
            R_0[2,1] = sin(frame_a.phi);
            R_0[2,2] = cos(frame_a.phi);
            r_0 = R_0 * e * (s + s_offset);
            frame_b.r_0 = frame_a.r_0 + r_0;
            frame_b.v_0 = frame_a.v_0 + R_0 * e * v;
            frame_b.a_0 = frame_a.a_0 + R_0 * e * a;
            frame_b.phi = frame_a.phi;
            frame_b.w = frame_a.w;
            frame_b.z = frame_a.z;
            {0,0} = frame_a.f + frame_b.f;
            0 = frame_a.t + frame_b.t + r_0[1] * frame_b.f[2] - r_0[2] * frame_b.f[1];
            f =  -R_0 * e * frame_b.f;
          end Prismatic;

        end Internal;

        model ActuatedRevolute "Actuated revolute joint used in loops (1 rotational degree-of-freedom, no states)"
          extends Internal.Revolute(final tau = axis.tau);
          Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the joint";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing";
        equation
          axis.phi = phi;
          bearing.phi = 0;
        end ActuatedRevolute;

        model ActuatedPrismatic "Actuated prismatic joint used in loops (1 translational degree-of-freedom, no states)"
          extends Internal.Prismatic(final f = axis.f);
          Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the joint";
          Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing";
        equation
          axis.s = s;
          bearing.s = 0;
        end ActuatedPrismatic;

      end LoopJoints;

      package Joints

        model RollingWheel "Joint that describes an ideal rolling wheel (1 non-holonomic constraint, no states)"
          extends Interfaces.PartialRollingWheel;
        equation
          f_lon = 0;
        end RollingWheel;

        model Revolute "Revolute joint (1 rotational degree-of-freedom, 2 states)"
          extends Internal.Revolute;
        end Revolute;

        model Prismatic "Prismatic joint (1 translational degree-of-freedom, 2 states)"
          extends Internal.Prismatic;
        end Prismatic;

        package Internal

          model Revolute "Revolute joint (rotational degree-of-freedom, 2 states)"
            Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque";
            Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque";
            parameter Real phi_offset = 0 "Relative angle offset (angle = phi + phi_offset)";
            Real phi(start = phi_start, fixed = if initType[1] > 0 then true else false) "Relative rotation angle from frame_a to frame_b = phi + phi_offset";
            Real w(start = w_start, fixed = if initType[2] > 0 then true else false) "First derivative of angle phi (relative angular velocity)";
            Real z(start = z_start, fixed = if initType[3] > 0 then true else false) "Second derivative of angle phi (relative angular acceleration)";
            Real tau = 0 "Driving torque in direction of axis of rotation";
            parameter Real initType[3] = {0,0,0} "Type of initial value for [phi,w,z] (0=guess,1=fixed)";
            parameter Real phi_start = 0 "Initial value of rotation angle phi";
            parameter Real w_start = 0 "Initial value of relative angular velocity w = der(phi)";
            parameter Real z_start = 0 "Initial value of relative angular acceleration z = der(w)";
          equation
            w = der(phi);
            z = der(w);
            frame_b.r_0 = frame_a.r_0;
            frame_b.v_0 = frame_a.v_0;
            frame_b.a_0 = frame_a.a_0;
            frame_b.phi = frame_a.phi + phi + phi_offset;
            frame_b.w = frame_a.w + w;
            frame_b.z = frame_a.z + z;
            {0,0} = frame_a.f + frame_b.f;
            0 = frame_a.t + frame_b.t;
            frame_a.t = tau;
          end Revolute;

          model Prismatic "Prismatic joint (1 translational degree-of-freedom, 2 states)"
            Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque";
            Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque";
            parameter Real n[2] = {1,0} "Axis of translation resolved in frame_a (= same as in frame_b)";
            parameter Real s_offset = 0 "Relative distance offset (distance between frame_a and frame_b = s_offset + s)";
            Real f = 0 "Actuation force in direction of joint axis";
            Real s(start = s_start, fixed = if initType[1] > 0 then true else false) "Relative distance between frame_a and frame_b = s + s_offset)";
            Real v(start = v_start, fixed = if initType[2] > 0 then true else false) "First derivative of s (relative velocity)";
            Real a(start = a_start, fixed = if initType[3] > 0 then true else false) "Second derivative of (relative accleration)";
            parameter Real initType[3] = {0,0,0} "Type of initial value for [s,v,a] (0=guess,1=fixed)";
            parameter Real s_start = 0 "Initial value of distance s";
            parameter Real v_start = 0 "Initial value of relative velocity v = der(s)";
            parameter Real a_start = 0 "Initial value of relative acceleration a = der(v)";
          protected
            Real e[2] = n / sqrt(n * n) "Unit vector in direction of prismatic axis n, resolved in frame_a";
            Real r_0[2] "Vector from frame_a to frame_b resolved in frame_a";
            Real R_0[2,2] "Rotation matrix";
          equation
            v = der(s);
            a = der(v);
            R_0[1,1] = cos(frame_a.phi);
            R_0[1,2] =  -sin(frame_a.phi);
            R_0[2,1] = sin(frame_a.phi);
            R_0[2,2] = cos(frame_a.phi);
            r_0 = R_0 * e * (s + s_offset);
            frame_b.r_0 = frame_a.r_0 + r_0;
            frame_b.v_0 = frame_a.v_0 + R_0 * e * v;
            frame_b.a_0 = frame_a.a_0 + R_0 * e * a;
            frame_b.phi = frame_a.phi;
            frame_b.w = frame_a.w;
            frame_b.z = frame_a.z;
            {0,0} = frame_a.f + frame_b.f;
            0 = frame_a.t + frame_b.t + r_0[1] * frame_b.f[2] - r_0[2] * frame_b.f[1];
            f =  -R_0 * e * frame_b.f;
          end Prismatic;

        end Internal;

        model FreeMotion "Free motion joint (3 degrees-of-freedom, 6 states)"
          extends Interfaces.PartialTwoFrames;
          Real r_rel_a[2](start = r_rel_a_start, fixed = if initType[1] > 0 then {true,true} else {false,false}) "Position vector from origin of frame_a to origin of frame_b, resolved in frame_a";
          Real v_rel_a[2](start = v_rel_a_start, fixed = if initType[2] > 0 then {true,true} else {false,false}) "= der(r_rel_a), i.e., velocity of origin of frame_b with respect to origin of frame_a, resolved in frame_a";
          Real a_rel_a[2](start = a_rel_a_start, fixed = if initType[3] > 0 then {true,true} else {false,false}) "= der(v_rel_a), i.e. acceleration of prigin of frame_b with respect to origin of frame_a, resolved in frame_a";
          Real phi_rel(start = phi_rel_start, fixed = if initType[4] > 0 then true else false) "Relative angle to rotate frame_a into frame_b (= frame_b.phi - frame_a.phi)";
          Real w_rel(start = w_rel_start, fixed = if initType[5] > 0 then true else false) "First derivative of angle phi_rel (relative angular velocity)";
          Real z_rel(start = z_rel_start, fixed = if initType[6] > 0 then true else false) "Second derivative of angle phi_rel (relative angular acceleration)";
          parameter Real initType[6] = {0,0,0,0,0,0} "Type of initial value for [r_rel_a,v_rel_a,a_rel_a,phi_rel,w_rel,z_rel] (0=guess,1=fixed)";
          parameter Real r_rel_a_start[2] = {0,0} "Initial values of r_rel_a (vector from origin of frame_a to origin of frame_b resolved in frame_a)";
          parameter Real v_rel_a_start[2] = {0,0} "Initial values of velocity v_rel_a = der(r_rel_a)";
          parameter Real a_rel_a_start[2] = {0,0} "Initial values of acceleration a_rel_a = der(v_rel_a)";
          parameter Real phi_rel_start = 0 "Initial value of angle phi_rel to rotate frame_a into frame_b";
          parameter Real w_rel_start = 0 "Initial value of angular velocity w_rel = der(phi_rel) of frame_b with respect to frame_a";
          parameter Real z_rel_start = 0 "Initial value of angular acceleration z_rel = der(w_rel) of frame_b with respect to frame_a";
        protected
          Real r_rel[2] "r_rel_a resolved in world frame";
          Real v_rel[2] "v_rel_a resolved in world frame";
          Real a_rel[2] "a_rel_a resolved in world frame";
          Real R_0[2,2] "Rotation matrix, describes rotation from frame_a into world frame";
        equation
          R_0[1,1] = cos(frame_a.phi);
          R_0[1,2] =  -sin(frame_a.phi);
          R_0[2,1] = sin(frame_a.phi);
          R_0[2,2] = cos(frame_a.phi);
          r_rel = R_0 * r_rel_a;
          v_rel = R_0 * v_rel_a;
          a_rel = R_0 * a_rel_a;
          v_rel_a = der(r_rel_a);
          a_rel_a = der(v_rel_a);
          frame_b.r_0 = frame_a.r_0 + r_rel;
          frame_b.v_0 = frame_a.v_0 + v_rel + frame_a.w * { -r_rel[2],r_rel[1]};
          frame_b.a_0 = frame_a.a_0 + a_rel + frame_a.z * { -r_rel[2],r_rel[1]} + 2 * frame_a.w * { -v_rel[2],v_rel[1]} - frame_a.w * frame_a.w * r_rel;
          w_rel = der(phi_rel);
          z_rel = der(w_rel);
          frame_b.phi = frame_a.phi + phi_rel;
          frame_b.w = frame_a.w + w_rel;
          frame_b.z = frame_a.z + z_rel;
          frame_a.f = {0,0};
          frame_a.t = 0;
          frame_b.f = {0,0};
          frame_b.t = 0;
        end FreeMotion;

        model ActuatedRollingWheel "Joint that describes an ideal actuated rolling wheel (1 non-holonomic constraint, no states)"
          extends Interfaces.PartialRollingWheel;
          Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the joint";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing";
          parameter Real radius = 1 "Radius of wheel";
          Real w_axis "Angular Velocity (w_axis=der(axis.phi))";
          Real a_axis "Angular acceleration of wheel axis (a_axis=der(w_axis))";
        equation
          f_lon = radius * axis.tau;
          w_axis = der(axis.phi);
          a_axis = der(w_axis);
          a_axis * radius = (if f_lon > 0 then 1 else  -1) * sqrt(frame_a.a_0 * frame_a.a_0);
          bearing.phi = 0;
        end ActuatedRollingWheel;

        model ActuatedRevolute "Actuated revolute joint (1 rotational degree-of-freedom, 2 states)"
          extends Internal.Revolute(final tau = axis.tau);
          Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the joint";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing";
        equation
          axis.phi = phi;
          bearing.phi = 0;
        end ActuatedRevolute;

        model ActuatedPrismatic "Actuated prismatic joint (1 translational degree-of-freedom, 2 states)"
          extends Internal.Prismatic(final f = axis.f);
          Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the joint";
          Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing";
        equation
          axis.s = s;
          bearing.s = 0;
        end ActuatedPrismatic;

      end Joints;

      package Interfaces

        partial model PartialTwoFrames "Base model for components providing two frame connectors"
          Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque";
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque";
        end PartialTwoFrames;

        model PartialRollingWheel "Base model that describes an ideal rolling wheel (1 non-holonomic constraint, no states)"
          Interfaces.Frame_a frame_a "Frame fixed in wheel center point";
          parameter Real n[2] = {0,1} "Wheel axis resolved in frame_a";
        protected
          Real f_lat "Force acting on wheel in lateral direction";
          Real f_lon "Force acting on wheel in longitudinal direction";
          Real f_wheel[2] "Force acting on wheel, resolved in frame_a";
          Real e[2] = n / sqrt(n * n) "Unit vector in direction of wheel axis n, resolved in frame_a";
          Real e_0[2] "Unit vector in direction of wheel axis n, resolved in world frame";
          Real R_0[2,2] "Rotation matrix";
        equation
          R_0[1,1] = cos(frame_a.phi);
          R_0[1,2] =  -sin(frame_a.phi);
          R_0[2,1] = sin(frame_a.phi);
          R_0[2,2] = cos(frame_a.phi);
          f_wheel = e * f_lat + {e[2], -e[1]} * f_lon;
          e_0 = R_0 * e;
          0 = e_0 * frame_a.v_0;
          0 = frame_a.t;
          {0,0} = frame_a.f + R_0 * f_wheel;
        end PartialRollingWheel;

        partial model PartialRelativeVectorSensor "Base model to measure a relative vector variable between two frames"
          extends Modelica.Icons.TranslationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system a";
          Interfaces.Frame_b frame_b "Coordinate system b";
          Modelica.Blocks.Interfaces.RealOutput y[2] "Measured data as signal vector";
        equation
          frame_a.f = {0,0};
          frame_a.t = 0;
          frame_b.f = {0,0};
          frame_b.t = 0;
        end PartialRelativeVectorSensor;

        partial model PartialRelativeResolvedVectorSensor "Base model to measure a relative vector variable between two frames resolved in frame_resolve"
          extends PartialRelativeVectorSensor;
          Frame_resolve frame_resolve "Measured data as signal vector is resolved in this frame";
          Real y_0[2] "Measured data as signal vector resolved in world frame";
        protected
          Real R_res[2,2] "Rotation matrix, describes rotation from world frame into frame_resolve";
        equation
          R_res[1,1] = cos(frame_resolve.phi);
          R_res[1,2] = sin(frame_resolve.phi);
          R_res[2,1] =  -sin(frame_resolve.phi);
          R_res[2,2] = cos(frame_resolve.phi);
          y.signal = R_res * y_0;
          frame_resolve.f = {0,0};
          frame_resolve.t = 0;
        end PartialRelativeResolvedVectorSensor;

        partial model PartialAbsoluteVectorSensor "Base model to measure an absolute vector frame variable"
          extends Modelica.Icons.TranslationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system a";
          Modelica.Blocks.Interfaces.RealOutput y[2] "Measured data as signal vector";
        equation
          frame_a.f = {0,0};
          frame_a.t = 0;
        end PartialAbsoluteVectorSensor;

        partial model PartialAbsoluteSensor "Base model to measure a absolute frame variable"
          extends Modelica.Icons.RotationalSensor;
          Interfaces.Frame_a frame_a "Coordinate system a";
          Modelica.Blocks.Interfaces.RealOutput y "Measured data as signal vector";
        equation
          frame_a.f = {0,0};
          frame_a.t = 0;
        end PartialAbsoluteSensor;

        partial model PartialAbsoluteResolvedVectorSensor "Base model to measure an absolute vector frame variable resolved in frame_resolve"
          extends PartialAbsoluteVectorSensor;
          Frame_resolve frame_resolve "Measured data as signal vector is resolved in this frame";
          Real y_0[2] "Measured data as signal vector resolved in world frame";
        protected
          Real R_res[2,2] "Rotation matrix, describes rotation from world frame into frame_resolve";
        equation
          R_res[1,1] = cos(frame_resolve.phi);
          R_res[1,2] = sin(frame_resolve.phi);
          R_res[2,1] =  -sin(frame_resolve.phi);
          R_res[2,2] = cos(frame_resolve.phi);
          y.signal = R_res * y_0;
          frame_resolve.f = {0,0};
          frame_resolve.t = 0;
        end PartialAbsoluteResolvedVectorSensor;

        connector Frame "Coordinate system fixed to the component with one cut-force and cut-torque (no icon)"
          Real r_0[2] "Position vector from world frame to the connector frame origin, resolved in world frame";
          Real v_0[2] "Absolute velocity of connector frame origin, resolved in world frame";
          Real a_0[2] "Absolute acceleration (- gravitational acceleration) of connector frame origin, resolved in world frame";
          Real phi "Angle between x-axis of the connector frame and the x-axis of the world frame";
          Real w "Absolute angular velocity of the connector frame";
          Real z "Absolute angular acceleration of the connector frame";
          flow Real f[2] "Cut-force resolved in world frame";
          flow Real t "Cut-torque resolved in world frame";
        end Frame;

        connector Frame_resolve "Coordinate system fixed to the component used to express in which coordinate system a vector is resolved (non-filled rectangular icon)"
          extends Frame;
        end Frame_resolve;

        connector Frame_b "Coordinate system fixed to the component with one cut-force and cut-torque (non-filled rectangular icon) "
          extends Frame;
        end Frame_b;

        connector Frame_a "Coordinate system fixed to the component with one cut-force and cut-torque (filled rectangular icon)"
          extends Frame;
        end Frame_a;

      end Interfaces;

      package Forces

        model WorldTorque "External torce acting at frame_b"
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque.signal";
          Modelica.Blocks.Interfaces.RealInput torque "Torque signal";
        equation
          frame_b.f = {0,0};
          frame_b.t =  -torque.signal;
        end WorldTorque;

        model WorldForce "External force.signal acting at frame_b, defined by 2 input signals and resolved in world frame"
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force.signal and cut-torque";
          Modelica.Blocks.Interfaces.RealInput force[2] "x- and y-coordinates of force resolved in world frame";
        equation
          frame_b.f = { -force[1].signal, -force[2].signal};
          frame_b.t = 0;
        end WorldForce;

        model LineForceWithMass "General line force component with a point mass on the connection line"
          extends Interfaces.PartialTwoFrames;
          parameter Real m = 1 "Mass of point mass (> 0) on the connetion line between the origin of frame_a and the origin of frame_b";
          parameter Real lengthFraction = 0.5 "Location of point mass with respect to frame_a as a fraction of the distance from frame_a to frame_b";
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_b "1-dim. translational flange (connect force of Translational library between flange_a and flange_b)";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_a "1-dim. translational flange (connect force of Translational library between flange_a and flange_b)";
          Real length "Distance between the origin of frame_a and the origin of frame_b";
          Real e_rel_0[2] "Unit vector in direction from frame_a to frame_b, resolved in world frame";
          parameter Real s_small = 1e-10 "Prevent zero-division if distance between frame_a and frame_b is zero";
          Real phi_rel "Relative angle to rotate frame_a into frame_b (= frame_b.phi - frame_a.phi)";
          Real w_rel "First derivative of angle phi_rel (relative angular velocity)";
          Real z_rel "Second derivative of angle phi_rel (relative angular acceleration)";
        protected
          Real r_rel_0[2] "r_rel_a resolved in world frame";
          Real v_rel_0[2] "v_rel_a resolved in world frame";
          Real a_rel_0[2] "a_rel_a resolved in world frame";
          Real a_CM_0[2] "Acceleration of point mass, resolved in world frame";
        equation
          frame_b.r_0 = frame_a.r_0 + r_rel_0;
          frame_b.v_0 = frame_a.v_0 + v_rel_0 + frame_a.w * { -r_rel_0[2],r_rel_0[1]};
          frame_b.a_0 = frame_a.a_0 + a_rel_0 + frame_a.z * { -r_rel_0[2],r_rel_0[1]} + 2 * frame_a.w * { -v_rel_0[2],v_rel_0[1]} - frame_a.w * frame_a.w * r_rel_0;
          frame_b.phi = frame_a.phi + phi_rel;
          frame_b.w = frame_a.w + w_rel;
          frame_b.z = frame_a.z + z_rel;
          a_CM_0 = frame_a.a_0 + lengthFraction * (frame_b.a_0 - frame_a.a_0);
          length = sqrt(r_rel_0 * r_rel_0);
          flange_a.s = 0;
          flange_b.s = length;
          e_rel_0 = r_rel_0 / noEvent(max(length, s_small));
          frame_a.f = m * (1 - lengthFraction) * a_CM_0 - flange_a.f * e_rel_0;
          frame_a.t = 0;
          frame_b.f = m * lengthFraction * a_CM_0 - flange_b.f * e_rel_0;
          frame_b.t = 0;
        end LineForceWithMass;

        model LineForce "General line force component"
          extends Interfaces.PartialTwoFrames;
          Modelica.Mechanics.Translational.Interfaces.Flange_a flange_b "1-dim. translational flange (connect force of Translational library between flange_a and flange_b)";
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange_a "1-dim. translational flange (connect force of Translational library between flange_a and flange_b)";
          Real length "Distance between the origin of frame_a and the origin of frame_b";
          Real e_rel_0[2] "Unit vector in direction from frame_a to frame_b, resolved in world frame";
          parameter Real s_small = 1e-10 "Prevent zero-division if distance between frame_a and frame_b is zero";
          Real phi_rel "Relative angle to rotate frame_a into frame_b (= frame_b.phi - frame_a.phi)";
          Real w_rel "First derivative of angle phi_rel (relative angular velocity)";
          Real z_rel "Second derivative of angle phi_rel (relative angular acceleration)";
        protected
          Real r_rel_0[2] "r_rel_a resolved in world frame";
          Real v_rel_0[2] "v_rel_a resolved in world frame";
          Real a_rel_0[2] "a_rel_a resolved in world frame";
        equation
          frame_b.r_0 = frame_a.r_0 + r_rel_0;
          frame_b.v_0 = frame_a.v_0 + v_rel_0 + frame_a.w * { -r_rel_0[2],r_rel_0[1]};
          frame_b.a_0 = frame_a.a_0 + a_rel_0 + frame_a.z * { -r_rel_0[2],r_rel_0[1]} + 2 * frame_a.w * { -v_rel_0[2],v_rel_0[1]} - frame_a.w * frame_a.w * r_rel_0;
          frame_b.phi = frame_a.phi + phi_rel;
          frame_b.w = frame_a.w + w_rel;
          frame_b.z = frame_a.z + z_rel;
          length = sqrt(r_rel_0 * r_rel_0);
          flange_a.s = 0;
          flange_b.s = length;
          e_rel_0 = r_rel_0 / noEvent(max(length, s_small));
          frame_a.f =  -flange_a.f * e_rel_0;
          frame_a.t = 0;
          frame_b.f =  -flange_b.f * e_rel_0;
          frame_b.t = 0;
        end LineForce;

        model FrameForce "External force.signal acting at frame_b, defined by 2 input signals and resolved in frame_resolve"
          Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force.signal and cut-torque";
          Interfaces.Frame_resolve frame_resolve "Input signals are resolved in this frame";
          Modelica.Blocks.Interfaces.RealInput force[2] "x- and y-coordinates of force resolved in world frame";
        protected
          Real R_0[2,2] "Rotation matrix, describes rotation from frame_resolve into world frame";
        equation
          R_0[1,1] = cos(frame_resolve.phi);
          R_0[1,2] =  -sin(frame_resolve.phi);
          R_0[2,1] = sin(frame_resolve.phi);
          R_0[2,2] = cos(frame_resolve.phi);
          frame_b.f = R_0 * { -force[1].signal, -force[2].signal};
          frame_b.t = 0;
          frame_resolve.f = {0,0};
          frame_resolve.t = 0;
        end FrameForce;

      end Forces;

    end Planar;

  end Mechanics;

  package Electrical

    package Analog

      package Sources

        model TrapezoidVoltage "Trapezoidal voltage source"
          parameter Real V = 1 "Amplitude of trapezoid";
          parameter Real rising = 0 "Rising duration of trapezoid (>=0)";
          parameter Real width = 0.5 "Width duration of trapezoid (>=0)";
          parameter Real falling = 0 "Falling duration of trapezoid (>=0)";
          parameter Real period = 1 "Time for one period (>0)";
          parameter Real nperiod =  -1 "Number of periods (< 0 means infinite number of periods)";
          extends Modelica.Electrical.Analog.Interfaces.VoltageSource;
          Coselica.Blocks.Sources.Trapezoid signalSource(amplitude = V, rising = rising, width = width, falling = falling, period = period, nperiod = nperiod);
        equation
          v = signalSource.y;
        end TrapezoidVoltage;

        model TrapezoidCurrent "Trapezoidal current source"
          parameter Real I = 1 "Amplitude of trapezoid";
          parameter Real rising = 0 "Rising duration of trapezoid (>=0)";
          parameter Real width = 0.5 "Width duration of trapezoid (>=0)";
          parameter Real falling = 0 "Falling duration of trapezoid (>=0)";
          parameter Real period = 1 "Time for one period (>0)";
          parameter Real nperiod =  -1 "Number of periods (< 0 means infinite number of periods)";
          extends Modelica.Electrical.Analog.Interfaces.CurrentSource;
          Coselica.Blocks.Sources.Trapezoid signalSource(amplitude = I, rising = rising, width = width, falling = falling, period = period, nperiod = nperiod);
        equation
          i = signalSource.y;
        end TrapezoidCurrent;

      end Sources;

      package Sensors

        model PowerSensor "Sensor to measure the power.signal"
          Modelica.Electrical.Analog.Interfaces.PositivePin pc "Positive pin, current path";
          Modelica.Electrical.Analog.Interfaces.NegativePin nc "Negative pin, current path";
          Modelica.Electrical.Analog.Interfaces.PositivePin pv "Positive pin, voltage path";
          Modelica.Electrical.Analog.Interfaces.NegativePin nv "Negative pin, voltage path";
          Modelica.Blocks.Interfaces.RealOutput power;
        equation
          pv.i = 0;
          nv.i = 0;
          pc.v = nc.v;
          pc.i =  -nc.i;
          power.signal = (pv.v - nv.v) * pc.i;
        end PowerSensor;

      end Sensors;

      package Semiconductors

        model ZDiode "Zener Diode with 3 working areas"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real Ids = 1e-06 "Saturation current";
          parameter Real Vt = 0.04 "Voltage equivalent of temperature (kT/qn)";
          parameter Real Maxexp = 30 "Max. exponent for linear continuation";
          parameter Real R = 100000000.0 "Parallel ohmic resistance";
          parameter Real Bv = 5.1 "Breakthrough voltage = Zener- or Z-voltage";
          parameter Real Ibv = 0.7 "Breakthrough knee current";
          parameter Real Nbv = 0.74 "Breakthrough emission coefficient";
        equation
          i = if v > Maxexp * Vt then Ids * (exp(Maxexp) * (1 + v / Vt - Maxexp) - 1) + v / R else if v + Bv <  -Maxexp * Nbv * Vt then  -Ids - Ibv * exp(Maxexp) * (1 - (v + Bv) / (Nbv * Vt) - Maxexp) + v / R else Ids * (exp(v / Vt) - 1) - Ibv * exp( -(v + Bv) / (Nbv * Vt)) + v / R;
        end ZDiode;

        model Thyristor "Simple Thyristor Model"
          parameter Real VDRM = 100 "Forward breakthrough voltage (>= 0)";
          parameter Real VRRM = 100 "Reverse breakthrough voltage (>= 0)";
          parameter Real IDRM = 0.1 "Saturation current";
          parameter Real VTM = 1.7 "Conducting voltage";
          parameter Real IH = 0.006 "Holding current";
          parameter Real ITM = 25 "Conducting current";
          parameter Real VGT = 0.7 "Gate trigger voltage";
          parameter Real IGT = 0.005 "Gate trigger current";
          parameter Real TON = 1e-06 "Switch on time";
          parameter Real TOFF = 1.5e-05 "Switch off time";
          parameter Real Vt = 0.04 "Voltage equivalent of temperature (kT/qn)";
          parameter Real Nbv = 0.74 "Reverse Breakthrough emission coefficient";
          Real iGK "gate current";
          Real vGK "voltage between gate and cathode";
          Real vAK "voltage between anode and cathode";
          Real vControl(start = 0);
          Real vContot;
          Real vConmain;
        public
          Modelica.Electrical.Analog.Interfaces.PositivePin Anode;
          Modelica.Electrical.Analog.Interfaces.NegativePin Cathode;
          Modelica.Electrical.Analog.Interfaces.PositivePin Gate;
        protected
          parameter Real Von = 5;
          parameter Real Voff = 1.5;
          parameter Real Ron = (VTM - 0.7) / ITM "Forward conducting mode resistance";
          parameter Real Roff = VDRM ^ 2 / VTM / IH "Blocking mode resistance";
        equation
          Anode.i + Gate.i + Cathode.i = 0;
          vGK = Gate.v - Cathode.v;
          vAK = Anode.v - Cathode.v;
          iGK = Gate.i;
          vGK = if vGK < 0.65 then VGT / IGT * iGK else 0.65 ^ 2 / VGT + (iGK * (VGT - 0.65)) / IGT;
          vContot = vConmain + (if iGK < 0.95 * IGT then 0 else if iGK < 0.95 * IGT + 0.001 then 10000 * (iGK - 0.95 * IGT) * vAK else 10 * vAK);
          der(vControl) = (vContot - vControl) / (if vContot - vControl > 0 then 1.87 * TON else 0.638 * TOFF);
          Anode.i = noEvent(if vAK <  -VRRM then  -VRRM / Roff * exp( -(vAK + VRRM) / (Nbv * Vt)) else if vControl < Voff then vAK / Roff else if vControl < Von then vAK / (sqrt(Ron * Roff) * (Ron / Roff) ^ ((3 * (2 * vControl - Von - Voff) / (2 * (Von - Voff)) - 4 * ((2 * vControl - Von - Voff) / (2 * (Von - Voff))) ^ 3) / 2)) else vAK / Ron);
          vConmain = if Anode.i > IH or vAK > VDRM then Von else 0;
        end Thyristor;

      end Semiconductors;

      package Ideal

        model IdealDiode "Ideal diode"
          extends Modelica.Electrical.Analog.Interfaces.OnePort;
          parameter Real Ron = 1e-05 "Forward state-on differential resistance (closed diode resistance >=0)";
          parameter Real Goff = 1e-05 "Backward state-off conductance (opened diode conductance >= 0)";
          parameter Real Vknee = 0 "Forward threshold voltage (>= 0";
        protected
          Real s "Auxiliary variable: if on then current, if opened then voltage";
        equation
          v = s * (if s < 0 then 1 else Ron) + Vknee;
          i = s * (if s < 0 then Goff else 1) + Goff * Vknee;
        end IdealDiode;

      end Ideal;

      package Basic

        model TranslationalEMF "Electromotoric force (electric/mechanic transformer)"
          parameter Real k = 1 "Transformation coefficient";
          Real v "Voltage drop between the two pins";
          Real i "Current flowing from positive to negative pin";
          Real s "Position of flange relative to support";
          Real vel "Velocity of flange relative to support";
          Modelica.Electrical.Analog.Interfaces.PositivePin p;
          Modelica.Electrical.Analog.Interfaces.NegativePin n;
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange;
          Coselica.Mechanics.Translational.Interfaces.Support support "Support/housing";
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          s = flange.s - support.s;
          vel = der(s);
          k * vel = v;
          flange.f =  -k * i;
          flange.f + support.f = 0;
        end TranslationalEMF;

        model TranslationalEMF0 "Electromotoric force (electric/mechanic transformer)"
          parameter Real k = 1 "Transformation coefficient";
          Real v "Voltage drop between the two pins";
          Real i "Current flowing from positive to negative pin";
          Real s "Position of flange relative to support";
          Real vel "Velocity of flange relative to support";
          Modelica.Electrical.Analog.Interfaces.PositivePin p;
          Modelica.Electrical.Analog.Interfaces.NegativePin n;
          Modelica.Mechanics.Translational.Interfaces.Flange_b flange;
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          s = flange.s;
          vel = der(s);
          k * vel = v;
          flange.f =  -k * i;
        end TranslationalEMF0;

        model EMF "Electromotoric force (electric/mechanic transformer)"
          parameter Real k = 1 "Transformation coefficient";
          Real v "Voltage drop between the two pins";
          Real i "Current flowing from positive to negative pin";
          Real phi "Angle of shaft flange with respect to support (= flange.phi - support.phi)";
          Real w "Angular velocity of flange relative to support";
          Modelica.Electrical.Analog.Interfaces.PositivePin p;
          Modelica.Electrical.Analog.Interfaces.NegativePin n;
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
          Coselica.Mechanics.Rotational.Interfaces.Support support "Support/housing of emf shaft";
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          phi = flange.phi - support.phi;
          w = der(phi);
          k * w = v;
          flange.tau =  -k * i;
          flange.tau + support.tau = 0;
        end EMF;

        model EMF0 "Electromotoric force (electric/mechanic transformer)"
          parameter Real k = 1 "Transformation coefficient";
          Real v "Voltage drop between the two pins";
          Real i "Current flowing from positive to negative pin";
          Real phi "Angle of shaft flange with respect to support (= flange.phi - support.phi)";
          Real w "Angular velocity of flange relative to support";
          Modelica.Electrical.Analog.Interfaces.PositivePin p;
          Modelica.Electrical.Analog.Interfaces.NegativePin n;
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          phi = flange.phi;
          w = der(phi);
          k * w = v;
          flange.tau =  -k * i;
        end EMF0;

      end Basic;

    end Analog;

  end Electrical;

  package Blocks

    package Sources

      model Trapezoid "Generate trapezoidal signal of type Real"
        parameter Real amplitude = 1 "Amplitude of trapezoid";
        parameter Real rising = 0 "Rising duration of trapezoid";
        parameter Real width = 0.5 "Width duration of trapezoid";
        parameter Real falling = 0 "Falling duration of trapezoid";
        parameter Real period = 1 "Time for one period";
        parameter Real nperiod =  -1 "Number of periods (< 0 means infinite number of periods)";
        parameter Real offset = 0 "Offset of output signal";
        parameter Real startTime = 0 "Output = offset for time < startTime";
        extends Modelica.Blocks.Interfaces.SO;
      protected
        parameter Real T_rising = rising "End time of rising phase within one period";
        parameter Real T_width = T_rising + width "End time of width phase within one period";
        parameter Real T_falling = T_width + falling "End time of falling phase within one period";
        discrete Real T0(start = startTime, fixed = true) "Start time of current period";
        discrete Real counter(start = nperiod, fixed = true) "Period counter";
      equation
        when time > T0 + period then
            T0 = time;
          counter = max(0, counter - 1);

        end when;
        y.signal = offset + (if time < startTime or counter >  -1 and counter < 1 or time >= T0 + T_falling then 0 else if time < T0 + T_rising then ((time - T0) * amplitude) / T_rising else if time < T0 + T_width then amplitude else ((T0 + T_falling - time) * amplitude) / (T_falling - T_width));
      end Trapezoid;

    package Routing

      model Replicator "Signal replicator"
        extends Modelica.Blocks.Interfaces.SIMO;
      equation
        y.signal = fill(u.signal, nout);
      end Replicator;

      model MultiplexVector2 "Multiplexer model for two input connectors"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        parameter Integer n1 = 1 "dimension of input signal connector 1";
        parameter Integer n2 = 1 "dimension of input signal connector 2";
        Modelica.Blocks.Interfaces.RealInput u1[n1] "Connector of Real input signals 1";
        Modelica.Blocks.Interfaces.RealInput u2[n2] "Connector of Real input signals 2";
        Modelica.Blocks.Interfaces.RealOutput y[n1 + n2] "Connector of Real output signals";
      equation
        for i in 1:n1 loop
        y[i].signal = u1[i].signal;
        end for;
        for i in 1:n2 loop
        y[n1 + i].signal = u2[i].signal;
        end for;
      end MultiplexVector2;

      model Multiplex2 "Multiplexer model for two input connectors"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        Modelica.Blocks.Interfaces.RealInput u1 "Connector of Real input signals 1";
        Modelica.Blocks.Interfaces.RealInput u2 "Connector of Real input signals 2";
        Modelica.Blocks.Interfaces.RealOutput y[2] "Connector of Real output signals";
      equation
        y[1].signal = u1.signal;
        y[2].signal = u2.signal;
      end Multiplex2;

      model Extractor "Extract scalar signal out of signal vector"
        extends Modelica.Blocks.Interfaces.MISO;
        parameter Integer index = 1 "Index of output signal (positive integer <= nin)";
      equation
        y.signal = u[index].signal;
      end Extractor;

      model DeMultiplexVector2 "DeMultiplexer model for two output connectors"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        parameter Integer n1 = 1 "dimension of output signal connector 1";
        parameter Integer n2 = 1 "dimension of output signal connector 2";
        Modelica.Blocks.Interfaces.RealInput u[n1 + n2] "Connector of Real input signals";
        Modelica.Blocks.Interfaces.RealOutput y1[n1] "Connector of Real output signals 1";
        Modelica.Blocks.Interfaces.RealOutput y2[n2] "Connector of Real output signals 2";
      equation
        for i in 1:n1 loop
        u[i].signal = y1[i].signal;
        end for;
        for i in 1:n2 loop
        u[n1 + i].signal = y2[i].signal;
        end for;
      end DeMultiplexVector2;

      model DeMultiplex2 "DeMultiplexer model for two output connectors"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        Modelica.Blocks.Interfaces.RealInput u[2] "Connector of Real input signals";
        Modelica.Blocks.Interfaces.RealOutput y1 "Connector of Real output signals 1";
        Modelica.Blocks.Interfaces.RealOutput y2 "Connector of Real output signals 2";
      equation
        u[1].signal = y1.signal;
        u[2].signal = y2.signal;
      end DeMultiplex2;

    end Routing;

    package Nonlinear

      model RateLimiter "Limit rate of change of signal"
        extends Modelica.Blocks.Interfaces.SISO;
        parameter Real sMax = 1 "Maximum slope";
        parameter Real sMin =  -1 "Minimum slope";
        parameter Real T = 0.0001 "Time constant (> 0)";
        parameter Real y_start = 0 "Start value of output";
      protected
        Real x "approximated rate";
        Real yaux(start = y_start, fixed = true) "auxillary variable for initialization of output";
      equation
        y.signal = yaux;
        der(x) = (u.signal - y.signal) / T;
        der(y.signal) = noEvent(if der(x) > sMax then sMax else if der(x) < sMin then sMin else der(x));
      end RateLimiter;

      model Hysteresis "Switch output between two constants with hysteresis"
        extends Modelica.Blocks.Interfaces.SISO;
        parameter Real uOn = 1 "Switch on when u.signal >= uOn";
        parameter Real uOff = 0 "Switch off when u.signal <= uOff";
        parameter Real yOn = 1 "Output when switched on";
        parameter Real yOff = 0 "Output when switched off";
        parameter Real y_start = 0 "Start value of output";
      protected
        discrete Real yd(start = y_start, fixed = true) "discrete state for output value (y.signal=yd)";
      equation
        y.signal = yd;
        when u.signal >= uOn then
            yd = yOn;

        end when;
        when u.signal <= uOff then
            yd = yOff;

        end when;
      end Hysteresis;

    end Nonlinear;

    package Math

      package Vectors

        model ElementwiseProduct "Outputs the element-wise product of two input signal vectors"
          extends Modelica.Blocks.Interfaces.MI2MO;
        equation
          for i in 1:n loop
          y[i].signal = u1[i].signal * u2[i].signal;
          end for;
        end ElementwiseProduct;

        model DotProduct "Outputs the dot product of two input signal vectors"
          extends Modelica.Blocks.Interfaces.BlockIcon;
          parameter Integer n = 1 "Dimension of input vectors.";
          Modelica.Blocks.Interfaces.RealInput u1[n] "Connector 1 of Real input signals";
          Modelica.Blocks.Interfaces.RealInput u2[n] "Connector 2 of Real input signals";
          Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal";
        equation
          y.signal = u1.signal * u2.signal;
        end DotProduct;

        model CrossProduct "Outputs the cross product of two input signal vectors of dimension 3"
          extends Modelica.Blocks.Interfaces.BlockIcon;
          Modelica.Blocks.Interfaces.RealInput u1[3] "Connector 1 of Real input signals";
          Modelica.Blocks.Interfaces.RealInput u2[3] "Connector 2 of Real input signals";
          Modelica.Blocks.Interfaces.RealOutput y[3] "Connector of Real output signals";
        equation
          y[1].signal = u1[2].signal * u2[3].signal - u1[3].signal * u2[2].signal;
          y[2].signal = u1[3].signal * u2[1].signal - u1[1].signal * u2[3].signal;
          y[3].signal = u1[1].signal * u2[2].signal - u1[2].signal * u2[1].signal;
        end CrossProduct;

        model Add "Outputs the addition of two input signal vectors"
          extends Modelica.Blocks.Interfaces.MI2MO;
          parameter Real k1 =  +1 "Gain of upper input";
          parameter Real k2 =  +1 "Gain of lower input";
        equation
          y.signal = k1 * u1.signal + k2 * u2.signal;
        end Add;

      end Vectors;

      model TwoOutputs "Change causality of output signals by defining that two output signals are identical (e.g. for inverse models)"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        Modelica.Blocks.Interfaces.RealOutput y1 "Connector of first Real output signal";
        Modelica.Blocks.Interfaces.RealOutput y2 "Connector of second Real output signal ";
      equation
        y1.signal = y2.signal;
      end TwoOutputs;

      model TwoInputs "Change causality of input signals by defining that two input signals are identical (e.g. for inverse models)"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        Modelica.Blocks.Interfaces.RealInput u1 "Connector of first Real input signal";
        Modelica.Blocks.Interfaces.RealInput u2 "Connector of second Real input signal ";
      equation
        u1.signal = u2.signal;
      end TwoInputs;

      model Sum "Output the sum of the elements of the input vector"
        extends Modelica.Blocks.Interfaces.MISO;
        parameter Real k[nin] = {1} "Vector of sum coefficients (length nin)";
      equation
        y.signal = k * u.signal;
      end Sum;

      model Atan2 "Output atan(u1.signal/u2.signal) of the inputs u1.signal and u2.signal"
        extends Modelica.Blocks.Interfaces.SI2SO;
      equation
        y.signal = 2 * atan(u1.signal / (sqrt(u1.signal * u1.signal + u2.signal * u2.signal) + u2.signal));
      end Atan2;

      model Add3 "Output the sum of the three inputs"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        parameter Real k1 =  +1 "Gain of upper input";
        parameter Real k2 =  +1 "Gain of middle input";
        parameter Real k3 =  +1 "Gain of lower input";
        input Modelica.Blocks.Interfaces.RealInput u1 "Connector 1 of Real input signals";
        input Modelica.Blocks.Interfaces.RealInput u2 "Connector 2 of Real input signals";
        input Modelica.Blocks.Interfaces.RealInput u3 "Connector 3 of Real input signals";
        output Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signals";
      equation
        y.signal = k1 * u1.signal + k2 * u2.signal + k3 * u3.signal;
      end Add3;

    end Math;

    package Interfaces

      model RealOutput
        Modelica.Blocks.Interfaces.RealInput u;
        Real y;
      equation
        y = u.signal;
      end RealOutput;

      model RealInput
        Real u;
        Modelica.Blocks.Interfaces.RealOutput y;
      equation
        y.signal = u;
      end RealInput;

    end Interfaces;

  end Blocks;

  package Constants "Mathematical constants and constants of nature"
    //import SI = Modelica.SIunits;
    //import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    //extends Modelica.Icons.Library2;
    constant Real e = 2.71828182846;
    constant Real pi = 3.14159265359;
    constant Real D2R = pi / 180 "Degree to Radian";
    constant Real R2D = 180 / pi "Radian to Degree";
    constant Real eps = 1e-15 "Biggest number such that 1.0 + eps = 1.0";
    constant Real small = 1e-60 "Smallest number such that small and -small are representable on the machine";
    constant Real inf = 1e+60 "Biggest Real number such that inf and -inf are representable on the machine";
    constant Integer Integer_inf = 1073741823 "Biggest Integer number such that Integer_inf and -Integer_inf are representable on the machine";
    constant Real c = 299792458 "Speed of light in vacuum";
    constant Real g_n = 9.80665 "Standard acceleration of gravity on earth";
    constant Real G = 6.6742e-11 "Newtonian constant of gravitation";
    constant Real h = 6.6260693e-34 "Planck constant";
    constant Real k = 1.3806505e-23 "Boltzmann constant";
    constant Real R = 8.314472 "Molar gas constant";
    constant Real sigma = 5.6704e-08 "Stefan-Boltzmann constant";
    constant Real N_A = 6.0221415e+23 "Avogadro constant";
    constant Real mue_0 = 4 * pi * 1e-07 "Magnetic constant";
    constant Real epsilon_0 = 1 / (mue_0 * c * c) "Electric constant";
    constant Real T_zero =  -273.15 "Absolute zero temperature";
  end Constants;

end Coselica;




// wrapping models for scicos

model CBI_RealOutput
  extends Coselica.Blocks.Interfaces.RealOutput;
end CBI_RealOutput;

model CBI_RealInput
  extends Coselica.Blocks.Interfaces.RealInput;
end CBI_RealInput;

model CBR_Multiplex2
  extends Coselica.Blocks.Routing.Multiplex2;
end CBR_Multiplex2;

model CBR_DeMultiplex2
  extends Coselica.Blocks.Routing.DeMultiplex2;
end CBR_DeMultiplex2;

model CBR_Replicator
  extends Coselica.Blocks.Routing.Replicator;
end CBR_Replicator;

model CBR_Extractor
  extends Coselica.Blocks.Routing.Extractor;
end CBR_Extractor;

model CBR_MultiplexVector2
  extends Coselica.Blocks.Routing.MultiplexVector2;
end CBR_MultiplexVector2;

model CBR_DeMultiplexVector2
  extends Coselica.Blocks.Routing.DeMultiplexVector2;
end CBR_DeMultiplexVector2;

model MBM_Gain
  extends Modelica.Blocks.Math.Gain;
end MBM_Gain;

model MBM_Abs
  extends Modelica.Blocks.Math.Abs;
end MBM_Abs;

model MBM_Sign
  extends Modelica.Blocks.Math.Sign;
end MBM_Sign;

model MBM_Sqrt
  extends Modelica.Blocks.Math.Sqrt;
end MBM_Sqrt;

model MBM_Sin
  extends Modelica.Blocks.Math.Sin;
end MBM_Sin;

model MBM_Cos
  extends Modelica.Blocks.Math.Cos;
end MBM_Cos;

model MBM_Tan
  extends Modelica.Blocks.Math.Tan;
end MBM_Tan;

model MBM_Asin
  extends Modelica.Blocks.Math.Asin;
end MBM_Asin;

model MBM_Acos
  extends Modelica.Blocks.Math.Acos;
end MBM_Acos;

model MBM_Atan
  extends Modelica.Blocks.Math.Atan;
end MBM_Atan;

model MBM_Sinh
  extends Modelica.Blocks.Math.Sinh;
end MBM_Sinh;

model MBM_Cosh
  extends Modelica.Blocks.Math.Cosh;
end MBM_Cosh;

model MBM_Tanh
  extends Modelica.Blocks.Math.Tanh;
end MBM_Tanh;

model MBM_Exp
  extends Modelica.Blocks.Math.Exp;
end MBM_Exp;

model MBM_Log
  extends Modelica.Blocks.Math.Log;
end MBM_Log;

model MBM_Log10
  extends Modelica.Blocks.Math.Log10;
end MBM_Log10;

model CBM_Sum
  extends Coselica.Blocks.Math.Sum;
end CBM_Sum;

model MBM_Add
  extends Modelica.Blocks.Math.Add;
end MBM_Add;

model MBM_Product
  extends Modelica.Blocks.Math.Product;
end MBM_Product;

model MBM_Division
  extends Modelica.Blocks.Math.Division;
end MBM_Division;

model MBM_Max
  extends Modelica.Blocks.Math.Max;
end MBM_Max;

model MBM_Min
  extends Modelica.Blocks.Math.Min;
end MBM_Min;

model CBM_Atan2
  extends Coselica.Blocks.Math.Atan2;
end CBM_Atan2;

model CBMV_DotProduct
  extends Coselica.Blocks.Math.Vectors.DotProduct;
end CBMV_DotProduct;

model CBMV_Add
  extends Coselica.Blocks.Math.Vectors.Add;
end CBMV_Add;

model CBMV_ElementwiseProduct
  extends Coselica.Blocks.Math.Vectors.ElementwiseProduct;
end CBMV_ElementwiseProduct;

model CBMV_CrossProduct
  extends Coselica.Blocks.Math.Vectors.CrossProduct;
end CBMV_CrossProduct;

model MBM_Feedback
  extends Modelica.Blocks.Math.Feedback;
end MBM_Feedback;

model CBM_Add3
  extends Coselica.Blocks.Math.Add3;
end CBM_Add3;

model CBM_TwoInputs
  extends Coselica.Blocks.Math.TwoInputs;
end CBM_TwoInputs;

model CBM_TwoOutputs
  extends Coselica.Blocks.Math.TwoOutputs;
end CBM_TwoOutputs;

model MBS_Clock
  extends Modelica.Blocks.Sources.Clock;
end MBS_Clock;

model MBS_Constant
  extends Modelica.Blocks.Sources.Constant;
end MBS_Constant;

model MBS_Step
  extends Modelica.Blocks.Sources.Step;
end MBS_Step;

model MBS_Ramp
  extends Modelica.Blocks.Sources.Ramp;
end MBS_Ramp;

model MBS_Sine
  extends Modelica.Blocks.Sources.Sine;
end MBS_Sine;

model MBS_ExpSine
  extends Modelica.Blocks.Sources.ExpSine;
end MBS_ExpSine;

model MBS_Exponentials
  extends Modelica.Blocks.Sources.Exponentials;
end MBS_Exponentials;

model CBS_Trapezoid
  extends Coselica.Blocks.Sources.Trapezoid;
end CBS_Trapezoid;

model MBC_Integrator
  extends Modelica.Blocks.Continuous.Integrator;
end MBC_Integrator;

model MBC_LimIntegrator
  extends Modelica.Blocks.Continuous.LimIntegrator;
end MBC_LimIntegrator;

model MBC_Der
  extends Modelica.Blocks.Continuous.Der;
end MBC_Der;

model MBC_Derivative
  extends Modelica.Blocks.Continuous.Derivative;
end MBC_Derivative;

model MBC_FirstOrder
  extends Modelica.Blocks.Continuous.FirstOrder;
end MBC_FirstOrder;

model MBC_SecondOrder
  extends Modelica.Blocks.Continuous.SecondOrder;
end MBC_SecondOrder;

model MBC_PI
  extends Modelica.Blocks.Continuous.PI;
end MBC_PI;

model MBC_PID
  extends Modelica.Blocks.Continuous.PID;
end MBC_PID;

model MBC_LimPID
  extends Modelica.Blocks.Continuous.LimPID;
end MBC_LimPID;

model MBN_Limiter
  extends Modelica.Blocks.Nonlinear.Limiter;
end MBN_Limiter;

model MBN_DeadZone
  extends Modelica.Blocks.Nonlinear.DeadZone;
end MBN_DeadZone;

model CBN_Hysteresis
  extends Coselica.Blocks.Nonlinear.Hysteresis;
end CBN_Hysteresis;

model CBN_RateLimiter
  extends Coselica.Blocks.Nonlinear.RateLimiter;
end CBN_RateLimiter;

model MEAB_Ground
  extends Modelica.Electrical.Analog.Basic.Ground;
end MEAB_Ground;

model MEAB_Resistor
  extends Modelica.Electrical.Analog.Basic.Resistor;
end MEAB_Resistor;

model MEAB_Capacitor
  extends Modelica.Electrical.Analog.Basic.Capacitor;
end MEAB_Capacitor;

model MEAB_Inductor
  extends Modelica.Electrical.Analog.Basic.Inductor;
end MEAB_Inductor;

model CEAB_EMF0
  extends Coselica.Electrical.Analog.Basic.EMF0;
end CEAB_EMF0;

model CEAB_EMF
  extends Coselica.Electrical.Analog.Basic.EMF;
end CEAB_EMF;

model CEAB_TranslationalEMF0
  extends Coselica.Electrical.Analog.Basic.TranslationalEMF0;
end CEAB_TranslationalEMF0;

model CEAB_TranslationalEMF
  extends Coselica.Electrical.Analog.Basic.TranslationalEMF;
end CEAB_TranslationalEMF;

model MEAB_VariableResistor
  extends Modelica.Electrical.Analog.Basic.VariableResistor;
end MEAB_VariableResistor;

model MEAB_VariableCapacitor
  extends Modelica.Electrical.Analog.Basic.VariableCapacitor;
end MEAB_VariableCapacitor;

model MEAB_VariableInductor
  extends Modelica.Electrical.Analog.Basic.VariableInductor;
end MEAB_VariableInductor;

model MEAB_Transformer
  extends Modelica.Electrical.Analog.Basic.Transformer;
end MEAB_Transformer;

model MEAB_Gyrator
  extends Modelica.Electrical.Analog.Basic.Gyrator;
end MEAB_Gyrator;

model MEAB_VCV
  extends Modelica.Electrical.Analog.Basic.VCV;
end MEAB_VCV;

model MEAB_VCC
  extends Modelica.Electrical.Analog.Basic.VCC;
end MEAB_VCC;

model MEAB_CCV
  extends Modelica.Electrical.Analog.Basic.CCV;
end MEAB_CCV;

model MEAB_CCC
  extends Modelica.Electrical.Analog.Basic.CCC;
end MEAB_CCC;

model MEAB_OpAmp
  extends Modelica.Electrical.Analog.Basic.OpAmp;
end MEAB_OpAmp;

model MEAB_HeatingResistor
  extends Modelica.Electrical.Analog.Basic.HeatingResistor;
end MEAB_HeatingResistor;

model MEAS_PotentialSensor
  extends Modelica.Electrical.Analog.Sensors.PotentialSensor;
end MEAS_PotentialSensor;

model MEAS_VoltageSensor
  extends Modelica.Electrical.Analog.Sensors.VoltageSensor;
end MEAS_VoltageSensor;

model MEAS_CurrentSensor
  extends Modelica.Electrical.Analog.Sensors.CurrentSensor;
end MEAS_CurrentSensor;

model CEAS_PowerSensor
  extends Coselica.Electrical.Analog.Sensors.PowerSensor;
end CEAS_PowerSensor;

model MEAS_ConstantVoltage
  extends Modelica.Electrical.Analog.Sources.ConstantVoltage;
end MEAS_ConstantVoltage;

model MEAS_SignalVoltage
  extends Modelica.Electrical.Analog.Sources.SignalVoltage;
end MEAS_SignalVoltage;

model MEAS_ConstantCurrent
  extends Modelica.Electrical.Analog.Sources.ConstantCurrent;
end MEAS_ConstantCurrent;

model MEAS_SignalCurrent
  extends Modelica.Electrical.Analog.Sources.SignalCurrent;
end MEAS_SignalCurrent;

model MEAS_StepVoltage
  extends Modelica.Electrical.Analog.Sources.StepVoltage;
end MEAS_StepVoltage;

model MEAS_StepCurrent
  extends Modelica.Electrical.Analog.Sources.StepCurrent;
end MEAS_StepCurrent;

model MEAS_SineVoltage
  extends Modelica.Electrical.Analog.Sources.SineVoltage;
end MEAS_SineVoltage;

model MEAS_SineCurrent
  extends Modelica.Electrical.Analog.Sources.SineCurrent;
end MEAS_SineCurrent;

model MEAS_PulseVoltage
  extends Modelica.Electrical.Analog.Sources.PulseVoltage;
end MEAS_PulseVoltage;

model MEAS_PulseCurrent
  extends Modelica.Electrical.Analog.Sources.PulseCurrent;
end MEAS_PulseCurrent;

model MEAS_RampVoltage
  extends Modelica.Electrical.Analog.Sources.RampVoltage;
end MEAS_RampVoltage;

model MEAS_RampCurrent
  extends Modelica.Electrical.Analog.Sources.RampCurrent;
end MEAS_RampCurrent;

model MEAS_SawToothVoltage
  extends Modelica.Electrical.Analog.Sources.SawToothVoltage;
end MEAS_SawToothVoltage;

model MEAS_SawToothCurrent
  extends Modelica.Electrical.Analog.Sources.SawToothCurrent;
end MEAS_SawToothCurrent;

model CEAS_TrapezoidVoltage
  extends Coselica.Electrical.Analog.Sources.TrapezoidVoltage;
end CEAS_TrapezoidVoltage;

model CEAS_TrapezoidCurrent
  extends Coselica.Electrical.Analog.Sources.TrapezoidCurrent;
end CEAS_TrapezoidCurrent;

model MEAI_Idle
  extends Modelica.Electrical.Analog.Ideal.Idle;
end MEAI_Idle;

model MEAI_Short
  extends Modelica.Electrical.Analog.Ideal.Short;
end MEAI_Short;

model MEAI_IdealOpeningSwitch
  extends Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch;
end MEAI_IdealOpeningSwitch;

model MEAI_IdealClosingSwitch
  extends Modelica.Electrical.Analog.Ideal.IdealClosingSwitch;
end MEAI_IdealClosingSwitch;

model CEAI_IdealDiode
  extends Coselica.Electrical.Analog.Ideal.IdealDiode;
end CEAI_IdealDiode;

model MEAI_IdealTransformer
  extends Modelica.Electrical.Analog.Ideal.IdealTransformer;
end MEAI_IdealTransformer;

model MEAI_IdealGyrator
  extends Modelica.Electrical.Analog.Ideal.IdealGyrator;
end MEAI_IdealGyrator;

model MEAS_Diode
  extends Modelica.Electrical.Analog.Semiconductors.Diode;
end MEAS_Diode;

model CEAS_ZDiode
  extends Coselica.Electrical.Analog.Semiconductors.ZDiode;
end CEAS_ZDiode;

model MEAS_NPN
  extends Modelica.Electrical.Analog.Semiconductors.NPN;
end MEAS_NPN;

model MEAS_PNP
  extends Modelica.Electrical.Analog.Semiconductors.PNP;
end MEAS_PNP;

model MEAS_NMOS
  extends Modelica.Electrical.Analog.Semiconductors.NMOS;
end MEAS_NMOS;

model MEAS_PMOS
  extends Modelica.Electrical.Analog.Semiconductors.PMOS;
end MEAS_PMOS;

model CEAS_Thyristor
  extends Coselica.Electrical.Analog.Semiconductors.Thyristor;
end CEAS_Thyristor;

model MMT_Fixed
  extends Modelica.Mechanics.Translational.Fixed;
end MMT_Fixed;

model CMTC_Free
  extends Coselica.Mechanics.Translational.Components.Free;
end CMTC_Free;

model MMT_Rod
  extends Modelica.Mechanics.Translational.Rod;
end MMT_Rod;

model MMT_Spring
  extends Modelica.Mechanics.Translational.Spring;
end MMT_Spring;

model MMT_Damper
  extends Modelica.Mechanics.Translational.Damper;
end MMT_Damper;

model MMT_SpringDamper
  extends Modelica.Mechanics.Translational.SpringDamper;
end MMT_SpringDamper;

model CMTC_ElastoGap
  extends Coselica.Mechanics.Translational.Components.ElastoGap;
end CMTC_ElastoGap;

model CMTC_Lever
  extends Coselica.Mechanics.Translational.Components.Lever;
end CMTC_Lever;

model CMTC_Pulley
  extends Coselica.Mechanics.Translational.Components.Pulley;
end CMTC_Pulley;

model CMTC_ActuatedPulley
  extends Coselica.Mechanics.Translational.Components.ActuatedPulley;
end CMTC_ActuatedPulley;

model CMT_Stop
  extends Coselica.Mechanics.Translational.Stop;
end CMT_Stop;

model CMT_MassWithFriction
  extends Coselica.Mechanics.Translational.MassWithFriction;
end CMT_MassWithFriction;

model MMT_SlidingMass
  extends Modelica.Mechanics.Translational.SlidingMass;
end MMT_SlidingMass;

model CMTC_Mass
  extends Coselica.Mechanics.Translational.Components.Mass;
end CMTC_Mass;

model CMTC_MassWithWeight
  extends Coselica.Mechanics.Translational.Components.MassWithWeight;
end CMTC_MassWithWeight;

model CMTS_Position0
  extends Coselica.Mechanics.Translational.Sources.Position0;
end CMTS_Position0;

model CMTS_Speed0
  extends Coselica.Mechanics.Translational.Sources.Speed0;
end CMTS_Speed0;

model CMTS_Accelerate0
  extends Coselica.Mechanics.Translational.Sources.Accelerate0;
end CMTS_Accelerate0;

model CMTS_Force0
  extends Coselica.Mechanics.Translational.Sources.Force0;
end CMTS_Force0;

model CMTS_Position
  extends Coselica.Mechanics.Translational.Sources.Position;
end CMTS_Position;

model CMTS_Speed
  extends Coselica.Mechanics.Translational.Sources.Speed;
end CMTS_Speed;

model CMTS_Accelerate
  extends Coselica.Mechanics.Translational.Sources.Accelerate;
end CMTS_Accelerate;

model CMTS_Force
  extends Coselica.Mechanics.Translational.Sources.Force;
end CMTS_Force;

model CMTS_Force2
  extends Coselica.Mechanics.Translational.Sources.Force2;
end CMTS_Force2;

model CMTS_LinearSpeedDependen
  extends Coselica.Mechanics.Translational.Sources.LinearSpeedDependentForce;
end CMTS_LinearSpeedDependen;

model CMTS_QuadraticSpeedDepen
  extends Coselica.Mechanics.Translational.Sources.QuadraticSpeedDependentForce;
end CMTS_QuadraticSpeedDepen;

model CMTS_ConstantForce
  extends Coselica.Mechanics.Translational.Sources.ConstantForce;
end CMTS_ConstantForce;

model CMTS_ConstantSpeed
  extends Coselica.Mechanics.Translational.Sources.ConstantSpeed;
end CMTS_ConstantSpeed;

model CMTS_ForceStep
  extends Coselica.Mechanics.Translational.Sources.ForceStep;
end CMTS_ForceStep;

model CMTS_ForceSensor
  extends Coselica.Mechanics.Translational.Sensors.ForceSensor;
end CMTS_ForceSensor;

model CMTS_PowerSensor
  extends Coselica.Mechanics.Translational.Sensors.PowerSensor;
end CMTS_PowerSensor;

model CMTS_PositionSensor
  extends Coselica.Mechanics.Translational.Sensors.PositionSensor;
end CMTS_PositionSensor;

model CMTS_SpeedSensor
  extends Coselica.Mechanics.Translational.Sensors.SpeedSensor;
end CMTS_SpeedSensor;

model CMTS_AccSensor
  extends Coselica.Mechanics.Translational.Sensors.AccSensor;
end CMTS_AccSensor;

model CMTS_RelPositionSensor
  extends Coselica.Mechanics.Translational.Sensors.RelPositionSensor;
end CMTS_RelPositionSensor;

model CMTS_RelSpeedSensor
  extends Coselica.Mechanics.Translational.Sensors.RelSpeedSensor;
end CMTS_RelSpeedSensor;

model CMTS_RelAccSensor
  extends Coselica.Mechanics.Translational.Sensors.RelAccSensor;
end CMTS_RelAccSensor;

model MMR_Fixed
  extends Modelica.Mechanics.Rotational.Fixed;
end MMR_Fixed;

model CMRC_Free
  extends Coselica.Mechanics.Rotational.Components.Free;
end CMRC_Free;

model CMRC_Disc
  extends Coselica.Mechanics.Rotational.Components.Disc;
end CMRC_Disc;

model MMR_Inertia
  extends Modelica.Mechanics.Rotational.Inertia;
end MMR_Inertia;

model MMR_Spring
  extends Modelica.Mechanics.Rotational.Spring;
end MMR_Spring;

model MMR_Damper
  extends Modelica.Mechanics.Rotational.Damper;
end MMR_Damper;

model MMR_SpringDamper
  extends Modelica.Mechanics.Rotational.SpringDamper;
end MMR_SpringDamper;

model MMR_IdealGear
  extends Modelica.Mechanics.Rotational.IdealGear;
end MMR_IdealGear;

model MMR_ElastoBacklash
  extends Modelica.Mechanics.Rotational.ElastoBacklash;
end MMR_ElastoBacklash;

model CMRC_ElastoBacklash
  extends Coselica.Mechanics.Rotational.Components.ElastoBacklash;
end CMRC_ElastoBacklash;

model MMR_IdealGearR2T
  extends Modelica.Mechanics.Rotational.IdealGearR2T;
end MMR_IdealGearR2T;

model MMR_IdealPlanetary
  extends Modelica.Mechanics.Rotational.IdealPlanetary;
end MMR_IdealPlanetary;

model CMRC_IdealDifferential
  extends Coselica.Mechanics.Rotational.Components.IdealDifferential;
end CMRC_IdealDifferential;

model CMR_BearingFriction
  extends Coselica.Mechanics.Rotational.BearingFriction;
end CMR_BearingFriction;

model CMR_OneWayClutch
  extends Coselica.Mechanics.Rotational.OneWayClutch;
end CMR_OneWayClutch;

model CMR_Clutch
  extends Coselica.Mechanics.Rotational.Clutch;
end CMR_Clutch;

model CMR_Brake
  extends Coselica.Mechanics.Rotational.Brake;
end CMR_Brake;

model CMR_Freewheel
  extends Coselica.Mechanics.Rotational.Freewheel;
end CMR_Freewheel;

model MMRS_TorqueSensor
  extends Modelica.Mechanics.Rotational.Sensors.TorqueSensor;
end MMRS_TorqueSensor;

model CMRS_PowerSensor
  extends Coselica.Mechanics.Rotational.Sensors.PowerSensor;
end CMRS_PowerSensor;

model MMRS_RelAngleSensor
  extends Modelica.Mechanics.Rotational.Sensors.RelAngleSensor;
end MMRS_RelAngleSensor;

model MMRS_RelSpeedSensor
  extends Modelica.Mechanics.Rotational.Sensors.RelSpeedSensor;
end MMRS_RelSpeedSensor;

model MMRS_RelAccSensor
  extends Modelica.Mechanics.Rotational.Sensors.RelAccSensor;
end MMRS_RelAccSensor;

model MMRS_AngleSensor
  extends Modelica.Mechanics.Rotational.Sensors.AngleSensor;
end MMRS_AngleSensor;

model MMRS_SpeedSensor
  extends Modelica.Mechanics.Rotational.Sensors.SpeedSensor;
end MMRS_SpeedSensor;

model MMRS_AccSensor
  extends Modelica.Mechanics.Rotational.Sensors.AccSensor;
end MMRS_AccSensor;

model CMRS_Position0
  extends Coselica.Mechanics.Rotational.Sources.Position0;
end CMRS_Position0;

model CMRS_Speed0
  extends Coselica.Mechanics.Rotational.Sources.Speed0;
end CMRS_Speed0;

model CMRS_Accelerate0
  extends Coselica.Mechanics.Rotational.Sources.Accelerate0;
end CMRS_Accelerate0;

model CMRS_Torque0
  extends Coselica.Mechanics.Rotational.Sources.Torque0;
end CMRS_Torque0;

model CMRS_Position
  extends Coselica.Mechanics.Rotational.Sources.Position;
end CMRS_Position;

model CMRS_Speed
  extends Coselica.Mechanics.Rotational.Sources.Speed;
end CMRS_Speed;

model CMRS_Accelerate
  extends Coselica.Mechanics.Rotational.Sources.Accelerate;
end CMRS_Accelerate;

model CMRS_Torque2
  extends Coselica.Mechanics.Rotational.Sources.Torque2;
end CMRS_Torque2;

model CMRS_Torque
  extends Coselica.Mechanics.Rotational.Sources.Torque;
end CMRS_Torque;

model CMRS_ConstantTorque
  extends Coselica.Mechanics.Rotational.Sources.ConstantTorque;
end CMRS_ConstantTorque;

model CMRS_ConstantSpeed
  extends Coselica.Mechanics.Rotational.Sources.ConstantSpeed;
end CMRS_ConstantSpeed;

model CMRS_TorqueStep
  extends Coselica.Mechanics.Rotational.Sources.TorqueStep;
end CMRS_TorqueStep;

model CMRS_LinearSpeedDependen
  extends Coselica.Mechanics.Rotational.Sources.LinearSpeedDependentTorque;
end CMRS_LinearSpeedDependen;

model CMRS_QuadraticSpeedDepen
  extends Coselica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque;
end CMRS_QuadraticSpeedDepen;

model CMP_World
  extends Coselica.Mechanics.Planar.World;
end CMP_World;

model CMPP_Fixed
  extends Coselica.Mechanics.Planar.Parts.Fixed;
end CMPP_Fixed;

model CMPP_FixedTranslation
  extends Coselica.Mechanics.Planar.Parts.FixedTranslation;
end CMPP_FixedTranslation;

model CMPP_FixedRotation
  extends Coselica.Mechanics.Planar.Parts.FixedRotation;
end CMPP_FixedRotation;

model CMPP_Body
  extends Coselica.Mechanics.Planar.Parts.Body;
end CMPP_Body;

model CMPP_BodyShape
  extends Coselica.Mechanics.Planar.Parts.BodyShape;
end CMPP_BodyShape;

model CMPP_PointMass
  extends Coselica.Mechanics.Planar.Parts.PointMass;
end CMPP_PointMass;

model CMPJ_Revolute
  extends Coselica.Mechanics.Planar.Joints.Revolute;
end CMPJ_Revolute;

model CMPJ_ActuatedRevolute
  extends Coselica.Mechanics.Planar.Joints.ActuatedRevolute;
end CMPJ_ActuatedRevolute;

model CMPJ_Prismatic
  extends Coselica.Mechanics.Planar.Joints.Prismatic;
end CMPJ_Prismatic;

model CMPJ_ActuatedPrismatic
  extends Coselica.Mechanics.Planar.Joints.ActuatedPrismatic;
end CMPJ_ActuatedPrismatic;

model CMPJ_FreeMotion
  extends Coselica.Mechanics.Planar.Joints.FreeMotion;
end CMPJ_FreeMotion;

model CMPJ_RollingWheel
  extends Coselica.Mechanics.Planar.Joints.RollingWheel;
end CMPJ_RollingWheel;

model CMPJ_ActuatedRollingWhee
  extends Coselica.Mechanics.Planar.Joints.ActuatedRollingWheel;
end CMPJ_ActuatedRollingWhee;

model CMPL_Revolute
  extends Coselica.Mechanics.Planar.LoopJoints.Revolute;
end CMPL_Revolute;

model CMPL_ActuatedRevolute
  extends Coselica.Mechanics.Planar.LoopJoints.ActuatedRevolute;
end CMPL_ActuatedRevolute;

model CMPL_Prismatic
  extends Coselica.Mechanics.Planar.LoopJoints.Prismatic;
end CMPL_Prismatic;

model CMPL_ActuatedPrismatic
  extends Coselica.Mechanics.Planar.LoopJoints.ActuatedPrismatic;
end CMPL_ActuatedPrismatic;

model CMPS_CutTorque
  extends Coselica.Mechanics.Planar.Sensors.CutTorque;
end CMPS_CutTorque;

model CMPS_CutForce
  extends Coselica.Mechanics.Planar.Sensors.CutForce;
end CMPS_CutForce;

model CMPS_CutForce2
  extends Coselica.Mechanics.Planar.Sensors.CutForce2;
end CMPS_CutForce2;

model CMPS_Distance
  extends Coselica.Mechanics.Planar.Sensors.Distance;
end CMPS_Distance;

model CMPS_RelPosition
  extends Coselica.Mechanics.Planar.Sensors.RelPosition;
end CMPS_RelPosition;

model CMPS_RelVelocity
  extends Coselica.Mechanics.Planar.Sensors.RelVelocity;
end CMPS_RelVelocity;

model CMPS_RelAcceleration
  extends Coselica.Mechanics.Planar.Sensors.RelAcceleration;
end CMPS_RelAcceleration;

model CMPS_RelPosition2
  extends Coselica.Mechanics.Planar.Sensors.RelPosition2;
end CMPS_RelPosition2;

model CMPS_RelVelocity2
  extends Coselica.Mechanics.Planar.Sensors.RelVelocity2;
end CMPS_RelVelocity2;

model CMPS_RelAcceleration2
  extends Coselica.Mechanics.Planar.Sensors.RelAcceleration2;
end CMPS_RelAcceleration2;

model CMPS_AbsPosition
  extends Coselica.Mechanics.Planar.Sensors.AbsPosition;
end CMPS_AbsPosition;

model CMPS_AbsVelocity
  extends Coselica.Mechanics.Planar.Sensors.AbsVelocity;
end CMPS_AbsVelocity;

model CMPS_AbsAcceleration
  extends Coselica.Mechanics.Planar.Sensors.AbsAcceleration;
end CMPS_AbsAcceleration;

model CMPS_AbsPosition2
  extends Coselica.Mechanics.Planar.Sensors.AbsPosition2;
end CMPS_AbsPosition2;

model CMPS_AbsVelocity2
  extends Coselica.Mechanics.Planar.Sensors.AbsVelocity2;
end CMPS_AbsVelocity2;

model CMPS_AbsAcceleration2
  extends Coselica.Mechanics.Planar.Sensors.AbsAcceleration2;
end CMPS_AbsAcceleration2;

model CMPS_Angle
  extends Coselica.Mechanics.Planar.Sensors.Angle;
end CMPS_Angle;

model CMPS_RelAngularVelocity
  extends Coselica.Mechanics.Planar.Sensors.RelAngularVelocity;
end CMPS_RelAngularVelocity;

model CMPS_RelAngularAccelerat
  extends Coselica.Mechanics.Planar.Sensors.RelAngularAcceleration;
end CMPS_RelAngularAccelerat;

model CMPS_AbsAngle
  extends Coselica.Mechanics.Planar.Sensors.AbsAngle;
end CMPS_AbsAngle;

model CMPS_AbsAngularVelocity
  extends Coselica.Mechanics.Planar.Sensors.AbsAngularVelocity;
end CMPS_AbsAngularVelocity;

model CMPS_AbsAngularAccelerat
  extends Coselica.Mechanics.Planar.Sensors.AbsAngularAcceleration;
end CMPS_AbsAngularAccelerat;

model CMPS_Power
  extends Coselica.Mechanics.Planar.Sensors.Power;
end CMPS_Power;

model CMPF_WorldForce
  extends Coselica.Mechanics.Planar.Forces.WorldForce;
end CMPF_WorldForce;

model CMPF_WorldTorque
  extends Coselica.Mechanics.Planar.Forces.WorldTorque;
end CMPF_WorldTorque;

model CMPF_FrameForce
  extends Coselica.Mechanics.Planar.Forces.FrameForce;
end CMPF_FrameForce;

model CMPF_LineForce
  extends Coselica.Mechanics.Planar.Forces.LineForce;
end CMPF_LineForce;

model CMPF_LineForceWithMass
  extends Coselica.Mechanics.Planar.Forces.LineForceWithMass;
end CMPF_LineForceWithMass;

model MTH_HeatCapacitor
  extends Modelica.Thermal.HeatTransfer.HeatCapacitor;
end MTH_HeatCapacitor;

model MTH_ThermalConductor
  extends Modelica.Thermal.HeatTransfer.ThermalConductor;
end MTH_ThermalConductor;

model MTH_BodyRadiation
  extends Modelica.Thermal.HeatTransfer.BodyRadiation;
end MTH_BodyRadiation;

model MTH_Convection
  extends Modelica.Thermal.HeatTransfer.Convection;
end MTH_Convection;

model MTH_FixedTemperature
  extends Modelica.Thermal.HeatTransfer.FixedTemperature;
end MTH_FixedTemperature;

model MTHC_FixedTemperature
  extends Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature;
end MTHC_FixedTemperature;

model MTH_FixedHeatFlow
  extends Modelica.Thermal.HeatTransfer.FixedHeatFlow;
end MTH_FixedHeatFlow;

model MTH_PrescribedTemperatur
  extends Modelica.Thermal.HeatTransfer.PrescribedTemperature;
end MTH_PrescribedTemperatur;

model MTHC_PrescribedTemperatu
  extends Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature;
end MTHC_PrescribedTemperatu;

model MTH_PrescribedHeatFlow
  extends Modelica.Thermal.HeatTransfer.PrescribedHeatFlow;
end MTH_PrescribedHeatFlow;

model MTH_TemperatureSensor
  extends Modelica.Thermal.HeatTransfer.TemperatureSensor;
end MTH_TemperatureSensor;

model MTHC_TemperatureSensor
  extends Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor;
end MTHC_TemperatureSensor;

model MTH_HeatFlowSensor
  extends Modelica.Thermal.HeatTransfer.HeatFlowSensor;
end MTH_HeatFlowSensor;

model MTH_RelTemperatureSensor
  extends Modelica.Thermal.HeatTransfer.RelTemperatureSensor;
end MTH_RelTemperatureSensor;

model MTHC_ToKelvin
  extends Modelica.Thermal.HeatTransfer.Celsius.ToKelvin;
end MTHC_ToKelvin;

model MTHC_FromKelvin
  extends Modelica.Thermal.HeatTransfer.Celsius.FromKelvin;
end MTHC_FromKelvin;

model MBS_Pulse
  extends Modelica.Blocks.Sources.Pulse;
end MBS_Pulse;

model MBS_SawTooth
  extends Modelica.Blocks.Sources.SawTooth;
end MBS_SawTooth;

model CMT_Position
  extends Coselica.Mechanics.Translational.Position;
end CMT_Position;

model CMT_Speed
  extends Coselica.Mechanics.Translational.Speed;
end CMT_Speed;

model MMT_Accelerate
  extends Modelica.Mechanics.Translational.Accelerate;
end MMT_Accelerate;

model MMT_Force
  extends Modelica.Mechanics.Translational.Force;
end MMT_Force;

model MEAB_EMF
  extends Modelica.Electrical.Analog.Basic.EMF;
end MEAB_EMF;

model MMR_Torque2
  extends Modelica.Mechanics.Rotational.Torque2;
end MMR_Torque2;

model MMR_Torque
  extends Modelica.Mechanics.Rotational.Torque;
end MMR_Torque;

model MMR_Accelerate
  extends Modelica.Mechanics.Rotational.Accelerate;
end MMR_Accelerate;

model CMR_Position
  extends Coselica.Mechanics.Rotational.Position;
end CMR_Position;

model CMR_Speed
  extends Coselica.Mechanics.Rotational.Speed;
end CMR_Speed;

model MMR_ConstantTorque
  extends Modelica.Mechanics.Rotational.ConstantTorque;
end MMR_ConstantTorque;

model MMR_ConstantSpeed
  extends Modelica.Mechanics.Rotational.ConstantSpeed;
end MMR_ConstantSpeed;

model MMR_TorqueStep
  extends Modelica.Mechanics.Rotational.TorqueStep;
end MMR_TorqueStep;

model MMR_LinearSpeedDependent
  extends Modelica.Mechanics.Rotational.LinearSpeedDependentTorque;
end MMR_LinearSpeedDependent;

model MMR_QuadraticSpeedDepend
  extends Modelica.Mechanics.Rotational.QuadraticSpeedDependentTorque;
end MMR_QuadraticSpeedDepend;
