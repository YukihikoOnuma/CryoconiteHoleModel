!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     CryHo: Cryoconite Hole Model
!     Developed by Koji Fujita, Nagoya University
!     Disclose version edited in Dec. 2022
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	implicit none
!  declaration
	integer nt,it ! total time
	integer nh,ih ! hour in a day
	integer nd,id ! calculation days / read from para.ini file
	parameter(nt=2400,nh=24) ! nt/nh=100days, if you want calculate more days, change here
	integer nyr(nt) ! year from input data
	integer nmn(nt) ! month from input data
	integer ndy(nt) ! day from input data
	integer nhr(nt) ! hour from input data
	integer jd(nt) ! day of year from input data
	real at(nt) ! air temperature from input data (degC)
	real ws(nt) ! wind speed from input data (m s^-1)
	real rh(nt) ! relative humidity from input data (0-1)
	real srd(nt) ! downward shortwave radiation from input data (W m^-2)
	real sru(nt) ! upward shortwave radiation from input data (W m^-2)
	real lrd(nt) ! downward longwave radiation from input data (W m^-2)
	real lru(nt) ! upward longwave radiation from input data (W m^-2)
	real snd(nt) ! surface level (m)
	real apr(nt) ! air pressure from input data (hPa)
!
	real el ! latent heat for evaporation (J kg^-1)
	real elw ! latent heat for liquid-vapor (2.5*1E6 J kg^-1)
	real elm ! latent heat for solid-liquid (3.336*1E5 J kg^-1)
	real em ! emissivity for longwave radiation (1.0)
	real spr ! standard air pressure (1013.25 hPa)
	real blt ! Stefan-Boltzmann constant (5.67*1E-8 W m^-2 K^-4)
	real cpa ! heat capacity of air (1006 J K^-1 kg^-1)
	real dni ! ice density (900 kg m^-3)
	real dnw ! water density (1000 kg m^-3)
	real thour ! time for hour (3600 sec)
!
	real atp ! temperature bias for calibration (degC)
	real aat ! calibrated air temperature (degC)
	real st ! surface temperature (degC)
	real dna ! air density (kg m^-3)
	real qs ! saturated specific humidity at air temperature (kg kg^-1)
	real qss ! saturated specific humidity at surface temperature (kg kg^-1)
	real sc ! solar constant (1367 W m^-2)
	real pi ! pi (3.141)
	real abt ! ice melting temperature in Kelvin for unit conversion (273.15 K)
!
	real ylat ! latitude of the site (radian converted from input degree)
	real trd ! shortwave radiation at the top of atmosphere (W m^-2)
	real nsri ! net shortwave radiation at the ice surface (W m^-2)
	real nlri ! net longwave radiation at the ice surface (W m^-2)
	real chi ! bulk coefficient at the ice surface (-)
	real shi ! sensible heat at the ice surface (W m^-2)
	real lhi ! latent heat at the ice surface (W m^-2)
	real mhi ! melting heat at the ice surface (W m^-2)
	real nsrc ! net shortwave radiation at the CH bottom (W m^-2)
	real nlrc ! net longwave radiation at the CH bottom (W m^-2)
	real chc ! bulk coefficient at the CH bottom (W m^-2)
	real shc ! sensible heat at the CH bottom (W m^-2)
	real lhc ! latent heat at the CH bottom (W m^-2)
	real mhc ! melting heat at the CH bottom (W m^-2)
	real zan ! zenith angle of the Sun (radian)
	real can ! zenith angle from the CH center to edge (radian)
	real sky ! sky view factor (-)
	real kid ! extinction coefficient for direct shortwave radiation (m^-1)
	real kis ! extinction coefficient for diffuse shortwave radiation (m^-1)
	real tid ! transmittance for direct shortwave radiation (-)
	real tis ! transmittance for diffuse shortwave radiation (-)
	integer nss ! switch for shortwave component
	real srid ! direct shortwave radiation at the ice surface (W m^-2)
	real sris ! diffuse shortwave radiation at the ice surface (W m^-2)
	real srcd ! direct shortwave radiation at the CH bottom (W m^-2)
	real srcs ! diffuse shortwave radiation at the CH bottom (W m^-2)
	real lrdc ! longwave radiation from the sky view (W m^-2)
	real lrdw ! longwave radiation from the CH wall (W m^-2)
	real dif ! ratio of diffuse shortwave radiation (0-1)
	real days ! day and time for output
	real alc ! albedo at the CH bottom (-)
	real ali ! albedo at the ice surface (-)
	real ddc ! CH diameter (mm)
	real cd ! CH depth (mm)
	real srf ! calculated surface level (m)
	real dcay ! decay factor for turbulent fluxes (not used in the final version)
	real td ! calibration parameter for direct shortwave radiation transmitted through ice (-)
	real ts ! calibration parameter for diffuse shortwave radiation transmitted through ice (-)
	parameter(ts=1.0) ! transmittance is calculated based on a study dealing with diffuse component so that here calibration parameter is set as 1. change here for sensitivity experiment if necessary
	character*128 metfile,outfile
!
	call para(metfile,outfile,ylat,alc,ali,atp,ddc,cd,srf,chi,nd,nss,dcay,td)
	call const(sc,pi,abt,blt,elw,elm,em,cpa,spr,dni,dnw,thour,ylat)
	call metdata(nyr,nmn,ndy,nhr,jd,at,ws,rh,srd,sru,lrd,lru,snd,apr,nt,nd,nh,metfile)
	open(20,file=trim(outfile))
	write(20,'(a)') 'days_for_graph,month,day,hour,sd_obs,sd_calc,nsr_ice,nlr_ice,sh_ice,lh_ice,melt_ice,&
	&nsr_cryo,nlr_cryo,sh_cryo,lh_cryo,melt_cryo,cryo_angle,solar_angle,&
	&d_nsr,d_nlr,d_sh,d_lh,d_melt,cryoconite_depth,&
	&sr,sr_direct,sr_diffuse,src_direct,src_diffuse,t_direct,t_diffuse,k_direct,k_diffuse'
	do id=1,nd
	 do ih=1,nh
	  it=(id-1)*nh+ih
	  days=real(jd(it))+real(nhr(it)/24.0) ! setting day & time for graph
	  aat=at(it)+atp ! temperature biased
	  st=(lru(it)/blt)**0.25-abt ! surface temperature from upward longwave radiation
	  call vapor(aat,rh(it),apr(it),spr,elw,elm,st,el,qs,qss,dna,abt)
! heat balance on ice surface
	  nsri=(1.0-ali)*srd(it) ! net shortwave radiation ! here can be "srd(it)-sru(it)" if necessary
	  nlri=em*(lrd(it)-lru(it)) ! net longwave radiation
	  shi=cpa*dna*chi*ws(it)*(aat-st) ! sensible heat
	  lhi=el*dna*chi*ws(it)*(qs*rh(it)-qss) ! latent heat
!
	  call toprad(jd(it),ih,pi,sc,ylat,trd,zan)
	  call diffuse(aat,nlri,zan,srd(it),srid,sris,abt,nss,dif)
! determine zenith angle of CH edge and sky view
	  call checkzenithangle(pi,cd,ddc,can,sky)
! determine direct solar radiation 
	  if(zan.lt.can)then ! direct solar radiation from sky
	   srcd=srid ! direct sunlight from sky
	   tid=0;kid=0 ! no transmission through ice
	  else
	   if(zan.lt.(0.5*pi))then
          td = 1 / 1.66
	    call transmit(cd/cos(zan),tid,dif,td,kid) ! transmittance for direct component
	   else
	    tid=0;kid=0 ! no radiation in night
	   endif
	   srcd=srid*tid ! direct component through ice
	  endif
! determine diffuse solar radiation
	  if((zan.lt.(0.5*pi)).and.(cd.gt.0))then
	   call transmit(cd,tis,dif,ts,kis) ! transmittance for diffuse component
	  else
	   tis=0;kis=0 ! no CH or night
	  endif
! heat balance at CH bottom
	  srcs=sris*sky+(1.0-sky)*sris*tis ! diffuse component from sky and through ice
	  lrdc=em*lrd(it)*sky ! long wave radiation from sky
	  lrdw=(1.0-sky)*em*blt*((st+abt)**4.0) ! long wave radiation from CH wall
	  nsrc=(1.0-alc)*(srcd+srcs) ! net shortwave radiation at CH bottome
	  nlrc=lrdc+lrdw-em*blt*((st+abt)**4.0) ! net longwave radiation at CH bottome
!	  chc=1.0*exp(dcay*cd/ddc) ! reduced wind speed with deepening
	  chc=0.0 ! turbulent flux assumed to be zero due to water in the hole
	  shc=shi*chc ! sensible heat at CH bottom
	  lhc=lhi*chc ! latent heat at CH bottom
	  if(st.lt.0)then ! melt or not
	   mhi=0 ! no melt
	   mhc=0 ! no melt
	  else
	   mhi=nsri+nlri+shi+lhi ! melt heat at ice surface
	   mhc=nsrc+nlrc+shc+lhc ! melt heat at CH depth
	   if(mhi.lt.0) mhi=0
	   if(mhc.lt.0) mhc=0
	  endif
	  srf=srf+mhi*thour/elm/dni ! calc surface level at next time step
	  cd=cd+(mhc-mhi)*thour/elm/(dni/dnw) ! calc CH depth at next time step
	  if(cd.lt.0) cd=0
	  write(20,*) days,',',nmn(it),',',ndy(it),',',ih-0,',',-snd(it)+0.1,',',srf,',',nsri,',',&
	& nlri,',',shi,',',lhi,',',mhi,',',nsrc,',',nlrc,',',shc,',',lhc,',',mhc,',',can,',',zan,',',&
	& nsrc-nsri,',',nlrc-nlri,',',shc-shi,',',lhc-lhi,',',mhc-mhi,',',cd,',',&
	& srd(it),',',srid,',',sris,',',srcd,',',srcs,',',tid,',',tis,',',kid,',',kis
	 enddo
	enddo
	close(20)
	stop
	end
!!
!  read variable parameters
	subroutine para(metfile,outfile,ylat,alc,ali,atp,ddc,cd,srf,chi,nd,nss,dcay,td)
	implicit none
	integer nd,nss
	real ylat,alc,ali,atp,ddc,cd,srf,chi,dcay,td
	character*128 metfile,outfile,cdum
	open(10,file='parameter.ini')
	read(10,*) metfile,outfile ! met_input & output file names
	read(10,*) cdum,ylat ! latitude (degree)
	read(10,*) cdum,alc ! albedo of cryoconite
	read(10,*) cdum,ali ! albedo of ice surface
	read(10,*) cdum,atp	! temperature bias (degC)
	read(10,*) cdum,ddc ! CH diameter (mm)
	read(10,*) cdum,cd ! intial CH depth (mm)
	read(10,*) cdum,srf ! initial surface level (m)
	read(10,*) cdum,chi ! bulk coefficient for ice surface
	read(10,*) cdum,nd ! calculation days
	read(10,*) cdum,nss ! switch for shortwave radiation (1: regular scheme, 2: all direct, 3: all diffuse)
	read(10,*) cdum,dcay ! how wind speed decrease with CH depth (not used in this study)
	read(10,*) cdum,td ! tuning parameter for transmittance direct SR (relative to diffuse SR)
	close(10)
	return
	endsubroutine
!!
!  set constant parameters
	subroutine const(sc,pi,abt,blt,elw,elm,em,cpa,spr,dni,dnw,thour,ylat)
	implicit none
	real sc,pi,abt,blt,elw,elm,em,cpa,spr,dni,dnw,thour,ylat
	sc=1367.0 ! solar constant
	pi=3.14159265358979 ! pit
	abt=273.15 ! ice melting temperature in Kelvin
	blt=5.67*1E-8 ! stefan-boltzmann constant
	elw=2.5*1E6 ! latent heat for water evaporation
	elm=3.336*1E5 ! latent heat for ice melting
	em=1.0 ! emissivity of ice surface for longwave radiation
	cpa=1006.0 ! specific heat of air
	spr=1013.25 ! standard air pressure
	dni=900.0 ! ice density
	dnw=1000.0 ! water density
	thour=3600.0 ! duration of a day in second
	ylat=ylat*pi/180.0 ! latitude converted from degree to radian
	return
	endsubroutine
!!
!  read met_data
	subroutine metdata(nyr,nmn,ndy,nhr,jd,at,ws,rh,srd,sru,lrd,lru,snd,apr,nt,nd,nh,metfile)
	implicit none
	integer nt,nd,nh,it,id,ih
	integer nyr(nt),nmn(nt),ndy(nt),nhr(nt),jd(nt)
	real at(nt),ws(nt),rh(nt),srd(nt),sru(nt),lrd(nt),lru(nt),snd(nt),apr(nt)
	character*128 metfile
	open(10,file='../data/met_lv3/'//trim(metfile))
	do id=1,nd
	 do ih=1,nh
	  it=(id-1)*nh+ih
	  read(10,*) nyr(it),nmn(it),ndy(it),nhr(it),jd(it),at(it),ws(it),&
	            &rh(it),srd(it),sru(it),lrd(it),lru(it),snd(it),apr(it)
	 enddo
	enddo
	close(10)
	return
	endsubroutine
!!
!  vapor relevant parameters
	subroutine vapor(at,rh,apr,spr,elw,elm,st,el,qs,qss,dna,abt)
	implicit none
	real at,rh,apr,spr,elw,elm,st,el,qs,qss,dna,abt
	real es,ess
! saturated vapor pressure
	if(at.lt.-2.0)then
	 es=6.1078*10.0**(9.5*at/(265.3+at)) ! ice surface
	else
	 es=6.1078*10.0**(7.5*at/(237.3+at)) ! water surface
	endif
! saturated specific humidity for air
	qs=0.622/(apr/es-0.378)
! air density
	dna=1.293*abt*(apr/spr)*(1.0-0.378*es*rh/apr)/(at+abt)
! saturated specific humidity and latent heat for surface temperature
	if(st.lt.0)then
	 ess=6.1078*10.0**(9.5*st/(265.3+st)) ! ice surface
	 el=elw+elm
	else
	 ess=6.1078*10.0**(7.5*st/(237.3+st)) ! water surface
	 el=elw
	endif
	qss=0.622/(apr/ess-0.378)
	return
	endsubroutine
!!
!  top radiation and zenith angle
	subroutine toprad(jday,ih,pi,sc,ylat,trd,zan)
	implicit none
	integer jday,ih
	real ylat,pi,sc,trd,zan,tkk,dn,dd,dec
	dn=2.0*pi*(jday/365.0)
	dd=1.00011+0.034221*cos(dn)+0.001280*sin(dn)+0.000719*cos(2.0*dn)+0.000077*sin(2.0*dn)
	dec=0.006918-0.399912*cos(dn)+0.070257*sin(dn)-0.006758*cos(2.0*dn)+0.000907*sin(2.0*dn)-0.002697*cos(3.0*dn)+0.001480*sin(3.0*dn)
	tkk=(ih/24.0-0.5)*2.0*pi
	trd=sc*dd*(sin(ylat)*sin(dec)+cos(ylat)*cos(dec)*cos(tkk))
	if(trd.lt.0) trd=0
	zan=acos(trd/sc) ! zenith angle
	return
	endsubroutine
!!
!  Subroutine diffusive radiation
	subroutine diffuse(at,nlri,zan,ssr,srid,sris,abt,nss,dif)
	implicit none
	integer nss
	real at,nlri,zan,ssr,srid,sris,cld,dif,abt
	cld=1.0-nlri/(-5.4*(at+abt)+1363.21) ! cloud ratio
! diffuse ratio
	if(cos(zan).gt.0.0323)then
	 dif=0.0604/(cos(zan)-0.0223)+0.0683
	else
	 dif=0.0604/0.01+0.0683
	endif
	call checkdiffuse(dif)
	dif=dif+(1.0-dif)*cld
	call checkdiffuse(dif)
! for sensitivity experiments
	if(nss.eq.2) dif=0 ! all direct component
	if(nss.eq.3) dif=1 ! all diffuse component
	srid=(1.0-dif)*ssr	! determine direct component
	sris=dif*ssr		! determine diffuse component
	return
	endsubroutine
!!
!  check diffuse ratio
	subroutine checkdiffuse(dif)
	implicit none
	real dif
	if(dif.lt.0) dif=0
	if(dif.gt.1) dif=1
	return
	endsubroutine
!!
!  check zenith angle
	subroutine checkzenithangle(pi,cd,ddc,can,sky)
	implicit none
	real pi,cd,ddc,can,sky
	if(cd.gt.0)then
	 can=atan(ddc/2.0/cd)
	 sky=1.0-(cos(can))**2.0
	else
	 can=0.5*pi
	 sky=1.0
	endif
	return
	endsubroutine
!!
!  Subroutine transmit
	subroutine transmit(dd,tt,dif,td,kk)
	real dd,tt,dif,td,kk,kcr,kcd
	kcr=exp(-1.9167*td*(dd/1000.0)**(1.0-0.61328)) ! transmittance for clear sky
	kcd=exp(-1.6203*td*(dd/1000.0)**(1.0-0.51923)) ! transmittance for cloudy sky
	tt=((1.0-dif)*kcr+dif*kcd)
	kcr=1.9167*td*(dd/1000.0)**(-0.61328) ! extinction coefficient for clear sky
	kcd=1.6203*td*(dd/1000.0)**(-0.51923) ! extinction coefficient for cloudy sky
	kk=((1.0-dif)*kcr+dif*kcd)
	return
	end
!!
