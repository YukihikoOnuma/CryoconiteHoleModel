<HTML><h3>Instruction for Cryoconite Hole Model (CryHo)</h3>

<P ALIGN=JUSTIFY>The model was developed by <B>Koji Fujita</B>, Nagoya University, Japan. The study using this model was published in The Cryosphere (Onuma et al., 2023). This text is an instruction to use the model.</P>

<B>1. Preparation of an input meteorological data</B>
<br>[SIGMA-B_LT20140714-_Lv1_3.csv] is an example.
<br><B>year</B>
<br><B>month</B>
<br><B>day</B>
<br><B>hour</B>
<br><B>doy</B>: day of year
<br><B>at*</B>: air temperature (degC)
<br><B>ws*</B>: wind speed (m s^-1)
<br><B>rh*</B>: relative humidity (0-1)
<br><B>srd*</B>: downward shortwave radiation (W m^-2)
<br><B>sru</B>: upward shortwave radiation (W m^-2)
<br><B>lrd*</B>: downward longwave radiation (W m^-2)
<br><B>lru*</B>: upward longwave radiation (W m^-2)
<br><B>srf</B>: observed surface level (m)
<br><B>ap*</B>: air pressure (hPa)

<br>For year to doy, values should be "integer" while the other meteorological variables (from at to ap) should be "real". "should be real" means that, even if a value appears "0" on an excel sheet, it should be saved as "0.0".
<br>Parameters with asterisk [*] should be prepared to calculate the CH depth. [sru] and [srf] are not always required but, if unavailable, put any dummy values.
<br>It is not required the data starting time from "0" hour, the calculation should be performed for XX days x 24 hours.

<B>2. Preparation of parameters</B>
<br>Edit "parameter.ini" by a text editor. The setting of distributed version is that for Site 2 in 2014 to represent the camera-based CH depth.

<B>3. Installation of Fortran</B>
<br>This is out of this instruction. Please prepare it by yourself.

<B>4. Operation</B>
<br>Open a terminal at the folder containing the code, input data, and parameter files. Compile the code "cryho_disclose_version1.f90", and run the created execute file. You will get an output file [ch_hourly_2014_v3_monitor_at39_di51_id117_ai62.csv] (the file name can be changed. see next).
<br>The model simulations with parameters observed in Qaanaaq Ice Cap can be conducted by using "shell/cal_obs.sh".
<br>Note that cryho_disclose_version1_stest.f90, cryho_disclose_version1_Rscexp_LT13.f90 and cryho_disclose_version1_Rscexp_LT01.f90 are model codes for sensitivity tests (for Figs 9, 11a and 11b, respectively). Please use appropriate parameter file (i.e., parameter.ini_2014_S2_v3_stest or parameter.ini_2014_S2_v3_Rscexp). The sensitivity tests can be conducted by using shell scripts (stest.sh and stest_Rscexp.sh).

<B>5. Output file</B>
<br>You can change the file name at the second line of parameter.ini.
<br><B>days_for_graph: day and time for graph</B>
<br><B>month</B>
<br><B>day</B>
<br><B>hour</B> 
<br><B>sd_obs</B>: observed ice surface (m) note: the more positive, the more lowering
<br><B>sd_calc</B>: calculated ice surface (m) note: the more positive, the more lowering
<br><B>nsr_ice</B>: net shortwave radiation at ice surface (W m^-2)
<br><B>nlr_ice</B>: net longwave radiation at ice surface (W m^-2)
<br><B>sh_ice</B>: sensible heat at ice surface (W m^-2)
<br><B>lh_ice</B>: latent heat at ice surface (W m^-2)
<br><B>melt_ice</B>: melting heat at ice surface (W m^-2)
<br><B>nsr_cryo</B>: net shortwave radiation at CH bottom (W m^-2)
<br><B>nlr_cryo</B>: net longwave radiation at CH bottom (W m^-2)
<br><B>sh_cryo</B>: sensible heat at CH bottom (W m^-2)
<br><B>lh_cryo</B>: latent heat at CH bottom (W m^-2)
<br><B>melt_cryo</B>: melting heat at CH bottom (W m^-2)
<br><B>cryo_angle</B>: zenith angle of CH edge (radian)
<br><B>solar_angle</B>: zenith angle of Sun (radian
<br><B>d_nsr</B>: difference of net shortwave radiation between ice surface and CH bottom (W m^-2)
<br><B>d_nlr</B>: difference of net longwave radiation between ice surface and CH bottom (W m^-2)
<br><B>d_sh</B>: difference of sensible heat between ice surface and CH bottom (W m^-2)
<br><B>d_lh</B>: difference of latent heat between ice surface and CH bottom (W m^-2)
<br><B>d_melt</B>: difference of melting heat between ice surface and CH bottom (W m^-2)
<br><B>cryoconite_depth</B>: cryoconite hole depth (mm) note: the more positive, the deeper CH
<br><B>sr</B>: downward shortwaver radiation (W m^-2)
<br><B>sr_direct</B>: direct component of SR at ice surface (W m^-2)
<br><B>sr_diffuse</B>: diffuse component of SR at ice surface (W m^-2)
<br><B>src_direct</B>: direct component of SR at CH bottom (W m^-2)
<br><B>src_diffuse</B>: diffuse component of SR at CH bottom (W m^-2)
<br><B>t_direct</B>: transmittance of ice for direct component of SR (-)
<br><B>t_diffuse</B>: transmittance of ice for diffuse component of SR (-)
<br><B>k_direct</B>: extinction coefficient of ice for direct component of SR (m^-1)
<br><B>k_diffuse</B>: extinction coefficient of ice for diffuse component of SR (m^-1)
