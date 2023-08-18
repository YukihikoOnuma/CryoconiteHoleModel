<HTML><h3>Instruction for Cryoconite Hole Model (CryHo)</h3>

<P ALIGN=JUSTIFY>The model was developed by <B>Koji Fujita</B>, Nagoya University, Japan. The study using this model was published in The Cryosphere <B>(Onuma et al., 2023, doi:10.5194/tc-17-3309-2023)</B>. This text is an instruction to use the model.</P>

<B>1. Preparation of an input meteorological data</B>
<br>[SIGMA-B_LT20140714-_Lv1_3.csv] is an example.
<br>year
<br>month
<br>day
<br>hour
<br>doy: day of year
<br>at*: air temperature (degC)
<br>ws*: wind speed (m s^-1)
<br>rh*: relative humidity (0-1)
<br>srd*: downward shortwave radiation (W m^-2)
<br>sru: upward shortwave radiation (W m^-2)
<br>lrd*: downward longwave radiation (W m^-2)
<br>lru*: upward longwave radiation (W m^-2)
<br>srf: observed surface level (m)
<br>ap*: air pressure (hPa)

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
<br>days_for_graph: day and time for graph
<br>month
<br>day
<br>hour 
<br>sd_obs: observed ice surface (m) note: the more positive, the more lowering
<br>sd_calc: calculated ice surface (m) note: the more positive, the more lowering
<br>nsr_ice: net shortwave radiation at ice surface (W m^-2)
<br>nlr_ice: net longwave radiation at ice surface (W m^-2)
<br>sh_ice: sensible heat at ice surface (W m^-2)
<br>lh_ice: latent heat at ice surface (W m^-2)
<br>melt_ice: melting heat at ice surface (W m^-2)
<br>nsr_cryo: net shortwave radiation at CH bottom (W m^-2)
<br>nlr_cryo: net longwave radiation at CH bottom (W m^-2)
<br>sh_cryo: sensible heat at CH bottom (W m^-2)
<br>lh_cryo: latent heat at CH bottom (W m^-2)
<br>melt_cryo: melting heat at CH bottom (W m^-2)
<br>cryo_angle: zenith angle of CH edge (radian)
<br>solar_angle: zenith angle of Sun (radian
<br>d_nsr: difference of net shortwave radiation between ice surface and CH bottom (W m^-2)
<br>d_nlr: difference of net longwave radiation between ice surface and CH bottom (W m^-2)
<br>d_sh: difference of sensible heat between ice surface and CH bottom (W m^-2)
<br>d_lh: difference of latent heat between ice surface and CH bottom (W m^-2)
<br>d_melt: difference of melting heat between ice surface and CH bottom (W m^-2)
<br>cryoconite_depth: cryoconite hole depth (mm) note: the more positive, the deeper CH
<br>sr: downward shortwaver radiation (W m^-2)
<br>sr_direct: direct component of SR at ice surface (W m^-2)
<br>sr_diffuse: diffuse component of SR at ice surface (W m^-2)
<br>src_direct: direct component of SR at CH bottom (W m^-2)
<br>src_diffuse: diffuse component of SR at CH bottom (W m^-2)
<br>t_direct: transmittance of ice for direct component of SR (-)
<br>t_diffuse: transmittance of ice for diffuse component of SR (-)
<br>k_direct: extinction coefficient of ice for direct component of SR (m^-1)
<br>k_diffuse: extinction coefficient of ice for diffuse component of SR (m^-1)

<B>Reference:</B>
<br>Onuma, Y., Fujita, K., Takeuchi, N., Niwano, M., and Aoki, T.: Modelling the development and decay of cryoconite holes in northwestern Greenland, The Cryosphere, 17, 3309–3328, https://doi.org/10.5194/tc-17-3309-2023, 2023.
