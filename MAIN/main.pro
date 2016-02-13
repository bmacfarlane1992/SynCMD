; main.pro
;
; Procedure written to use utilise predetermined stellar distribution (simulation) to build
; a synthetic stellar population using package code of Pasetto, Chiosi and Kawata (2012).
;
; NOTES: 
;	- Procedure only analyses CMD data, MDF procedure encapsulated within postmain.pro 
;	- CMD increment value for both color + magnitude hard coded to 0.1, if edit is required
;	  parameter may be changed within $arch_dir$/Code/Globals.f90
; 
; Author: Benjamin MacFarlane
; Date: 11/11/2014
; Contact: bmacfarlane@uclan.ac.uk
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;		
	; - - - VARIABLE DEFINITIONS - - - ;
;
	extinct_q=0
;
	col1='J'
	col2='K'
	mag_glob='J'
	pop_q=0
;
	ntotstars=100000
	maglim1=12
	maglim2=14
	collim1=0.23
	collim2=0.45
;

	glim1=3.5
	glim2=4.5
;
	popgrid_q=1
;
	logg_q=0
;
	col_appvec_sup=5
	col_appvec_inf=-1
	mag_appvec_sup=30
	mag_appvec_inf=-1
	arr_app=((col_appvec_sup-col_appvec_inf)/0.05)*((mag_appvec_sup-mag_appvec_inf)/0.05)
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
	; - - - MAIN  PROGRAM - - - ;
;
		; - - - First read the architecture information for the SynCMD run
;
arch_dir=strarr(1)
sim1=strarr(1)
sim2=strarr(1)
tag=strarr(1)
hist_down=fltarr(1)
hist_up=fltarr(1)
hist_int=fltarr(1)
cutcount=fltarr(1)
globals='../../../ARCH_GLOBALS.dat'
openr, lun, globals, /get_lun
readf, lun, arch_dir
readf, lun, sim1
readf, lun, sim2
readf, lun, tag
readf, lun, hist_down
readf, lun, hist_up
readf, lun, hist_int
readf, lun, chem_gridup
readf, lun, chem_griddown
readf, lun, chem_gridint
readf, lun, cutcount
free_lun, lun
;
;
	; - - - Read global variables used in postmain.pro
	; - - - into ascii file to reduce required definition of values
;
filename=arch_dir+'ARCH_GLOBALS2.dat'
openw,lun,filename,/get_lun
printf, lun, col1
printf, lun, col2
printf, lun, mag_glob
free_lun, lun
;
		; - - - Plot the generated extinction value attributed to composite population
		; - - - as per extinct.pro
;
if (extinct_q eq 1) AND (extinct_q ne 0) then begin
	extinct_ts, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, cutcount=cutcount, help=0
endif
;
;
if (pop_q eq 1) AND (pop_q ne 0) then begin
;
		; - - - Read CMD specific variables into Globals.f90 input file
;
	globals, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, $
	col1=col1, col2=col2, mag_glob=mag_glob, $
	maglim1=maglim1, maglim2=maglim2, collim1=collim1, collim2=collim2, $
	glim1=glim1, glim2=glim2, help=0
;
;
		; - - - Read global CMD into population package input file and define CMD
		; - - - output file name
		; - - - Intrinsic to this module - run the SynCMD population synthesis tool to the
		; - - - global file
;
	GLOBAL_fileread, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, col1=col1, col2=col2, $
	mag_glob=mag_glob, help=0
;
		; - - - Plot both CMDs with illustration of color/magnitude
		; - - - restrictions (if applicable)
;
	cmd_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, col1=col1, col2=col2, $
	mag_glob=mag_glob, help=0
;
endif
;
if (popgrid_q eq 1) AND (popgrid_q ne 0) then begin
;
		; - - - Read gridded files into population package input file, and define
		; - - - CMD output file names specific to bins
		; - - - Intrinsic to this module - run the SynCMD population synthesis tool to the
		; - - - gridded files iteratively
;
	GRID_fileread, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, col1=col1, col2=col2, $
	mag_glob=mag_glob, hist_up=hist_up,hist_down=hist_down, hist_int=hist_int, $
	arr_app=arr_app, cutcount=cutcount, logg_q=logg_q, help=0
;
endif
;
end

