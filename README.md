Instruction for Cryoconite Hole Model (CryHo)

The model was developed by Koji Fujita, Nagoya University, Japan. The study using this model was published in The Cryosphere (Onuma et al., 2023). This text is an instruction to use the model.

1. Preparation of an input meteorological data
[SIGMA-B_LT20140714-_Lv1_3.csv] is an example.
year
month
day
hour
doy: day of year
at*: air temperature (degC)
ws*: wind speed (m s^-1)
rh*: relative humidity (0-1)
srd*: downward shortwave radiation (W m^-2)
sru: upward shortwave radiation (W m^-2)
lrd*: downward longwave radiation (W m^-2)
lru*: upward longwave radiation (W m^-2)
srf: observed surface level (m)
ap*: air pressure (hPa)

For year to doy, values should be "integer" while the other meteorological variables (from at to ap) should be "real". "should be real" means that, even if a value appears "0" on an excel sheet, it should be saved as "0.0".

Parameters with asterisk [*] should be prepared to calculate the CH depth. [sru] and [srf] are not always required but, if unavailable, put any dummy values.

It is not required the data starting time from "0" hour, the calculation should be performed for XX days x 24 hours.

2. Preparation of parameters
Edit "parameter.ini" by a text editor. The setting of distributed version is that for Site 2 in 2014 to represent the camera-based CH depth.

3. Installation of Fortran
This is out of this instruction. Please prepare it by yourself.

4. Operation
Open a terminal at the folder containing the code, input data, and parameter files. Compile the code "cryho_disclose_version1.f90", and run the created execute file. You will get an output file [ch_hourly_2014_v3_monitor_at39_di51_id117_ai62.csv] (the file name can be changed. see next).
The model simulations with parameters observed in Qaanaaq Ice Cap can be conducted by using "shell/cal_obs.sh".
Note that cryho_disclose_version1_stest.f90, cryho_disclose_version1_Rscexp_LT13.f90 and cryho_disclose_version1_Rscexp_LT01.f90 are model codes for sensitivity tests (for Figs 9, 11a and 11b, respectively). Please use appropriate parameter file (i.e., parameter.ini_2014_S2_v3_stest or parameter.ini_2014_S2_v3_Rscexp). The sensitivity tests can be conducted by using shell scripts (stest.sh and stest_Rscexp.sh).

5. Output file
You can change the file name at the second line of parameter.ini.

days_for_graph: day and time for graph
month
day
hour 
sd_obs: observed ice surface (m) note: the more positive, the more lowering
sd_calc: calculated ice surface (m) note: the more positive, the more lowering
nsr_ice: net shortwave radiation at ice surface (W m^-2)
nlr_ice: net longwave radiation at ice surface (W m^-2)
sh_ice: sensible heat at ice surface (W m^-2)
lh_ice: latent heat at ice surface (W m^-2)
melt_ice: melting heat at ice surface (W m^-2)
nsr_cryo: net shortwave radiation at CH bottom (W m^-2)
nlr_cryo: net longwave radiation at CH bottom (W m^-2)
sh_cryo: sensible heat at CH bottom (W m^-2)
lh_cryo: latent heat at CH bottom (W m^-2)
melt_cryo: melting heat at CH bottom (W m^-2)
cryo_angle: zenith angle of CH edge (radian)
solar_angle: zenith angle of Sun (radian
d_nsr: difference of net shortwave radiation between ice surface and CH bottom (W m^-2)
d_nlr: difference of net longwave radiation between ice surface and CH bottom (W m^-2)
d_sh: difference of sensible heat between ice surface and CH bottom (W m^-2)
d_lh: difference of latent heat between ice surface and CH bottom (W m^-2)
d_melt: difference of melting heat between ice surface and CH bottom (W m^-2)
cryoconite_depth: cryoconite hole depth (mm) note: the more positive, the deeper CH
sr: downward shortwaver radiation (W m^-2)
sr_direct: direct component of SR at ice surface (W m^-2)
sr_diffuse: diffuse component of SR at ice surface (W m^-2)
src_direct: direct component of SR at CH bottom (W m^-2)
src_diffuse: diffuse component of SR at CH bottom (W m^-2)
t_direct: transmittance of ice for direct component of SR (-)
t_diffuse: transmittance of ice for diffuse component of SR (-)
k_direct: extinction coefficient of ice for direct component of SR (m^-1)
k_diffuse: extinction coefficient of ice for diffuse component of SR (m^-1)
