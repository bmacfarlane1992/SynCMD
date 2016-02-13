; premain.pro
;
; Procedure written to use either MUGS/MAGICC g1536/g15784 simulations to select stellar
; distribution utilised within SynCMD
; 
; Author: Benjamin MacFarlane
; Date: 27/10/2014
; Contact: bmacfarlane@uclan.ac.uk
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;		
	; - - - VARIABLE DEFINITIONS - - - ;
;
	arch_dir='/san/cosmic2/bmacfarlane/SynCMD/'
;
	sim1='Selene'
	sim2=''
	tag='UBVRI'
;
	lbd_q=1
	x_up=0
	x_down=0
	y_up=0
	y_down=0
;
	z_up=100
	z_down=0
	l_up=360
	l_down=0
	b_up=90
	b_down=0
	d_up=100
	d_down=0
;
	extinct_q=0
;
	hist_up=1
	hist_down=-3
	hist_int=0.25 
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
; - - - MAIN  PROGRAM - - - ;
;
;
	; - - - Select simulation
;
select, arch_dir=arch_dir, sim1=sim1, sim2=sim2, simdir, help=0
print, sim1, sim2
;
	; - - - Read in simulation and convert xyz -> lbd, with spatial cut as predefined
;
xyz_lbd, arch_dir=arch_dir, sim1=sim1, sim2=sim2, simdir=simdir, tag=tag, lbd_q=lbd_q, x_up=x_up, $
	x_down=x_down, y_up=y_up, y_down=y_down, z_up=z_up, z_down=z_down, l_up=l_up, l_down=l_down, $
	b_up=b_up, b_down=b_down, d_up=d_up, d_down=d_down, sim_xyz, stars, gas, x_0, y_0, $
	z_0, count_stars, count_gas, help=0
;
	; - - - Calculate N_H and SAv from reference location
;
if (extinct_q ne 0) then begin
	extinct, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, gas=gas, $
		x_0=x_0, y_0=y_0, z_0=z_0, N_H, SAv, help=0
;
	stars(24,*)=N_H
	stars(25,*)=SAv
endif
;
	; - - - Print global star data in format required by SynCMD
;
filename=arch_dir+'Inputs/CMDSTARS'+sim1+sim2+'_'+tag+'.dat'
openw,lun,filename,/get_lun
printf,lun, stars
free_lun, lun
;
	; - - - Split, and print star data with metallicity binning as required for abundance analyses
;
if ((sim1 eq 'MaGICC') OR (sim1 eq 'MUGS')) AND (sim1 ne 'Selene') then begin
	mdf_split, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, help=0
endif
;
if (sim1 eq 'Selene') AND (sim1 ne 'MaGICC') AND (sim1 ne 'MUGS') then begin
	grid_split, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, chem_gridup, chem_griddown, chem_gridint, help=0
;
	mdf_split, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, help=0
endif
;
	; - - - Read global variables used in both main.pro and postmain.pro
	; - - - into ascii file to reduce required definition of values
;
filename=arch_dir+'ARCH_GLOBALS.dat'
openw,lun,filename,/get_lun
printf,lun, arch_dir
printf, lun, sim1
printf, lun, sim2
printf, lun, tag
printf, lun, hist_up
printf, lun, hist_down
printf, lun, hist_int
;
if (sim1 eq 'Selene') AND (sim1 ne 'MaGICC') AND (sim1 ne 'MUGS') then begin
	printf, lun, chem_gridup
	printf, lun, chem_griddown
	printf, lun, chem_gridint
endif
;
printf, lun, count_stars
free_lun, lun
;
;
end

